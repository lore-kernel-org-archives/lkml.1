Return-Path: <linux-kernel-owner+w=401wt.eu-S1756890AbYFER07@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890AbYFER07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 13:26:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753211AbYFER0t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 13:26:49 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:39688 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbYFER0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 13:26:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ily2Yv1m3SER8NMOH5BzqDCYUkmueR5gp4pbf43kF4Ioh3u+6TYRkJPpSHiI5Vsz3F
         +tHEtsxjoCB5eZaLVddEjInfLsKG/q1izwAsiTKzx0qu/yVYjZMWcIyJ5FiQv5cal7u3
         4jsNBCH1qlwbfkG8AgnsR4+PnENjZr2PhN1fE=
Message-ID: <86802c440806051026o113a3b0kea16d49cdfb9d488@mail.gmail.com>
Date: Thu, 5 Jun 2008 10:26:46 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Sam Ravnborg" <sam@ravnborg.org>
Subject: Re: RFC [PATCH] x86: make generic arch support NUMAQ
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080605110002.GB17961@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806050309.11197.yhlu.kernel@gmail.com>
	 <20080605110002.GB17961@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2008 at 4:00 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
> Hi Yinghai Lu.
>
> Some random comments after skimming through the diff.
>
> In general I like the simplification moving numaq.
> But there is too much ifdef going on - and it
> can be done better.
> Part of this may belong in a followup patch - other parts
> should be addressed in this patch.
>
>> +#if defined(CONFIG_X86_NUMAQ) || defined(CONFIG_X86_GENERICARCH)
>
> I counted several places where you test for the above.
> Introducing a CONFIG_X86_NUMAQ_OR_GENERIC would simplify stuff.
>
>
>> -obj-$(CONFIG_X86_NUMAQ)              += numaq_32.o
>> +
>> +ifeq ($(CONFIG_X86_NUMAQ), y)
>> +obj-y                                += numaq_32.o
>> +else
>> +ifeq ($(CONFIG_X86_GENERICARCH), y)
>> +obj-$(CONFIG_NUMA)           += numaq_32.o
>> +endif
>> +endif
>
> Can we move these dependencies to Kconfig?
> It should looks roughtly like this in the Makefile:
>
> obj-$(CONFIG_X86_NUMAQ)           += numaq_32.o
> obj-$(CONFIG_X86_NUMA_OR_GENERIC) += numaq_32.o
>
>
>> -#ifndef CONFIG_X86_NUMAQ
>>  static void __init setup_ioapic_ids_from_mpc(void)
>>  {
>>       union IO_APIC_reg_00 reg_00;
>> @@ -1725,6 +1724,11 @@ static void __init setup_ioapic_ids_from_mpc(void)
>>       unsigned char old_id;
>>       unsigned long flags;
>>
>> +#if defined(CONFIG_X86_NUMAQ) || defined(CONFIG_X86_GENERICARCH)
>> +     if (found_numaq)
>> +             return;
>> +#endif
> This ifdef should be found in a .h file defining a simple inline.
> Then you could just do:
>        if (found_numaq())
>                return;
>
>> +
>> +int mp_bus_id_to_node[MAX_MP_BUSSES];
>> +
>> +int mp_bus_id_to_local[MAX_MP_BUSSES];
>
> static? and introduce helper functions with proper
> prototypes in a .h file?
>
>> +++ b/arch/x86/mach-generic/probe.c
>> @@ -16,6 +16,9 @@
>>  #include <asm/apicdef.h>
>>  #include <asm/genapic.h>
>>
>> +#ifdef CONFIG_NUMA
>> +extern struct genapic apic_numaq;
>> +#endif
>
> No reason to use ifdef araound a extern.
>
>> diff --git a/arch/x86/pci/Makefile_32 b/arch/x86/pci/Makefile_32
>> index 89ec35d..88d6fcc 100644
>> --- a/arch/x86/pci/Makefile_32
>> +++ b/arch/x86/pci/Makefile_32
>> @@ -16,7 +16,13 @@ pci-y                              += legacy.o irq.o
>>  # Careful: VISWS and NUMAQ overrule the pci-y above. The colons are
>>  # therefor correct. This needs a proper fix by distangling the code.
>>  pci-$(CONFIG_X86_VISWS)              := visws.o fixup.o
>> -pci-$(CONFIG_X86_NUMAQ)              := numa.o irq.o
>> +
>> +ifeq ($(CONFIG_X86_NUMAQ), y)
>> +pci-y                                := numa.o irq.o
>> +endif
>> +ifeq ($(CONFIG_X86_GENERICARCH), y)
>> +pci-y                                += numa.o
>> +endif
>
> Use:
> pci-$(CONFIG_X86_NUMAQ)       :=  numa.o irq.o
> pci-$(CONFIG_X86_GENERICARCH) += numa.o
>
>
>> diff --git a/arch/x86/pci/numa.c b/arch/x86/pci/numa.c
>> index d9afbae..a4ff536 100644
>> --- a/arch/x86/pci/numa.c
>> +++ b/arch/x86/pci/numa.c
>> @@ -11,38 +11,18 @@
>>  #define XQUAD_PORTIO_BASE 0xfe400000
>>  #define XQUAD_PORTIO_QUAD 0x40000  /* 256k per quad. */
>>
>> -int mp_bus_id_to_node[MAX_MP_BUSSES];
>> +extern int mp_bus_id_to_node[MAX_MP_BUSSES];
>>  #define BUS2QUAD(global) (mp_bus_id_to_node[global])
>>
>> -int mp_bus_id_to_local[MAX_MP_BUSSES];
>> +extern int mp_bus_id_to_local[MAX_MP_BUSSES];
>>  #define BUS2LOCAL(global) (mp_bus_id_to_local[global])
>
> Move extern to .h file and consider introducing a helper function.
>
>> --- a/include/asm-x86/mmzone_32.h
>> +++ b/include/asm-x86/mmzone_32.h
>> @@ -12,9 +12,10 @@
>>  extern struct pglist_data *node_data[];
>>  #define NODE_DATA(nid)       (node_data[nid])
>>
>> -#ifdef CONFIG_X86_NUMAQ
>> +#if defined(CONFIG_X86_NUMAQ) || defined(CONFIG_X86_GENERICARCH)
>>       #include <asm/numaq.h>
>> -#elif defined(CONFIG_ACPI_SRAT)/* summit or generic arch */
>> +#endif
>> +#if defined(CONFIG_ACPI_SRAT)/* summit or generic arch */
>>       #include <asm/srat.h>
>>  #endif
>
> Move ifdef to .h files.
> If at all needed.
>
>> +#if defined(CONFIG_ACPI_SRAT)
>>       if (get_memcfg_from_srat())
>>               return;
>>  #endif
>
> Create a dummy inline in a .h file for this function
> so we can drop the ifdef here.
>
Thanks, will check it.

YH
