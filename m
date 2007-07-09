Return-Path: <linux-kernel-owner+w=401wt.eu-S1754894AbXGIQYn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754894AbXGIQYn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 12:24:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757026AbXGIQXS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 12:23:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41827 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756846AbXGIQXQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 12:23:16 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cluster-devel@redhat.com, Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       David Teigland <teigland@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH] [DLM] fix a couple of races
Date: Mon,  9 Jul 2007 17:02:08 +0100
Message-Id: <11839969911617-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1183996989263-git-send-email-swhiteho@redhat.com>
References: <11839969822277-git-send-email-swhiteho@redhat.com>
 <1183996989263-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Satyam Sharma <ssatyam@cse.iitk.ac.in>

Fix two races in fs/dlm/config.c:

(1) Grab the configfs subsystem semaphore before calling
config_group_find_obj() in get_space(). This solves a potential race
between get_space() and concurrent mkdir(2) or rmdir(2).

(2) Grab a reference on the found config_item _while_ holding the configfs
subsystem semaphore in get_comm(), and not after it. This solves a
potential race between get_comm() and concurrent rmdir(2).

Signed-off-by: Satyam Sharma <ssatyam@cse.iitk.ac.in>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index 822abdc..5a3d390 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -748,9 +748,16 @@ static ssize_t node_weight_write(struct node *nd, const char *buf, size_t len)
 
 static struct space *get_space(char *name)
 {
+	struct config_item *i;
+
 	if (!space_list)
 		return NULL;
-	return to_space(config_group_find_obj(space_list, name));
+
+	down(&space_list->cg_subsys->su_sem);
+	i = config_group_find_obj(space_list, name);
+	up(&space_list->cg_subsys->su_sem);
+
+	return to_space(i);
 }
 
 static void put_space(struct space *sp)
@@ -776,20 +783,20 @@ static struct comm *get_comm(int nodeid, struct sockaddr_storage *addr)
 			if (cm->nodeid != nodeid)
 				continue;
 			found = 1;
+			config_item_get(i);
 			break;
 		} else {
 			if (!cm->addr_count ||
 			    memcmp(cm->addr[0], addr, sizeof(*addr)))
 				continue;
 			found = 1;
+			config_item_get(i);
 			break;
 		}
 	}
 	up(&clusters_root.subsys.su_sem);
 
-	if (found)
-		config_item_get(i);
-	else
+	if (!found)
 		cm = NULL;
 	return cm;
 }
-- 
1.5.1.2

