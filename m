Return-Path: <linux-kernel-owner+w=401wt.eu-S1755090AbYJBVi6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755090AbYJBVi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 17:38:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754427AbYJBViu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 17:38:50 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51977 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754349AbYJBVit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 17:38:49 -0400
Date: Thu, 2 Oct 2008 14:37:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: arjan@infradead.org, david@fromorbit.com, andi@firstfloor.org,
       linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] Give kjournald a IOPRIO_CLASS_RT io priority
Message-Id: <20081002143713.2f8ebc04.akpm@linux-foundation.org>
In-Reply-To: <20081002192223.GP19428@kernel.dk>
References: <20081001200034.65eb67d6@infradead.org>
	<20081001215638.3a65134c.akpm@linux-foundation.org>
	<87fxnfpjqj.fsf@basil.nowhere.org>
	<20081002075511.GX19428@kernel.dk>
	<20081002093326.GF30001@disturbed>
	<20081002094537.GA19428@kernel.dk>
	<20081002120408.21585949@infradead.org>
	<20081002192223.GP19428@kernel.dk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Oct 2008 21:22:23 +0200
Jens Axboe <jens.axboe@oracle.com> wrote:

> > @@ -131,6 +132,17 @@ static int kjournald(void *arg)
> >  			journal->j_commit_interval / HZ);
> >  
> >  	/*
> > +	 * kjournald is the process on which most other processes depend on
> > +	 * for doing the filesystem portion of their IO. As such, there exists
> > +	 * the equivalent of a priority inversion situation, where kjournald
> > +	 * would get less priority as it should.
> > +	 *
> > +	 * For this reason we set to "medium real time priority", which is higher
> > +	 * than regular tasks, but not infinitely powerful.
> > +	 */
> > +	set_task_ioprio(current, IOPRIO_PRIO_VALUE(IOPRIO_CLASS_BE, 0));
> > +
> > +	/*
> >  	 * And now, wait forever for commit wakeup events.
> >  	 */
> >  	spin_lock(&journal->j_state_lock);
> > diff --git a/include/linux/ioprio.h b/include/linux/ioprio.h
> > index f98a656..76dad48 100644
> > --- a/include/linux/ioprio.h
> > +++ b/include/linux/ioprio.h
> > @@ -86,4 +86,6 @@ static inline int task_nice_ioclass(struct task_struct *task)
> >   */
> >  extern int ioprio_best(unsigned short aprio, unsigned short bprio);
> >  
> > +extern int set_task_ioprio(struct task_struct *task, int ioprio);
> > +
> >  #endif
> > -- 
> > 1.5.5.1
> 
> Can we agree on this patch?

This change will cause _all_ kjournald writeout to have elevated
priority.  The majority of that writeout (in data=ordered mode) is file
data, which we didn't intend to change.

The risk here is that this will *worsen* latency for plain old read(),
because now kjournald writeout will be favoured.

There is in fact a good argument for _reducing_ kjournald's IO
priority, not increasing it!

A better approach might be to mark the relevant buffers/bios as needing
higher priority at submit_bh() time (if that's possible).  At least
that way we don't accidentally elevate the priority of the bulk data.


It's a bit of a hack, sorry :(
