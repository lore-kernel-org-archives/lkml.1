Return-Path: <linux-kernel-owner+w=401wt.eu-S1756981AbZKRJ3l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981AbZKRJ3l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 04:29:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756866AbZKRJ3k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 04:29:40 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39395 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756747AbZKRJZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 04:25:06 -0500
From: Jan Blunck <jblunck@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, jkacur@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>,
       Christoph Hellwig <hch@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
       matthew@wil.cx, Jan Blunck <jblunck@suse.de>,
       Steve French <smfrench@gmail.com>, Steve French <sfrench@samba.org>
Subject: [PATCH 07/20] BKL: Remove BKL from CifsFS
Date: Wed, 18 Nov 2009 10:24:40 +0100
Message-Id: <1258536293-7762-8-git-send-email-jblunck@suse.de>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1258536293-7762-1-git-send-email-jblunck@suse.de>
References: <1258536293-7762-1-git-send-email-jblunck@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The BKL is only used in put_super and fill_super that are both protected by
the superblocks s_umount rw_semaphore. Therefore it is safe to remove the
BKL entirely.

Signed-off-by: Jan Blunck <jblunck@suse.de>
Cc: Steve French <smfrench@gmail.com>
---
 fs/cifs/cifsfs.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 09ccb9d..137d1e8 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -35,7 +35,6 @@
 #include <linux/delay.h>
 #include <linux/kthread.h>
 #include <linux/freezer.h>
-#include <linux/smp_lock.h>
 #include "cifsfs.h"
 #include "cifspdu.h"
 #define DECLARE_GLOBALS_HERE
@@ -201,8 +200,6 @@ cifs_put_super(struct super_block *sb)
 		return;
 	}
 
-	lock_kernel();
-
 	rc = cifs_umount(sb, cifs_sb);
 	if (rc)
 		cERROR(1, ("cifs_umount failed with return code %d", rc));
@@ -215,8 +212,6 @@ cifs_put_super(struct super_block *sb)
 
 	unload_nls(cifs_sb->local_nls);
 	kfree(cifs_sb);
-
-	unlock_kernel();
 }
 
 static int
@@ -598,28 +593,22 @@ cifs_get_sb(struct file_system_type *fs_type,
 	int rc;
 	struct super_block *sb;
 
-	lock_kernel();
-
 	sb = sget(fs_type, NULL, set_anon_super, NULL);
 
 	cFYI(1, ("Devname: %s flags: %d ", dev_name, flags));
 
-	if (IS_ERR(sb)) {
-		unlock_kernel();
+	if (IS_ERR(sb))
 		return PTR_ERR(sb);
-	}
 
 	sb->s_flags = flags;
 
 	rc = cifs_read_super(sb, data, dev_name, flags & MS_SILENT ? 1 : 0);
 	if (rc) {
 		deactivate_locked_super(sb);
-		unlock_kernel();
 		return rc;
 	}
 	sb->s_flags |= MS_ACTIVE;
 	simple_set_mnt(mnt, sb);
-	unlock_kernel();
 	return 0;
 }
 
-- 
1.6.4.2

