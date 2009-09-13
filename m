Return-Path: <linux-kernel-owner+w=401wt.eu-S1754910AbZIMCzQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbZIMCzQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Sep 2009 22:55:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754866AbZIMCzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Sep 2009 22:55:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754643AbZIMCzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Sep 2009 22:55:07 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 2/3] SELinux: seperate avc_cache flushing
To: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov
Cc: sds@tycho.nsa.gov, jmorris@namei.org, mingo@elte.hu, dhowells@redhat.com
Date: Sat, 12 Sep 2009 22:54:17 -0400
Message-ID: <20090913025417.6583.19746.stgit@paris.rdu.redhat.com>
In-Reply-To: <20090913025409.6583.58777.stgit@paris.rdu.redhat.com>
References: <20090913025409.6583.58777.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move the avc_cache flushing into it's own function so it can be reused when
disabling SELinux.

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 security/selinux/avc.c |   24 +++++++++++++++++-------
 1 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/security/selinux/avc.c b/security/selinux/avc.c
index e3d1901..f601246 100644
--- a/security/selinux/avc.c
+++ b/security/selinux/avc.c
@@ -709,18 +709,16 @@ out:
 }
 
 /**
- * avc_ss_reset - Flush the cache and revalidate migrated permissions.
- * @seqno: policy sequence number
+ * avc_flush - Flush the cache
  */
-int avc_ss_reset(u32 seqno)
+static void avc_flush(void)
 {
-	struct avc_callback_node *c;
-	int i, rc = 0, tmprc;
-	unsigned long flag;
-	struct avc_node *node;
 	struct hlist_head *head;
 	struct hlist_node *next;
+	struct avc_node *node;
 	spinlock_t *lock;
+	unsigned long flag;
+	int i;
 
 	for (i = 0; i < AVC_CACHE_SLOTS; i++) {
 		head = &avc_cache.slots[i];
@@ -737,6 +735,18 @@ int avc_ss_reset(u32 seqno)
 		rcu_read_unlock();
 		spin_unlock_irqrestore(lock, flag);
 	}
+}
+
+/**
+ * avc_ss_reset - Flush the cache and revalidate migrated permissions.
+ * @seqno: policy sequence number
+ */
+int avc_ss_reset(u32 seqno)
+{
+	struct avc_callback_node *c;
+	int rc = 0, tmprc;
+
+	avc_flush();
 
 	for (c = avc_callbacks; c; c = c->next) {
 		if (c->events & AVC_CALLBACK_RESET) {

