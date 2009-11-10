Return-Path: <linux-kernel-owner+w=401wt.eu-S1758601AbZKJWgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758601AbZKJWgw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 17:36:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758597AbZKJWgv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 17:36:51 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:20422 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758572AbZKJWgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 17:36:49 -0500
Subject: [PATCH v3 3/5] mm: refactor unregister_cpu_under_node()
To: akpm@linux-foundation.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Tue, 10 Nov 2009 15:36:54 -0700
Message-ID: <20091110223654.25636.96385.stgit@bob.kio>
In-Reply-To: <20091110223154.25636.48462.stgit@bob.kio>
References: <20091110223154.25636.48462.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By returning early if the node is not online, we can unindent the
interesting code by two levels.

No functional change.

Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/base/node.c |   18 ++++++++++++------
 1 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index ef7dd22..ffda067 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -243,12 +243,18 @@ int register_cpu_under_node(unsigned int cpu, unsigned int nid)
 
 int unregister_cpu_under_node(unsigned int cpu, unsigned int nid)
 {
-	if (node_online(nid)) {
-		struct sys_device *obj = get_cpu_sysdev(cpu);
-		if (obj)
-			sysfs_remove_link(&node_devices[nid].sysdev.kobj,
-					 kobject_name(&obj->kobj));
-	}
+	struct sys_device *obj;
+
+	if (!node_online(nid))
+		return 0;
+
+	obj = get_cpu_sysdev(cpu);
+	if (!obj)
+		return 0;
+
+	sysfs_remove_link(&node_devices[nid].sysdev.kobj,
+			  kobject_name(&obj->kobj));
+
 	return 0;
 }
 

