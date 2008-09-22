Return-Path: <linux-kernel-owner+w=401wt.eu-S1753870AbYIVSlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbYIVSlN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 14:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbYIVSkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 14:40:43 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54649 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894AbYIVSkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 14:40:41 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] dlm: fix address compare
Date: Mon, 22 Sep 2008 13:28:37 -0500
Message-Id: <1222108119-24928-5-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Compare only the addr and port fields of sockaddr structures.
Fixes a problem with ipv6 where sin6_scope_id does not match.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/config.c |   33 +++++++++++++++++++++++++++++++--
 1 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index 89d2fb7..1359be3 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -14,6 +14,9 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/configfs.h>
+#include <linux/in.h>
+#include <linux/in6.h>
+#include <net/ipv6.h>
 #include <net/sock.h>
 
 #include "config.h"
@@ -776,6 +779,33 @@ static void put_space(struct dlm_space *sp)
 	config_item_put(&sp->group.cg_item);
 }
 
+static int addr_compare(struct sockaddr_storage *x, struct sockaddr_storage *y)
+{
+	switch (x->ss_family) {
+	case AF_INET: {
+		struct sockaddr_in *sinx = (struct sockaddr_in *)x;
+		struct sockaddr_in *siny = (struct sockaddr_in *)y;
+		if (sinx->sin_addr.s_addr != siny->sin_addr.s_addr)
+			return 0;
+		if (sinx->sin_port != siny->sin_port)
+			return 0;
+		break;
+	}
+	case AF_INET6: {
+		struct sockaddr_in6 *sinx = (struct sockaddr_in6 *)x;
+		struct sockaddr_in6 *siny = (struct sockaddr_in6 *)y;
+		if (!ipv6_addr_equal(&sinx->sin6_addr, &siny->sin6_addr))
+			return 0;
+		if (sinx->sin6_port != siny->sin6_port)
+			return 0;
+		break;
+	}
+	default:
+		return 0;
+	}
+	return 1;
+}
+
 static struct dlm_comm *get_comm(int nodeid, struct sockaddr_storage *addr)
 {
 	struct config_item *i;
@@ -797,8 +827,7 @@ static struct dlm_comm *get_comm(int nodeid, struct sockaddr_storage *addr)
 			config_item_get(i);
 			break;
 		} else {
-			if (!cm->addr_count ||
-			    memcmp(cm->addr[0], addr, sizeof(*addr)))
+			if (!cm->addr_count || !addr_compare(cm->addr[0], addr))
 				continue;
 			found = 1;
 			config_item_get(i);
-- 
1.5.5.1

