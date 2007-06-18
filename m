Return-Path: <linux-kernel-owner+w=401wt.eu-S1764200AbXFRPNl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764200AbXFRPNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 11:13:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932226AbXFRPMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 11:12:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51569 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932213AbXFRPMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 11:12:36 -0400
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com, linux-kernel@vger.kernel.org
Cc: Satyam Sharma <ssatyam@cse.iitk.ac.in>,
       David Teigland <teigland@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 2/4] [DLM] fix a couple of races
Date: Mon, 18 Jun 2007 15:54:28 +0100
Message-Id: <11821784801162-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <1182178478593-git-send-email-swhiteho@redhat.com>
References: y
 <11821784703600-git-send-email-swhiteho@redhat.com>
 <1182178478593-git-send-email-swhiteho@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="------------1.5.1.2"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Satyam Sharma <ssatyam@cse.iitk.ac.in>

This is a multi-part message in MIME format.
--------------1.5.1.2
Content-Type: text/plain; charset=UTF-8; format=fixed
Content-Transfer-Encoding: 8bit


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
---
 fs/dlm/config.c |   15 +++++++++++----
 1 files changed, 11 insertions(+), 4 deletions(-)
--------------1.5.1.2
Content-Type: text/x-patch; name="1f692e48dd1f3fa00629c69b2e34ab35c9929b45.diff"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline; filename="1f692e48dd1f3fa00629c69b2e34ab35c9929b45.diff"

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

--------------1.5.1.2--


