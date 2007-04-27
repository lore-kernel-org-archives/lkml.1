Return-Path: <linux-kernel-owner+w=401wt.eu-S1757103AbXD0TC7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103AbXD0TC7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 15:02:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757083AbXD0S7V
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 14:59:21 -0400
Received: from cantor.suse.de ([195.135.220.2]:50855 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757080AbXD0S7J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 14:59:09 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 45/46] drivers/base/attribute_container.c: use mutex instead of binary semaphore
Date: Fri, 27 Apr 2007 11:53:59 -0700
Message-Id: <11777002102105-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11777002064008-git-send-email-gregkh@suse.de>
References: <20070427185152.GA17121@kroah.com>
 <1177700040520-git-send-email-gregkh@suse.de>
 <11777000433552-git-send-email-gregkh@suse.de>
 <11777000471977-git-send-email-gregkh@suse.de>
 <11777000511784-git-send-email-gregkh@suse.de>
 <11777000552084-git-send-email-gregkh@suse.de>
 <1177700059319-git-send-email-gregkh@suse.de>
 <11777000632194-git-send-email-gregkh@suse.de>
 <11777000663361-git-send-email-gregkh@suse.de>
 <1177700070961-git-send-email-gregkh@suse.de>
 <1177700074272-git-send-email-gregkh@suse.de>
 <11777000773819-git-send-email-gregkh@suse.de>
 <11777000814075-git-send-email-gregkh@suse.de>
 <11777000852694-git-send-email-gregkh@suse.de>
 <11777000881307-git-send-email-gregkh@suse.de>
 <11777000923797-git-send-email-gregkh@suse.de>
 <11777000963332-git-send-email-gregkh@suse.de>
 <11777001002860-git-send-email-gregkh@suse.de>
 <11777001041847-git-send-email-gregkh@suse.de>
 <11777001072576-git-send-email-gregkh@suse.de>
 <11777001102852-git-send-email-gregkh@suse.de>
 <1177700114535-git-send-email-gregkh@suse.de>
 <11777001182501-git-send-email-gregkh@suse.de>
 <11777001222882-git-send-email-gregkh@suse.de>
 <1177700125350-git-send-email-gregkh@suse.de>
 <11777001301175-git-send-email-gregkh@suse.de>
 <11777001333852-git-send-email-gregkh@suse.de>
 <117770013729-git-send-email-gregkh@suse.de>
 <11777001413571-git-send-email-gregkh@suse.de>
 <11777001442148-git-send-email-gregkh@suse.de>
 <1177700148815-git-send-email-gregkh@suse.de>
 <11777001521006-git-send-email-gregkh@suse.de>
 <1177700156641-git-send-email-gregkh@suse.de>
 <1177700160896-git-send-email-gregkh@suse.de>
 <11777001642551-git-send-email-gregkh@suse.de>
 <11777001682584-git-send-email-gregkh@suse.de>
 <1177700172258-git-send-email-gregkh@suse.de>
 <11777001773804-git-send-email-gregkh@suse.de>
 <11777001803098-git-send-email-gregkh@suse.de>
 <11777001852549-git-send-email-gregkh@suse.de>
 <11777001891914-git-send-email-gregkh@suse.de>
 <11777001931075-git-send-email-gregkh@suse.de>
 <11777001971761-git-send-email-gregkh@suse.de>
 <11777002022552-git-send-email-gregkh@suse.de>
 <11777002064008-git-send-email-gregkh@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

use mutex instead of binary semaphore in
drivers/base/attribute_container.c

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/attribute_container.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/base/attribute_container.c b/drivers/base/attribute_container.c
index 2222073..1ec0654 100644
--- a/drivers/base/attribute_container.c
+++ b/drivers/base/attribute_container.c
@@ -62,7 +62,7 @@ EXPORT_SYMBOL_GPL(attribute_container_classdev_to_container);
 
 static struct list_head attribute_container_list;
 
