Return-Path: <linux-kernel-owner+w=401wt.eu-S1752766AbXCEKPL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbXCEKPL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 05:15:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932244AbXCEKPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 05:15:10 -0500
Received: from smtp.ocgnet.org ([64.20.243.3]:45815 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752766AbXCEKPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 05:15:08 -0500
Date: Mon, 5 Mar 2007 19:12:31 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: John Reiser <jreiser@BitWagon.com>, Andi Kleen <ak@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: + fully-honor-vdso_enabled.patch added to -mm tree
Message-ID: <20070305101231.GA12363@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Oleg Nesterov <oleg@tv-sign.ru>, John Reiser <jreiser@BitWagon.com>,
	Andi Kleen <ak@suse.de>, Ingo Molnar <mingo@elte.hu>,
	Arjan van de Ven <arjan@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <20070301175207.GA849@tv-sign.ru> <45E891E6.7090807@BitWagon.com> <20070302221854.GA162@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070302221854.GA162@tv-sign.ru>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 03, 2007 at 01:18:54AM +0300, Oleg Nesterov wrote:
> On 03/02, John Reiser wrote:
> > Paul Mundt has commented on setup_rt_frame() and provided a patch which
> > bullet-proofs that area.  I will include that patch into the next revision.
> 
> Confused. I still think his patch incomplete. Don't we need the same check
> in setup_rt_frame() ?
> 
Yes, you're right. The patch is missing the proper restorer logic in the
setup_rt_frame() case. This should handle both of them, restoring the
previous logic when the VDSO is disabled.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

--

 arch/i386/kernel/signal.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/arch/i386/kernel/signal.c b/arch/i386/kernel/signal.c
index 4f99e87..26c2497 100644
--- a/arch/i386/kernel/signal.c
+++ b/arch/i386/kernel/signal.c
@@ -350,7 +350,7 @@ static int setup_frame(int sig, struct k_sigaction *ka,
 			goto give_sigsegv;
 	}
 
-	if (current->binfmt->hasvdso)
+	if (current->binfmt->hasvdso && current->mm->context.vdso)
 		restorer = (void *)VDSO_SYM(&__kernel_sigreturn);
 	else
 		restorer = (void *)&frame->retcode;
@@ -449,17 +449,20 @@ static int setup_rt_frame(int sig, struct k_sigaction *ka, siginfo_t *info,
 		goto give_sigsegv;
 
 	/* Set up to return from userspace.  */
-	restorer = (void *)VDSO_SYM(&__kernel_rt_sigreturn);
+	if (current->binfmt->hasvdso && current->mm->context.vdso)
+		restorer = (void *)VDSO_SYM(&__kernel_rt_sigreturn);
+	else
+		restorer = (void *)&frame->retcode;
 	if (ka->sa.sa_flags & SA_RESTORER)
 		restorer = ka->sa.sa_restorer;
 	err |= __put_user(restorer, &frame->pretcode);
-	 
+
 	/*
 	 * This is movl $,%eax ; int $0x80
 	 *
-	 * WE DO NOT USE IT ANY MORE! It's only left here for historical
-	 * reasons and because gdb uses it as a signature to notice
-	 * signal handler stack frames.
+	 * This is not used in the general case! It's left here for
+	 * handling toggling of the VDSO state and because gdb uses it
+	 * as a signature to notice signal handler stack frames.
 	 */
 	err |= __put_user(0xb8, (char __user *)(frame->retcode+0));
 	err |= __put_user(__NR_rt_sigreturn, (int __user *)(frame->retcode+1));
