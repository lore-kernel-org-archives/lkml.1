Return-Path: <linux-kernel-owner+w=401wt.eu-S1758612AbZKJWg6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758612AbZKJWg6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 17:36:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758606AbZKJWg4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 17:36:56 -0500
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:39336 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044AbZKJWgy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 17:36:54 -0500
Subject: [PATCH v3 4/5] mm: add numa node symlink for cpu devices in sysfs
To: akpm@linux-foundation.org
From: Alex Chiang <achiang@hp.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       David Rientjes <rientjes@google.com>
Date: Tue, 10 Nov 2009 15:36:59 -0700
Message-ID: <20091110223659.25636.89997.stgit@bob.kio>
In-Reply-To: <20091110223154.25636.48462.stgit@bob.kio>
References: <20091110223154.25636.48462.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You can discover which CPUs belong to a NUMA node by examining
/sys/devices/system/node/node#/

However, it's not convenient to go in the other direction, when looking at
/sys/devices/system/cpu/cpu#/

Yes, you can muck about in sysfs, but adding these symlinks makes
life a lot more convenient.

Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Alex Chiang <achiang@hp.com>
---

 drivers/base/node.c |   11 ++++++++++-
 1 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index ffda067..24fa962 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -227,6 +227,7 @@ struct node node_devices[MAX_NUMNODES];
  */
 int register_cpu_under_node(unsigned int cpu, unsigned int nid)
 {
+	int ret;
 	struct sys_device *obj;
 
 	if (!node_online(nid))
@@ -236,9 +237,15 @@ int register_cpu_under_node(unsigned int cpu, unsigned int nid)
 	if (!obj)
 		return 0;
 
-	return sysfs_create_link(&node_devices[nid].sysdev.kobj,
+	ret = sysfs_create_link(&node_devices[nid].sysdev.kobj,
 				&obj->kobj,
 				kobject_name(&obj->kobj));
+	if (ret)
+		return ret;
+
+	return sysfs_create_link(&obj->kobj,
+				 &node_devices[nid].sysdev.kobj,
+				 kobject_name(&node_devices[nid].sysdev.kobj));
 }
 
 int unregister_cpu_under_node(unsigned int cpu, unsigned int nid)
@@ -254,6 +261,8 @@ int unregister_cpu_under_node(unsigned int cpu, unsigned int nid)
 
 	sysfs_remove_link(&node_devices[nid].sysdev.kobj,
 			  kobject_name(&obj->kobj));
+	sysfs_remove_link(&obj->kobj,
+			  kobject_name(&node_devices[nid].sysdev.kobj));
 
 	return 0;
 }

