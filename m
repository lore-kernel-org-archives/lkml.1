Return-Path: <linux-kernel-owner+w=401wt.eu-S1760588AbYGOSw4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760588AbYGOSw4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 14:52:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755667AbYGOSws
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 14:52:48 -0400
Received: from rv-out-0506.google.com ([209.85.198.227]:12653 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763AbYGOSwr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 14:52:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=nx/R4dP+h2JjqWPI6+zCeBSv5+LmTQ5lduj7eKQcSK81XZa74DLYaDLtgi0nQKzpPb
         K5zcw+OM3wJ6Ned7vM02ExBWHksmuQm+IMSInbIuir1m2ZeRzNAKRNgNgmKzVc2LPkc7
         6SaiVM6YaGlexF/jpDPDehOGWRKZkypQa1NmY=
Message-ID: <86802c440807151152s57d26f07jf1bc9336bf287dfe@mail.gmail.com>
Date: Tue, 15 Jul 2008 11:52:46 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Zachary Amsden" <zach@vmware.com>
Subject: Re: Patch from LKML
Cc: suresh.b.siddha@intel.com, "Chris Wright" <chrisw@sous-sol.org>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Rusty Russell" <rusty@rustcorp.com.au>,
       virtualization <virtualization@lists.osdl.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <1216147130.6620.184.camel@bodhitayantram.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1216147130.6620.184.camel@bodhitayantram.eng.vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2008 at 11:38 AM, Zachary Amsden <zach@vmware.com> wrote:
>
>> On Tue, Jul 15, 2008 at 10:33 AM, Suresh Siddha
>> <suresh.b.siddha@intel.com> wrote:
>> > On Sun, Jul 13, 2008 at 10:19:35PM -0700, Yinghai Lu wrote:
>> >>
>> >> fix for pv.
>> >>
>> >> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
>> >>
>> >> ---
>> >>  arch/x86/kernel/paravirt.c |    5 ----
>> >>  arch/x86/kernel/vmi_32.c   |   51 ++++++++++++++++++++++++++++++++++++++++++---
>> >>  arch/x86/xen/enlighten.c   |   19 +++++++---------
>> >>  include/asm-x86/paravirt.h |   29 -------------------------
>> >>  4 files changed, 57 insertions(+), 47 deletions(-)
>> >>
>> >> Index: linux-2.6/arch/x86/kernel/paravirt.c
>> >> ===================================================================
>> >> --- linux-2.6.orig/arch/x86/kernel/paravirt.c
>> >> +++ linux-2.6/arch/x86/kernel/paravirt.c
>> >> @@ -373,11 +373,6 @@ struct pv_cpu_ops pv_cpu_ops = {
>> >>
>> >>  struct pv_apic_ops pv_apic_ops = {
>> >>  #ifdef CONFIG_X86_LOCAL_APIC
>> >> -#ifndef CONFIG_X86_64
>> >> -       .apic_write = native_apic_mem_write,
>> >> -       .apic_write_atomic = native_apic_mem_write_atomic,
>> >> -       .apic_read = native_apic_mem_read,
>> >> -#endif
>> >>         .setup_boot_clock = setup_boot_APIC_clock,
>> >>         .setup_secondary_clock = setup_secondary_APIC_clock,
>> >>         .startup_ipi_hook = paravirt_nop,
>> >> Index: linux-2.6/arch/x86/kernel/vmi_32.c
>> >> ===================================================================
>> >> --- linux-2.6.orig/arch/x86/kernel/vmi_32.c
>> >> +++ linux-2.6/arch/x86/kernel/vmi_32.c
>> >> @@ -676,6 +676,50 @@ static inline int __init probe_vmi_rom(v
>> >>         return 0;
>> >>  }
>> >>
>> >> +#ifdef CONFIG_X86_LOCAL_APIC
>> >> +static u32 vmi_apic_read(u32 reg)
>> >> +{
>> >> +       return 0;
>> >> +}
>> >> +
>> >> +static void vmi_apic_write(u32 reg, u32 val)
>> >> +{
>> >> +       /* Warn to see if there's any stray references */
>> >> +       WARN_ON(1);
>> >> +}
>> >> +
>> >> +static u64 vmi_apic_icr_read(void)
>> >> +{
>> >> +       return 0;
>> >> +}
>> >> +
>> >> +static void vmi_apic_icr_write(u32 low, u32 id)
>> >> +{
>> >> +       /* Warn to see if there's any stray references */
>> >> +       WARN_ON(1);
>> >> +}
>> >> +
>> >> +static void vmi_apic_wait_icr_idle(void)
>> >> +{
>> >> +       return;
>> >> +}
>> >> +
>> >> +static u32 vmi_safe_apic_wait_icr_idle(void)
>> >> +{
>> >> +       return 0;
>> >> +}
>> >> +
>> >> +static struct apic_ops vmi_basic_apic_ops = {
>> >> +        .read = vmi_apic_read,
>> >> +        .write = vmi_apic_write,
>> >> +        .write_atomic = vmi_apic_write,
>> >> +        .icr_read = vmi_apic_icr_read,
>> >> +        .icr_write = vmi_apic_icr_write,
>> >> +        .wait_icr_idle = vmi_apic_wait_icr_idle,
>> >> +        .safe_wait_icr_idle = vmi_safe_apic_wait_icr_idle,
>> >> +};
>> >> +#endif
>> >> +
>> >>  /*
>> >>   * VMI setup common to all processors
>> >>   */
>> >> @@ -904,9 +948,10 @@ static inline int __init activate_vmi(vo
>> >>  #endif
>> >>
>> >>  #ifdef CONFIG_X86_LOCAL_APIC
>> >> -       para_fill(pv_apic_ops.apic_read, APICRead);
>> >> -       para_fill(pv_apic_ops.apic_write, APICWrite);
>> >> -       para_fill(pv_apic_ops.apic_write_atomic, APICWrite);
>> >> +       para_fill(vmi_basic_apic_ops.read, APICRead);
>> >> +       para_fill(vmi_basic_apic_ops.write, APICWrite);
>> >> +       para_fill(vmi_basic_apic_ops.write_atomic, APICWrite);
>> >> +       apic_ops = &vmi_basic_apic_ops;
>> >
>> > Yinghai, Looking more closely at this, based on my understanding this might be
>> > wrong for VMI. Correct patch should be as follows. Any comments?
>>
>> so you mean icr related will still use default native member?
>>
>> YH
>
> Nacked-by: Zachary Amsden <zach@vmware.com>

because of not ccing you?

>
> What are you doing here and why aren't you cc-ing the maintainers?

did you checking tip tree for x86 changing?

YH
