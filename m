Return-Path: <linux-kernel-owner+w=401wt.eu-S1759504AbYHZRjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759504AbYHZRjA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 13:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758955AbYHZRh3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 13:37:29 -0400
Received: from 75-130-108-43.dhcp.oxfr.ma.charter.com ([75.130.108.43]:54193
	"EHLO dev.haskins.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758934AbYHZRh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 13:37:28 -0400
From: Gregory Haskins <ghaskins@novell.com>
Subject: [PATCH v2 5/6] plist: fix PLIST_NODE_INIT to work with debug enabled
To: mingo@elte.hu
Cc: srostedt@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, npiggin@suse.de,
       gregory.haskins@gmail.com
Date: Tue, 26 Aug 2008 13:35:10 -0400
Message-ID: <20080826173510.16413.45136.stgit@dev.haskins.net>
In-Reply-To: <20080826173131.16413.17862.stgit@dev.haskins.net>
References: <20080826173131.16413.17862.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that PLIST_NODE_INIT breaks if used and DEBUG_PI_LIST is defined.
Since there are no current users of PLIST_NODE_INIT, this has gone
undetected.  This patch fixes the build issue that enables the
DEBUG_PI_LIST later in the series when we use it in init_task.h

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 include/linux/plist.h |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/include/linux/plist.h b/include/linux/plist.h
index 85de2f0..2b65483 100644
--- a/include/linux/plist.h
+++ b/include/linux/plist.h
@@ -96,6 +96,10 @@ struct plist_node {
 # define PLIST_HEAD_LOCK_INIT(_lock)
 #endif
 
+#define _PLIST_HEAD_INIT(head)				\
+	.prio_list = LIST_HEAD_INIT((head).prio_list),	\
+	.node_list = LIST_HEAD_INIT((head).node_list)
+
 /**
  * PLIST_HEAD_INIT - static struct plist_head initializer
  * @head:	struct plist_head variable name
@@ -103,8 +107,7 @@ struct plist_node {
  */
 #define PLIST_HEAD_INIT(head, _lock)			\
 {							\
-	.prio_list = LIST_HEAD_INIT((head).prio_list),	\
-	.node_list = LIST_HEAD_INIT((head).node_list),	\
+	_PLIST_HEAD_INIT(head),                         \
 	PLIST_HEAD_LOCK_INIT(&(_lock))			\
 }
 
@@ -116,7 +119,7 @@ struct plist_node {
 #define PLIST_NODE_INIT(node, __prio)			\
 {							\
 	.prio  = (__prio),				\
-	.plist = PLIST_HEAD_INIT((node).plist, NULL),	\
+	.plist = { _PLIST_HEAD_INIT((node).plist) }, 	\
 }
 
 /**