-static DECLARE_MUTEX(attribute_container_mutex);
+static DEFINE_MUTEX(attribute_container_mutex);
 
 /**
  * attribute_container_register - register an attribute container
@@ -77,9 +77,9 @@ attribute_container_register(struct attribute_container *cont)
 	klist_init(&cont->containers,internal_container_klist_get,
 		   internal_container_klist_put);
 		
-	down(&attribute_container_mutex);
+	mutex_lock(&attribute_container_mutex);
 	list_add_tail(&cont->node, &attribute_container_list);
-	up(&attribute_container_mutex);
+	mutex_unlock(&attribute_container_mutex);
 
 	return 0;
 }
@@ -94,7 +94,7 @@ int
 attribute_container_unregister(struct attribute_container *cont)
 {
 	int retval = -EBUSY;
-	down(&attribute_container_mutex);
+	mutex_lock(&attribute_container_mutex);
 	spin_lock(&cont->containers.k_lock);
 	if (!list_empty(&cont->containers.k_list))
 		goto out;
@@ -102,7 +102,7 @@ attribute_container_unregister(struct attribute_container *cont)
 	list_del(&cont->node);
  out:
 	spin_unlock(&cont->containers.k_lock);
-	up(&attribute_container_mutex);
+	mutex_unlock(&attribute_container_mutex);
 	return retval;
 		
 }
@@ -145,7 +145,7 @@ attribute_container_add_device(struct device *dev,
 {
 	struct attribute_container *cont;
 
-	down(&attribute_container_mutex);
+	mutex_lock(&attribute_container_mutex);
 	list_for_each_entry(cont, &attribute_container_list, node) {
 		struct internal_container *ic;
 
@@ -173,7 +173,7 @@ attribute_container_add_device(struct device *dev,
 			attribute_container_add_class_device(&ic->classdev);
 		klist_add_tail(&ic->node, &cont->containers);
 	}
-	up(&attribute_container_mutex);
+	mutex_unlock(&attribute_container_mutex);
 }
 
 /* FIXME: can't break out of this unless klist_iter_exit is also
@@ -211,7 +211,7 @@ attribute_container_remove_device(struct device *dev,
 {
 	struct attribute_container *cont;
 
-	down(&attribute_container_mutex);
+	mutex_lock(&attribute_container_mutex);
 	list_for_each_entry(cont, &attribute_container_list, node) {
 		struct internal_container *ic;
 		struct klist_iter iter;
@@ -234,7 +234,7 @@ attribute_container_remove_device(struct device *dev,
 			}
 		}
 	}
-	up(&attribute_container_mutex);
+	mutex_unlock(&attribute_container_mutex);
 }
 
 /**
@@ -255,7 +255,7 @@ attribute_container_device_trigger(struct device *dev,
 {
 	struct attribute_container *cont;
 
-	down(&attribute_container_mutex);
+	mutex_lock(&attribute_container_mutex);
 	list_for_each_entry(cont, &attribute_container_list, node) {
 		struct internal_container *ic;
 		struct klist_iter iter;
@@ -273,7 +273,7 @@ attribute_container_device_trigger(struct device *dev,
 				fn(cont, dev, &ic->classdev);
 		}
 	}
-	up(&attribute_container_mutex);
+	mutex_unlock(&attribute_container_mutex);
 }
 
 /**
@@ -295,12 +295,12 @@ attribute_container_trigger(struct device *dev,
 {
 	struct attribute_container *cont;
 
-	down(&attribute_container_mutex);
+	mutex_lock(&attribute_container_mutex);
 	list_for_each_entry(cont, &attribute_container_list, node) {
 		if (cont->match(cont, dev))
 			fn(cont, dev);
 	}
-	up(&attribute_container_mutex);
+	mutex_unlock(&attribute_container_mutex);
 }
 
 /**
-- 
1.5.1.2

