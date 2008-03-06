Return-Path: <linux-kernel-owner+w=401wt.eu-S1759819AbYCFIJt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759819AbYCFIJt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 03:09:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751920AbYCFIJi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 03:09:38 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46186 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873AbYCFIJh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 03:09:37 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
X-Fcc: ~/Mail/linus
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] introduce ptrace_reparented() helper
In-Reply-To: Oleg Nesterov's message of  Wednesday, 5 March 2008 20:24:20 +0300 <20080305172420.GA6751@tv-sign.ru>
References: <20080303041751.GA18914@tv-sign.ru>
	<20080303072123.GA25282@tv-sign.ru>
	<20080305041858.8FBD927010A@magilla.localdomain>
	<20080305172420.GA6751@tv-sign.ru>
X-Zippy-Says: Are we live or on tape?
Message-Id: <20080306080902.BDB1B2700FD@magilla.localdomain>
Date: Thu,  6 Mar 2008 00:09:02 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I am planning to do some changes in forget_original_parent (fix 2 very
> old minor bugs and _perhaps_ add some improvement). I hit the minor but
> nasty problem: this open coded __ptrace_unlink() in reparent_thread().
> _This_ is the actual reason for this patch.
> 
> So. Would you object if I do
> 
> 	--- kernel/ptrace.c	2008-03-03 17:01:06.000000000 +0300
> 	+++ kernel/ptrace.c	2008-03-05 20:22:44.801142777 +0300
> 	@@ -67,11 +67,12 @@ void ptrace_untrace(struct task_struct *
> 	  * remove it from the ptrace list.
> 	  *
> 	  * Must be called with the tasklist lock write-held.
> 	+ *
> 	+ * Either the caller is ptracer, or the caller is ->real_parent
> 	+ * and the child is not traced.
> 	  */
> 	 void __ptrace_unlink(struct task_struct *child)
> 	 {
> 	-	BUG_ON(!child->ptrace);
> 	-
> 		child->ptrace = 0;
> 		if (ptrace_reparented(child)) {
> 			list_del_init(&child->ptrace_list);
> 
> ?

That seems ok.  The duplication of magic in reparent_thread is indeed bad.
I don't think this BUG_ON is buying us much if we haven't hit it in a long
time.


Thanks,
Roland
