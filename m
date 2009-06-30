Return-Path: <linux-kernel-owner+w=401wt.eu-S1756967AbZF3HzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967AbZF3HzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 03:55:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751065AbZF3Hy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 03:54:59 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60938 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbZF3Hy6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 03:54:58 -0400
Date: Tue, 30 Jun 2009 10:54:57 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: linux-kernel@vger.kernel.org, Suresh Siddha <suresh.b.siddha@intel.com>,
       Sheng Yang <sheng@linux.intel.com>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "avi@redhat.com" <avi@redhat.com>
Subject: Re: [PATCH v4] enable x2APIC without interrupt remapping under KVM
Message-ID: <20090630075457.GH20289@redhat.com>
References: <20090630064515.GG20289@redhat.com> <86802c440906300018p8c5156dy3e8d84b8c263797e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <86802c440906300018p8c5156dy3e8d84b8c263797e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 12:18:19AM -0700, Yinghai Lu wrote:
> On Mon, Jun 29, 2009 at 11:45 PM, Gleb Natapov<gleb@redhat.com> wrote:
> > KVM would like to provide x2APIC interface to a guest without emulating
> > interrupt remapping device. The reason KVM prefers guest to use x2APIC
> > is that x2APIC interface is better virtualizable and provides better
> > performance than mmio xAPIC interface:
> >
> > - msr exits are faster than mmio (no page table walk, emulation)
> > - no need to read back ICR to look at the busy bit
> > - one 64 bit ICR write instead of two 32 bit writes
> > - shared code with the Hyper-V paravirt interface
> >
> > Included patch changes x2APIC enabling logic to enable it even if IR
> > initialization failed, but kernel runs under KVM and no apic id is
> > greater than 255 (if there is one spec requires BIOS to move to x2apic
> > mode before starting an OS).
> >
> > Signed-off-by: Gleb Natapov <gleb@redhat.com>
> > diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
> > index 8c7c042..351d55a 100644
> > --- a/arch/x86/kernel/apic/apic.c
> > +++ b/arch/x86/kernel/apic/apic.c
> > @@ -49,6 +49,7 @@
> > š#include <asm/mtrr.h>
> > š#include <asm/smp.h>
> > š#include <asm/mce.h>
> > +#include <asm/kvm_para.h>
> >
> > šunsigned int num_processors;
> >
> > @@ -1363,52 +1364,75 @@ void enable_x2apic(void)
> > š}
> > š#endif /* CONFIG_X86_X2APIC */
> >
> > -void __init enable_IR_x2apic(void)
> > +int __init enable_IR(void)
> > š{
> > š#ifdef CONFIG_INTR_REMAP
> > š š š šint ret;
> > - š š š unsigned long flags;
> > - š š š struct IO_APIC_route_entry **ioapic_entries = NULL;
> >
> > š š š šret = dmar_table_init();
> > š š š šif (ret) {
> > š š š š š š š špr_debug("dmar_table_init() failed with %d:\n", ret);
> > - š š š š š š š goto ir_failed;
> > + š š š š š š š return 0;
> > š š š š}
> >
> > š š š šif (!intr_remapping_supported()) {
> > š š š š š š š špr_debug("intr-remapping not supported\n");
> > - š š š š š š š goto ir_failed;
> > + š š š š š š š return 0;
> > š š š š}
> >
> > -
> > š š š šif (!x2apic_preenabled && skip_ioapic_setup) {
> > š š š š š š š špr_info("Skipped enabling intr-remap because of skipping "
> > š š š š š š š š š š š š"io-apic setup\n");
> > - š š š š š š š return;
> > + š š š š š š š return 0;
> > š š š š}
> >
> > + š š š if (enable_intr_remapping(x2apic_supported()))
> > + š š š š š š š return 0;
> > +
> > + š š š pr_info("Enabled Interrupt-remapping\n");
> > +
> > + š š š return 1;
> > +
> > +#endif
> > + š š š return 0;
> > +}
> > +
> > +void __init enable_IR_x2apic(void)
> > +{
> > + š š š unsigned long flags;
> > + š š š struct IO_APIC_route_entry **ioapic_entries = NULL;
> > + š š š int ret, x2apic_enabled = 0;
> > +
> > š š š šioapic_entries = alloc_ioapic_entries();
> > š š š šif (!ioapic_entries) {
> > - š š š š š š š pr_info("Allocate ioapic_entries failed: %d\n", ret);
> > - š š š š š š š goto end;
> > + š š š š š š š špr_info("Allocate ioapic_entries failed\n");
> > + š š š š š š š šgoto out;
> > š š š š}
> >
> > š š š šret = save_IO_APIC_setup(ioapic_entries);
> > š š š šif (ret) {
> > š š š š š š š špr_info("Saving IO-APIC state failed: %d\n", ret);
> > - š š š š š š š goto end;
> > + š š š š š š š goto out;
> > š š š š}
> >
> > š š š šlocal_irq_save(flags);
> > - š š š mask_IO_APIC_setup(ioapic_entries);
> > š š š šmask_8259A();
> > + š š š mask_IO_APIC_setup(ioapic_entries);
> >
> > - š š š ret = enable_intr_remapping(x2apic_supported());
> > - š š š if (ret)
> > - š š š š š š š goto end_restore;
> > + š š š ret = enable_IR();
> > + š š š if (!ret) {
> > + š š š š š š š /* IR is required if x2apic is enabled by BIOS even
> > + š š š š š š š š* when running in kvm since this indicates present
> > + š š š š š š š š* of APIC ID > 255 */
> > + š š š š š š š if (x2apic_preenabled || !kvm_para_available())
> > + š š š š š š š š š š š goto nox2apic;
> > + š š š š š š š else
> > + š š š š š š š š š š š /* without IR all CPUs can be addressed by IOAPIC/MSI
> > + š š š š š š š š š š š š* only in physical mode */
> > + š š š š š š š š š š š x2apic_phys = 1;
> > + š š š }
> 
> how about kexec second kernel in KVM ?
> 
> x2apic_preenabled will be set in second kernel.
> 
Yes, bummer. But the similar problem exist now and without KVM. After
running x2apic enabled kernel you can't kexec kernel without x2apic
support. Shouldn't apic be reset to its initial state on reboot?

--
			Gleb.
