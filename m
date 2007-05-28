Return-Path: <linux-kernel-owner+w=401wt.eu-S1760454AbXE1NdX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760454AbXE1NdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 09:33:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754649AbXE1NdQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 09:33:16 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:39113 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104AbXE1NdQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 09:33:16 -0400
Date: Mon, 28 May 2007 17:41:57 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, devel@openvz.org
Subject: [PATCH] /proc/*/environ: wrong placing of ptrace_may_attach() check
Message-ID: <20070528134157.GA7171@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 fs/proc/base.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -204,12 +204,17 @@ static int proc_pid_environ(struct task_
 	int res = 0;
 	struct mm_struct *mm = get_task_mm(task);
 	if (mm) {
-		unsigned int len = mm->env_end - mm->env_start;
+		unsigned int len;
+
+		res = -ESRCH;
+		if (!ptrace_may_attach(task))
+			goto out;
+
+		len  = mm->env_end - mm->env_start;
 		if (len > PAGE_SIZE)
 			len = PAGE_SIZE;
 		res = access_process_vm(task, mm->env_start, buffer, len, 0);
-		if (!ptrace_may_attach(task))
-			res = -ESRCH;
+out:
 		mmput(mm);
 	}
 	return res;

