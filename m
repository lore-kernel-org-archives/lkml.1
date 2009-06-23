Return-Path: <linux-kernel-owner+w=401wt.eu-S1759125AbZFWPCN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759125AbZFWPCN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 11:02:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759917AbZFWPBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 11:01:51 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51191 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760052AbZFWPBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 11:01:51 -0400
Date: Tue, 23 Jun 2009 08:01:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>, hch@infradead.org
Subject: Re: merging the per-bdi writeback patchset
Message-Id: <20090623080137.33cdc45c.akpm@linux-foundation.org>
In-Reply-To: <20090623085505.GU31415@kernel.dk>
References: <20090623081156.GT31415@kernel.dk>
	<20090623014835.1fc8fb14.akpm@linux-foundation.org>
	<20090623085505.GU31415@kernel.dk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Jun 2009 10:55:05 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:

> On Tue, Jun 23 2009, Andrew Morton wrote:
> > On Tue, 23 Jun 2009 10:11:56 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
> > 
> > > Things are looking good for this patchset and it's been in -next for
> > > almost a week without any reports of problems. So I'd like to merge it
> > > for 2.6.31 if at all possible. Any objections?
> > 
> > erk.  I was rather expecting I'd have time to have a look at it all.
> 
> OK, we can wait if we have to, just trying to avoid having to keep this
> fresh for one full cycle. I have posted this patchset 11 times though
> over months, so it's not like it's a new piece of work :-)

Yeah, sorry.  

> > It's unclear to me actually _why_ the performance changes which were
> > observed have actually occurred.  In fact it's a bit unclear (to me)
> > why the patchset was written and what it sets out to achieve :(
> 
> It started out trying to get rid of the pdflush uneven writeout. If you
> look at various pdflush intensive workloads, even on a single disk you
> often have 5 or more pdflush threads working the same device. It's just
> not optimal.

That's a bug, isn't it?  This

		/* Is another pdflush already flushing this queue? */
		if (current_is_pdflush() && !writeback_acquire(bdi))
			break;

isn't working.

> Another issue was starvation with request allocation. Given
> that pdflush does non-blocking writes (it has to, by design), pdflush
> can potentially be starved if someone else is working the device.

hm, true.  100% starved, or just "slowed down"?  The latter I trust -
otherwise there are still failure modes?

> > A long time ago the XFS guys (Dave Chinner iirc) said that XFS needs
> > more than one thread per device to keep the device saturated.  Did that
> > get addressed?
> 
> It supports up to 32-threads per device, but Chinner et all have been
> silent. So the support is there and there's a
> super_operations->inode_get_wb() to map a dirty inode to a writeback
> device. Nobody is doing that yet though.

OK.

How many kernel threads do the 1000-spindle people end up with?
