Return-Path: <linux-kernel-owner+w=401wt.eu-S1758013AbZA1Xbl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758013AbZA1Xbl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 18:31:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756945AbZA1X2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 18:28:17 -0500
Received: from kroah.org ([198.145.64.141]:56993 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756922AbZA1X2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 18:28:16 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Oleg Nesterov <oleg@redhat.com>,
       =?utf-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       Brian Swetland <swetland@google.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 07/10] Staging: android: task_get_unused_fd_flags: fix the wrong usage of tsk->signal
Date: Wed, 28 Jan 2009 15:26:47 -0800
Message-Id: <1233185210-23098-7-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.1
In-Reply-To: <20090128232319.GA23009@kroah.com>
References: <20090128232319.GA23009@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

Compile tested.

task_struct->signal is not protected by RCU, the code is bogus.
Change the code to take ->siglock to pin ->signal.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Cc: Arve Hjønnevåg <arve@android.com>
Cc: Brian Swetland <swetland@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/staging/android/binder.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/android/binder.c b/drivers/staging/android/binder.c
index ab014bc..758131c 100644
--- a/drivers/staging/android/binder.c
+++ b/drivers/staging/android/binder.c
@@ -319,6 +319,7 @@ int task_get_unused_fd_flags(struct task_struct *tsk, int flags)
 	int fd, error;
 	struct fdtable *fdt;
 	unsigned long rlim_cur;
+	unsigned long irqs;
 
 	if (files == NULL)
 		return -ESRCH;
@@ -335,12 +336,11 @@ repeat:
 	 * N.B. For clone tasks sharing a files structure, this test
 	 * will limit the total number of files that can be opened.
 	 */
-	rcu_read_lock();
-	if (tsk->signal)
+	rlim_cur = 0;
+	if (lock_task_sighand(tsk, &irqs)) {
 		rlim_cur = tsk->signal->rlim[RLIMIT_NOFILE].rlim_cur;
-	else
-		rlim_cur = 0;
-	rcu_read_unlock();
+		unlock_task_sighand(tsk, &irqs);
+	}
 	if (fd >= rlim_cur)
 		goto out;
 
-- 
1.6.0.2

