Return-Path: <linux-kernel-owner+w=401wt.eu-S1759296AbZLKPiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759296AbZLKPiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 10:38:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759265AbZLKPiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 10:38:19 -0500
Received: from mail.windriver.com ([147.11.1.11]:57531 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759054AbZLKPhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 10:37:08 -0500
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       Jason Wessel <jason.wessel@windriver.com>
Subject: [PATCH 2/9] kgdb: Read buffer overflow
Date: Fri, 11 Dec 2009 09:36:10 -0600
Message-Id: <1260545777-8089-3-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
In-Reply-To: <1260545777-8089-2-git-send-email-jason.wessel@windriver.com>
References: <1260545777-8089-1-git-send-email-jason.wessel@windriver.com>
 <1260545777-8089-2-git-send-email-jason.wessel@windriver.com>
X-OriginalArrivalTime: 11 Dec 2009 15:36:31.0457 (UTC) FILETIME=[B6792510:01CA7A77]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roel Kluin reported an error found with Parfait.  Where we want to
ensure that that kgdb_info[-1] never gets accessed.

Also check to ensure any negative tid does not exceed the size of the
shadow CPU array, else report critical debug context because it is an
internal kgdb failure.

Reported-by: Roel Kluin <roel.kluin@gmail.com>
Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 kernel/kgdb.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/kernel/kgdb.c b/kernel/kgdb.c
index 7d70146..29357a9 100644
--- a/kernel/kgdb.c
+++ b/kernel/kgdb.c
@@ -541,12 +541,17 @@ static struct task_struct *getthread(struct pt_regs *regs, int tid)
 	 */
 	if (tid == 0 || tid == -1)
 		tid = -atomic_read(&kgdb_active) - 2;
-	if (tid < 0) {
+	if (tid < -1 && tid > -NR_CPUS - 2) {
 		if (kgdb_info[-tid - 2].task)
 			return kgdb_info[-tid - 2].task;
 		else
 			return idle_task(-tid - 2);
 	}
+	if (tid <= 0) {
+		printk(KERN_ERR "KGDB: Internal thread select error\n");
+		dump_stack();
+		return NULL;
+	}
 
 	/*
 	 * find_task_by_pid_ns() does not take the tasklist lock anymore
-- 
1.6.4.rc1

