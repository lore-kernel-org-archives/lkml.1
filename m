Return-Path: <linux-kernel-owner+w=401wt.eu-S1757099AbZGPCNA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757099AbZGPCNA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 22:13:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757076AbZGPCM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 22:12:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:12489 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757058AbZGPCM6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 22:12:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,408,1243839600"; 
   d="scan'208";a="165536129"
Date: Thu, 16 Jul 2009 10:12:39 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] shmem: call set_page_dirty() with locked page
Message-ID: <20090716021239.GA5944@localhost>
References: <20090714092926.GA23969@localhost> <20090714153250.GA4149@hack>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="n8g4imXOkfNTN/H1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090714153250.GA4149@hack>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--n8g4imXOkfNTN/H1
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, Jul 14, 2009 at 11:33:08PM +0800, Américo Wang wrote:
> On Tue, Jul 14, 2009 at 05:29:26PM +0800, Wu Fengguang wrote:
> >Here set_page_dirty() can be moved into the page lock.
> >
> >CC: Hugh Dickins <hugh@veritas.com>
> >Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> 
> Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>

Thank you.

Andi, please take the attached patch.

Thanks,
Fengguang

--n8g4imXOkfNTN/H1
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="shmem-dirty-inside-page-lock.patch"

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

Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Reviewed-by: WANG Cong <xiyou.wangcong@gmail.com>
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

--n8g4imXOkfNTN/H1--
