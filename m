Return-Path: <linux-kernel-owner+w=401wt.eu-S1755907AbXI3Ilh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbXI3Ilh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2007 04:41:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754396AbXI3Il3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Sep 2007 04:41:29 -0400
Received: from smtp.nokia.com ([131.228.20.170]:56189 "EHLO
	mgw-ext11.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461AbXI3Il2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2007 04:41:28 -0400
Message-ID: <46FF6107.8010901@yandex.ru>
Date: Sun, 30 Sep 2007 11:40:39 +0300
From: Artem Bityutskiy <dedekind@yandex.ru>
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Write-back from inside FS - need suggestions
References: <46FCC686.3050009@yandex.ru>        <46FE2167.8000800@yandex.ru>        <20070929033939.6ee65e19.akpm@linux-foundation.org>        <46FEA332.9090904@yandex.ru> <20070929130011.c3a11139.akpm@linux-foundation.org>
In-Reply-To: <20070929130011.c3a11139.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 30 Sep 2007 08:40:40.0393 (UTC) FILETIME=[94C5AB90:01C8033D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, thank you for this help.

Andrew Morton wrote:
> writepage under i_mutex is commonly done on the
> sys_write->alloc_pages->direct-reclaim path.  It absolutely has to work,
> and you'll be fine relying upon that.
> 
> However ->prepare_write() is called with the page locked, so you are
> vulnerable to deadlocks there.  I suspect you got lucky because the page
> which you're holding the lock on is not dirty in your testing.  But in
> other applications (eg: 1k blocksize ext2/3/4) the page _can_ be dirty
> while we're trying to allocate more blocks for it, in which case the
> lock_page() deadlock can happen.
> 
> One approach might be to add another flag to writeback_control telling
> write_cache_pages() to skip locked pages.  Or even put a page* into
> wrietback_control and change it to skip *this* page.

Well, in my case I force write-back from prepare_write _only_ when the page
is clean, because if it is dirty, it was (pessimistically) accounted earlier
already and changing dirty page does not change anything on the media. So
I call writeback only for _new_ pages, which are always clean.

I use PagePrivate() flag to flag pages as dirty, and unflag them in
writepage(). I need to keep my own accounting of number of dirty pages at
any point of time. I found that I cannot use PageDirty() flag because
it is cleaned before my ->writepage is called, so I cannot decrement my
dirty_pg_counter, and I'd have to muck with radix tree's tags which I do
not really like to do, thus I just use the private flag.

So in writepage() i only call writeback if PagePrivate() is unset, which
guarantees me that the page is clean, I presume.

So for my purposes the patch below _looks_ ok. I'm saying "looks" because I
tested it just a little.

>> This means that if I'm in the middle of an operation or ino #X, I own
>> its i_mutex, but not I_LOCK, I can be preempted and ->writepage can
>> be called for a dirty page belonging to this inode #X?
> 
> yup.  Or another CPU can do the same.

Ok, thank you! I (naively) thought i_mutex is locked in ->writepage. But now
I see that pdflush does not lock it, readahead calls ->readpage without
i_mutex too. They just lock the page.

>> Could you or someone please give me a hint what exactly
>> inode->i_flags & I_LOCK protects?
> 
> err, it's basically an open-coded mutex via which one thread can get
> exclusive access to some parts of an inode's internals.  Perhaps it could
> literally be replaced with a mutex.  Exactly what I_LOCK protects has not
> been documented afaik.  That would need to be reverse engineered :(

I see, thanks. There is also i_size and i_size_write() and i_size_read().
My understanding is that i_size may be changed without something (i_mutex
or I_LOCK) locked, thus these helpers. i_size is read/written without them
in many places, though, so the relation of these i_size protection helpers
to i_mutex/I_LOCK is unclean for me.

Ideally, it would be nice to teach lockdep to monitor I_LOCK vs i_mutex.

Below it the patch which seems to give me what I need. Just for reference.

=========================
Subject: [PATCH] VFS: introduce writeback_inodes_sb()

Let file systems to writeback their pages and inodes when needed.

Note, it cannot be called if one of the dirty pages is locked by
the caller, otherwise it'll deadlock.

Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
---
 fs/fs-writeback.c         |    8 ++++++++
 include/linux/writeback.h |    1 +
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index a4b142a..17c8aaa 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -486,6 +486,14 @@ void sync_inodes_sb(struct super_block *sb, int wait)
        spin_unlock(&inode_lock);
 }

+void writeback_inodes_sb(struct super_block *sb, struct writeback_control *wbc)
+{
+       spin_lock(&inode_lock);
+       sync_sb_inodes(sb, wbc);
+       spin_unlock(&inode_lock);
+}
+EXPORT_SYMBOL_GPL(writeback_inodes_sb);
+
 /*
  * Rather lame livelock avoidance.
  */
diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index 4ef4d22..e20cd12 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -72,6 +72,7 @@ void writeback_inodes(struct writeback_control *wbc);
 void wake_up_inode(struct inode *inode);
 int inode_wait(void *);
 void sync_inodes_sb(struct super_block *, int wait);
+void writeback_inodes_sb(struct super_block *sb, struct writeback_control *wbc);
 void sync_inodes(int wait);

 /* writeback.h requires fs.h; it, too, is not included from here. */
--
1.5.0.6

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
