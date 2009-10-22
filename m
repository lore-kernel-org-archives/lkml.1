Return-Path: <linux-kernel-owner+w=401wt.eu-S1752603AbZJVEPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbZJVEPc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 00:15:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752296AbZJVEPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 00:15:31 -0400
Received: from g1t0027.austin.hp.com ([15.216.28.34]:18922 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784AbZJVEPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 00:15:15 -0400
Subject: [PATCH v2 3/5] mm: refactor unregister_cpu_under_node()
To: akpm@linux-foundation.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Wed, 21 Oct 2009 22:15:20 -0600
Message-ID: <20091022041520.15705.206.stgit@bob.kio>
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
 

