Return-Path: <linux-kernel-owner+w=401wt.eu-S1758888AbYEHUI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758888AbYEHUI0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 16:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751837AbYEHUIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 16:08:13 -0400
Received: from smtp7.tech.numericable.fr ([82.216.111.43]:48905 "EHLO
	smtp7.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbYEHUIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 16:08:06 -0400
Message-ID: <48235DA1.5060809@numericable.fr>
Date: Thu, 08 May 2008 22:08:01 +0200
From: Rufus & Azrael <rufus-azrael@numericable.fr>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Venki Pallipadi <venkatesh.pallipadi@intel.com>
CC: Ingo Molnar <mingo@elte.hu>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>
Subject: Re: [2.6.25-git18 => 2.6.26-rc1-git1] Xorg crash with	xf86MapVidMem
 error
References: <20080506020910.GA24041@linux-os.sc.intel.com> <20080506115524.GE32591@elte.hu> <4820962B.6050702@numericable.fr> <924EFEDD5F540B4284297C4DC59F3DEE01004FC1@orsmsx423.amr.corp.intel.com> <4820D415.5090900@numericable.fr> <924EFEDD5F540B4284297C4DC59F3DEE010050B6@orsmsx423.amr.corp.intel.com> <482217F3.2040900@numericable.fr> <924EFEDD5F540B4284297C4DC59F3DEE010057B4@orsmsx423.amr.corp.intel.com> <4822A6F7.7010704@numericable.fr> <B5B0CFF685D7DF46A05CF1678CFB42ED20E04609@orsmsx423.amr.corp.intel.com> <20080508192555.GA8643@linux-os.sc.intel.com>
In-Reply-To: <20080508192555.GA8643@linux-os.sc.intel.com>
Content-Type: multipart/mixed;
 boundary="------------020201070206030402040505"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020201070206030402040505
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable

Venki Pallipadi a =E9crit :
> On Thu, May 08, 2008 at 06:18:48AM -0700, Pallipadi, Venkatesh wrote:
>  =20
>> =20
>>
>>    =20
>>> -----Original Message-----
>>> From: Rufus & Azrael [mailto:rufus-azrael@numericable.fr]=20
>>> Sent: Thursday, May 08, 2008 12:09 AM
>>> To: Pallipadi, Venkatesh
>>> Cc: Ingo Molnar; Siddha, Suresh B; Linux-kernel Mailing List
>>> Subject: Re: [2.6.25-git18 =3D> 2.6.26-rc1-git1] Xorg crash with=20
>>> xf86MapVidMem error
>>>
>>> Pallipadi, Venkatesh a =E9crit :
>>>      =20
>>>> =20
>>>> One more piece of data I need. Can you please send the=20
>>>>        =20
>>> output of `cat /proc/mtrr` from this system (after the X=20
>>> failure has happened)
>>>      =20
>>>> Thanks,
>>>> Venki
>>>>
>>>>  =20
>>>>        =20
>>> Hi Venki,
>>>
>>>
>>> See my /proc/mtrr file attached.
>>>
>>>      =20
>> OK. Thanks for all the info.
>>
>> I think I figured out what is going wrong here:
>> 1) uvesafb is mapping 0xf0000000-0xf1000000
>> [4294014.924303] reserve_memtype added 0xf0000000-0xf1000000, track
>> uncached-minus, req uncached-minus, ret uncached-minus
>>
>> 2) Set up the framebuffer within that mapped region. Uvesafb is settin=
g
>> "write-combine" mtrr for framebuffer for this 16M. 0xf0000000-0xf10000=
00
>> [4294015.649340] uvesafb: framebuffer at 0xf0000000, mapped to
>> 0xffffc20010a80000, using 16384k, total 16384k
>> [4294015.649340] fb0: VESA VGA frame buffer device
>>
>> 3) Later when X starts up, it tries to map bigger PCI range
>> 0xf0000000-0xf8000000 from /dev/mem.
>>
>> 4) PAT check tries to make sure the entire region being mmap'ed is of =
the
>> same effective memory type. But in this case start of the address
>> (0xf0000000) is write-combine and end of the address is uncached. So,
>> with the new PAT code mmap fails with EINVAL, resulting in X failure.
>> xf86MapVidMem: Could not mmap framebuffer (0xf0000000,0x8000000) (Inva=
lid
>> argument)
>>
>>
>> Now we need to figure out a clean solution for this problem. I think w=
e
>> don't have to check the full range of address is of same type as long =
as we
>> are requesting for PAT type UC_MINUS and MTRR has WC sub ranges. But, =
we
>> need to think about other such conflict conditiond when having multipl=
e
>> users of same range (uvesafb and X) also. Will be back with a patch fo=
r
>> you to try and test.
>>
>>    =20
>
> Hi,
>
> Can you please check whether the patch below solves this problem. Also,=
 please
> send in 'dmesg' and /proc/mtrr output after you boot with this patch.
>
> Thanks,
> Venki
>
>
> Use UC_MINUS in reserve_memtype call with -1, when MTRR lookup fails fo=
r any
> reason.
>
> Change the logic in mtrr_type_lookup to just get the type from the star=
t
> address. Using start and end adddress is not right/complete as start an=
d
> end can be covered by different mtrr (where old code will fail) or
> start and end can be in same mtrr, but still have some different
> memory type region in between. Using only start is less restrictive and=

