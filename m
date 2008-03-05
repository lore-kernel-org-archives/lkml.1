Return-Path: <linux-kernel-owner+w=401wt.eu-S1759161AbYCERUc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759161AbYCERUc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 12:20:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755587AbYCERUY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 12:20:24 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:42642 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755445AbYCERUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 12:20:23 -0500
Date: Wed, 5 Mar 2008 20:24:20 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Roland McGrath <roland@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] introduce ptrace_reparented() helper
Message-ID: <20080305172420.GA6751@tv-sign.ru>
References: <20080303041751.GA18914@tv-sign.ru> <20080303072123.GA25282@tv-sign.ru> <20080305041858.8FBD927010A@magilla.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080305041858.8FBD927010A@magilla.localdomain>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04, Roland McGrath wrote:
>
> > Somehow the patch I sent misses the change in ptrace.c, it can use the
> > new helper too.
> 
> Actually, my pedantic streak prefers that to be in a separate patch.
> ...
> I don't object to the change, but it should be
> separate so bisect distinguishes it should it ever turn out to
> matter in some way we are now overlooking. 

OK, agreed, will do.

> I'd even be a
> little inclined towards:
> 
> 	if (child->real_parent == child->parent) {
> 		BUG_ON(!list_empty(&child->ptrace_list));
> 		return 0;
> 	} else {
> 		BUG_ON(list_empty(&child->ptrace_list));
> 		return 1;
> 	}
> 
> except of course you couldn't use that in the reparent_thread case.
                                                ^^^^^^^^^^^^^^^
I can't believe. You are reading my mind!

I am planning to do some changes in forget_original_parent (fix 2 very
old minor bugs and _perhaps_ add some improvement). I hit the minor but
nasty problem: this open coded __ptrace_unlink() in reparent_thread().
_This_ is the actual reason for this patch.

So. Would you object if I do

	--- kernel/ptrace.c	2008-03-03 17:01:06.000000000 +0300
	+++ kernel/ptrace.c	2008-03-05 20:22:44.801142777 +0300
	@@ -67,11 +67,12 @@ void ptrace_untrace(struct task_struct *
	  * remove it from the ptrace list.
	  *
	  * Must be called with the tasklist lock write-held.
	+ *
	+ * Either the caller is ptracer, or the caller is ->real_parent
	+ * and the child is not traced.
	  */
	 void __ptrace_unlink(struct task_struct *child)
	 {
	-	BUG_ON(!child->ptrace);
	-
		child->ptrace = 0;
		if (ptrace_reparented(child)) {
			list_del_init(&child->ptrace_list);

?

Oleg.

