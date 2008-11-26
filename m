Return-Path: <linux-kernel-owner+w=401wt.eu-S1755098AbYKZR6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098AbYKZR6d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 12:58:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753280AbYKZR6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 12:58:14 -0500
Received: from styx.suse.cz ([82.119.242.94]:45261 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753202AbYKZR6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 12:58:12 -0500
Date: Wed, 26 Nov 2008 18:58:11 +0100
From: Jan Kara <jack@suse.cz>
To: Valdis.Kletnieks@vt.edu
Cc: mfasheh@suse.de, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.28-rc6-mmotm1126 - BUG in disk quota code
Message-ID: <20081126175811.GH23124@duck.suse.cz>
References: <4270.1227716433@turing-police.cc.vt.edu> <20081126164906.GG23124@duck.suse.cz> <3893.1227721813@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ALfTUftag+2gvp1h"
Content-Disposition: inline
In-Reply-To: <3893.1227721813@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ALfTUftag+2gvp1h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed 26-11-08 12:50:13, Valdis.Kletnieks@vt.edu wrote:
> On Wed, 26 Nov 2008 17:49:06 +0100, Jan Kara said:
> > On Wed 26-11-08 11:20:33, Valdis.Kletnieks@vt.edu wrote:
> > > System blew out when /etc/rc.sysinit did a 'quotaon -a'.  Not sure which
> > > of the many quota-related commits in linux-next.patch or in -mm did this...
> >   Thanks for report. Already hit it myself and Mark should have the fix in
> > his tree (I sent it to him yesterday) so it should propagate into -mm
> > quickly.
> 
> Good enough - I'll wait for Andrew to drop the next -mmotm, and I'll
> yell if it's still broken then...
  Hmm, I've just checked and it does not seem Mark has merged the patches
yet. I've attached the patches which fix the problem just in case you need
to boot the machine with -mm for some other purposes.

									Honza

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--ALfTUftag+2gvp1h
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0007-quota-Export-dquot_alloc-and-dquot_destroy-func.patch"

>From 47878ec675816082601ec6c6a34b174347299734 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 25 Nov 2008 15:15:22 +0100
Subject: [PATCH 07/10] quota: Export dquot_alloc() and dquot_destroy() functions

These are default functions for creating and destroying quota structures
and they should be used from filesystems.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dquot.c               |    6 ++++--
 include/linux/quotaops.h |    2 ++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/dquot.c b/fs/dquot.c
index 6f7df91..c724586 100644
--- a/fs/dquot.c
+++ b/fs/dquot.c
@@ -413,10 +413,11 @@ out_dqlock:
 	return ret;
 }
 
-static void dquot_destroy(struct dquot *dquot)
+void dquot_destroy(struct dquot *dquot)
 {
 	kmem_cache_free(dquot_cachep, dquot);
 }
+EXPORT_SYMBOL(dquot_destroy);
 
 static inline void do_destroy_dquot(struct dquot *dquot)
 {
@@ -668,10 +669,11 @@ we_slept:
 	spin_unlock(&dq_list_lock);
 }
 
-static struct dquot *dquot_alloc(struct super_block *sb, int type)
+struct dquot *dquot_alloc(struct super_block *sb, int type)
 {
 	return kmem_cache_zalloc(dquot_cachep, GFP_NOFS);
 }
+EXPORT_SYMBOL(dquot_alloc);
 
 static struct dquot *get_empty_dquot(struct super_block *sb, int type)
 {
diff --git a/include/linux/quotaops.h b/include/linux/quotaops.h
index f491394..21b781a 100644
--- a/include/linux/quotaops.h
+++ b/include/linux/quotaops.h
@@ -31,6 +31,8 @@ int dquot_is_cached(struct super_block *sb, unsigned int id, int type);
 int dquot_scan_active(struct super_block *sb,
 		      int (*fn)(struct dquot *dquot, unsigned long priv),
 		      unsigned long priv);
+struct dquot *dquot_alloc(struct super_block *sb, int type);
+void dquot_destroy(struct dquot *dquot);
 
 int dquot_alloc_space(struct inode *inode, qsize_t number, int prealloc);
 int dquot_alloc_inode(const struct inode *inode, qsize_t number);
-- 
1.6.0.4


--ALfTUftag+2gvp1h
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0008-reiserfs-Add-default-allocation-routines-for-quota.patch"

>From 0d3e1815b72c86457cb77c180ae4af703cfd0324 Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 25 Nov 2008 15:06:10 +0100
Subject: [PATCH 08/10] reiserfs: Add default allocation routines for quota structures

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/reiserfs/super.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
index a9b393a..c55651f 100644
--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -649,6 +649,8 @@ static struct dquot_operations reiserfs_quota_operations = {
 	.release_dquot = reiserfs_release_dquot,
 	.mark_dirty = reiserfs_mark_dquot_dirty,
 	.write_info = reiserfs_write_info,
+	.alloc_dquot	= dquot_alloc,
+	.destroy_dquot	= dquot_destroy,
 };
 
 static struct quotactl_ops reiserfs_qctl_operations = {
-- 
1.6.0.4


--ALfTUftag+2gvp1h
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0009-ext3-Add-default-allocation-routines-for-quota-stru.patch"

>From 6fd37ba50a6d3e349e843fe88cd866278674bc4f Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 25 Nov 2008 15:08:30 +0100
Subject: [PATCH 09/10] ext3: Add default allocation routines for quota structures

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext3/super.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/ext3/super.c b/fs/ext3/super.c
index fee8705..abed9f9 100644
--- a/fs/ext3/super.c
+++ b/fs/ext3/super.c
@@ -713,7 +713,9 @@ static struct dquot_operations ext3_quota_operations = {
 	.acquire_dquot	= ext3_acquire_dquot,
 	.release_dquot	= ext3_release_dquot,
 	.mark_dirty	= ext3_mark_dquot_dirty,
-	.write_info	= ext3_write_info
+	.write_info	= ext3_write_info,
+	.alloc_dquot	= dquot_alloc,
+	.destroy_dquot	= dquot_destroy,
 };
 
 static struct quotactl_ops ext3_qctl_operations = {
-- 
1.6.0.4


--ALfTUftag+2gvp1h
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0010-ext4-Add-default-allocation-routines-for-quota-stru.patch"

>From 9885ce56c2119e08e5dec2504cf05a88dd821b9d Mon Sep 17 00:00:00 2001
From: Jan Kara <jack@suse.cz>
Date: Tue, 25 Nov 2008 15:09:11 +0100
Subject: [PATCH 10/10] ext4: Add default allocation routines for quota structures

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/ext4/super.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 9e5a717..e6a5d74 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -803,7 +803,9 @@ static struct dquot_operations ext4_quota_operations = {
 	.acquire_dquot	= ext4_acquire_dquot,
 	.release_dquot	= ext4_release_dquot,
 	.mark_dirty	= ext4_mark_dquot_dirty,
-	.write_info	= ext4_write_info
+	.write_info	= ext4_write_info,
+	.alloc_dquot	= dquot_alloc,
+	.destroy_dquot	= dquot_destroy,
 };
 
 static struct quotactl_ops ext4_qctl_operations = {
-- 
1.6.0.4


--ALfTUftag+2gvp1h--
