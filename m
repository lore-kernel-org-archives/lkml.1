Return-Path: <linux-kernel-owner+w=401wt.eu-S1762911AbZD1Qux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762911AbZD1Qux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 12:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762347AbZD1Quk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 12:50:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:7978 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755937AbZD1Qui convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 12:50:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,261,1239001200"; 
   d="scan'208";a="452187145"
From: "Cihula, Joseph" <joseph.cihula@intel.com>
To: Andi Kleen <andi@firstfloor.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "jmorris@namei.org" <jmorris@namei.org>,
       "jbeulich@novell.com" <jbeulich@novell.com>,
       "peterm@redhat.com" <peterm@redhat.com>,
       "Wei, Gang" <gang.wei@intel.com>, "Wang, Shane" <shane.wang@intel.com>
Date: Tue, 28 Apr 2009 09:50:28 -0700
Subject: RE: [RFC v2][PATCH 1/1] intel_txt: Intel(R) TXT and tboot kernel
 support
Thread-Topic: [RFC v2][PATCH 1/1] intel_txt: Intel(R) TXT and tboot kernel
 support
Thread-Index: AcnFvdJ5qvoEcNTWRAiFQl8n7T7k3ABNYzfA
Message-ID: <4F65016F6CB04E49BFFA15D4F7B798D99896AAA7@orsmsx506.amr.corp.intel.com>
References: <49D1A6AB.5090808@intel.com> <87d4baqnxy.fsf@basil.nowhere.org>
 <4F65016F6CB04E49BFFA15D4F7B798D9988D0041@orsmsx506.amr.corp.intel.com>
 <20090425155607.GS13896@one.firstfloor.org>
In-Reply-To: <20090425155607.GS13896@one.firstfloor.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Andi Kleen [mailto:andi@firstfloor.org]
> Sent: Saturday, April 25, 2009 8:56 AM
>
> On Fri, Apr 24, 2009 at 02:57:34PM -0700, Cihula, Joseph wrote:
> > > > +/* GAS - Generic Address Structure (ACPI 2.0+) */
> > > > +struct tboot_acpi_generic_address {
> > > > +  u8  space_id;
> > > > +  u8  bit_width;
> > > > +  u8  bit_offset;
> > > > +  u8  access_width;
> > > > +  u64 address;
> > > > +} __attribute__ ((__packed__));
> > >
> > > Why not use the existing structure from ACPI?
> >
> > This is the ACPI structure, but just not the Linux type definition of it.  This is because
> tboot needs to work with multiple target kernels/VMMs and so it must define its parameters
> "independently".
>
> But it's the same type. Or are you saying that include file is shared
> with another project? Why can't tboot include the ACPICA include files?
> If it's shared with another project there should be a clear comment
> about that.

It's the same type today, but what if Linux adds a field to the structure or the new ACPI spec changes it?  That would cause a silent failure with a tboot built for the older version.  This header file is a Linux-ified version of the one in the tboot project that also gets copied into any other VMM/kernel that uses tboot (e.g. Xen), so I'd prefer to keep this definition and do explicit field population in the code.

