Return-Path: <linux-kernel-owner+w=401wt.eu-S1761675AbXKAPGM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761675AbXKAPGM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 11:06:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756366AbXKAPFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 11:05:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:44182 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754072AbXKAPFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 11:05:46 -0400
Date: Thu, 1 Nov 2007 16:05:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Ulrich Drepper <drepper@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [patch] PID namespace design bug, workaround
Message-ID: <20071101150537.GC4044@elte.hu>
References: <20071101144307.GA29566@elte.hu> <4729E86A.9090705@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4729E86A.9090705@redhat.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Ulrich Drepper <drepper@redhat.com> wrote:

> Ingo Molnar wrote:
> > +	clone_flags &= ~CLONE_NEWPID;
> 
> I think the call should rather fail than silently drop the bit but 
> aside from that I agree.  The problems we'd run into if the feature is 
> getting used as-is are severe.

does the patch below look OK to you?

	Ingo

------------------->
From: Ingo Molnar <mingo@elte.hu>
Subject: PID namespaces: turn them off for now

while checking recent commits to the kernel core i took a look at the 
PID namespaces implementation, and it has a fatal flaw: it breaks 
futexes and various libraries (and other stuff) that use PIDs as the 
means of identifying tasks, by not providing any means of global 
identification that works across PID namespaces. (PIDs _are_ a very 
convenient and global way of identifying contexts.)

i asked Ulrich about this and it turns out he has warned about this 
early on:

  http://www.nabble.com/Re%3A-question%3A-pid-space-semantics.-p3409990.html

but this problem is still present in the code, and it has been recently 
committed into mainline via:

  commit 30e49c263e36341b60b735cbef5ca37912549264
  Author: Pavel Emelyanov <xemul@openvz.org>
  Date:   Thu Oct 18 23:40:10 2007 -0700

      pid namespaces: allow cloning of new namespace

without these problems having been resolved. A full-scale revert is 
probably too intrusive, but at minimum we need to turn off user-space 
access to this feature via this simple patch. Until this issue is 
resolved properly the new PID namespace code needs to be turned off. 
Letting this into 2.6.24 would be a disaster.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/fork.c |    9 +++++++++
 1 file changed, 9 insertions(+)

Index: v/kernel/fork.c
===================================================================
--- v.orig/kernel/fork.c
+++ v/kernel/fork.c
@@ -1420,6 +1420,15 @@ long do_fork(unsigned long clone_flags,
 	int trace = 0;
 	long nr;
 
+	/*
+	 * PID namespaces are broken at the moment: they do not allow
+	 * certain PID based syscalls (such as futexes) to be used
+	 * across namespaces. This is broken and must not be allowed,
+	 * so we keep this feature turned off until it's properly fixed.
+	 */
+	if (clone_flags & CLONE_NEWPID)
+		return -ENOSYS;
+
 	if (unlikely(current->ptrace)) {
 		trace = fork_traceflag (clone_flags);
 		if (trace)
