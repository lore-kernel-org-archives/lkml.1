Return-Path: <linux-kernel-owner+w=401wt.eu-S933604AbXEKUVR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933604AbXEKUVR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 16:21:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758977AbXEKUVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 16:21:07 -0400
Received: from mail.screens.ru ([213.234.233.54]:56746 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754979AbXEKUVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 16:21:06 -0400
Date: Sat, 12 May 2007 00:21:02 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Gautham R Shenoy <ego@in.ibm.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH 1/7] Freezer: Read PF_BORROWED_MM in a nonracy way
Message-ID: <20070511202102.GA155@tv-sign.ru>
References: <200705110035.32229.rjw@sisk.pl> <200705110036.26617.rjw@sisk.pl> <20070511123959.190adfaf.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070511123959.190adfaf.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11, Andrew Morton wrote:
>
> On Fri, 11 May 2007 00:36:25 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> >  static inline int is_user_space(struct task_struct *p)
> >  {
> > -	return p->mm && !(p->flags & PF_BORROWED_MM);
> > +	int ret;
> > +
> > +	task_lock(p);
> > +	ret = p->mm && !(p->flags & PF_BORROWED_MM);
> > +	task_unlock(p);
> > +	return ret;
> >  }
> 
> The whole function is racy, isn't it?  I mean, the condition which it is
> testing can go from true->false or false->true at any instant after this
> function returns its now-wrong value.
> 
> iow, callers of this function need to to something to prevent the expression
> `p->mm && !(p->flags & PF_BORROWED_MM);' from changing value _anyway_.  In
> which case the new locking is not needed?

freeze_processes() first freezes user-space tasks only, then kernel threads.

Without task_lock() we can miss PF_BORROWED_MM and count the kernel thread
(which is doing use_mm()) as a user space process. This means it will be
frozen prematurely.

true->false means daemonize() or do_exit(), seems harmless.

false->true means exec from kernel space. That is why FREEZER_KERNEL_THREADS
in fact means all tasks, not only kernel threads.

Oleg.

