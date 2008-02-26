Return-Path: <linux-kernel-owner+w=401wt.eu-S1758687AbYBZIwe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758687AbYBZIwe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 03:52:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751454AbYBZIwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 03:52:24 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33357 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbYBZIwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 03:52:23 -0500
Date: Tue, 26 Feb 2008 09:51:54 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Roland McGrath <roland@redhat.com>
Cc: Markus Metzger <markus.t.metzger@intel.com>, ak@suse.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       markus.t.metzger@gmail.com, suresh.b.siddha@intel.com,
       akpm@linux-foundation.org, mtk.manpages@gmail.com,
       eranian@googlemail.com
Subject: Re: [patch 1/2] x86, ptrace: support pebs in ds.c
Message-ID: <20080226085154.GD9857@elte.hu>
References: <20080213112349.A3283@sedona.ch.intel.com> <20080221210026.7B1C62701D5@magilla.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080221210026.7B1C62701D5@magilla.localdomain>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Roland McGrath <roland@redhat.com> wrote:

> Sorry I haven't replied in this thread sooner.
> 
> I would like to see all the BTS and DS work wait until after 2.6.25. 
> We have a lot of x86 churn in 2.6.25 already, and I think we'd do 
> better without adding this wrinkle at the same time.
> 
> The low-level implementation pieces should gel a bit more in -mm or 
> whereever.  They should both get more testing and also get more 
> concrete use from the perfmon2 integration effort to iron out their 
> internal interface kinks.
> 
> For the user-level interface, we should not be hasty with cooking up 
> hairy ptrace extensions.  Personally, I'd prefer that we never add a 
> ptrace-based interface for this (ptrace must die).  I think it will 
> fit much better either merged into the interfaces that come from 
> perfmon2 integration, or into what replaces ptrace when that comes. 
> There is not yet any different userland interface framework in the 
> tree to base it on, so ptrace extensions may be better than nothing if 
> they are well-gelled in 2.6.26 and nothing else is close to ready. But 
> I also don't know of anyone desperate and about to burst from lack of 
> BTS functionality.

i'd you'd like to have something like the patch below to happen?

what API should BTS/DS functionality use towards user-space if not 
ptrace? Should it be utrace?

	Ingo

--------------------->
Subject: x86: disable BTS ptrace extensions for now
From: Ingo Molnar <mingo@elte.hu>
Date: Tue Feb 26 09:40:27 CET 2008

based on general objections from Roland McGrath:

    http://lkml.org/lkml/2008/2/21/323

we'll let the BTS functionality cook some more and enable
it in v2.6.26.

(X86_BTS is not defined at the moment)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/ptrace.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-x86.q/arch/x86/kernel/ptrace.c
===================================================================
--- linux-x86.q.orig/arch/x86/kernel/ptrace.c
+++ linux-x86.q/arch/x86/kernel/ptrace.c
@@ -961,6 +961,10 @@ long arch_ptrace(struct task_struct *chi
 		break;
 #endif
 
+	/*
+	 * These bits need more cooking - not enabled yet:
+	 */
+#ifdef X86_BTS
 	case PTRACE_BTS_CONFIG:
 		ret = ptrace_bts_config
 			(child, data, (struct ptrace_bts_config __user *)addr);
@@ -988,6 +992,7 @@ long arch_ptrace(struct task_struct *chi
 		ret = ptrace_bts_drain
 			(child, data, (struct bts_struct __user *) addr);
 		break;
+#endif
 
 	default:
 		ret = ptrace_request(child, request, addr, data);
