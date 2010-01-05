Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207Ab0AESRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab0AESRh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 13:17:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754957Ab0AESRf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 13:17:35 -0500
Received: from [206.15.93.42] ([206.15.93.42]:2132 "EHLO
	visionfs1.visionengravers.com" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754736Ab0AESRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 13:17:35 -0500
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] nodemask.h: change any_online_node() to a static inline
Date: Tue, 5 Jan 2010 11:17:39 -0700
Cc: akpm@linux-foundation.org, bfields@fieldses.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001051117.39423.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change any_online_node() from a macro to a static inline function.
 
The macro any_online_node() uses the local symbol 'node', this causes a
sparse warning in net/sunrpc/svc.c.  Changing the macro to a static inline
function quites the sparse warning and will prevent the same warning
from possibly occurring in the future.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: J. Bruce Fields <bfields@fieldses.org>

---

diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index 454997c..1f66e02 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -467,15 +467,6 @@ static inline int num_node_state(enum node_states state)
 #define node_online_map 	node_states[N_ONLINE]
 #define node_possible_map 	node_states[N_POSSIBLE]
 
-#define any_online_node(mask)			\
-({						\
-	int node;				\
-	for_each_node_mask(node, (mask))	\
-		if (node_online(node))		\
-			break;			\
-	node;					\
-})
-
 #define num_online_nodes()	num_node_state(N_ONLINE)
 #define num_possible_nodes()	num_node_state(N_POSSIBLE)
 #define node_online(node)	node_state((node), N_ONLINE)
@@ -484,6 +475,17 @@ static inline int num_node_state(enum node_states state)
 #define for_each_node(node)	   for_each_node_state(node, N_POSSIBLE)
 #define for_each_online_node(node) for_each_node_state(node, N_ONLINE)
 
+static inline int any_online_node(nodemask_t mask)
+{
+	int node;
+
+	for_each_node_mask(node, mask) {
+		if (node_online(node))
+			break;
+	}
+	return node;
+}
+
 /*
  * For nodemask scrach area.
  * NODEMASK_ALLOC(type, name) allocates an object with a specified type and
