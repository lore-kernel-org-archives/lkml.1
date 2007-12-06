Return-Path: <linux-kernel-owner+w=401wt.eu-S1754403AbXLFKYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403AbXLFKYz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 05:24:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbXLFKYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 05:24:41 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:34293 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753922AbXLFKYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 05:24:40 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andrew Morton <akpm@linux-foundation.org>
Cc: marcus@better.se, containers@lists.osdl.org, devel@openvz.org,
       linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>
Subject: [PATCH] proc: Do not invalidate dentries with submounts
References: <20071205143518.GA24886@iris.sw.ru>
Date: Thu, 06 Dec 2007 03:22:50 -0700
In-Reply-To: <20071205143518.GA24886@iris.sw.ru> (Denis V. Lunev's message of
	"Wed, 5 Dec 2007 17:35:18 +0300")
Message-ID: <m1bq94t951.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


If the dcache path to a mount point is ever broken it becomes
impossible to unmount it, and we leak a vfsmount.  Therefore it is not
valid to invalidate dentries with mount points at or below them.

This patch uses the have_submounts test as the other network
filesystem revalidate routines do.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/base.c    |    9 +++++++++
 fs/proc/generic.c |    5 +++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 0e71707..552d752 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1216,6 +1216,9 @@ static int pid_revalidate(struct dentry *dentry, struct nameidata *nd)
 		put_task_struct(task);
 		return 1;
 	}
+	/* Force validity if something is mounted under us */
+	if (inode && S_ISDIR(inode->i_mode) && have_submounts(dentry))
+		return 1;
 	d_drop(dentry);
 	return 0;
 }
@@ -1393,6 +1396,9 @@ static int tid_fd_revalidate(struct dentry *dentry, struct nameidata *nd)
 		}
 		put_task_struct(task);
 	}
+	/* Force validity if something is mounted under us */
+	if (inode && S_ISDIR(inode->i_mode) && have_submounts(dentry))
+		return 1;
 	d_drop(dentry);
 	return 0;
 }
@@ -2056,6 +2062,9 @@ static int proc_base_revalidate(struct dentry *dentry, struct nameidata *nd)
 		put_task_struct(task);
 		return 1;
 	}
+	/* Force validity if something is mounted under us */
+	if (inode && S_ISDIR(inode->i_mode) && have_submounts(dentry))
+		return 1;
 	d_drop(dentry);
 	return 0;
 }
diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 4abd568..233dcdc 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -370,6 +370,11 @@ static int proc_delete_dentry(struct dentry * dentry)
 
 static int proc_revalidate_dentry(struct dentry *dentry, struct nameidata *nd)
 {
+	struct inode *inode = dentry->d_inode;
+
+	/* Force validity if something is mounted under us */
+	if (inode && S_ISDIR(inode->i_mode) && have_submounts(dentry))
+		return 1;
 	d_drop(dentry);
 	return 0;
 }
-- 
1.5.3.rc6.17.g1911

