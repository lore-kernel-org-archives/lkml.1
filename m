Return-Path: <linux-kernel-owner+w=401wt.eu-S932120AbZKROmy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932120AbZKROmy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 09:42:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932078AbZKROmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 09:42:53 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:36893 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932106AbZKROmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 09:42:52 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 4/5] tty: Move the leader test in disassociate
To: linux-kernel@vger.kernel.org
Date: Wed, 18 Nov 2009 14:26:29 +0000
Message-ID: <20091118142621.3806.50993.stgit@localhost.localdomain>
In-Reply-To: <20091118142313.3806.47368.stgit@localhost.localdomain>
References: <20091118142313.3806.47368.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two call points, both want to check that tty->signal->leader is
set. Move the test into disassociate_ctty() as that will make locking
changes easier in a bit

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/tty_io.c |    5 +++--
 kernel/exit.c         |    2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)


diff --git a/drivers/char/tty_io.c b/drivers/char/tty_io.c
index f4a0404..aee68f5 100644
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
index f7864ac..dbca05b 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -970,7 +970,7 @@ NORET_TYPE void do_exit(long code)
 	exit_thread();
 	cgroup_exit(tsk, 1);
 
-	if (group_dead && tsk->signal->leader)
+	if (group_dead)
 		disassociate_ctty(1);
 
 	module_put(task_thread_info(tsk)->exec_domain->module);

