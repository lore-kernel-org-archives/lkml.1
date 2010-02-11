Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757476Ab0BKXUH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 18:20:07 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:54713 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755775Ab0BKXUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 18:20:04 -0500
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       "Tejun Heo <tj@kernel.org> Neil Brown" <neilb@suse.de>,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] sysfs: Only take active references on attributes.
References: <19314.1869.847327.15190@notabene.brown>
	<2375c9f91002091808n713275dsc9ace8f51871364e@mail.gmail.com>
	<4B7217CF.2080702@kernel.org> <m1vde57c11.fsf@fess.ebiederm.org>
	<4B728CFE.40208@kernel.org> <m1sk992bji.fsf@fess.ebiederm.org>
	<20100210230544.GA678@suse.de> <m1ocjwwob1.fsf@fess.ebiederm.org>
	<4B73671E.2050105@kernel.org> <m1bpfvxt67.fsf_-_@fess.ebiederm.org>
	<m14olnxt3s.fsf_-_@fess.ebiederm.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 11 Feb 2010 15:20:00 -0800
In-Reply-To: <m14olnxt3s.fsf_-_@fess.ebiederm.org> (Eric W. Biederman's message of "Thu\, 11 Feb 2010 15\:14\:47 -0800")
Message-ID: <m1ljezwean.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If we exclude directories and symlinks from the set of sysfs
dirents where we need active references we are left with
sysfs attributes (binary or not).

- Tweak sysfs_deactivate to only do something on attributes
- Move lockdep initialization into sysfs_file_add_mode to
  limit it to just attributes.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/sysfs/dir.c   |    5 ++++-
 fs/sysfs/file.c  |    1 +
 fs/sysfs/sysfs.h |    1 +
 3 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/fs/sysfs/dir.c b/fs/sysfs/dir.c
index 1bdc42f..481fdec 100644
--- a/fs/sysfs/dir.c
+++ b/fs/sysfs/dir.c
@@ -156,6 +156,10 @@ static void sysfs_deactivate(struct sysfs_dirent *sd)
 	int v;
 
 	BUG_ON(sd->s_sibling || !(sd->s_flags & SYSFS_FLAG_REMOVED));
+
+	if (!(sysfs_type(sd) & SYSFS_ACTIVE_REF))
+		return;
+
 	sd->s_sibling = (void *)&wait;
 
 	rwsem_acquire(&sd->dep_map, 0, 0, _RET_IP_);
@@ -315,7 +319,6 @@ struct sysfs_dirent *sysfs_new_dirent(const char *name, umode_t mode, int type)
 
 	atomic_set(&sd->s_count, 1);
 	atomic_set(&sd->s_active, 0);
-	sysfs_dirent_init_lockdep(sd);
 
 	sd->s_name = name;
 	sd->s_mode = mode;
diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
index 8d6bd65..8eaae5d 100644
--- a/fs/sysfs/file.c
+++ b/fs/sysfs/file.c
@@ -509,6 +509,7 @@ int sysfs_add_file_mode(struct sysfs_dirent *dir_sd,
 	if (!sd)
 		return -ENOMEM;
 	sd->s_attr.attr = (void *)attr;
+	sysfs_dirent_init_lockdep(sd);
 
 	sysfs_addrm_start(&acxt, dir_sd);
 	rc = sysfs_add_one(&acxt, sd);
diff --git a/fs/sysfs/sysfs.h b/fs/sysfs/sysfs.h
index bb7723c..7db6884 100644
--- a/fs/sysfs/sysfs.h
+++ b/fs/sysfs/sysfs.h
@@ -79,6 +79,7 @@ struct sysfs_dirent {
 #define SYSFS_KOBJ_BIN_ATTR		0x0004
 #define SYSFS_KOBJ_LINK			0x0008
 #define SYSFS_COPY_NAME			(SYSFS_DIR | SYSFS_KOBJ_LINK)
+#define SYSFS_ACTIVE_REF		(SYSFS_KOBJ_ATTR | SYSFS_KOBJ_BIN_ATTR)
 
 #define SYSFS_FLAG_MASK			~SYSFS_TYPE_MASK
 #define SYSFS_FLAG_REMOVED		0x0200
-- 
1.6.5.2.143.g8cc62

