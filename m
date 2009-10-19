Return-Path: <linux-kernel-owner+w=401wt.eu-S1757990AbZJSVev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757990AbZJSVev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Oct 2009 17:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757909AbZJSVeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Oct 2009 17:34:50 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:1752 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757904AbZJSVeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Oct 2009 17:34:20 -0400
Subject: [PATCH 3/5] mm: refactor unregister_cpu_under_node()
To: akpm@linux-foundation.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Date: Mon, 19 Oct 2009 15:34:25 -0600
Message-ID: <20091019213425.32729.3993.stgit@bob.kio>
In-Reply-To: <20091019212740.32729.7171.stgit@bob.kio>
References: <20091019212740.32729.7171.stgit@bob.kio>
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
 

