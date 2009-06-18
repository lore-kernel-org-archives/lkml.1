Return-Path: <linux-kernel-owner+w=401wt.eu-S1764624AbZFRMxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764624AbZFRMxe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 08:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764019AbZFRMvy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 08:51:54 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:33182 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763967AbZFRMvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 08:51:51 -0400
X-Greylist: delayed 331 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Jun 2009 08:51:51 EDT
From: Louis Rilling <louis.rilling@kerlabs.com>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Renaud Lottiaux <renaud.lottiaux@kerlabs.com>,
       Louis Rilling <louis.rilling@kerlabs.com>
Subject: [PATCH] [BUGFIX] bsdacct: Fix access to invalid filp in acct_on()
Date: Thu, 18 Jun 2009 14:46:19 +0200
Message-Id: <1245329179-24604-1-git-send-email-louis.rilling@kerlabs.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Renaud Lottiaux <renaud.lottiaux@kerlabs.com>

The file opened in acct_on and freshly stored in the ns->bacct struct can
be closed in acct_file_reopen by a concurrent call after we release
acct_lock and before we call mntput(file->f_path.mnt).

Record file->f_path.mnt in a local variable and use this variable only.

Signed-off-by: Renaud Lottiaux <renaud.lottiaux@kerlabs.com>
Signed-off-by: Louis Rilling <louis.rilling@kerlabs.com>
---
 kernel/acct.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/acct.c b/kernel/acct.c
index 7afa315..9f33910 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -215,6 +215,7 @@ static void acct_file_reopen(struct bsd_acct_struct *acct, struct file *file,
 static int acct_on(char *name)
 {
 	struct file *file;
+	struct vfsmount *mnt;
 	int error;
 	struct pid_namespace *ns;
 	struct bsd_acct_struct *acct = NULL;
@@ -256,11 +257,12 @@ static int acct_on(char *name)
 		acct = NULL;
 	}
 
-	mnt_pin(file->f_path.mnt);
+	mnt = file->f_path.mnt;
+	mnt_pin(mnt);
 	acct_file_reopen(ns->bacct, file, ns);
 	spin_unlock(&acct_lock);
 
-	mntput(file->f_path.mnt); /* it's pinned, now give up active reference */
+	mntput(mnt); /* it's pinned, now give up active reference */
 	kfree(acct);
 
 	return 0;
-- 
1.5.6.5

