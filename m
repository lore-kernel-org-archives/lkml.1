Return-Path: <linux-kernel-owner+w=401wt.eu-S1755480AbYJBVvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480AbYJBVvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2008 17:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754500AbYJBVve
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Oct 2008 17:51:34 -0400
Received: from mylar.outflux.net ([69.93.193.226]:46377 "EHLO
	mylar.outflux.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404AbYJBVvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2008 17:51:33 -0400
X-Greylist: delayed 2222 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Oct 2008 17:51:33 EDT
Date: Thu, 2 Oct 2008 14:14:24 -0700
From: Kees Cook <kees.cook@canonical.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] proc: add "personality" to process status file
Message-ID: <20081002211424.GJ10632@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no sane way to query the personality flags of arbitrary process
from userspace.  This adds the flags to the /proc/$pid/status file.
For example, to detect READ_IMPLIES_EXEC:

$ ./32bit-sleeper &
[1] 6732
$ grep ^Pers /proc/6732/status
Personality:    00000000
$ execstack -s 32bit-sleeper
$ ./32bit-slepper &
[2] 6735
$ grep ^Pers /proc/6735/status
Personality:    00040000

Signed-off-by: Kees Cook <kees.cook@canonical.com>
---
 fs/proc/array.c       |    6 ++++--
 include/linux/sched.h |    3 +--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 71c9be5..1235fab 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -182,13 +182,15 @@ static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
 		"PPid:\t%d\n"
 		"TracerPid:\t%d\n"
 		"Uid:\t%d\t%d\t%d\t%d\n"
-		"Gid:\t%d\t%d\t%d\t%d\n",
+		"Gid:\t%d\t%d\t%d\t%d\n"
+		"Personality:\t%08x\n",
 		get_task_state(p),
 		task_tgid_nr_ns(p, ns),
 		pid_nr_ns(pid, ns),
 		ppid, tpid,
 		p->uid, p->euid, p->suid, p->fsuid,
-		p->gid, p->egid, p->sgid, p->fsgid);
+		p->gid, p->egid, p->sgid, p->fsgid,
+		p->personality);
 
 	task_lock(p);
 	if (p->files)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 3d9120c..f2fc441 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1085,8 +1085,7 @@ struct task_struct {
 	int exit_state;
 	int exit_code, exit_signal;
 	int pdeath_signal;  /*  The signal sent when the parent dies  */
-	/* ??? */
-	unsigned int personality;
+	unsigned int personality; /* Special-case bits (linux/personality.h) */
 	unsigned did_exec:1;
 	pid_t pid;
 	pid_t tgid;
-- 
1.5.6.3


-- 
Kees Cook
Ubuntu Security Team
