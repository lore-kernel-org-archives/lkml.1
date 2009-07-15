Return-Path: <linux-kernel-owner+w=401wt.eu-S1754978AbZGOOFA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754978AbZGOOFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 10:05:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754872AbZGOOE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 10:04:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:7389 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754848AbZGOOE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 10:04:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,404,1243839600"; 
   d="scan'208";a="165277105"
Date: Wed, 15 Jul 2009 22:04:47 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] shmem: call set_page_dirty() with locked page
Message-ID: <20090715140447.GA15177@localhost>
References: <20090714092926.GA23969@localhost> <Pine.LNX.4.64.0907141918380.10805@sister.anvils> <20090715111012.GA1403@localhost> <Pine.LNX.4.64.0907151405020.23573@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0907151405020.23573@sister.anvils>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 15, 2009 at 09:18:44PM +0800, Hugh Dickins wrote:
> On Wed, 15 Jul 2009, Wu Fengguang wrote:
> > On Wed, Jul 15, 2009 at 02:24:54AM +0800, Hugh Dickins wrote:
> > > On Tue, 14 Jul 2009, Wu Fengguang wrote:
> > > > Here set_page_dirty() can be moved into the page lock.
> > > 
> > > Indeed it can, but you've forgotten to mention why you think
> > > that would be a good thing?  All I can see is that it would
> > 
> > Sorry for missing out the rational.  My problem is: the hwpoison code
> > must make sure whether one page can be dropped without losing data.
> 
> Ah, thanks: your comments here will need to go into the patch
> description.  But shouldn't this patch be part of the hwpoison set?

OK, and we'll make it into the hwpoison patchset.

> > 
> > > very very slightly increase the page's lock hold time, which
> > > wouldn't be an improvement: what improvement are you making?
> > 
> > Yes there were nothing wrong. Just to make it align with the general
> > practice(not rule): pages are normally dirtied inside the page lock.
> 
> I don't mind making shmem follow more common practice here if it makes
> life easier for you; but until now there's been no reason to do so -
> as you say, there's no rule to call set_page_dirty with page locked.

Yep, thanks.

> I wish you would distinguish between dirtying a page and marking a
> page dirty: if it matters to you whether it's done inside the page
> lock or not, then it matter which one you are talking about.  This
> page was dirtied while the page lock was held, but it's being marked
> dirty just after dropping the page lock.

Right, good concepts!

> What about shmem_symlink: shouldn't this patch be moving the
> unlock_page down there too?

Sure, thanks for the reminding!

Thanks,
Fengguang
---
shmem: call set_page_dirty() with locked page

The dirtying of page and set_page_dirty() can be moved into the page lock.

- In shmem_write_end(), the page was dirtied while the page lock was held,
  but it's being marked dirty just after dropping the page lock.
- In shmem_symlink(), both dirtying and marking can be moved into page lock.

It's valuable for the hwpoison code to know whether one bad page can be dropped
without losing data. It mainly judges by testing the PG_dirty bit after taking
the page lock. So it becomes important that the dirtying of page and the
marking of dirtiness are both done inside the page lock. Which is a common
practice, but sadly not a rule.

The noticeable exceptions are
- mapped pages
- pages with buffer_heads
The above pages could go dirty at any time. Fortunately the hwpoison will
unmap the page and release the buffer_heads beforehand anyway.

Many other types of pages (eg. metadata pages) can also be dirtied at will by
their owners, the hwpoison code cannot do meaningful things to them anyway. 
Only the dirtiness of pagecache pages owned by regular files are interested.

CC: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/shmem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux.orig/mm/shmem.c
+++ linux/mm/shmem.c
@@ -1630,8 +1630,8 @@ shmem_write_end(struct file *file, struc
 	if (pos + copied > inode->i_size)
 		i_size_write(inode, pos + copied);
 
-	unlock_page(page);
 	set_page_dirty(page);
+	unlock_page(page);
 	page_cache_release(page);
 
 	return copied;
@@ -1968,13 +1968,13 @@ static int shmem_symlink(struct inode *d
 			iput(inode);
 			return error;
 		}
-		unlock_page(page);
 		inode->i_mapping->a_ops = &shmem_aops;
 		inode->i_op = &shmem_symlink_inode_operations;
 		kaddr = kmap_atomic(page, KM_USER0);
 		memcpy(kaddr, symname, len);
 		kunmap_atomic(kaddr, KM_USER0);
 		set_page_dirty(page);
+		unlock_page(page);
 		page_cache_release(page);
 	}
 	if (dir->i_mode & S_ISGID)
