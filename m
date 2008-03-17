Return-Path: <linux-kernel-owner+w=401wt.eu-S1754582AbYCQIZs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582AbYCQIZs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 04:25:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752781AbYCQIZi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 04:25:38 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50841 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626AbYCQIZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 04:25:38 -0400
Message-ID: <47DE2AD9.503@cn.fujitsu.com>
Date: Mon, 17 Mar 2008 17:24:57 +0900
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.osdl.org>
Subject: [PATCH -mm] cgroup: fix boot option parsing
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When boot with 'cgroup_disable=cpuacct', it turns out subsystem
'cpu' is disabled.

When Balbir posted the patch to add cgroup boot option support,
Paul M noticed this problem, but the patch was accepted without
fixing it.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup.c |   15 ++++++---------
 1 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e8e8ec4..54c28ea 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3062,25 +3062,22 @@ static void cgroup_release_agent(struct work_struct *work)
 static int __init cgroup_disable(char *str)
 {
 	int i;
+	char *token;
+
+	while ((token = strsep(&str, ",")) != NULL) {
+		if (!*token)
+			continue;
 
-	while (*str) {
 		for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
 			struct cgroup_subsys *ss = subsys[i];
 
-			if (!strncmp(str, ss->name, strlen(ss->name))) {
+			if (!strcmp(token, ss->name)) {
 				ss->disabled = 1;
 				printk(KERN_INFO "Disabling %s control group"
 					" subsystem\n", ss->name);
 				break;
 			}
 		}
-		/*
-		 * Find the next option if any
-		 */
-		while (*str && (*str != ','))
-			str++;
-		if (*str == ',')
-			str++;
 	}
 	return 1;
 }
-- 
1.5.4.rc3
