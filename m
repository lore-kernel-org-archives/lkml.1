Return-Path: <linux-kernel-owner+w=401wt.eu-S1752738AbZBZIlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbZBZIlg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 03:41:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753564AbZBZIlX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 03:41:23 -0500
Received: from hera.kernel.org ([140.211.167.34]:57336 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753653AbZBZIlW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 03:41:22 -0500
Message-ID: <49A65556.5090805@kernel.org>
Date: Thu, 26 Feb 2009 00:39:50 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ravikiran G Thirumalai <kiran@scalex86.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       shai@scalex86.org
Subject: Re: [PATCH] x86: don't compile vsmp_64 for 32bit
References: <49A626B2.8090205@kernel.org> <20090226064806.GC27240@localdomain>
In-Reply-To: <20090226064806.GC27240@localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ravikiran G Thirumalai wrote:
> On Wed, Feb 25, 2009 at 09:20:50PM -0800, Yinghai Lu wrote:
>> Impact: cleanup
>>
>> that is only needed when CONFIG_X86_VSMP is defined with 64bit
>> also remove dead code about PCI, because CONFIG_X86_VSMP depends on PCI
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>>
> 
> NAK!
> vsmp64.c is compiled unconditionally for a reason.  There are ifdefs in the
> file to avoid code compilation based on config options. is_vsmp_box() is
> needed even when CONFIG_X86_VSMP is not enabled, since distro kernels don't ship
> with CONFIG_X86_VSMP, and since is_vsmp_box() is used to determine  whether
> tsc's can be considered synced or not, this is needed.

so even CONFIG_X86_VSMP is not defined, you want all x86 systems including 32bit kernel and 64bit kernel 
to call

static int is_vsmp = -1;

static void __init detect_vsmp_box(void)
{
        is_vsmp = 0;

        if (!early_pci_allowed())
                return;

        /* Check if we are running on a ScaleMP vSMPowered box */
        if (read_pci_config(0, 0x1f, 0, PCI_VENDOR_ID) ==
             (PCI_VENDOR_ID_SCALEMP | (PCI_DEVICE_ID_SCALEMP_VSMP_CTL << 16)))
                is_vsmp = 1;
}

int is_vsmp_box(void)
{
        if (is_vsmp != -1)
                return is_vsmp;
        else {
                WARN_ON_ONCE(1);
                return 0;
        }
}


> 
> In the future, I would appreciate if you copy me on cleanups/changes involving
> vsmp64.c

i didn't touch vsmp64.c

YH

> 
> Thanks,
> Kiran
> 
>> ---
>> arch/x86/include/asm/apic.h  |    7 +++++++
>> arch/x86/include/asm/setup.h |    4 ++++
>> arch/x86/kernel/Makefile     |    2 +-
>> arch/x86/kernel/setup.c      |    2 --
>> arch/x86/kernel/vsmp_64.c    |   12 +-----------
>> 5 files changed, 13 insertions(+), 14 deletions(-)
>>
>> Index: linux-2.6/arch/x86/include/asm/apic.h
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/include/asm/apic.h
>> +++ linux-2.6/arch/x86/include/asm/apic.h
>> @@ -75,7 +75,14 @@ static inline void default_inquire_remot
>> #define setup_secondary_clock setup_secondary_APIC_clock
>> #endif
>>
>> +#ifdef CONFIG_X86_VSMP
>> extern int is_vsmp_box(void);
>> +#else
>> +static inline int is_vsmp_box(void)
>> +{
>> +	return 0;
>> +}
>> +#endif
>> extern void xapic_wait_icr_idle(void);
>> extern u32 safe_xapic_wait_icr_idle(void);
>> extern void xapic_icr_write(u32, u32);
>> Index: linux-2.6/arch/x86/include/asm/setup.h
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/include/asm/setup.h
>> +++ linux-2.6/arch/x86/include/asm/setup.h
>> @@ -64,7 +64,11 @@ extern void x86_quirk_time_init(void);
>> #include <asm/bootparam.h>
>>
>> /* Interrupt control for vSMPowered x86_64 systems */
>> +#ifdef CONFIG_X86_VSMP
>> void vsmp_init(void);
>> +#else
>> +static inline void vsmp_init(void) { }
>> +#endif
>>
>> void setup_bios_corruption_check(void);
>>
>> Index: linux-2.6/arch/x86/kernel/Makefile
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/kernel/Makefile
>> +++ linux-2.6/arch/x86/kernel/Makefile
>> @@ -70,7 +70,7 @@ obj-$(CONFIG_FUNCTION_GRAPH_TRACER)	+= f
>> obj-$(CONFIG_KEXEC)		+= machine_kexec_$(BITS).o
>> obj-$(CONFIG_KEXEC)		+= relocate_kernel_$(BITS).o crash.o
>> obj-$(CONFIG_CRASH_DUMP)	+= crash_dump_$(BITS).o
>> -obj-y				+= vsmp_64.o
>> +obj-$(CONFIG_X86_VSMP)		+= vsmp_64.o
>> obj-$(CONFIG_KPROBES)		+= kprobes.o
>> obj-$(CONFIG_MODULES)		+= module_$(BITS).o
>> obj-$(CONFIG_EFI) 		+= efi.o efi_$(BITS).o efi_stub_$(BITS).o
>> Index: linux-2.6/arch/x86/kernel/setup.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/kernel/setup.c
>> +++ linux-2.6/arch/x86/kernel/setup.c
>> @@ -863,9 +863,7 @@ void __init setup_arch(char **cmdline_p)
>>
>> 	reserve_initrd();
>>
>> -#ifdef CONFIG_X86_64
>> 	vsmp_init();
>> -#endif
>>
>> 	io_delay_init();
>>
>> Index: linux-2.6/arch/x86/kernel/vsmp_64.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/kernel/vsmp_64.c
>> +++ linux-2.6/arch/x86/kernel/vsmp_64.c
>> @@ -22,7 +22,7 @@
>> #include <asm/paravirt.h>
>> #include <asm/setup.h>
>>
>> -#if defined CONFIG_PCI && defined CONFIG_PARAVIRT
>> +#ifdef CONFIG_PARAVIRT
>> /*
>>  * Interrupt control on vSMPowered systems:
>>  * ~AC is a shadow of IF.  If IF is 'on' AC should be 'off'
>> @@ -114,7 +114,6 @@ static void __init set_vsmp_pv_ops(void)
>> }
>> #endif
>>
>> -#ifdef CONFIG_PCI
>> static int is_vsmp = -1;
>>
>> static void __init detect_vsmp_box(void)
>> @@ -139,15 +138,6 @@ int is_vsmp_box(void)
>> 		return 0;
>> 	}
>> }
>> -#else
>> -static void __init detect_vsmp_box(void)
>> -{
>> -}
>> -int is_vsmp_box(void)
>> -{
>> -	return 0;
>> -}
>> -#endif
>>
>> void __init vsmp_init(void)
>> {
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/