> deterministic.
>
> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>
> ---
>  arch/x86/kernel/cpu/mtrr/generic.c |    7 ++-----
>  arch/x86/mm/pat.c                  |    8 +-------
>  2 files changed, 3 insertions(+), 12 deletions(-)
>
> Index: linux-2.6/arch/x86/kernel/cpu/mtrr/generic.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/arch/x86/kernel/cpu/mtrr/generic.c	2008-05-02 09:45:=
23.000000000 -0700
> +++ linux-2.6/arch/x86/kernel/cpu/mtrr/generic.c	2008-05-08 12:22:16.00=
0000000 -0700
> @@ -48,7 +48,6 @@ module_param_named(show, mtrr_show, bool
>  /*
>   * Returns the effective MTRR type for the region
>   * Error returns:
> - * - 0xFE - when the range is "not entirely covered" by _any_ var rang=
e MTRR
>   * - 0xFF - when MTRR is not enabled
>   */
>  u8 mtrr_type_lookup(u64 start, u64 end)
> @@ -96,7 +95,7 @@ u8 mtrr_type_lookup(u64 start, u64 end)
> =20
>  	prev_match =3D 0xFF;
>  	for (i =3D 0; i < num_var_ranges; ++i) {
> -		unsigned short start_state, end_state;
> +		unsigned short start_state;
> =20
>  		if (!(mtrr_state.var_ranges[i].mask_lo & (1 << 11)))
>  			continue;
> @@ -107,9 +106,7 @@ u8 mtrr_type_lookup(u64 start, u64 end)
>  		       (mtrr_state.var_ranges[i].mask_lo & PAGE_MASK);
> =20
>  		start_state =3D ((start & mask) =3D=3D (base & mask));
> -		end_state =3D ((end & mask) =3D=3D (base & mask));
> -		if (start_state !=3D end_state)
> -			return 0xFE;
> +		/* Just check the type of start address */
> =20
>  		if ((start & mask) !=3D (base & mask)) {
>  			continue;
> Index: linux-2.6/arch/x86/mm/pat.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/arch/x86/mm/pat.c	2008-05-07 13:35:56.000000000 -070=
0
> +++ linux-2.6/arch/x86/mm/pat.c	2008-05-08 12:22:35.000000000 -0700
> @@ -162,10 +162,6 @@ static int pat_x_mtrr_type(u64 start, u6
>  		*ret_prot =3D prot;
>  		return 0;
>  	}
> -	if (mtrr_type =3D=3D 0xFE) {		/* MTRR match error */
> -		*ret_prot =3D _PAGE_CACHE_UC;
> -		return -1;
> -	}
>  	if (mtrr_type !=3D MTRR_TYPE_UNCACHABLE &&
>  	    mtrr_type !=3D MTRR_TYPE_WRBACK &&
>  	    mtrr_type !=3D MTRR_TYPE_WRCOMB) {	/* MTRR type unhandled */
> @@ -244,9 +240,7 @@ int reserve_memtype(u64 start, u64 end,=20
>  		 * no match.
>  		 */
>  		u8 mtrr_type =3D mtrr_type_lookup(start, end);
> -		if (mtrr_type =3D=3D 0xFE) { /* MTRR match error */
> -			err =3D -1;
> -		}
> +		/* MTRR lookup failed - Use UC_MINUS*/
> =20
>  		if (mtrr_type =3D=3D MTRR_TYPE_WRBACK) {
>  			req_type =3D _PAGE_CACHE_WB;
>
>  =20
Hi Venki,


Patch applied on 2.6.26-rc1-git5 and all works fine in X server with =20
CONFIG_X86_PAT=3Dy.

See dmesg and mtrr files attached.

Thanks for all,

Regards.


--------------020201070206030402040505
Content-Type: text/plain;
 name="dmesg.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="dmesg.log"

4] Overlap at 0x77fde000-0x77fdf000
[4294014.667081] reserve_memtype added 0x77fde000-0x77fdf000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294014.668374] New Entry
[4294014.668411] reserve_memtype added 0xe0090000-0xe0092000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294014.668465] New Entry
[4294014.668502] reserve_memtype added 0xfe8ff000-0xfe901000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294014.669345] Completing Region/Field/Buffer/Package initialization:................................................................................................
[4294014.674411] Initialized 8/17 Regions 22/22 Fields 30/30 Buffers 36/37 Packages (751 nodes)
[4294014.674487] Initializing Device/Processor/Thermal objects by executing _INI methods:<6>free_memtype request 0xe0090000-0xe0092000
[4294014.674601] New Entry
[4294014.674637] reserve_memtype added 0xe00a0000-0xe00a2000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294014.674703] ..
[4294014.674834] Executed 2 _INI methods requiring 0 _STA executions (examined 67 objects)
[4294014.674937] free_memtype request 0x77fde000-0x77fdf000
[4294014.674977] Overlap at 0x77fde000-0x77fdf000
[4294014.675013] reserve_memtype added 0x77fde000-0x77fdf000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294014.677255] evgpeblk-1052 [00] ev_initialize_gpe_bloc: Found 6 Wake, Enabled 11 Runtime GPEs in this block
[4294014.677372] ACPI: Interpreter enabled
[4294014.677408] ACPI: (supports S0 S5)
[4294014.677508] ACPI: Using IOAPIC for interrupt routing
[4294014.677588] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[4294014.680813] PCI: MCFG area at e0000000 reserved in ACPI motherboard resources
[4294014.681797] Overlap at 0xe00a0000-0xe00a2000
[4294014.681833] reserve_memtype added 0xe0000000-0xf0000000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294014.687615] PCI: Using MMCONFIG at e0000000 - efffffff
[4294014.694935] ACPI: PCI Root Bridge [PCI0] (0000:00)
[4294014.698495] PCI: Transparent bridge - 0000:00:14.4
[4294014.698541] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[4294014.698541] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0P1._PRT]
[4294014.698541] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCE7._PRT]
[4294014.698541] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.P0PC._PRT]
[4294014.702541] ACPI: PCI Interrupt Link [LNKA] (IRQs 3 4 *5 7 10 11 12 14 15)
[4294014.702541] ACPI: PCI Interrupt Link [LNKB] (IRQs *3 4 5 7 10 11 12 14 15)
[4294014.703008] ACPI: PCI Interrupt Link [LNKC] (IRQs 3 4 5 7 *10 11 12 14 15)
[4294014.703543] ACPI: PCI Interrupt Link [LNKD] (IRQs 3 4 5 7 *10 11 12 14 15)
[4294014.704022] ACPI: PCI Interrupt Link [LNKE] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
[4294014.704552] ACPI: PCI Interrupt Link [LNKF] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
[4294014.705085] ACPI: PCI Interrupt Link [LNKG] (IRQs 3 4 5 7 10 *11 12 14 15)
[4294014.705550] ACPI: PCI Interrupt Link [LNKH] (IRQs 3 4 5 7 10 11 12 14 15) *0, disabled.
[4294014.706611] Overlap at 0x77fd0000-0x77fd1000
[4294014.706611] reserve_memtype added 0x77fd0000-0x77fd1000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294014.706611] Overlap at 0x77fd0000-0x77fd1000
[4294014.706611] reserve_memtype added 0x77fd0000-0x77fd1000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294014.706611] Overlap at 0x77fde000-0x77fdf000
[4294014.706611] reserve_memtype added 0x77fde000-0x77fdf000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294014.706611] ACPI Warning (tbutils-0217): Incorrect checksum in table [OEMB] - FE, should be F2 [20080321]
[4294014.706611] Overlap at 0x77fd0000-0x77fd5000
[4294014.706611] reserve_memtype added 0x77fd4000-0x77fd5000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294014.706611] ACPI: WMI: Mapper loaded
[4294014.706611] Linux Plug and Play Support v0.97 (c) Adam Belay
[4294014.706611] pnp: PnP ACPI init
[4294014.706611] ACPI: bus type pnp registered
[4294014.710610] pnp: PnP ACPI: found 16 devices
[4294014.710610] ACPI: ACPI bus type pnp unregistered
[4294014.710610] SCSI subsystem initialized
[4294014.710610] libata version 3.00 loaded.
[4294014.711610] usbcore: registered new interface driver usbfs
[4294014.711610] usbcore: registered new interface driver hub
[4294014.711610] usbcore: registered new device driver usb
[4294014.711610] PCI: Using ACPI for IRQ routing
[4294014.720608] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0
[4294014.720608] hpet0: 4 32-bit timers, 14318180 Hz
[4294014.721608] ACPI: RTC can wake from S4
[4294014.722015] Switched to high resolution mode on CPU 0
[4294014.722958] Switched to high resolution mode on CPU 1
[4294014.727052] system 00:01: iomem range 0x78000000-0x7fffffff has been reserved
[4294014.727098] system 00:09: iomem range 0xfec00000-0xfec00fff has been reserved
[4294014.727138] system 00:09: iomem range 0xfee00000-0xfee00fff has been reserved
[4294014.727184] system 00:0a: ioport range 0x4d0-0x4d1 has been reserved
[4294014.727221] system 00:0a: ioport range 0x40b-0x40b has been reserved
[4294014.727257] system 00:0a: ioport range 0x4d6-0x4d6 has been reserved
[4294014.727949] system 00:0a: ioport range 0xc00-0xc01 has been reserved
[4294014.727986] system 00:0a: ioport range 0xc14-0xc14 has been reserved
[4294014.728023] system 00:0a: ioport range 0xc50-0xc51 has been reserved
[4294014.728060] system 00:0a: ioport range 0xc52-0xc52 has been reserved
[4294014.728096] system 00:0a: ioport range 0xc6c-0xc6c has been reserved
[4294014.728133] system 00:0a: ioport range 0xc6f-0xc6f has been reserved
[4294014.728170] system 00:0a: ioport range 0xcd0-0xcd1 has been reserved
[4294014.728207] system 00:0a: ioport range 0xcd2-0xcd3 has been reserved
[4294014.728244] system 00:0a: ioport range 0xcd4-0xcd5 has been reserved
[4294014.728266] system 00:0a: ioport range 0xcd6-0xcd7 has been reserved
[4294014.728266] system 00:0a: ioport range 0xcd8-0xcdf has been reserved
[4294014.728266] system 00:0a: ioport range 0x800-0x89f has been reserved
[4294014.728266] system 00:0a: ioport range 0xb10-0xb1f has been reserved
[4294014.728266] system 00:0a: ioport range 0x900-0x90f has been reserved
[4294014.728266] system 00:0a: ioport range 0x910-0x91f has been reserved
[4294014.728266] system 00:0a: ioport range 0xfe00-0xfefe has been reserved
[4294014.728266] system 00:0a: iomem range 0xffb80000-0xffbfffff has been reserved
[4294014.728266] system 00:0a: iomem range 0xfff80000-0xffffffff could not be reserved
[4294014.728266] system 00:0d: ioport range 0x600-0x6df has been reserved
[4294014.728310] system 00:0d: ioport range 0xae0-0xaef has been reserved
[4294014.728350] system 00:0e: iomem range 0xe0000000-0xefffffff has been reserved
[4294014.728393] system 00:0f: iomem range 0x0-0x9ffff could not be reserved
[4294014.728947] system 00:0f: iomem range 0xc0000-0xcffff has been reserved
[4294014.728985] system 00:0f: iomem range 0xe0000-0xfffff could not be reserved
[4294014.729022] system 00:0f: iomem range 0x100000-0x77ffffff could not be reserved
[4294014.729062] system 00:0f: iomem range 0xfec00000-0xffffffff could not be reserved
[4294014.729296] PCI: Bridge: 0000:00:01.0
[4294014.729339]   IO window: d000-dfff
[4294014.729376]   MEM window: 0xfe900000-0xfeafffff
[4294014.729413]   PREFETCH window: 0x00000000f0000000-0x00000000f7ffffff
[4294014.729450] PCI: Bridge: 0000:00:07.0
[4294014.729487]   IO window: e000-efff
[4294014.729523]   MEM window: 0xfeb00000-0xfebfffff
[4294014.729559]   PREFETCH window: disabled.
[4294014.729601] PCI: Bridge: 0000:00:14.4
[4294014.730190]   IO window: disabled.
[4294014.730229]   MEM window: disabled.
[4294014.730266]   PREFETCH window: disabled.
[4294014.730319] PCI: Setting latency timer of device 0000:00:07.0 to 64
[4294014.730333] NET: Registered protocol family 2
[4294014.740948] IP route cache hash table entries: 65536 (order: 7, 524288 bytes)
[4294014.741748] TCP established hash table entries: 262144 (order: 10, 4194304 bytes)
[4294014.744101] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[4294014.745264] TCP: Hash tables configured (established 262144 bind 65536)
[4294014.745305] TCP reno registered
[4294014.747921] NET: Registered protocol family 1
[4294014.753840] msgmni has been set to 3768 for ipc namespace ffffffff807d2a00
[4294014.753840] io scheduler noop registered
[4294014.753840] io scheduler anticipatory registered
[4294014.753840] io scheduler deadline registered
[4294014.753840] io scheduler cfq registered (default)
[4294014.753840] New Entry
[4294014.753840] reserve_memtype added 0xfe8fe000-0xfe8ff000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294014.774850] free_memtype request 0xfe8fe000-0xfe8ff000
[4294014.774899] New Entry
[4294014.774935] reserve_memtype added 0xfe8fd000-0xfe8fe000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294014.795849] free_memtype request 0xfe8fd000-0xfe8fe000
[4294014.795896] New Entry
[4294014.795931] reserve_memtype added 0xfe8fc000-0xfe8fd000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294014.816850] free_memtype request 0xfe8fc000-0xfe8fd000
[4294014.816897] New Entry
[4294014.816933] reserve_memtype added 0xfe8fb000-0xfe8fc000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294014.842166] free_memtype request 0xfe8fb000-0xfe8fc000
[4294014.842213] New Entry
[4294014.842248] reserve_memtype added 0xfe8fa000-0xfe8fb000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294014.863210] free_memtype request 0xfe8fa000-0xfe8fb000
[4294014.863257] Overlap at 0xfe8ff000-0xfe901000
[4294014.863294] reserve_memtype added 0xfe8ff000-0xfe900000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294014.873841] free_memtype request 0xfe8ff000-0xfe900000
[4294014.873893] pci 0000:01:05.0: Boot video device
[4294014.874699] PCI: Setting latency timer of device 0000:00:07.0 to 64
[4294014.874699] assign_interrupt_mode Found MSI capability
[4294014.874699] Allocate Port Service[0000:00:07.0:pcie00]
[4294014.874699] Allocate Port Service[0000:00:07.0:pcie03]
[4294014.874699] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[4294014.874699] acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
[4294014.876695] pciehp: PCI Express Hot Plug Controller Driver version: 0.4
[4294014.876695] shpchp: Standard Hot Plug PCI Controller Driver version: 0.4
[4294014.879696] New Entry
[4294014.879696] reserve_memtype added 0xfed00000-0xfed01000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294014.879696] hpet_resources: 0xfed00000 is busy
[4294014.879696] free_memtype request 0xfed00000-0xfed01000
[4294014.879696] Non-volatile memory driver v1.2
[4294014.879696] Linux agpgart interface v0.103
[4294014.879696] [drm] Initialized drm 1.1.0 20060810
[4294014.880085] ACPI: PCI Interrupt 0000:01:05.0[A] -> GSI 18 (level, low) -> IRQ 18
[4294014.880695] [drm] Initialized radeon 1.28.0 20060524 on minor 0
[4294014.880843] New Entry
[4294014.880843] reserve_memtype added 0x0-0x1000, track write-back, req write-back, ret write-back
[4294014.881698] uvesafb: (C) 1988-2005, ATI Technologies Inc. RS69001.00, RS69001.00, 01.00, OEM: ATI ATOMBIOS(C) 1988-2005, ATI Technologies Inc. RS69001.00, VBE v3.0
[4294014.898695] uvesafb: VBIOS/hardware supports DDC2 transfers
[4294014.958695] uvesafb: monitor limits: vf = 75 Hz, hf = 83 kHz, clk = 140 MHz
[4294014.958695] uvesafb: scrolling: redraw
[4294014.958695] New Entry
[4294014.958695] reserve_memtype added 0xf0000000-0xf1000000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294014.961030] uvesafb: mode switch failed (eax=0x34f, err=0). Trying again with default timings.
[4294015.205352] uvesafb: mode switch failed (eax=0x34f, err=0). Trying again with default timings.
[4294015.442355] Console: switching to colour frame buffer device 160x64
[4294015.442355] uvesafb: mode switch failed (eax=0x34f, err=0). Trying again with default timings.
[4294015.676796] uvesafb: framebuffer at 0xf0000000, mapped to 0xffffc20010a80000, using 16384k, total 16384k
[4294015.676796] fb0: VESA VGA frame buffer device
[4294015.676796] input: Power Button (FF) as /devices/LNXSYSTM:00/LNXPWRBN:00/input/input0
[4294015.681803] ACPI: Power Button (FF) [PWRF]
[4294015.682797] input: Power Button (CM) as /devices/LNXSYSTM:00/device:00/PNP0C0C:00/input/input1
[4294015.684811] ACPI: Power Button (CM) [PWRB]
[4294015.685798] ACPI: duty_cycle spans bit 4
[4294015.685798] ACPI: ACPI0007:00 is registered as cooling_device0
[4294015.685798] ACPI: ACPI0007:01 is registered as cooling_device1
[4294015.688520] Serial: 8250/16550 driver $Revision: 1.90 $ 4 ports, IRQ sharing disabled
[4294015.689533] loop: module loaded
[4294015.689533] r8169 Gigabit Ethernet driver 2.2LK loaded
[4294015.689571] ACPI: PCI Interrupt 0000:02:00.0[A] -> GSI 19 (level, low) -> IRQ 19
[4294015.689615] PCI: Setting latency timer of device 0000:02:00.0 to 64
[4294015.689621] New Entry
[4294015.689634] reserve_memtype added 0xfebff000-0xfec00000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294015.689687] r8169 0000:02:00.0: no MSI. Back to INTx.
[4294015.690532] eth0: RTL8101e at 0xffffc20000332000, 00:19:db:86:af:87, XID 34000000 IRQ 19
[4294015.691520] Linux video capture interface: v2.00
[4294015.691520] pwc: Philips webcam module version 10.0.13 loaded.
[4294015.691520] pwc: Supports Philips PCA645/646, PCVC675/680/690, PCVC720[40]/730/740/750 & PCVC830/840.
[4294015.691520] pwc: Also supports the Askey VC010, various Logitech Quickcams, Samsung MPC-C10 and MPC-C30,
[4294015.691520] pwc: the Creative WebCam 5 & Pro Ex, SOTEC Afina Eye and Visionite VCS-UC300 and VCS-UM100.
[4294015.691520] usbcore: registered new interface driver Philips webcam
[4294015.691520] Driver 'sd' needs updating - please use bus_type methods
[4294015.691520] Driver 'sr' needs updating - please use bus_type methods
[4294015.691520] ahci 0000:00:12.0: version 3.0
[4294015.691520] ACPI: PCI Interrupt 0000:00:12.0[A] -> GSI 22 (level, low) -> IRQ 22
[4294015.691520] Overlap at 0xfe8ff000-0xfe901000
[4294015.691520] reserve_memtype added 0xfe8ff000-0xfe900000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294015.691520] ahci 0000:00:12.0: controller can't do 64bit DMA, forcing 32bit
[4294015.691520] ahci 0000:00:12.0: controller can't do PMP, turning off CAP_PMP
[4294016.993657] ahci 0000:00:12.0: AHCI 0001.0100 32 slots 4 ports 3 Gbps 0xf impl SATA mode
[4294016.993689] ahci 0000:00:12.0: flags: ncq sntf ilck pm led clo pio slum part 
[4294016.994612] scsi0 : ahci
[4294016.994612] scsi1 : ahci
[4294016.994612] scsi2 : ahci
[4294016.994612] scsi3 : ahci
[4294016.996544] ata1: SATA max UDMA/133 abar m1024@0xfe8ff800 port 0xfe8ff900 irq 22
[4294016.997615] ata2: SATA max UDMA/133 abar m1024@0xfe8ff800 port 0xfe8ff980 irq 22
[4294016.998724] ata3: SATA max UDMA/133 abar m1024@0xfe8ff800 port 0xfe8ffa00 irq 22
[4294016.999827] ata4: SATA max UDMA/133 abar m1024@0xfe8ff800 port 0xfe8ffa80 irq 22
[4294017.305485] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[4294017.314613] ata1.00: ATA-8: SAMSUNG HD501LJ, CR100-10, max UDMA7
[4294017.318273] ata1.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 31/32)
[4294017.319433] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
[4294017.323540] ata1.00: SB600 AHCI: limiting to 255 sectors per cmd
[4294017.324650] ata1.00: configured for UDMA/133
[4294017.630429] ata2: SATA link down (SStatus 0 SControl 300)
[4294017.936429] ata3: SATA link down (SStatus 0 SControl 300)
[4294018.242429] ata4: SATA link down (SStatus 0 SControl 300)
[4294018.243625] isa bounce pool size: 16 pages
[4294018.245023] scsi 0:0:0:0: Direct-Access     ATA      SAMSUNG HD501LJ  CR10 PQ: 0 ANSI: 5
[4294018.247287] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
[4294018.248588] sd 0:0:0:0: [sda] Write Protect is off
[4294018.249735] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[4294018.249757] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[4294018.251108] sd 0:0:0:0: [sda] 976773168 512-byte hardware sectors (500108 MB)
[4294018.252473] sd 0:0:0:0: [sda] Write Protect is off
[4294018.253811] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[4294018.253831] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[4294018.255171]  sda: sda1 sda2 sda3 sda4 < sda5 sda6 sda7 sda8 sda9 sda10 sda11 >
[4294018.409343] sd 0:0:0:0: [sda] Attached SCSI disk
[4294018.411190] sd 0:0:0:0: Attached scsi generic sg0 type 0
[4294018.412603] ACPI: PCI Interrupt 0000:00:14.1[A] -> GSI 16 (level, low) -> IRQ 16
[4294018.414190] PCI: Setting latency timer of device 0000:00:14.1 to 64
[4294018.414190] scsi4 : pata_atiixp
[4294018.415494] scsi5 : pata_atiixp
[4294018.417892] ata5: PATA max UDMA/100 cmd 0x1f0 ctl 0x3f6 bmdma 0xff00 irq 14
[4294018.418604] ata6: PATA max UDMA/100 cmd 0x170 ctl 0x376 bmdma 0xff08 irq 15
[4294018.573771] ata5.00: ATAPI: TSSTcorpCD/DVDW SH-S182D, SB05, max UDMA/33
[4294018.580712] ata5.00: configured for UDMA/33
[4294018.732303] scsi 4:0:0:0: CD-ROM            TSSTcorp CD/DVDW SH-S182D SB05 PQ: 0 ANSI: 5
[4294018.745323] sr0: scsi3-mmc drive: 48x/48x writer dvd-ram cd/rw xa/form2 cdda tray
[4294018.748372] Uniform CD-ROM driver Revision: 3.20
[4294018.750739] sr 4:0:0:0: Attached scsi CD-ROM sr0
[4294018.750739] sr 4:0:0:0: Attached scsi generic sg1 type 5
[4294018.752322] ACPI: PCI Interrupt 0000:00:13.5[D] -> GSI 19 (level, low) -> IRQ 19
[4294018.753335] Overlap at 0xfe8ff000-0xfe900000
[4294018.754672] reserve_memtype added 0xfe8ff000-0xfe900000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294018.756335] ehci_hcd 0000:00:13.5: EHCI Host Controller
[4294018.758034] ehci_hcd 0000:00:13.5: new USB bus registered, assigned bus number 1
[4294018.759405] ehci_hcd 0000:00:13.5: debug port 1
[4294018.760437] ehci_hcd 0000:00:13.5: irq 19, io mem 0xfe8ff000
[4294018.766340] ehci_hcd 0000:00:13.5: USB 2.0 started, EHCI 1.00, driver 10 Dec 2004
[4294018.768646] usb usb1: configuration #1 chosen from 1 choice
[4294018.770140] hub 1-0:1.0: USB hub found
[4294018.771445] hub 1-0:1.0: 10 ports detected
[4294018.873333] 116x: driver isp116x-hcd, 03 Nov 2005
[4294018.874729] ohci_hcd: 2006 August 04 USB 1.1 'Open' Host Controller (OHCI) Driver
[4294018.874729] ACPI: PCI Interrupt 0000:00:13.0[A] -> GSI 16 (level, low) -> IRQ 16
[4294018.875733] New Entry
[4294018.877104] reserve_memtype added 0xfe8fe000-0xfe8ff000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294018.878992] ohci_hcd 0000:00:13.0: OHCI Host Controller
[4294018.880644] ohci_hcd 0000:00:13.0: new USB bus registered, assigned bus number 2
[4294018.881996] ohci_hcd 0000:00:13.0: irq 16, io mem 0xfe8fe000
[4294018.938316] usb usb2: configuration #1 chosen from 1 choice
[4294018.939455] hub 2-0:1.0: USB hub found
[4294018.940527] hub 2-0:1.0: 2 ports detected
[4294019.043068] ACPI: PCI Interrupt 0000:00:13.1[B] -> GSI 17 (level, low) -> IRQ 17
[4294019.044073] New Entry
[4294019.045455] reserve_memtype added 0xfe8fd000-0xfe8fe000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294019.046882] ohci_hcd 0000:00:13.1: OHCI Host Controller
[4294019.048876] ohci_hcd 0000:00:13.1: new USB bus registered, assigned bus number 3
[4294019.050335] ohci_hcd 0000:00:13.1: irq 17, io mem 0xfe8fd000
[4294019.079918] hub 1-0:1.0: unable to enumerate USB device on port 1
[4294019.106903] usb usb3: configuration #1 chosen from 1 choice
[4294019.108223] hub 3-0:1.0: USB hub found
[4294019.109686] hub 3-0:1.0: 2 ports detected
[4294019.211655] ACPI: PCI Interrupt 0000:00:13.2[C] -> GSI 18 (level, low) -> IRQ 18
[4294019.212663] New Entry
[4294019.214207] reserve_memtype added 0xfe8fc000-0xfe8fd000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294019.215841] ohci_hcd 0000:00:13.2: OHCI Host Controller
[4294019.217691] ohci_hcd 0000:00:13.2: new USB bus registered, assigned bus number 4
[4294019.218928] ohci_hcd 0000:00:13.2: irq 18, io mem 0xfe8fc000
[4294019.276403] usb usb4: configuration #1 chosen from 1 choice
[4294019.277820] hub 4-0:1.0: USB hub found
[4294019.279370] hub 4-0:1.0: 2 ports detected
[4294019.287167] usb 1-9: new high speed USB device using ehci_hcd and address 3
[4294019.381527] ACPI: PCI Interrupt 0000:00:13.3[B] -> GSI 17 (level, low) -> IRQ 17
[4294019.382532] New Entry
[4294019.384130] reserve_memtype added 0xfe8fb000-0xfe8fc000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294019.385678] ohci_hcd 0000:00:13.3: OHCI Host Controller
[4294019.387806] ohci_hcd 0000:00:13.3: new USB bus registered, assigned bus number 5
[4294019.388817] ohci_hcd 0000:00:13.3: irq 17, io mem 0xfe8fb000
[4294019.403854] usb 1-9: configuration #1 chosen from 1 choice
[4294019.447195] usb usb5: configuration #1 chosen from 1 choice
[4294019.448593] hub 5-0:1.0: USB hub found
[4294019.450140] hub 5-0:1.0: 2 ports detected
[4294019.551947] ACPI: PCI Interrupt 0000:00:13.4[C] -> GSI 18 (level, low) -> IRQ 18
[4294019.552952] New Entry
[4294019.554560] reserve_memtype added 0xfe8fa000-0xfe8fb000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294019.556280] ohci_hcd 0000:00:13.4: OHCI Host Controller
[4294019.558435] ohci_hcd 0000:00:13.4: new USB bus registered, assigned bus number 6
[4294019.559449] ohci_hcd 0000:00:13.4: irq 18, io mem 0xfe8fa000
[4294019.616836] usb usb6: configuration #1 chosen from 1 choice
[4294019.618262] hub 6-0:1.0: USB hub found
[4294019.619810] hub 6-0:1.0: 2 ports detected
[4294019.625596] usb 2-1: new full speed USB device using ohci_hcd and address 2
[4294019.721003] sl811: driver sl811-hcd, 19 May 2005
[4294019.723476] driver u132_hcd built at 21:59:42 on May  8 2008
[4294019.725032] r8a66597_hcd: driver r8a66597_hcd, 10 Apr 2008
[4294019.726593] Initializing USB Mass Storage driver...
[4294019.830864] usb 2-1: configuration #1 chosen from 1 choice
[4294019.835352] pwc: Logitech QuickCam Pro 3000 USB webcam detected.
[4294019.837618] pwc: Registered as /dev/video0.
[4294020.111280] scsi6 : SCSI emulation for USB Mass Storage devices
[4294020.112280] usb-storage: device found at 3
[4294020.112280] usb-storage: waiting for device to settle before scanning
[4294020.112889] usbcore: registered new interface driver usb-storage
[4294020.114385] USB Mass Storage support registered.
[4294020.115883] driver ftdi-elan built at 21:59:37 on May  8 2008
[4294020.117757] usbcore: registered new interface driver ftdi-elan
[4294020.119341] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at 0x60,0x64 irq 1,12
[4294020.122232] serio: i8042 KBD port at 0x60,0x64 irq 1
[4294020.123698] serio: i8042 AUX port at 0x60,0x64 irq 12
[4294020.125938] mice: PS/2 mouse device common for all mice
[4294020.140646] input: AT Translated Set 2 keyboard as /devices/platform/i8042/serio0/input/input2
[4294020.161646] input: PC Speaker as /devices/platform/pcspkr/input/input3
[4294020.298098] logips2pp: Detected unknown logitech mouse model 127
[4294020.785654] input: ImExPS/2 Logitech Explorer Mouse as /devices/platform/i8042/serio1/input/input4
[4294020.807606] rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
[4294020.808650] rtc0: alarms up to one month, y3k
[4294020.811055] piix4_smbus 0000:00:14.0: Found 0000:00:14.0 device
[4294020.812706] EDAC MC: Ver: 2.1.0 May  8 2008
[4294020.814153] cpuidle: using governor ladder
[4294020.815563] cpuidle: using governor menu
[4294020.817158] usbcore: registered new interface driver hiddev
[4294020.818631] usbcore: registered new interface driver usbhid
[4294020.819635] usbhid: v2.6:USB HID core driver
[4294020.821427] Advanced Linux Sound Architecture Driver Version 1.0.16.
[4294020.822814] ACPI: PCI Interrupt 0000:00:14.2[A] -> GSI 16 (level, low) -> IRQ 16
[4294020.823840] New Entry
[4294020.825482] reserve_memtype added 0xfe8f4000-0xfe8f8000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294020.902938] usbcore: registered new interface driver snd-usb-audio
[4294020.903951] ALSA device list:
[4294020.905455]   #0: HDA ATI SB at 0xfe8f4000 irq 16
[4294020.906941]   #1: USB Device 0x46d:0x8b0 at usb-0000:00:13.0-1, full speed
[4294020.908396] Netfilter messages via NETLINK v0.30.
[4294020.909843] nf_conntrack version 0.5.0 (16384 buckets, 65536 max)
[4294020.911936] TCP cubic registered
[4294020.913057] Initializing XFRM netlink socket
[4294020.914403] NET: Registered protocol family 17
[4294020.915781] NET: Registered protocol family 15
[4294020.917723] powernow-k8: Found 1 AMD Athlon(tm) 64 X2 Dual Core Processor 6000+ processors (2 cpu cores) (version 2.20.00)
[4294020.918774] powernow-k8:    0 : fid 0x16 (3000 MHz), vid 0x8
[4294020.920728] powernow-k8:    1 : fid 0x14 (2800 MHz), vid 0xa
[4294020.922074] powernow-k8:    2 : fid 0x12 (2600 MHz), vid 0xc
[4294020.923408] powernow-k8:    3 : fid 0x10 (2400 MHz), vid 0xe
[4294020.924834] powernow-k8:    4 : fid 0xe (2200 MHz), vid 0x10
[4294020.926149] powernow-k8:    5 : fid 0xc (2000 MHz), vid 0x10
[4294020.927432] powernow-k8:    6 : fid 0xa (1800 MHz), vid 0x10
[4294020.928785] powernow-k8:    7 : fid 0x2 (1000 MHz), vid 0x12
[4294021.006827] kjournald starting.  Commit interval 5 seconds
[4294021.020198] EXT3-fs: mounted filesystem with ordered data mode.
[4294021.021437] VFS: Mounted root (ext3 filesystem) readonly.
[4294021.023441] Freeing unused kernel memory: 508k freed
[4294021.024951] Write protecting the kernel read-only data: 5844k
[4294022.403997] Clocksource tsc unstable (delta = -334189613 ns)
[4294023.129719] parport_pc 00:07: reported by Plug and Play ACPI
[4294023.129732] parport0: PC-style at 0x378, irq 7 [PCSPP(,...)]
[4294025.262977] usb-storage: device scan complete
[4294025.262977] scsi 6:0:0:0: Direct-Access     Generic  USB SD Reader    1.00 PQ: 0 ANSI: 0
[4294025.264831] scsi 6:0:0:1: Direct-Access     Generic  USB CF Reader    1.01 PQ: 0 ANSI: 0
[4294025.264831] scsi 6:0:0:2: Direct-Access     Generic  USB SM Reader    1.02 PQ: 0 ANSI: 0
[4294025.265831] scsi 6:0:0:3: Direct-Access     Generic  USB MS Reader    1.03 PQ: 0 ANSI: 0
[4294025.267862] sd 6:0:0:0: [sdb] Attached SCSI removable disk
[4294025.267887] sd 6:0:0:0: Attached scsi generic sg2 type 0
[4294025.276832] sd 6:0:0:1: [sdc] Attached SCSI removable disk
[4294025.276858] sd 6:0:0:1: Attached scsi generic sg3 type 0
[4294025.291969] sd 6:0:0:2: [sdd] Attached SCSI removable disk
[4294025.291997] sd 6:0:0:2: Attached scsi generic sg4 type 0
[4294025.299831] sd 6:0:0:3: [sde] Attached SCSI removable disk
[4294025.299831] sd 6:0:0:3: Attached scsi generic sg5 type 0
[4294058.846278] EXT3 FS on sda3, internal journal
[4294059.048882] kjournald starting.  Commit interval 5 seconds
[4294059.048882] EXT3 FS on sda5, internal journal
[4294059.048882] EXT3-fs: mounted filesystem with ordered data mode.
[4294059.062888] kjournald starting.  Commit interval 5 seconds
[4294059.062888] EXT3 FS on sda6, internal journal
[4294059.062888] EXT3-fs: mounted filesystem with ordered data mode.
[4294059.111895] kjournald starting.  Commit interval 5 seconds
[4294059.111968] EXT3 FS on sda7, internal journal
[4294059.111971] EXT3-fs: mounted filesystem with ordered data mode.
[4294059.123887] kjournald starting.  Commit interval 5 seconds
[4294059.123887] EXT3 FS on sda8, internal journal
[4294059.123887] EXT3-fs: mounted filesystem with ordered data mode.
[4294059.158889] kjournald starting.  Commit interval 5 seconds
[4294059.160890] EXT3 FS on sda9, internal journal
[4294059.160890] EXT3-fs: mounted filesystem with ordered data mode.
[4294059.171894] kjournald starting.  Commit interval 5 seconds
[4294059.171894] EXT3 FS on sda10, internal journal
[4294059.171894] EXT3-fs: mounted filesystem with ordered data mode.
[4294059.253922] ReiserFS: sda11: found reiserfs format "3.6" with standard journal
[4294059.253922] ReiserFS: sda11: using ordered data mode
[4294059.262911] ReiserFS: sda11: journal params: device sda11, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
[4294059.265172] ReiserFS: sda11: checking transaction log (sda11)
[4294059.274915] ReiserFS: sda11: Using r5 hash to sort names
[4294060.630491] uvesafb: mode switch failed (eax=0x34f, err=0). Trying again with default timings.
[4294061.991228] r8169: eth0: link up
[4294061.991234] r8169: eth0: link up
[4294064.569418] Adding 2008116k swap on /dev/sda2.  Priority:-1 extents:1 across:2008116k
[4294071.133455] New Entry
[4294071.133461] reserve_memtype added 0xfeaf0000-0xfeb00000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294071.180296] ip_tables: (C) 2000-2006 Netfilter Core Team
[4294071.274495] free_memtype request 0xfeaf0000-0xfeb00000
[4294071.276395] New Entry
[4294071.276397] reserve_memtype added 0xfeaf0000-0xfeb00000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294071.278494] Overlap at 0xf0000000-0xf1000000
[4294071.278496] reserve_memtype added 0xf0000000-0xf8000000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294071.656420] Overlap at 0xf0000000-0xf8000000
[4294071.656426] reserve_memtype added 0xf0000000-0xf8000000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294071.656511] Overlap at 0xfeaf0000-0xfeb00000
[4294071.656513] reserve_memtype added 0xfeaf0000-0xfeb00000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294071.660628] free_memtype request 0xf0000000-0xf8000000
[4294071.660651] free_memtype request 0xfeaf0000-0xfeb00000
[4294072.177663] Overlap at 0xf0000000-0xf8000000
[4294072.177670] reserve_memtype added 0xf0000000-0xf8000000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294072.177765] Overlap at 0xfeaf0000-0xfeb00000
[4294072.177767] reserve_memtype added 0xfeaf0000-0xfeb00000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294072.181753] free_memtype request 0xf0000000-0xf8000000
[4294072.181770] free_memtype request 0xfeaf0000-0xfeb00000
[4294073.719242] Overlap at 0xf0000000-0xf8000000
[4294073.719250] reserve_memtype added 0xf0000000-0xf8000000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294073.719364] Overlap at 0xfeaf0000-0xfeb00000
[4294073.719366] reserve_memtype added 0xfeaf0000-0xfeb00000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294073.724222] free_memtype request 0xf0000000-0xf8000000
[4294073.724244] free_memtype request 0xfeaf0000-0xfeb00000
[4294074.132216] Overlap at 0xf0000000-0xf8000000
[4294074.132223] reserve_memtype added 0xf0000000-0xf8000000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294074.132334] Overlap at 0xfeaf0000-0xfeb00000
[4294074.132335] reserve_memtype added 0xfeaf0000-0xfeb00000, track uncached-minus, req uncached-minus, ret uncached-minus
[4294074.137333] free_memtype request 0xf0000000-0xf8000000
[4294074.137333] free_memtype request 0xfeaf0000-0xfeb00000
[4294075.573895] ctnetlink v0.93: registering with nfnetlink.
[4294075.808754] ClusterIP Version 0.8 loaded successfully
[4294079.695769] uvesafb: mode switch failed (eax=0x34f, err=0). Trying again with default timings.
[4294080.163127] uvesafb: mode switch failed (eax=0x34f, err=0). Trying again with default timings.

--------------020201070206030402040505
Content-Type: text/plain;
 name="mtrr"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mtrr"

reg00: base=0x00000000 (   0MB), size=2048MB: write-back, count=1
reg01: base=0xf0000000 (3840MB), size= 128MB: write-combining, count=1

--------------020201070206030402040505--
