Return-Path: <linux-kernel-owner+w=401wt.eu-S1755500AbZDNUXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755500AbZDNUXW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 16:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754716AbZDNUVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 16:21:47 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:48643 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095AbZDNUVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 16:21:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=YHPESaDc9sDneK5Ni0Exrot+IHB7/y9DWIsO/EU8iFP5tY8qTvYBYuC0eOGFGsYfHj
         yfsOWt4rb3mUXi6RNuZgehgJydiSlvquugwhZ/HzNpdyoKlBMyiUexnfh93WROf7SUxR
         4ZqmTQu1dq55dHiyOxVmWYJOUPzSwz/KqivX0=
From: Andrea Righi <righi.andrea@gmail.com>
To: Paul Menage <menage@google.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, agk@sourceware.org,
       akpm@linux-foundation.org, axboe@kernel.dk, baramsori72@gmail.com,
       Carl Henrik Lunde <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
       Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, Hirokazu Takahashi <taka@valinux.co.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, matt@bluehost.com,
       dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 4/9] support checking of cgroup subsystem dependencies
Date: Tue, 14 Apr 2009 22:21:15 +0200
Message-Id: <1239740480-28125-5-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.5.6.3
In-Reply-To: <1239740480-28125-1-git-send-email-righi.andrea@gmail.com>
References: <1239740480-28125-1-git-send-email-righi.andrea@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Li Zefan <lizf@cn.fujitsu.com>

From: Li Zefan <lizf@cn.fujitsu.com>

This allows one subsystem to require to be mounted only when some other
subsystems are also present in or not in the proposed hierarchy.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 Documentation/cgroups/cgroups.txt |    5 +++++
 include/linux/cgroup.h            |    2 ++
 kernel/cgroup.c                   |   19 ++++++++++++++++++-
 3 files changed, 25 insertions(+), 1 deletions(-)

diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
index 6eb1a97..6938025 100644
--- a/Documentation/cgroups/cgroups.txt
+++ b/Documentation/cgroups/cgroups.txt
@@ -552,6 +552,11 @@ and root cgroup. Currently this will only involve movement between
 the default hierarchy (which never has sub-cgroups) and a hierarchy
 that is being created/destroyed (and hence has no sub-cgroups).
 
+int subsys_depend(struct cgroup_subsys *ss, unsigned long subsys_bits)
+Called when a cgroup subsystem wants to check if some other subsystems
+are also present in the proposed hierarchy. If this method returns error,
+the mount of the cgroup filesystem will fail.
+
 4. Questions
 ============
 
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 665fa70..37ace23 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -385,6 +385,8 @@ struct cgroup_subsys {
 			struct cgroup *cgrp);
 	void (*post_clone)(struct cgroup_subsys *ss, struct cgroup *cgrp);
 	void (*bind)(struct cgroup_subsys *ss, struct cgroup *root);
+	int (*subsys_depend)(struct cgroup_subsys *ss,
+			     unsigned long subsys_bits);
 
 	int subsys_id;
 	int active;
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 382109b..fad3f08 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -830,6 +830,23 @@ static int cgroup_show_options(struct seq_file *seq, struct vfsmount *vfs)
 	return 0;
 }
 
+static int check_subsys_dependency(unsigned long subsys_bits)
+{
+	int i;
+	int ret;
+	struct cgroup_subsys *ss;
+
+	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
+		ss = subsys[i];
+		if (test_bit(i, &subsys_bits) && ss->subsys_depend) {
+			ret = ss->subsys_depend(ss, subsys_bits);
+			if (ret)
+				return ret;
+		}
+	}
+	return 0;
+}
+
 struct cgroup_sb_opts {
 	unsigned long subsys_bits;
 	unsigned long flags;
@@ -890,7 +907,7 @@ static int parse_cgroupfs_options(char *data,
 	if (!opts->subsys_bits)
 		return -EINVAL;
 
-	return 0;
+	return check_subsys_dependency(opts->subsys_bits);
 }
 
 static int cgroup_remount(struct super_block *sb, int *flags, char *data)
-- 
1.5.6.3

