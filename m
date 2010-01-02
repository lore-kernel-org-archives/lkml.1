Return-Path: <linux-kernel-owner+w=401wt.eu-S1752476Ab0ABVhg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab0ABVhg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 16:37:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212Ab0ABVhf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 16:37:35 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:48552 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab0ABVhf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 16:37:35 -0500
To: Greg KH <greg@kroah.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Borislav Petkov <petkovbb@googlemail.com>,
       David Airlie <airlied@linux.ie>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Al Viro <viro@ZenIV.linux.org.uk>, Tejun Heo <tj@kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH] sysfs: Add lockdep annotations for the sysfs active reference
References: <alpine.LFD.2.00.0912241350510.11961@localhost.localdomain>
	<20091226094504.GA6214@liondog.tnic>
	<20091228092712.AA8C.A69D9226@jp.fujitsu.com>
	<alpine.LFD.2.00.0912301259220.11961@localhost.localdomain>
	<m11victac1.fsf@fess.ebiederm.org>
	<alpine.LFD.2.00.0912301348320.11961@localhost.localdomain>
	<m1fx6rtu31.fsf@fess.ebiederm.org>
	<alpine.LFD.2.00.0912311043330.11961@localhost.localdomain>
	<m11vi9c0td.fsf@fess.ebiederm.org> <4B3EB687.7000005@kernel.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Sat, 02 Jan 2010 13:37:12 -0800
In-Reply-To: <4B3EB687.7000005@kernel.org> (Tejun Heo's message of "Sat\, 02 Jan 2010 11\:59\:19 +0900")
Message-ID: <m11vi8yyrb.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Holding locks over device_del -> kobject_del -> sysfs_deactivate can
cause deadlocks if those same locks are grabbed in sysfs show or store
methods.

The I model s_active count + completion as a sleeping read/write lock.
I describe to lockdep sysfs_get_active as a read_trylock,
sysfs_put_active as a read_unlock, and sysfs_deactivate as a
write_lock and write_unlock pair.  This seems to capture the essence
for purposes of finding deadlocks, and in my testing gives finds real
issues and ignores non-issues.

This brings us back to holding locks over kobject_del is a problem
that ideally we should find a way of addressing, but at least lockdep
can tell us about the problems instead of requiring developers to debug
rare strange system deadlocks, that happen when sysfs files are removed
while being written to.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/sysfs/dir.c   |   14 ++++++++++++--
 fs/sysfs/sysfs.h |   15 +++++++++++++++
 2 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 5d88e30..5c4703d 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -106,8 +106,10 @@ static struct sysfs_dirent *sysfs_get_active(struct sysfs_dirent *sd)
 			return NULL;
 
 		t = atomic_cmpxchg(&sd->s_active, v, v + 1);
-		if (likely(t == v))
+		if (likely(t == v)) {
+			rwsem_acquire_read(&sd->dep_map, 0, 1, _RET_IP_);
 			return sd;
+		}
 		if (t < 0)
 			return NULL;
 
@@ -130,6 +132,7 @@ static void sysfs_put_active(struct sysfs_dirent *sd)
 	if (unlikely(!sd))
 		return;
 
+	rwsem_release(&sd->dep_map, 1, _RET_IP_);
 	v = atomic_dec_return(&sd->s_active);
 	if (likely(v != SD_DEACTIVATED_BIAS))
 		return;
@@ -194,15 +197,21 @@ static void sysfs_deactivate(struct sysfs_dirent *sd)
 	BUG_ON(sd->s_sibling || !(sd->s_flags & SYSFS_FLAG_REMOVED));
 	sd->s_sibling = (void *)&wait;
 
+	rwsem_acquire(&sd->dep_map, 0, 0, _RET_IP_);
 	/* atomic_add_return() is a mb(), put_active() will always see
 	 * the updated sd->s_sibling.
 	 */
 	v = atomic_add_return(SD_DEACTIVATED_BIAS, &sd->s_active);
 
-	if (v != SD_DEACTIVATED_BIAS)
+	if (v != SD_DEACTIVATED_BIAS) {
+		lock_contended(&sd->dep_map, _RET_IP_);
 		wait_for_completion(&wait);
+	}
 
 	sd->s_sibling = NULL;
+
+	lock_acquired(&sd->dep_map, _RET_IP_);
+	rwsem_release(&sd->dep_map, 1, _RET_IP_);
 }
 
 static int sysfs_alloc_ino(ino_t *pino)
@@ -345,6 +354,7 @@ struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
 
 	atomic_set(&sd->s_count, 1);
 	atomic_set(&sd->s_active, 0);
+	sysfs_dirent_init_lockdep(sd);
 
 	sd->s_name = name;
 	sd->s_mode = mode;
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index ca52e7b..cdd9377 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -8,6 +8,7 @@
  * This file is released under the GPLv2.
  */
 
+#include <linux/lockdep.h>
 #include <linux/fs.h>
 
 struct sysfs_open_dirent;
@@ -50,6 +51,9 @@ struct sysfs_inode_attrs {
 struct sysfs_dirent {
 	atomic_t		s_count;
 	atomic_t		s_active;
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map	dep_map;
+#endif
 	struct sysfs_dirent	*s_parent;
 	struct sysfs_dirent	*s_sibling;
 	const char		*s_name;
@@ -84,6 +88,17 @@ static inline unsigned int sysfs_type(struct sysfs_dirent *sd)
 	return sd->s_flags & SYSFS_TYPE_MASK;
 }
 
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+#define sysfs_dirent_init_lockdep(sd)				\
+do {								\
+	static struct lock_class_key __key;			\
+								\
+	lockdep_init_map(&sd->dep_map, "s_active", &__key, 0);	\
+} while(0)
+#else
+#define sysfs_dirent_init_lockdep(sd) do {} while(0)
+#endif
+
 /*
  * Context structure to be used while adding/removing nodes.
  */
-- 
1.6.5.2.143.g8cc62

