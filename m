Return-Path: <linux-kernel-owner+w=401wt.eu-S1753013AbZIXMfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013AbZIXMfV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 08:35:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbZIXMfS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 08:35:18 -0400
Received: from brick.kernel.dk ([93.163.65.50]:45188 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486AbZIXMfQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 08:35:16 -0400
Date: Thu, 24 Sep 2009 14:35:19 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: "Li, Shaohua" <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Mason <chris.mason@oracle.com>, linux-fsdevel@vger.kernel.org,
       Jan Kara <jack@suse.cz>
Subject: Re: [RFC] page-writeback: move indoes from one superblock together
Message-ID: <20090924123519.GF23126@kernel.dk>
References: <1253775260.10618.10.camel@sli10-desk.sh.intel.com> <20090924100136.GA25778@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090924100136.GA25778@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24 2009, Wu Fengguang wrote:
> On Thu, Sep 24, 2009 at 02:54:20PM +0800, Li, Shaohua wrote:
> > __mark_inode_dirty adds inode to wb dirty list in random order. If a disk has
> > several partitions, writeback might keep spindle moving between partitions.
> > To reduce the move, better write big chunk of one partition and then move to
> > another. Inodes from one fs usually are in one partion, so idealy move indoes
> > from one fs together should reduce spindle move. This patch tries to address
> > this. Before per-bdi writeback is added, the behavior is write indoes
> > from one fs first and then another, so the patch restores previous behavior.
> > The loop in the patch is a bit ugly, should we add a dirty list for each
> > superblock in bdi_writeback?
> > 
> > Test in a two partition disk with attached fio script shows about 3% ~ 6%
> > improvement.
> 
> A side note: given the noticeable performance gain, I wonder if it
> deserves to generalize the idea to do whole disk location ordered
> writeback. That should benefit many small file workloads more than
> 10%. Because this patch only sorted 2 partitions and inodes in 5s
> time window, while the below patch will roughly divide the disk into
> 5 areas and sort inodes in a larger 25s time window.
> 
>         http://lkml.org/lkml/2007/8/27/45
> 
> Judging from this old patch, the complexity cost would be about 250
> lines of code (need a rbtree).

First of all, nice patch, I'll add it to the current tree. I too was
pondering using an rbtree for sb+dirty_time insertion and extraction.
But for 100 inodes or less, I bet that just doing the re-sort in
writeback time ends up being cheaper on the CPU cycle side.

-- 
Jens Axboe

