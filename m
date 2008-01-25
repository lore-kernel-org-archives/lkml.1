Return-Path: <linux-kernel-owner+w=401wt.eu-S1757978AbYAYHTA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978AbYAYHTA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 02:19:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757057AbYAYHOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 02:14:54 -0500
Received: from mx2.suse.de ([195.135.220.15]:47455 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756941AbYAYHOv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 02:14:51 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <johnpol@2ka.mipt.ru>, Kay Sievers <kay.sievers@vrfy.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 016/196] kref: add kref_set()
Date: Thu, 24 Jan 2008 23:09:14 -0800
Message-Id: <1201245134-4876-16-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080125071127.GA4860@kroah.com>
References: <20080125071127.GA4860@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>

This adds kref_set() to the kref api for future use by people who really
know what they are doing with krefs...

From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 include/linux/kref.h |    1 +
 lib/kref.c           |   15 +++++++++++++--
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/linux/kref.h b/include/linux/kref.h
index 6fee353..5d18563 100644
--- a/include/linux/kref.h
+++ b/include/linux/kref.h
@@ -24,6 +24,7 @@ struct kref {
 	atomic_t refcount;
 };
 
+void kref_set(struct kref *kref, int num);
 void kref_init(struct kref *kref);
 void kref_get(struct kref *kref);
 int kref_put(struct kref *kref, void (*release) (struct kref *kref));
diff --git a/lib/kref.c b/lib/kref.c
index a6dc3ec..9ecd6e8 100644
--- a/lib/kref.c
+++ b/lib/kref.c
@@ -15,13 +15,23 @@
 #include <linux/module.h>
 
 /**
+ * kref_set - initialize object and set refcount to requested number.
+ * @kref: object in question.
+ * @num: initial reference counter
+ */
+void kref_set(struct kref *kref, int num)
+{
+	atomic_set(&kref->refcount, num);
+	smp_mb();
+}
+
+/**
  * kref_init - initialize object.
  * @kref: object in question.
  */
 void kref_init(struct kref *kref)
 {
-	atomic_set(&kref->refcount,1);
-	smp_mb();
+	kref_set(kref, 1);
 }
 
 /**
@@ -61,6 +71,7 @@ int kref_put(struct kref *kref, void (*release)(struct kref *kref))
 	return 0;
 }
 
+EXPORT_SYMBOL(kref_set);
 EXPORT_SYMBOL(kref_init);
 EXPORT_SYMBOL(kref_get);
 EXPORT_SYMBOL(kref_put);
-- 
1.5.3.8

