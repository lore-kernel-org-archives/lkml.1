Return-Path: <linux-kernel-owner+w=401wt.eu-S1752469AbZIXOJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752469AbZIXOJ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Sep 2009 10:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752354AbZIXOJ3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Sep 2009 10:09:29 -0400
Received: from mga14.intel.com ([143.182.124.37]:39778 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700AbZIXOJ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Sep 2009 10:09:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,445,1249282800"; 
   d="scan'208";a="191218028"
Date: Thu, 24 Sep 2009 22:09:19 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, "Li, Shaohua" <shaohua.li@intel.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Mason <chris.mason@oracle.com>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Jan Kara <jack@suse.cz>
Subject: Re: [RFC] page-writeback: move indoes from one superblock together
Message-ID: <20090924140919.GA3103@localhost>
References: <1253775260.10618.10.camel@sli10-desk.sh.intel.com> <20090924100136.GA25778@localhost> <20090924123519.GF23126@kernel.dk> <20090924132252.GA696@localhost> <20090924132949.GH23126@kernel.dk> <20090924134625.GA2507@localhost> <20090924155217.5ad0de4b@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090924155217.5ad0de4b@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 24, 2009 at 09:52:17PM +0800, Arjan van de Ven wrote:
> On Thu, 24 Sep 2009 21:46:25 +0800
> Wu Fengguang <fengguang.wu@intel.com> wrote:
> > 
> > Note that dirty_time may not be unique, so need some workaround.  And
> > the resulted rbtree implementation may not be more efficient than
> > several list traversals even for a very large list (as long as
> > superblocks numbers are low).
> > 
> > The good side is, once sb+dirty_time rbtree is implemented, it should
> > be trivial to switch the key to sb+inode_number (also may not be
> > unique), and to do location ordered writeback ;)
> 
> would you want to sort by dirty time, or by inode number?
> (assuming inode number is loosely related to location on disk)

Sort by inode number; dirty time will also be considered when judging
whether the traversed inode is old enough(*) to be eligible for writeback.

(*) this "old enough" criterion has to be much more relaxed, from the
original >30s to >5s. The promise to user would change from

        "dirtied inodes will be started writeback _around_ 30s"

to

        "dirtied inodes will be started writeback _within_ 30s"



The more detailed algorithm would be:

- put inodes to rbtree with key sb+inode_number
- in each per-5s writeback, traverse a range of 1/5 rbtree
- in each traverse, sync inodes that is dirtied more than 5s ago

So the user visible result would be
- on every 5s, roughly a 1/5 disk area will be visited
- for each dirtied inode, it will be synced after 5-30s


Thanks,
Fengguang
