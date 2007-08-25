Return-Path: <linux-kernel-owner+w=401wt.eu-S1761649AbXHYDbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761649AbXHYDbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 23:31:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752846AbXHYDbJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 23:31:09 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:39067 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752288AbXHYDbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 23:31:06 -0400
Date: Fri, 24 Aug 2007 20:30:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Tilman Schmidt <tilman@imap.cc>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       john stultz <johnstul@us.ibm.com>, Andi Kleen <ak@suse.de>,
       Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       Dave Jones <davej@codemonkey.org.uk>, Thomas Renninger <trenn@suse.de>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Subject: Re: 2.6.23-rc3-mm1
Message-Id: <20070824203000.1d710cee.akpm@linux-foundation.org>
In-Reply-To: <46CF7C3F.10707@imap.cc>
References: <20070822020648.5ea3a612.akpm@linux-foundation.org>
	<46CF695D.1020008@imap.cc>
	<20070824170702.a2c51084.akpm@linux-foundation.org>
	<46CF7C3F.10707@imap.cc>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Aug 2007 02:47:59 +0200 Tilman Schmidt <tilman@imap.cc> wrote:

> Am 25.08.2007 02:07 schrieb Andrew Morton:
> > On Sat, 25 Aug 2007 01:27:25 +0200
> > Tilman Schmidt <tilman@imap.cc> wrote:
> > 
> >> Am 22.08.2007 11:06 schrieb Andrew Morton:
> >>> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.23-rc3/2.6.23-rc3-mm1/
> 
> >> After applying Matthew Wilcox' patch to include/linux/isa.h
> > 
> > which patch is that?
> 
> The one allowing drivers/scsi/advansys.c to compile with CONFIG_ISA=n:
> 
> Date: 	Wed, 22 Aug 2007 10:28:02 -0600
> From: Matthew Wilcox <matthew@wil.cx>
> Subject: Re: drivers/scsi/advansys.c - ld error ( Re: 2.6.23-rc3-mm1 )
> Message-ID: <20070822162802.GJ9163@parisc-linux.org>
> 
> When CONFIG_ISA is disabled, the isa_driver support will not be compiled
> in.  Define stubs so that we don't get link-time errors.

oh, OK, I have that.

> >> this compiles
> >> and boots on my Intel/openSUSE 10.2 test machine but throws out the
> >> following messages I don't remember ever seeing with other kernels:
> >>
> >> - on console early during boot, also in SuSE's /var/log/boot.msg:
> >>
> >> your system time is not correct:
> >> Wed Jul 13 13:15:31 UTC 1910
> >> setting system time to:
> >> Tue Jul 24 00:00:00 UTC 2007
> > 
> > What architecture?
> 
> i386. The machine is a Pentium D 940 which would be x86_64 capable,
> but I'm still running 32 bit kernels on it.

OK.

> > if x86_64 then perhaps something went wrong with the old x86_64 dynticks
> > leftovers which were in rc3-mm1.  I've just merged a shiny fresh new series
> > so perhaps things there got fixed.  Please retest next -mm.
> 
> Will do that anyway.

It looks like you'll need to :(

> > Perhaps it would be helpful if you could do a 
> > 
> > 	diff -u dmesg-2.6.23-rc3 dmesg-2.6.26-rc3-mm1
> 
> I hope the attached helps. I created it by taking /var/log/boot.msg
> of the two systems, removing everything after "Kernel logging stopped",
> editing out the printk timestamps and then running diff -u on them,
> so it should be more or less the dmesg diff. I did not edit out any
> of the differences because I'm lazy. (And also because I wasn't so sure
> what would or wouldn't be interesting for you.)
> 

--- /tmp/bootmsg-2.6.23-rc3	2007-08-25 02:25:54.000000000 +0200
> +++ /tmp/bootmsg-2.6.23-rc3-mm1	2007-08-25 02:26:08.000000000 +0200
> @@ -1,10 +1,10 @@
>
> ...
>
>  <6>..TIMER: vector=0x31 apic1=0 pin1=2 apic2=-1 pin2=-1
> -<6>checking TSC synchronization [CPU#0 -> CPU#1]: passed.
> +<6>checking TSC synchronization [CPU#0 -> CPU#1]:
> +<4>Measured 32 cycles TSC warp between CPUs, turning off TSC clock.
> +<4>Marking TSC unstable due to: check_tsc_sync_source failed.

looky here.

>  <6>Brought up 2 CPUs
>  <6>Booting paravirtualized kernel on bare hardware
>  <6>NET: Registered protocol family 16
>  <6>ACPI: bus type pci registered
> -<3>PCI: BIOS Bug: MCFG area at f0000000 is not E820-reserved
> -<3>PCI: Not using MMCONFIG.

hm, I wonder if that's related.

>  <6>PCI: Using configuration type 1
>  <4>Setting up standard PCI resources
>  <7>ACPI: EC: Look up EC in DSDT
>  <6>ACPI: Interpreter enabled
>  <6>ACPI: (supports S0 S3)
>  <6>ACPI: Using IOAPIC for interrupt routing
> +<5>PCI: MCFG configuration 0: base 4026531840 segment 0 buses 0 - 127
> +<5>PCI: MCFG area at f0000000 reserved in ACPI motherboard resources
> +<6>PCI: Using MMCONFIG

we're using mmconfig

>  <6>ACPI: PCI Root Bridge [PCI0] (0000:00)
> +<7>PCI: Probing PCI hardware (bus 00)
>  <4>PCI quirk: region 0400-047f claimed by ICH6 ACPI/GPIO/TCO
>  <4>PCI quirk: region 0500-053f claimed by ICH6 GPIO
>  <6>PCI: Transparent bridge - 0000:00:1e.0
> @@ -285,7 +291,9 @@
>  <6>NetLabel:  protocols = UNLABELED CIPSOv4
>  <6>NetLabel:  unlabeled traffic allowed by default
>  <4>ACPI: RTC can wake from S4
> -<6>Time: tsc clocksource has been installed.
> +<6>Time: hpet clocksource has been installed.
> +<6>Switched to high resolution mode on CPU 0
> +<6>Switched to high resolution mode on CPU 1

No longer using tsc, using hpet instead.  Slower.

> -<7>hpet_resources: 0xfed00000 is busy
> +<4>hpet_acpi_add: no address or irqs in _CRS

oh boy

> +<4>thermal: Unknown symbol acpi_processor_set_thermal_limit

I think there are acpi fixes in Len's latest tree which will fix this.

>  <6>Linux agpgart interface v0.102
> +<6>rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
> +<4>rtc_cmos: probe of 00:03 failed with error -16
> +<6>agpgart: suspend/resume problematic: resume with 3D/DRI active may lockup X.Org
> +<4>on some chipset/BIOS combos (see DEBUG_AGP_PM in intel-agp.c)
>  <6>agpgart: Detected an Intel 965Q Chipset.
>  <6>agpgart: Unknown page table size, assuming 512KB
>  <6>agpgart: Detected 7676K stolen memory.
>  <6>agpgart: AGP aperture is 256M @ 0x40000000
> -<6>rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
> -<4>rtc_cmos: probe of 00:03 failed with error -16

I wonder if that was supposed to happen.  It's also happening in 2.6.23-rc3
base.


I don't see anything there which would cause you to lose the clock setting,
but there are obviously a few things going wrong in the time-management
area here.  Please explicity retest this stuff as the code evolves and kepp
us informed of the problems.

Thanks.
