Return-Path: <linux-kernel-owner+w=401wt.eu-S1760939AbYAROyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760939AbYAROyq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 09:54:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753609AbYAROyh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 09:54:37 -0500
Received: from nz-out-0506.google.com ([64.233.162.239]:4388 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbYAROyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 09:54:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=pyHHNtBmLqBQrp0SPVWNexW4+e0BvGuv7x7pXOKiIc7PkuMuosTzNgxqVRrPGwlC6JgJxWBqhIY7qYE7G4zkmSx879RQnar3NHSKHR+fYHVFw/B3a1bJa0+f4moPQQi7vzHovMJcjF77zNYnu7hJ+6odTSGqCW6qGQhZ8WN9CH0=
Message-ID: <851fc09e0801180654u6957f966g47c7629db6d4b2b0@mail.gmail.com>
Date: Fri, 18 Jan 2008 22:54:32 +0800
From: "huang ying" <huang.ying.caritas@gmail.com>
To: "Ian Campbell" <ijc@hellion.org.uk>
Subject: Re: [PATCH -mm 1/3] i386 boot: replace boot_ioremap with enhanced bt_ioremap - enhance bt_ioremap
Cc: "Huang, Ying" <ying.huang@intel.com>, akpm@linux-foundation.org,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "Ingo Molnar" <mingo@redhat.com>, "Andi Kleen" <ak@suse.de>,
       linux-kernel@vger.kernel.org, "Jeremy Fitzhardinge" <jeremy@goop.org>
In-Reply-To: <1200646105.17230.28.camel@cthulhu.hellion.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1200375906.3505.30.camel@caritas-dev.intel.com>
	 <1200646105.17230.28.camel@cthulhu.hellion.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 18, 2008 4:48 PM, Ian Campbell <ijc@hellion.org.uk> wrote:
> On Tue, 2008-01-15 at 13:45 +0800, Huang, Ying wrote:
> > +void __init bt_ioremap_init(void)
> > +{
> > [...]
> > +     *pgd = __pa(bm_pte) | _PAGE_TABLE;
> > +}
> > [...]
> > +static void __init __bt_set_fixmap(enum fixed_addresses idx,
> > +                                unsigned long phys, pgprot_t flags)
> > +{
> > [...]
> > +     if (pgprot_val(flags))
> > +             *pte = (phys & PAGE_MASK) | pgprot_val(flags);
> > +     else
> > +             *pte = 0;
> [...]
>
> Shouldn't these, and the rest of the file, be using the PTE accessor
> macros set_pte,clear_pte etc? The boot_ioremap it replaces seems to have
> done. Otherwise these patches don't appear to be paravirt_ops clean. I

If CONFIG_X86_PAE is defined, the set_pte, clear_pte etc will operate
3-level page tables, while on i386, the early page table is always
2-level, so set_pte, clear_pte etc functions can not be used here. The
boot_ioremap use a trick to deal with this problem. The CONFIG_X86_PAE
is undefined in arch/x86/mm/boot_ioremap_32.c unconditionally, so the
2-level page table handling function is always used.

Is the method used by boot_ioremap better for Xen?

> haven't had a chance to investigate fully so this might be a Xen bug or
> unrelated to this patch but running current x86.git#mm as a Xen guest
> ends up with it being shot in the head by the hypervisor with:
>
>         (XEN) Unhandled page fault in domain 16 on VCPU 0 (ec=0000)
>         (XEN) Pagetable walk from 00000000f54fe40e:
>         (XEN)  L4[0x000] = 000000010c187027 00000000000003b2
>         (XEN)  L3[0x003] = 000000010c186027 00000000000003b3
>         (XEN)  L2[0x1aa] = 0000000000000000 ffffffffffffffff
>         (XEN) domain_crash_sync called from entry.S
>         (XEN) Domain 16 (vcpu#0) crashed on cpu#1:
>         (XEN) ----[ Xen-3.2.0-rc5  x86_64  debug=y  Not tainted ]----
>         (XEN) CPU:    1
>         (XEN) RIP:    e019:[<00000000c02601b1>]
>         (XEN) RFLAGS: 0000000000000282   CONTEXT: guest
>         (XEN) rax: 00000000f54fe40e   rbx: 0000000000005b00   rcx: 0000000000000000
>         (XEN) rdx: 0000000000000000   rsi: 0000000000000000   rdi: 00000000c0255b00
>         (XEN) rbp: 0000000000000000   rsp: 00000000c0257f68   r8:  0000000000000000
>         (XEN) r9:  0000000000000000   r10: 0000000000000000   r11: 0000000000000000
>         (XEN) r12: 0000000000000000   r13: 0000000000000000   r14: 0000000000000000
>         (XEN) r15: 0000000000000000   cr0: 000000008005003b   cr4: 00000000000006f0
>         (XEN) cr3: 000000011b240000   cr2: 00000000f54fe40e
>         (XEN) ds: e021   es: e021   fs: e021   gs: e021   ss: e021   cs: e019
>         (XEN) Guest stack trace from esp=c0257f68:
>         (XEN)   00000000 c02601b1 0001e019 00010082 c0223566 c0257fc8 00000000 c0260675
>         (XEN)   c0223566 000002d7 c0257fec c02230fe 00000000 c03af000 c0257fec c02230fe
>         (XEN)   00000000 c025ba84 c0203000 c026317f c0257fe4 c0257fe8 c0257fec bfebcbf5
>         (XEN)   c02766a0 c03af000 c0257fec c02230fe 00000000 c025f151 9fabc9f5 0000649d
>         (XEN)   01020800 00000f44 f5800000 00000000 c03af000 00000000
>
> This corresponds to the dereference of *bp in get_bios_ebda():
>         static inline unsigned long get_bios_ebda(void)
>         {
>                 unsigned short *bp;
>                 unsigned long address;
>
>                 bp = early_ioremap(0x40EUL, 2);
>                 if (!bp)
>                         return 0;
>
>                 address = *bp;

This crash has nothing to do with this patch. Because this patch is
for i386 only, x86_64 has its own early_ioremap implementation.

Best Regards,
Huang Ying
