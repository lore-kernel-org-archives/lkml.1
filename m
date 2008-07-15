Return-Path: <linux-kernel-owner+w=401wt.eu-S1758380AbYGOStm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758380AbYGOStm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 14:49:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754641AbYGOSte
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 14:49:34 -0400
Received: from smtp-outbound-2.vmware.com ([65.115.85.73]:58336 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753025AbYGOStd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 14:49:33 -0400
X-Greylist: delayed 580 seconds by postgrey-1.27 at vger.kernel.org; Tue, 15 Jul 2008 14:49:33 EDT
Subject: Patch from LKML
From: Zachary Amsden <zach@vmware.com>
To: suresh.b.siddha@intel.com, yhlu.kernel@gmail.com,
       Chris Wright <chrisw@sous-sol.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       virtualization <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 15 Jul 2008 11:38:50 -0700
Message-Id: <1216147130.6620.184.camel@bodhitayantram.eng.vmware.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Tue, Jul 15, 2008 at 10:33 AM, Suresh Siddha
> <suresh.b.siddha@intel.com> wrote:
> > On Sun, Jul 13, 2008 at 10:19:35PM -0700, Yinghai Lu wrote:
> >>
> >> fix for pv.
> >>
> >> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> >>
> >> ---
> >>  arch/x86/kernel/paravirt.c |    5 ----
> >>  arch/x86/kernel/vmi_32.c   |   51 ++++++++++++++++++++++++++++++++++++++++++---
> >>  arch/x86/xen/enlighten.c   |   19 +++++++---------
> >>  include/asm-x86/paravirt.h |   29 -------------------------
> >>  4 files changed, 57 insertions(+), 47 deletions(-)
> >>
> >> Index: linux-2.6/arch/x86/kernel/paravirt.c
> >> ===================================================================
> >> --- linux-2.6.orig/arch/x86/kernel/paravirt.c
> >> +++ linux-2.6/arch/x86/kernel/paravirt.c
> >> @@ -373,11 +373,6 @@ struct pv_cpu_ops pv_cpu_ops = {
> >>
> >>  struct pv_apic_ops pv_apic_ops = {
> >>  #ifdef CONFIG_X86_LOCAL_APIC
> >> -#ifndef CONFIG_X86_64
> >> -       .apic_write = native_apic_mem_write,
> >> -       .apic_write_atomic = native_apic_mem_write_atomic,
> >> -       .apic_read = native_apic_mem_read,
> >> -#endif
> >>         .setup_boot_clock = setup_boot_APIC_clock,
> >>         .setup_secondary_clock = setup_secondary_APIC_clock,
> >>         .startup_ipi_hook = paravirt_nop,
> >> Index: linux-2.6/arch/x86/kernel/vmi_32.c
> >> ===================================================================
> >> --- linux-2.6.orig/arch/x86/kernel/vmi_32.c
> >> +++ linux-2.6/arch/x86/kernel/vmi_32.c
> >> @@ -676,6 +676,50 @@ static inline int __init probe_vmi_rom(v
> >>         return 0;
> >>  }
> >>
> >> +#ifdef CONFIG_X86_LOCAL_APIC
> >> +static u32 vmi_apic_read(u32 reg)
> >> +{
> >> +       return 0;
> >> +}
> >> +
> >> +static void vmi_apic_write(u32 reg, u32 val)
> >> +{
> >> +       /* Warn to see if there's any stray references */
> >> +       WARN_ON(1);
> >> +}
> >> +
> >> +static u64 vmi_apic_icr_read(void)
> >> +{
> >> +       return 0;
> >> +}
> >> +
> >> +static void vmi_apic_icr_write(u32 low, u32 id)
> >> +{
> >> +       /* Warn to see if there's any stray references */
> >> +       WARN_ON(1);
> >> +}
> >> +
> >> +static void vmi_apic_wait_icr_idle(void)
> >> +{
> >> +       return;
> >> +}
> >> +
> >> +static u32 vmi_safe_apic_wait_icr_idle(void)
> >> +{
> >> +       return 0;
> >> +}
> >> +
> >> +static struct apic_ops vmi_basic_apic_ops = {
> >> +        .read = vmi_apic_read,
> >> +        .write = vmi_apic_write,
> >> +        .write_atomic = vmi_apic_write,
> >> +        .icr_read = vmi_apic_icr_read,
> >> +        .icr_write = vmi_apic_icr_write,
> >> +        .wait_icr_idle = vmi_apic_wait_icr_idle,
> >> +        .safe_wait_icr_idle = vmi_safe_apic_wait_icr_idle,
> >> +};
> >> +#endif
> >> +
> >>  /*
> >>   * VMI setup common to all processors
> >>   */
> >> @@ -904,9 +948,10 @@ static inline int __init activate_vmi(vo
> >>  #endif
> >>
> >>  #ifdef CONFIG_X86_LOCAL_APIC
> >> -       para_fill(pv_apic_ops.apic_read, APICRead);
> >> -       para_fill(pv_apic_ops.apic_write, APICWrite);
> >> -       para_fill(pv_apic_ops.apic_write_atomic, APICWrite);
> >> +       para_fill(vmi_basic_apic_ops.read, APICRead);
> >> +       para_fill(vmi_basic_apic_ops.write, APICWrite);
> >> +       para_fill(vmi_basic_apic_ops.write_atomic, APICWrite);
> >> +       apic_ops = &vmi_basic_apic_ops;
> >
> > Yinghai, Looking more closely at this, based on my understanding this might be
> > wrong for VMI. Correct patch should be as follows. Any comments?
> 
> so you mean icr related will still use default native member?
> 
> YH

Nacked-by: Zachary Amsden <zach@vmware.com>

What are you doing here and why aren't you cc-ing the maintainers?

Thanks,

Zach

