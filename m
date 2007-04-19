Return-Path: <linux-kernel-owner+w=401wt.eu-S1750844AbXDSW1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750844AbXDSW1h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 18:27:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753785AbXDSW1h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 18:27:37 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:60158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750844AbXDSW1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 18:27:36 -0400
Date: Thu, 19 Apr 2007 15:26:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Christoph Hellwig <hch@infradead.org>,
       Linux Containers <containers@lists.osdl.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mtd_blkdevs: Convert to use the kthread API
Message-Id: <20070419152639.1057c61b.akpm@linux-foundation.org>
In-Reply-To: <m11wigmb3h.fsf@ebiederm.dsl.xmission.com>
References: <m1slawn9eb.fsf@ebiederm.dsl.xmission.com>
	<11769657692046-git-send-email-ebiederm@xmission.com>
	<20070419164746.GA19469@infradead.org>
	<m11wigmb3h.fsf@ebiederm.dsl.xmission.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Apr 2007 13:13:22 -0600
ebiederm@xmission.com (Eric W. Biederman) wrote:

> Christoph Hellwig <hch@infradead.org> writes:
> 
> > On Thu, Apr 19, 2007 at 12:55:28AM -0600, Eric W. Biederman wrote:
> >> From: Eric W. Biederman <ebiederm@xmission.com> - unquoted
> >> 
> >> thread_run is used intead of kernel_thread, daemonize, and mucking
> >> around blocking signals directly.
> >
> > Please don't do incomplete transitions like that.  We don't really
> > want people to use kthread_run, but not the kthread stopping
> > mechanisms, because people will simply forget about that bit and
> > we'll never get rid of the enormous amount of, erm creativity, in
> > handling kernel thread stopping.
> >
> > This is just the first patch in your series where the thread is mutable,
> > but it equally applies to all following patches where this is the case
> > aswell.
> 
> I don't really care about the creativity.  Although it would
> be nice if it wasn't there.  I deliberately left it in so I would be
> certain my patches were correct.
> 
> I care about killing the maintenance and forward development roadblocks
> that are kernel_thread and daemonize.  And the user interface problem
> that is handling signals in kernel threads.
> 

Yes, I think that is a practical position, if not an ideal one.

MTD (to pick one example) does need to be decruftified: remove
r->blkcore_priv->exiting, probably ->blkcore_priv->thread_dead, switch
deregister_mtd_blktrans() to use kthread_stop().  But it's a bit much to
expect Eric to make that conversion, and to suitably test it.  All he can
do is to make a best-effort and hope that someone else tests it, which
isn't very reliable.

This partial patch at least gets us some of the way there, and serves as a
gentle reminder to dwmwyouknowwho to finish cleaning this stuff up.

I'd be more concerned about a part-conversion in a subsystem which has no
identifiable maintainer, because in that case the chances are that we'll
just forget about it an the conversion would never be completed.

And of course, these are not simply cleanup patches: we actually need to get
the kernel threads out of the daemonize() and signalling game to complete
the virtualisation work.

