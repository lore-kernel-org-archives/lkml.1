Return-Path: <linux-kernel-owner+w=401wt.eu-S1759068AbYJMQD3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759068AbYJMQD3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 12:03:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756098AbYJMQDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 12:03:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58964 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756036AbYJMQDS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 12:03:18 -0400
Date: Mon, 13 Oct 2008 18:02:59 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Karel Zak <kzak@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [kerneloops] regression in 2.6.27 wrt "lock_page" and the
	"hwclock" program
Message-ID: <20081013160259.GA26866@elte.hu>
References: <20081004174433.14a5e093@infradead.org> <20081004215225.2444d54b.akpm@linux-foundation.org> <20081005081145.30ba921b@infradead.org> <20081005102742.de8353b4.akpm@linux-foundation.org> <20081005103826.6771540a@infradead.org> <20081012200004.GI10429@nb.net.home> <alpine.LFD.2.00.0810121308210.3402@nehalem.linux-foundation.org> <20081013152633.GA6523@elte.hu> <alpine.LFD.2.00.0810130841440.3288@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0810130841440.3288@nehalem.linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Mon, 13 Oct 2008, Ingo Molnar wrote:
> > 
> > do you agree with the changelog and can i add your Signed-off-by ?
> 
> Sure. One thing I'd still like to see is that crazy "again" vs 
> "survive" mess for x86-64 vs x86-32. I think the patch as posted will 
> cause a new warning on x86-32 due to "unused label 'again'" or 
> similar.
> 
> It's totally insane that we have two different versions of the oom 
> handling for x86. I don't know why we do that, it's probably 
> historical, and I _suspect_ that the 32-bit one has gotten a lot more 
> testing.
> 
> And not just because there have been more of the 32-bit kernels 
> around, but also because low-memory situations are probably more 
> common on 32-bit setups. But I dunno.
> 
> So I would suggest you just pick the x86-32 version of that oom 
> handling thing too. Unless you know some deep reason why the 64-bit 
> one would be superior.

hm, i think the 64-bit case is the correct code, because in this 'init 
task OOMs' case we do:

out_of_memory:
        up_read(&mm->mmap_sem);
        if (is_global_init(tsk)) {
                yield();
                down_read(&mm->mmap_sem);

note that we drop the mmap_sem, so in theory another thread of this same 
MM could change the vma tree, and our 'vma' might not be valid anymore.

It's probably not a real issue in practice because this is about PID 1, 
so i doubt it really matters, but still.

So how about the patch below?

	Ingo

---------------->
>From 7b87da331b6ada44ccd5ffeedba76880c825d4fc Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Mon, 13 Oct 2008 17:49:02 +0200
Subject: [PATCH] x86/mm: unify init task OOM handling

Linus noticed that the "again:" versus "survive:" OOM logic for
the init task was arbitrarily different.

The 64-bit codepath is the better one, because it correctly re-lookups
the vma after having dropped the ->mmap_sem.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/fault.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index ac2ad78..8bc5956 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -671,7 +671,8 @@ void __kprobes do_page_fault(struct pt_regs *regs, unsigned long error_code)
 		goto bad_area_nosemaphore;
 
 again:
-	/* When running in the kernel we expect faults to occur only to
+	/*
+	 * When running in the kernel we expect faults to occur only to
 	 * addresses in user space.  All other faults represent errors in the
 	 * kernel and should generate an OOPS.  Unfortunately, in the case of an
 	 * erroneous fault occurring in a code path which already holds mmap_sem
@@ -734,9 +735,6 @@ good_area:
 			goto bad_area;
 	}
 
-#ifdef CONFIG_X86_32
-survive:
-#endif
 	/*
 	 * If for any reason at all we couldn't handle the fault,
 	 * make sure we exit gracefully rather than endlessly redo
@@ -871,12 +869,11 @@ out_of_memory:
 	up_read(&mm->mmap_sem);
 	if (is_global_init(tsk)) {
 		yield();
-#ifdef CONFIG_X86_32
-		down_read(&mm->mmap_sem);
-		goto survive;
-#else
+		/*
+		 * Re-lookup the vma - in theory the vma tree might
+		 * have changed:
+		 */
 		goto again;
-#endif
 	}
 
 	printk("VM: killing process %s\n", tsk->comm);
