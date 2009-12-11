Return-Path: <linux-kernel-owner+w=401wt.eu-S934611AbZLKXaQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934611AbZLKXaQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:30:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934507AbZLKX36
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:29:58 -0500
Received: from kroah.org ([198.145.64.141]:50549 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934441AbZLKX3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:29:39 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Alan Cox <alan@linux.intel.com>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 57/58] tty: Move the leader test in disassociate
Date: Fri, 11 Dec 2009 15:28:41 -0800
Message-Id: <1260574122-10676-57-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <20091211232805.GA10652@kroah.com>
References: <20091211232805.GA10652@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

There are two call points, both want to check that tty->signal->leader is
set. Move the test into disassociate_ctty() as that will make locking
changes easier in a bit

Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/char/tty_io.c |    5 +++--
 kernel/exit.c         |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index cc941a3..a19fef2 100644
--- a/drivers/char/tty_io.c
+++ b/drivers/char/tty_io.c
@@ -707,6 +707,8 @@ void disassociate_ctty(int on_exit)
 	struct tty_struct *tty;
 	struct pid *tty_pgrp = NULL;
 
+	if (!current->signal->leader)
+		return;
 
 	tty = get_current_tty();
 	if (tty) {
@@ -772,8 +774,7 @@ void no_tty(void)
 {
 	struct task_struct *tsk = current;
 	lock_kernel();
-	if (tsk->signal->leader)
-		disassociate_ctty(0);
+	disassociate_ctty(0);
 	unlock_kernel();
 	proc_clear_tty(tsk);
 }
diff --git a/kernel/exit.c b/kernel/exit.c
index 1143012..6f50ef5 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -971,7 +971,7 @@ NORET_TYPE void do_exit(long code)
 	exit_thread();
 	cgroup_exit(tsk, 1);
 
-	if (group_dead && tsk->signal->leader)
+	if (group_dead)
 		disassociate_ctty(1);
 
 	module_put(task_thread_info(tsk)->exec_domain->module);
-- 
1.6.5.5

