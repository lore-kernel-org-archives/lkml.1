Return-Path: <linux-kernel-owner+w=401wt.eu-S933045AbYA2OGw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933045AbYA2OGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 09:06:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932106AbYA2OGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 09:06:41 -0500
Received: from sacred.ru ([62.205.161.221]:48876 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763531AbYA2OGj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 09:06:39 -0500
Message-ID: <479F32E8.3090001@openvz.org>
Date: Tue, 29 Jan 2008 17:06:32 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Ralf Baechle <ralf@linux-mips.org>
Subject: [PATCH 11/12] mips: use find_task_by_vpid in system calls
References: <479F2C5C.1050303@openvz.org>
In-Reply-To: <479F2C5C.1050303@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Tue, 29 Jan 2008 17:06:12 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some places left in mips, that lookup task in
initial namespace, while the code doing so gets the pid
from the user space and thus must treat it as virtual.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---
 arch/mips/kernel/mips-mt-fpaff.c |    2 +-
 arch/mips/kernel/sysirix.c       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/mips/kernel/mips-mt-fpaff.c b/arch/mips/kernel/mips-mt-fpaff.c
index bb4f00c..df4d3f2 100644
--- a/arch/mips/kernel/mips-mt-fpaff.c
+++ b/arch/mips/kernel/mips-mt-fpaff.c
@@ -36,7 +36,7 @@ unsigned long mt_fpemul_threshold = 0;
  */
 static inline struct task_struct *find_process_by_pid(pid_t pid)
 {
-	return pid ? find_task_by_pid(pid) : current;
+	return pid ? find_task_by_vpid(pid) : current;
 }
 
 
diff --git a/arch/mips/kernel/sysirix.c b/arch/mips/kernel/sysirix.c
index 672fba8..c357762 100644
--- a/arch/mips/kernel/sysirix.c
+++ b/arch/mips/kernel/sysirix.c
@@ -111,7 +111,7 @@ asmlinkage int irix_prctl(unsigned option, ...)
 		printk("irix_prctl[%s:%d]: Wants PR_ISBLOCKED\n",
 		       current->comm, current->pid);
 		read_lock(&tasklist_lock);
-		task = find_task_by_pid(va_arg(args, pid_t));
+		task = find_task_by_vpid(va_arg(args, pid_t));
 		error = -ESRCH;
 		if (error)
 			error = (task->run_list.next != NULL);
-- 
1.5.3.4

