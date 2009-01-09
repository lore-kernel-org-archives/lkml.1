Return-Path: <linux-kernel-owner+w=401wt.eu-S1756271AbZAINS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271AbZAINS5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 08:18:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752220AbZAINSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 08:18:49 -0500
Received: from vena.lwn.net ([206.168.112.25]:34138 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751941AbZAINSs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 08:18:48 -0500
Date: Fri, 9 Jan 2009 06:18:46 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Oleg Nesterov <oleg@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Andi Kleen <andi@firstfloor.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Al Viro <viro@ZenIV.linux.org.uk>,
       bfields@fieldses.org
Subject: Re: RFC: Fix f_flags races without the BKL
Message-ID: <20090109061846.5beee8df@bike.lwn.net>
In-Reply-To: <20090109100821.GA27829@redhat.com>
References: <20081229041352.6bbdf57c@tpl>
	<20081229124151.GA29634@redhat.com>
	<20090108162806.48caaa29@bike.lwn.net>
	<20090109100821.GA27829@redhat.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Jan 2009 11:08:21 +0100
Oleg Nesterov <oleg@redhat.com> wrote:

> So, fasync_change() sets/clears FASYNC,
> 
> > +	lock_file_flags();
> >  	filp->f_flags = (arg & SETFL_MASK) | (filp->f_flags & ~SETFL_MASK);
> > +	unlock_file_flags();
> 
> and then we change f_flags again, including F_ASYNC bit.
> 
> This is racy?

No, I took FASYNC out of SETFL_MASK, so it isn't changed here.

> > +int fasync_change(int fd, struct file *filp, int on)
> > +{
> > +	int ret;
> > +	static DEFINE_MUTEX(fasync_mutex);
> > +
> > +	if (filp->f_op->fasync == NULL)
> > +		return -ENOTTY;
> > +
> > +	mutex_lock(&fasync_mutex);
> > +	lock_file_flags();
> > +	if (((filp->f_flags & FASYNC) == 0) == (on == 0)) {
> > +		unlock_file_flags();
> > +		return 0;
> > +	}
> > +	if (on)
> > +		filp->f_flags |= FASYNC;
> > +	else
> > +		filp->f_flags &= ~FASYNC;
> > +	unlock_file_flags();
> > +	ret = filp->f_op->fasync(fd, filp, on);
> > +	mutex_unlock(&fasync_mutex);
> > +	return ret;
> 
> But we must not change ->f_flags if ->fasync() fails?

Good point, that's not quite right.  That will make things a bit uglier -
we can't hold file_flags_lock when we call ->fasync() - but I'll fix it.
Unless people think that this approach is completely wrong too, of course. 
 
> Now we have the global mutex for ->fasync... Well, not very
> good but fasync_helper() takes fasync_lock anyway.

Not very good, but does anybody know of a workload which would result in
that mutex being contended ever?

Thanks,

jon
