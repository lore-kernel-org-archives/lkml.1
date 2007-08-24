Return-Path: <linux-kernel-owner+w=401wt.eu-S1764328AbXHXNZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764328AbXHXNZU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 09:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753015AbXHXNZF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 09:25:05 -0400
Received: from smtp.ustc.edu.cn ([202.38.64.16]:43104 "HELO ustc.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1753373AbXHXNZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 09:25:02 -0400
Message-ID: <387961898.15210@ustc.edu.cn>
X-EYOUMAIL-SMTPAUTH: wfg@mail.ustc.edu.cn
Date: Fri, 24 Aug 2007 21:24:58 +0800
From: Fengguang Wu <wfg@mail.ustc.edu.cn>
To: Chris Mason <chris.mason@oracle.com>
Cc: Andrew Morton <akpm@osdl.org>, Ken Chen <kenchen@google.com>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/6] writeback time order/delay fixes take 3
Message-ID: <20070824132458.GC7933@mail.ustc.edu.cn>
References: <386910467.21100@ustc.edu.cn> <20070821202314.335e86ec@think.oraclecorp.com> <387745522.02814@ustc.edu.cn> <20070822084201.2c4eceb6@think.oraclecorp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070822084201.2c4eceb6@think.oraclecorp.com>
X-GPG-Fingerprint: 53D2 DDCE AB5C 8DC6 188B  1CB1 F766 DA34 8D8B 1C6D
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2007 at 08:42:01AM -0400, Chris Mason wrote:
> > My vague idea is to
> > - keep the s_io/s_more_io as a FIFO/cyclic writeback dispatching
> > queue.
> > - convert s_dirty to some radix-tree/rbtree based data structure.
> >   It would have dual functions: delayed-writeback and
> > clustered-writeback. 
> > clustered-writeback:
> > - Use inode number as clue of locality, hence the key for the sorted
> >   tree.
> > - Drain some more s_dirty inodes into s_io on every kupdate wakeup,
> >   but do it in the ascending order of inode number instead of
> >   ->dirtied_when. 
> > 
> > delayed-writeback:
> > - Make sure that a full scan of the s_dirty tree takes <=30s, i.e.
> >   dirty_expire_interval.
> 
> I think we should assume a full scan of s_dirty is impossible in the
> presence of concurrent writers.  We want to be able to pick a start
> time (right now) and find all the inodes older than that start time.
> New things will come in while we're scanning.  But perhaps that's what
> you're saying...

Yeah, I was thinking about elevators :)
Or call it sweeping based on address-hint(inode number).

> At any rate, we've got two types of lists now.  One keeps track of age
> and the other two keep track of what is currently being written.  I
> would try two things:
> 
> 1) s_dirty stays a list for FIFO.  s_io becomes a radix tree that
> indexes by inode number (or some arbitrary field the FS can set in the
> inode).  Radix tree tags are used to indicate which things in s_io are
> already in progress or are pending (hand waving because I'm not sure
> exactly).
> 
> inodes are pulled off s_dirty and the corresponding slot in s_io is
> tagged to indicate IO has started.  Any nearby inodes in s_io are also
> sent down.
> 
> 2) s_dirty and s_io both become radix trees.  s_dirty is indexed by a
> sequence number that corresponds to age.  It is treated as a big
> circular indexed list that can wrap around over time.  Radix tree tags
> are used both on s_dirty and s_io to flag which inodes are in progress.

It's meaningless to convert s_io to radix tree. Because inodes on s_io
will normally be sent to block layer elevators at the same time.

Also s_dirty holds 30 seconds of inodes, while s_io only 5 seconds.
The more inodes, the more chances of good clustering. That's the
general rule.

s_dirty is the right place to do address-clustering.
As for the dirty_expire_interval parameter on dirty age,
we can apply a simple rule: do one full scan/sweep over the
fs-address-space in every 30s, syncing all inodes encountered,
and sparing those newly dirtied in less than 5s. With that rule,
any inode will get synced after being dirtied for 5-35 seconds.

-fengguang

