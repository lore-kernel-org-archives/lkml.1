Return-Path: <linux-kernel-owner+w=401wt.eu-S1753408AbZJVEQJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753408AbZJVEQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 00:16:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbZJVEP3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 00:15:29 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:20373 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbZJVEPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 00:15:10 -0400
Subject: [PATCH v2 2/5] mm: refactor register_cpu_under_node()
To: akpm@linux-foundation.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Wed, 21 Oct 2009 22:15:15 -0600
Message-ID: <20091022041515.15705.26283.stgit@bob.kio>
In-Reply-To: <20091022040814.15705.95572.stgit@bob.kio>
References: <20091022040814.15705.95572.stgit@bob.kio>
User-Agent: StGit/0.14.3.386.gb02d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By returning early if the node is not online, we can unindent the
interesting code by one level.

No functional change.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/base/node.c |   20 +++++++++++---------
 1 files changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 3108b21..ef7dd22 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -227,16 +227,18 @@ struct node node_devices[MAX_NUMNODES];
  */
 int register_cpu_under_node(unsigned int cpu, unsigned int nid)
 {
-	if (node_online(nid)) {
-		struct sys_device *obj = get_cpu_sysdev(cpu);
-		if (!obj)
-			return 0;
-		return sysfs_create_link(&node_devices[nid].sysdev.kobj,
-					 &obj->kobj,
-					 kobject_name(&obj->kobj));
-	 }
+	struct sys_device *obj;
 
-	return 0;
+	if (!node_online(nid))
+		return 0;
+
+	obj = get_cpu_sysdev(cpu);
+	if (!obj)
+		return 0;
+
+	return sysfs_create_link(&node_devices[nid].sysdev.kobj,
+				&obj->kobj,
+				kobject_name(&obj->kobj));
 }
 
 int unregister_cpu_under_node(unsigned int cpu, unsigned int nid)

