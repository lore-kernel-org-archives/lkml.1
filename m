Return-Path: <linux-kernel-owner+w=401wt.eu-S1757001AbYGGQwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001AbYGGQwi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 12:52:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673AbYGGQuJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 12:50:09 -0400
Received: from aa2005110791d2e6c28a.userreverse.dion.ne.jp ([210.230.194.138]:20574
	"EHLO localhost.localdomain" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754501AbYGGQuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 12:50:07 -0400
X-Greylist: delayed 449 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jul 2008 12:49:54 EDT
From: James Morris <jmorris@namei.org>
To: linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 12/20] SELinux: open code sidtab lock
Date: Tue,  8 Jul 2008 01:42:14 +0900
Message-Id: <1215448942-17581-13-git-send-email-jmorris@namei.org>
X-Mailer: git-send-email 1.5.5.1
In-Reply-To: <1215448942-17581-1-git-send-email-jmorris@namei.org>
References: <1215448942-17581-1-git-send-email-jmorris@namei.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Open code sidtab lock to make Andrew Morton happy.

Signed-off-by: James Morris <jmorris@namei.org>
Acked-by: Stephen Smalley <sds@tycho.nsa.gov>
---
 security/selinux/ss/sidtab.c |   18 +++++++-----------
 1 files changed, 7 insertions(+), 11 deletions(-)

diff --git a/security/selinux/ss/sidtab.c b/security/selinux/ss/sidtab.c
index ba35416..a81ded1 100644
--- a/security/selinux/ss/sidtab.c
+++ b/security/selinux/ss/sidtab.c
@@ -14,10 +14,6 @@
 #define SIDTAB_HASH(sid) \
 (sid & SIDTAB_HASH_MASK)
 
-#define INIT_SIDTAB_LOCK(s) spin_lock_init(&s->lock)
-#define SIDTAB_LOCK(s, x) spin_lock_irqsave(&s->lock, x)
-#define SIDTAB_UNLOCK(s, x) spin_unlock_irqrestore(&s->lock, x)
-
 int sidtab_init(struct sidtab *s)
 {
 	int i;
@@ -30,7 +26,7 @@ int sidtab_init(struct sidtab *s)
 	s->nel = 0;
 	s->next_sid = 1;
 	s->shutdown = 0;
-	INIT_SIDTAB_LOCK(s);
+	spin_lock_init(&s->lock);
 	return 0;
 }
 
@@ -180,7 +176,7 @@ int sidtab_context_to_sid(struct sidtab *s,
 
 	sid = sidtab_search_context(s, context);
 	if (!sid) {
-		SIDTAB_LOCK(s, flags);
+		spin_lock_irqsave(&s->lock, flags);
 		/* Rescan now that we hold the lock. */
 		sid = sidtab_search_context(s, context);
 		if (sid)
@@ -199,7 +195,7 @@ int sidtab_context_to_sid(struct sidtab *s,
 		if (ret)
 			s->next_sid--;
 unlock_out:
-		SIDTAB_UNLOCK(s, flags);
+		spin_unlock_irqrestore(&s->lock, flags);
 	}
 
 	if (ret)
@@ -264,19 +260,19 @@ void sidtab_set(struct sidtab *dst, struct sidtab *src)
 {
 	unsigned long flags;
 
-	SIDTAB_LOCK(src, flags);
+	spin_lock_irqsave(&src->lock, flags);
 	dst->htable = src->htable;
 	dst->nel = src->nel;
 	dst->next_sid = src->next_sid;
 	dst->shutdown = 0;
-	SIDTAB_UNLOCK(src, flags);
+	spin_unlock_irqrestore(&src->lock, flags);
 }
 
 void sidtab_shutdown(struct sidtab *s)
 {
 	unsigned long flags;
 
-	SIDTAB_LOCK(s, flags);
+	spin_lock_irqsave(&s->lock, flags);
 	s->shutdown = 1;
-	SIDTAB_UNLOCK(s, flags);
+	spin_unlock_irqrestore(&s->lock, flags);
 }
-- 
1.5.5.1