> > > > +struct tboot_acpi_sleep_info {
> > > > +  struct tboot_acpi_generic_address pm1a_cnt_blk;
> > > > +  struct tboot_acpi_generic_address pm1b_cnt_blk;
> > > > +  struct tboot_acpi_generic_address pm1a_evt_blk;
> > > > +  struct tboot_acpi_generic_address pm1b_evt_blk;
> > > > +  u16 pm1a_cnt_val;
> > > > +  u16 pm1b_cnt_val;
> > > > +  u64 wakeup_vector;
> > >
> > > So that vector can be >4GB but the tshared data structure not?
> >
> > Neither can currently be 64b in practice, though now both types will be 64b to allow for
> future "expansion".
>
> Seems pointless when legacy implementations like this one cannot deal with
> that.

The wakeup vector limitation is not TXT architectural but rather a limitation of the current tboot code.  So making it 64b will allow a future tboot without such limitations to use the same structure.

> > > > -   /* Stop the cpus and apics */
> > > > #ifdef CONFIG_SMP
> > > > -
> > > >     /* The boot cpu is always logical cpu 0 */
> > > >     int reboot_cpu_id = 0;
> > > > +#endif
> > > > +
> > > > +   /* TXT requires VMX to be off for all shutdowns */
> > > > +   if (tboot_in_measured_env())
> > > > +           emergency_vmx_disable_all();
> > >
> > > I thought KVM did that already in its shutdown handler? Why is this needed again?
> >
> > It does in most shutdown cases, but not for reboot.
>
> I think you should fix KVM then, not hack around it here.

OK, we found the issue in KVM and will submit that as a separate patch.

> > It was needed to ensure that all of the page table creation writes were getting flushed
> before paging got disabled by tboot.
>
> Hmm weird. Normally caches should be physical anyways.
>
> > Without it we were getting a PREEMPT SMP DEBUG_PAGEALLOC warning.
>
> Sounds strange. Is that back by some requirement in the SDM?
> Perhaps it's just a race of some sort and you're masking it by
> wbinvd being very slow.

Adding wbinvd was suggested by Venki Pallipadi.  But now that the pagetable allocation has been moved, this may no longer be necessary.  I have removed it and there doesn't seem to be any issues.

> > I will add a comment to this effect.
>
> I would double check that. Does a udelay(10) fix it too?
>
> > > for that?
> >
> > This code will only be executed if the tboot_shared page is found, which should not be the
> case if the kernel is running paravirtualized.  But I will change it to just write_cr3() to be
> more consistent with other cases where we don't try to specifically exclude paravirt hooks.
>
> I would also recommend to a add an explicit check for para virtualization
> somewhere and bail out.

I'll add that to the tboot_probe() fn.

> > > > +   /* Reuse the original kernel mapping */
> > > > +   tboot_pg_dir = pgd_alloc(&tboot_mm);
> > >
> > > That puts the PGD into the pgd_list and then pageattr.c will actually
> > > walk that list and change ptes, assuming it's a standard kernel
> > > mapping. Can you tolerate that? It seems dangerous. Better to use
> > > a pgd_alloc_kernel(). There's none, but you could add one.
> > >
> > from a followup email of Andi's:
> > > Thought some more about this. I think you're ok on 64bit at least
> > > because the kernel mappings are elsewhere from the identity map and
> > > keeping them in sync with pageattr makes sense and avoids illegal
> > > cache attribute aliases.
> > >
> > > But on 32bit it could be potentially a problem in general. e.g.
> > > what happens when the tboot shared page is in the area the kernel
> > > is running? You would crash during the window where you run
> > > in that pgd.
> > >
> > > It would be probably safer to use a low memory trampoline supplied
> > > by the kernel too that then loads the new pgd.
> >
> > I don't think that I understand the issue.  The tboot physical addr range will always be
> <4GB and thus will it's virtual 1:1 mapping.  Immediately after switching to this pgd the CPU
> calls into tboot which will then disable paging and do its thing.  Can you elaborate on what
> the exact issue would be?
>
> On 32bit the kernel direct mapping is virtually < 4GB. So when tboot happens
> to put some data into the usual 0xc0000... range the kernel lives
> in you would have conflicting mappings for the short period
> you're still executing in the kernel mapping.

tboot lives at a fixed address of 0x0800000 (8MB) and marks its region of memory as E820_UNUSABLE to avoid the kernel creating any mappings to it.  We have used the current method on 32b kernels and even enabled CONFIG_HIGHPTE and there is no conflict.  Under what configurations would this issue arise?

> > > So likely you can just drop the spinlock. Perhaps add a WARN_ON() somewhere
> > > for parallel entry using a simple flag.
> >
> > Per above, we will allocate early and then don't need the spinlock.
>
> Just make sure early panics before your initialization are covered.

Will do.

> > > > +                   PFN_PHYS(PFN_DOWN(virt_to_phys(&_text)));
> > > > +           tboot_shared->mac_regions[2].size =
> > > > +                   PFN_PHYS(PFN_UP(virt_to_phys(&_end))) -
> > > > +                   PFN_PHYS(PFN_DOWN(virt_to_phys(&_text)));
> > > > +   }
> > > > +
> > > > +   tboot_shared->shutdown_type = shutdown_type;
> > > > +
> > > > +   switch_to_tboot_pt();
> > >
> > > What happens with the NMIs? (nmi watchdog etc.) Are they all disabled at this point?
> > > Machine checks probably too.
> >
> > The TXT-related code doesn't disable them.  Doesn't Linux disable them before shutting down?
>
> No, but the direct shutdown code tends to load a special IDT
>
> Thinking of it the BIOS/ACPI shutdowns might be buggy this way.
>
> But your case is worse than any of them because you likely need longer
> so the race window is larger.
>
> I would recommend to load a special IDT before entering
> a special context to avoid all that.

Since the tboot code will install an IDT just after entry to the shutdown code, I think that the window would be extremely small (since the 1:1 pagetable we switch to includes the kernel mappings).

> > We can probably remove the BUG(), since the call itself can't fail and by the time the tboot
> code could get into a bad state that caused an un-matched ret, the kernel's page table would
> be long gone and it would never get back here.  But as any execution beyond the call would be
> catastrophic, it is actually desirable that things blow up rather than fail insecurely--so I'm
> inclined to leave it or replace it with something equally fatal (?).
>
> It'll be a triple fault, these tend to be hard to debug.  Better just loop.

OK.

> > > Normally using u64. i would add some sanity checks for out of bounds etc.
> > > Normally it's a good idea to sanity check anything coming from the BIOS.
> >
> > Changed to u64.  This data was already validated by tboot and should not have been altered
> since then.
>
> Assuming nothing ever corrupts memory?
> What happens when it's wrong?

Then it would really be no different than if something, after the kernel started booting, corrupted the kernel's memory.  Is there some function that kernel code calls to validate pointers before it uses them?

> > > Also isn't this reinventing ACPI table parser code? Perhaps the ACPI code
> > > could be used directly instead. or is this too early?
> >
> > This is a copy of the ACPI table that was made during the launch, placed into DMA-protected
> memory, and validated for correctness.  So that is why we want to get it from here.
>
> Still seems like a lot of reinvention. It would be better if you
> could integrate that with ACPI more cleanly.

This copy of the table is done by the TXT launch process.  All that this code is doing is locating it and pointing the IOMMU code at it.  I don't think that I can make it any simpler.

> > > > +           tboot_shared->acpi_sinfo.pm1b_cnt_val = PM1Bcontrol;
> > > > +           /* we need phys addr of waking vector, but can't use
> > > > +              virt_to_phys() on &acpi_gbl_FACS because it is ioremap'ed,
> > > > +              so calc from FACS phys addr */
> > > > +           tboot_shared->acpi_sinfo.wakeup_vector = acpi_gbl_FADT.facs +
> > > > +                   ((void *)&acpi_gbl_FACS->firmware_waking_vector -
> > > > +                    (void *)acpi_gbl_FACS);
> > >
> > > That's an opencoded offsetof ?
> >
> > I'm not sure I understand what you mean.
>
> I meant it should use offsetof(), not opencoding it.

OK, I see.
