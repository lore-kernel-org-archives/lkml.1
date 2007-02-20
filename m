Return-Path: <linux-kernel-owner+w=401wt.eu-S965035AbXBTP0K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965035AbXBTP0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 10:26:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965038AbXBTP0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 10:26:09 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60603 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965035AbXBTP0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 10:26:08 -0500
Date: Wed, 21 Feb 2007 00:25:26 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, akpm@linux-foundation.org,
       roland@redhat.com
Subject: Re: [PATCH] fix handling of SIGCHILD from reaped child
Message-Id: <20070221002526.c6b7edb0.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20070220142257.GA155@tv-sign.ru>
References: <20070220183220.41b3f1ca.kamezawa.hiroyu@jp.fujitsu.com>
	<20070220142257.GA155@tv-sign.ru>
X-Mailer: Sylpheed version 2.2.0 (GTK+ 2.6.10; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Feb 2007 17:22:57 +0300
Oleg Nesterov <oleg@tv-sign.ru> wrote:

>
> I'd suggest to make a separate function, but not complicate collect_signal().
>
okay. I'll try again if people admit me to go ahead. 

> > --- linux-2.6.20-devel.orig/kernel/exit.c
> > +++ linux-2.6.20-devel/kernel/exit.c
> > @@ -1252,8 +1252,12 @@ static int wait_task_zombie(struct task_
> >  		}
> >  		write_unlock_irq(&tasklist_lock);
> >  	}
> > -	if (p != NULL)
> > +	if (p != NULL) {
> >  		release_task(p);
> > +		/* if we received sigchild from "p" and p is released,
> > +		   we remove sigchild from it. */
> 
> current may be ptracer, not a parent. Should be ok, clear_stale_sigchild(pid)
> can't have a false positive (until we have namespace for pid_t), but the comment
> is misleading a bit.
> 
I'll rewrite and make this clearer.

> > +		clear_stale_sigchild(current, retval);
> 
> But we are not checking that SIGCHLD is blocked?
> 
I'm sorry if I don't read SUSv3 correctly. SUSv3 doesn't define how we should
do if SIGCHLD is not blocked.(so I don't check not-blocked case.)

IMHO, user's sig-child-handler is tend to call wait()/waitpid() and expects
successful return. So removing stale signal here may be good.

If this breaks assumptions of applications on Linux, I'll not go eagerly.

Thanks,
-Kame





