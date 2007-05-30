Return-Path: <linux-kernel-owner+w=401wt.eu-S1756998AbXE3TTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756998AbXE3TTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 15:19:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbXE3TSx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 15:18:53 -0400
Received: from mail.screens.ru ([213.234.233.54]:60088 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752892AbXE3TSw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 15:18:52 -0400
Date: Wed, 30 May 2007 23:18:49 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tty: fix leakage of -ERESTARTSYS to userland
Message-ID: <20070530191849.GB85@tv-sign.ru>
References: <20070529184435.GA174@tv-sign.ru> <20070530110513.b2ae50ad.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070530110513.b2ae50ad.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30, Andrew Morton wrote:
> On Tue, 29 May 2007 22:44:35 +0400
> Oleg Nesterov <oleg@tv-sign.ru> wrote:
> 
> > --- t/drivers/char/n_tty.c~	2007-04-05 12:18:26.000000000 +0400
> > +++ t/drivers/char/n_tty.c	2007-05-28 10:57:58.000000000 +0400
> > @@ -1191,6 +1191,7 @@ static int job_control(struct tty_struct
> >  			    is_current_pgrp_orphaned())
> >  				return -EIO;
> >  			kill_pgrp(task_pgrp(current), SIGTTIN, 1);
> > +			set_thread_flag(TIF_SIGPENDING);
> >  			return -ERESTARTSYS;
> >  		}
> >  	}
> 
> Are there other callers of kill_pgrp() which have the same problem?

Hopefully no.

> Perhaps we should have a kill_pgrp_self() which takes care of doing
> this, rather than open-coding it.  Something with a comment which
> explains what's going on ;)

This set_thread_flag(TIF_SIGPENDING) is "connected" to "return -ERESTARTSYS",
not to kill_pgrp(), imho the new helper is not so suitable.

Perhaps it makes sense to add the comment into include/linux/errno.h, to
explain that -ERESTART... codes are only valid when signal_pending() == true.

Oleg.

