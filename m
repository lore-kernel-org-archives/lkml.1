Return-Path: <linux-kernel-owner+w=401wt.eu-S1753402AbYCRJoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402AbYCRJoW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 05:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbYCRJoO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 05:44:14 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751989AbYCRJoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 05:44:13 -0400
Message-ID: <47DF8E13.6040408@redhat.com>
Date: Tue, 18 Mar 2008 06:40:35 -0300
From: Glauber Costa <gcosta@redhat.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Yinghai Lu <yhlu.kernel@gmail.com>
CC: linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org,
       kiran@scalemp.com, mingo@elte.hu, tglx@linutronix.de
Subject: Re: + x86-vsmp-build-fixes.patch added to -mm tree
References: <200803180514.m2I5ElVJ015693@imap1.linux-foundation.org> <86802c440803172226yb867326rb595b36b03e6c4b9@mail.gmail.com>
In-Reply-To: <86802c440803172226yb867326rb595b36b03e6c4b9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> On Mon, Mar 17, 2008 at 10:14 PM,  <akpm@linux-foundation.org> wrote:
>>  The patch titled
>>      x86: vsmp build fixes
>>  has been added to the -mm tree.  Its filename is
>>      x86-vsmp-build-fixes.patch
>>
>>  Before you just go and hit "reply", please:
>>    a) Consider who else should be cc'ed
>>    b) Prefer to cc a suitable mailing list as well
>>    c) Ideally: find the original patch on the mailing list and do a
>>       reply-to-all to that, adding suitable additional cc's
>>
>>  *** Remember to use Documentation/SubmitChecklist when testing your code ***
>>
>>  See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
>>  out what to do about this
>>
>>  The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/
>>
>>  ------------------------------------------------------
>>  Subject: x86: vsmp build fixes
>>  From: Glauber Costa <gcosta@redhat.com>
>>
>>  VSMP depends on PCI, but the file is now compiled conditionally on PARAVIRT,
>>  no VSMP, so enclose everything in an ifdef CONFIG_PCI.
>>
>>  We have to be careful enough to let is_vsmp_box and vsmp_init defined, since
>>  they are used outside this file
>>
>>  Signed-off-by: Glauber Costa <gcosta@redhat.com>
>>  Cc: Ravikiran Thirumalai <kiran@scalemp.com>
>>  Cc: Ingo Molnar <mingo@elte.hu>
>>  Cc: Thomas Gleixner <tglx@linutronix.de>
>>  Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>>  ---
>>
>>   arch/x86/kernel/vsmp_64.c |   10 +++++++++-
>>   1 file changed, 9 insertions(+), 1 deletion(-)
>>
>>  diff -puN arch/x86/kernel/vsmp_64.c~x86-vsmp-build-fixes arch/x86/kernel/vsmp_64.c
>>  --- a/arch/x86/kernel/vsmp_64.c~x86-vsmp-build-fixes
>>  +++ a/arch/x86/kernel/vsmp_64.c
>>  @@ -19,6 +19,7 @@
>>   #include <asm/io.h>
>>   #include <asm/paravirt.h>
>>
>>  +#ifdef CONFIG_PCI
>>   /*
>>   * Interrupt control on vSMPowered systems:
>>   * ~AC is a shadow of IF.  If IF is 'on' AC should be 'off'
>>  @@ -87,12 +88,18 @@ int is_vsmp_box(void)
>>         if (read_pci_config(0, 0x1f, 0, PCI_VENDOR_ID) ==
>>              (PCI_VENDOR_ID_SCALEMP || (PCI_DEVICE_ID_SCALEMP_VSMP_CTL << 16)))
>>                 vsmp = 1;
>>  -
>>         return vsmp;
>>   }
>>  +#else
>>  +int is_vsmp_box(void)
>>  +{
>>  +       return 0;
>>  +}
>>  +#endif
>>
>>   void __init vsmp_init(void)
>>   {
>>  +#ifdef CONFIG_PCI
>>         void *address;
>>         unsigned int cap, ctl, cfg;
>>
>>  @@ -125,5 +132,6 @@ void __init vsmp_init(void)
>>         }
>>
>>         early_iounmap(address, 8);
>>  +#endif
>>         return;
>>   }
>>  _
> 
> in arch/x86/Kconfig
> 
> config PCI
>         bool "PCI support" if !X86_VISWS && !X86_VSMP
>         depends on !X86_VOYAGER
>         default y
>         select ARCH_SUPPORTS_MSI if (X86_LOCAL_APIC && X86_IO_APIC)
>         help
>           Find out whether you have a PCI motherboard. PCI is the name of a
>           bus system, i.e. the way the CPU talks to the other stuff inside
>           your box. Other bus systems are ISA, EISA, MicroChannel (MCA) or
>           VESA. If you have PCI, say Y, otherwise N.
> 
> will make sure if X86_VSMP, the PCI=y
Unfortunately, as said in the changelog, this file is compiled in 
conditionaly with PARAVIRT, not VSMP.

That's precisely the reason for the discovery code. Finding out wheter 
or not we're running under vsmp.

