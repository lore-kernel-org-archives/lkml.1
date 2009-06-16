Return-Path: <linux-kernel-owner+w=401wt.eu-S1754396AbZFPDFe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbZFPDFe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 23:05:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751875AbZFPDF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 23:05:26 -0400
Received: from tomts10.bellnexxia.net ([209.226.175.54]:50939 "EHLO
	tomts10-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750930AbZFPDFZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 23:05:25 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AuMEAAukNkpMQWQl/2dsb2JhbACBT9FxhA0F
Date: Mon, 15 Jun 2009 23:05:22 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linus Torvalds <torvalds@linux-foundation.org>, mingo@redhat.com,
       paulus@samba.org, acme@redhat.com, linux-kernel@vger.kernel.org,
       penberg@cs.helsinki.fi, vegard.nossum@gmail.com, efault@gmx.de,
       jeremy@goop.org, npiggin@suse.de, tglx@linutronix.de,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perfcounters/core] perf_counter: x86: Fix call-chain
	support to use NMI-safe methods
Message-ID: <20090616030522.GA22162@Krystal>
References: <20090615211207.GB12919@Krystal> <20090615211605.GC27100@elte.hu> <20090615213429.GD12919@Krystal> <4A36BF61.10901@zytor.com> <20090615215420.GE12919@Krystal> <4A36C953.8060906@zytor.com> <20090615223038.GA15903@Krystal> <4A36CCFC.8070908@zytor.com> <20090615224908.GA16661@Krystal> <4A36F520.6020604@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <4A36F520.6020604@zytor.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:52:21 up 107 days, 23:18,  3 users,  load average: 0.12, 0.21,
	0.25
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin (hpa@zytor.com) wrote:
> Mathieu Desnoyers wrote:
> > 
> > Where is the kernel page fault handler grabbing any lock to service
> > in-kernel page faults exactly ?
> > 
> > Those are usually considered as utterly simple page table fixups,
> > nothing more.
> > 
> 
> It doesn't, *because it doesn't have to*.  Your proposal requires that
> page faults can be handled inside the page fault handler, and that's a
> pretty tall order.
> 
> 	-hpa
> 

I am not asking for the pf handler to handle every possible kind of
fault recursively. Just to keep the in-kernel page fault related code
for vmalloc (and possibly for prefetch ?) paths NMI-reentrant :

void do_page_fault(struct pt_regs *regs, unsigned long error_code)

  address = read_cr2();

  if (unlikely(kmmio_fault(regs, address)))
    return;

#ifdef CONFIG_X86_32
        if (unlikely(address >= TASK_SIZE)) {
#else
        if (unlikely(address >= TASK_SIZE64)) {
#endif
                if (!(error_code & (PF_RSVD|PF_USER|PF_PROT)) &&
                    vmalloc_fault(address) >= 0)
                        return;

                /* Can handle a stale RO->RW TLB */
                if (spurious_fault(address, error_code))
                        return;

                /* kprobes don't want to hook the spurious faults. */
                if (notify_page_fault(regs))
                        return;
                /*
                 * Don't take the mm semaphore here. If we fixup a prefetch
                 * fault we could otherwise deadlock.
                 */
                goto bad_area_nosemaphore;
        }

This includes vmalloc_fault. Note that I already looked into
vmalloc_fault to ensure it could handle NMIs on x86_64 as well. See
commit bdd5ea31e79fed76eb57d0cd797355267f4f4a8c. It seems I missed the
cr2 register issue though. I assumed NMI handler to save it somehow,
which ends up not being the case.

Mathieu




-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
