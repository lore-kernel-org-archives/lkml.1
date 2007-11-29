Return-Path: <linux-kernel-owner+w=401wt.eu-S933849AbXK2TwD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933849AbXK2TwD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 14:52:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933762AbXK2Tvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 14:51:41 -0500
Received: from smtp-out.google.com ([216.239.45.13]:41005 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933721AbXK2Tvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 14:51:39 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=N/UijVYFbfy5ipubrXwVpe8KnmHAnAhY3xjNf+R2hhRrjuRUswGb0Uut+x3FcN6PQ
	pE6DmUJ+ses5aemslme8A==
Message-ID: <532480950711291151g25e24b8mf5dc453ac654a3e1@mail.gmail.com>
Date: Thu, 29 Nov 2007 11:51:25 -0800
From: "Michael Rubin" <mrubin@google.com>
To: "Fengguang Wu" <wfg@mail.ustc.edu.cn>
Subject: Re: [patch 1/1] Writeback fix for concurrent large and small file writes
Cc: a.p.zijlstra@chello.nl, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       "Chris Mason" <chris.mason@oracle.com>
In-Reply-To: <396296481.07368@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20071128192957.511EAB8310@localhost> <396296481.07368@ustc.edu.cn>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

So Feng's one line change fixes the problem at hand. I will do some
more testing with it and then submit his patch credited with him for
2.6.24. If that's cool with Feng.

Also I will take the comment changes and re-submit my patch for 2.6.25
for general purpose improvement and see what happens.

mrubin

On Nov 28, 2007 4:34 PM, Fengguang Wu <wfg@mail.ustc.edu.cn> wrote:
> On Wed, Nov 28, 2007 at 11:29:57AM -0800, Michael Rubin wrote:
> > >From mrubin@matchstick.corp.google.com Wed Nov 28 11:10:06 2007
> > Message-Id: <20071128190121.716364000@matchstick.corp.google.com>
> > Date: Wed, 28 Nov 2007 11:01:21 -0800
> > From: mrubin@google.com
> > To: mrubin@google.com
> > Subject: [patch 1/1] Writeback fix for concurrent large and small file writes.
> >
> > From: Michael Rubin <mrubin@google.com>
> >
> > Fixing a bug where writing to large files while concurrently writing to
> > smaller ones creates a situation where writeback cannot keep up with the
>
> Could you demonstrate the situation? Or if I guess it right, could it
> be fixed by the following patch? (not a nack: If so, your patch could
> also be considered as a general purpose improvement, instead of a bug
> fix.)
>
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 0fca820..62e62e2 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -301,7 +301,7 @@ __sync_single_inode(struct inode *inode, struct writeback_control *wbc)
>                          * Someone redirtied the inode while were writing back
>                          * the pages.
>                          */
> -                       redirty_tail(inode);
> +                       requeue_io(inode);
>                 } else if (atomic_read(&inode->i_count)) {
>                         /*
>                          * The inode is clean, inuse
>
> Thank you,
> Fengguang
>
>
> > traffic and memory baloons until the we hit the threshold watermark. This
> > can result in surprising latency spikes when syncing. This latency
> > can take minutes on large memory systems. Upon request I can provide
> > a test to reproduce this situation. The flush tree fixes this issue and
> > fixes several other minor issues with fairness also.
> >
> > 1) Adding a data structure to guarantee fairness when writing inodes
> > to disk.  The flush_tree is based on an rbtree. The only difference is
> > how duplicate keys are chained off the same rb_node.
> >
> > 2) Added a FS flag to mark file systems that are not disk backed so we
> > don't have to flush them. Not sure I marked all of them. But just marking
> > these improves writeback performance.
> >
> > 3) Added an inode flag to allow inodes to be marked so that they are
> > never written back to disk. See get_pipe_inode.
> >
> > Under autotest this patch has passed: fsx, bonnie, and iozone. I am
> > currently writing more writeback focused tests (which so far have been
> > passed) to add into autotest.
> >
> > Signed-off-by: Michael Rubin <mrubin@google.com>
> > ---
>
>
