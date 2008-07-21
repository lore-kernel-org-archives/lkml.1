Return-Path: <linux-kernel-owner+w=401wt.eu-S1758756AbYGUKIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756AbYGUKIb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 06:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756813AbYGUKIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 06:08:23 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52802 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756408AbYGUKIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 06:08:22 -0400
Message-ID: <48845FAC.9070500@cn.fujitsu.com>
Date: Mon, 21 Jul 2008 18:06:36 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Cyrill Gorcunov <gorcunov@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] vfs: use kstrdup() and check failing allocation
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- use kstrdup() instead of kmalloc() + memcpy()
- return NULL if allocating ->mnt_devname failed
- mnt_devname should be const

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---

  Andrew, please drop vfs-use-kstrdup.patch

---

 fs/namespace.c        |   24 +++++++++++++-----------
 include/linux/mount.h |    2 +-
 2 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 4f6f763..e52e11f 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -112,9 +112,13 @@ struct vfsmount *alloc_vfsmnt(const char *name)
 		int err;
 
 		err = mnt_alloc_id(mnt);
-		if (err) {
-			kmem_cache_free(mnt_cache, mnt);
-			return NULL;
+		if (err)
+			goto out_free_cache;
+
+		if (name) {
+			mnt->mnt_devname = kstrdup(name, GFP_KERNEL);
+			if (!mnt->mnt_devname)
+				goto out_free_id;
 		}
 
 		atomic_set(&mnt->mnt_count, 1);
@@ -127,16 +131,14 @@ struct vfsmount *alloc_vfsmnt(const char *name)
 		INIT_LIST_HEAD(&mnt->mnt_slave_list);
 		INIT_LIST_HEAD(&mnt->mnt_slave);
 		atomic_set(&mnt->__mnt_writers, 0);
-		if (name) {
-			int size = strlen(name) + 1;
-			char *newname = kmalloc(size, GFP_KERNEL);
-			if (newname) {
-				memcpy(newname, name, size);
-				mnt->mnt_devname = newname;
-			}
-		}
 	}
 	return mnt;
+
+out_free_id:
+	mnt_free_id(mnt);
+out_free_cache:
+	kmem_cache_free(mnt_cache, mnt);
+	return NULL;
 }
 
 /*
diff --git a/include/linux/mount.h b/include/linux/mount.h
index 4374d1a..b5efaa2 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -47,7 +47,7 @@ struct vfsmount {
 	struct list_head mnt_child;	/* and going through their mnt_child */
 	int mnt_flags;
 	/* 4 bytes hole on 64bits arches */
-	char *mnt_devname;		/* Name of device e.g. /dev/dsk/hda1 */
+	const char *mnt_devname;	/* Name of device e.g. /dev/dsk/hda1 */
 	struct list_head mnt_list;
 	struct list_head mnt_expire;	/* link in fs-specific expiry list */
 	struct list_head mnt_share;	/* circular list of shared mounts */
-- 
1.5.4.rc3

