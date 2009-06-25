Return-Path: <linux-kernel-owner+w=401wt.eu-S1752864AbZFYReI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbZFYReI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 13:34:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbZFYRd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 13:33:57 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:54089 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699AbZFYRd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 13:33:56 -0400
From: Louis Rilling <louis.rilling@kerlabs.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Renaud Lottiaux <renaud.lottiaux@kerlabs.com>,
       Louis Rilling <louis.rilling@kerlabs.com>
Subject: [RESEND PATCH] [BUGFIX] bsdacct: Fix access to invalid filp in acct_on()
Date: Thu, 25 Jun 2009 19:33:56 +0200
Message-Id: <1245951236-30679-1-git-send-email-louis.rilling@kerlabs.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew,

Now that the merge window is closed, could you have a look at this? I couldn't
find any official maintainer for bsdacct.

Thanks!

Louis

-----------------------------------------------------------

From: Renaud Lottiaux <renaud.lottiaux@kerlabs.com>
Subject: [BUGFIX] bsdacct: Fix access to invalid filp in acct_on()

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

