Return-Path: <linux-kernel-owner+w=401wt.eu-S1760256AbZJIDva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760256AbZJIDva (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 23:51:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760226AbZJIDv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 23:51:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38216 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759079AbZJIDv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 23:51:28 -0400
Date: Fri, 9 Oct 2009 05:50:50 +0200
From: Nick Piggin <npiggin@suse.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-fsdevel@vger.kernel.org,
       Ravikiran G Thirumalai <kiran@scalex86.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [rfc][patch] store-free path walking
Message-ID: <20091009035050.GC4287@wotan.suse.de>
References: <20091006064919.GB30316@wotan.suse.de> <20091006101414.GM5216@kernel.dk> <20091006122623.GE30316@wotan.suse.de> <20091006124941.GS5216@kernel.dk> <20091007085849.GN30316@wotan.suse.de> <alpine.LFD.2.01.0910070742260.3432@localhost.localdomain> <20091008123622.GA30316@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091008123622.GA30316@wotan.suse.de>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 08, 2009 at 02:36:22PM +0200, Nick Piggin wrote:
> vfs
> 
> amples: 273522
> #
> # Overhead         Command                     Shared Object
> # ........  ..............  ................................
> #
>     48.24%             git  [kernel]
>                 |
>                 |--32.37%-- __d_lookup_rcu
>                 |--14.14%-- link_path_walk_rcu
>                 |--7.57%-- _read_unlock
>                 |          |
>                 |          |--96.46%-- path_init_rcu
>                 |          |          do_path_lookup
>                 |          |          user_path_at
>                 |          |          vfs_fstatat
>                 |          |          vfs_lstat
>                 |          |          sys_newlstat
>                 |          |          system_call_fastpath
>                 |          |
>                 |           --3.54%-- do_path_lookup
>                 |                     user_path_at
>                 |                     vfs_fstatat
>                 |                     vfs_lstat
>                 |                     sys_newlstat
>                 |                     system_call_fastpath

> This one is interesting. spin_lock/spin_unlock remains very low, however
> read_unlock pops up. This would be... fs->lock. You're using threads
> then (rather than processes)?

OK, I got rid of this guy from the RCU walk. Basically now hold
vfsmount_lock over the entire RCU path walk (which also pins the mnt)
and use a seqlock in the fs struct to get a consistent mnt,dentry
pair. This also simplifies the walk because we don't need the
complexity to avoid mntget/mntput (just do one final mntget on the
resulting mnt before dropping vfsmount_lock).

vfsmount_lock adds one per-cpu atomic for the spinlock, and we
remove two thread-shared atomics for fs->lock so a net win for
both single threaded performance and thread-shared scalability.
Latency is no problem because we hold rcu_read_lock for the same
length of time anyway.

The parallel git diff workload is improved by serveral percent.

Phew. I think I'll stop about here and try to start getting some of
this crap cleaned up and start trying to get the rest of the
filesystems done.

