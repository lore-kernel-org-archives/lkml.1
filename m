Return-Path: <linux-kernel-owner+w=401wt.eu-S1766994AbXDSVMt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766994AbXDSVMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 17:12:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422667AbXDSVMt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 17:12:49 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:48233
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1422636AbXDSVMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 17:12:48 -0400
Date: Thu, 19 Apr 2007 23:16:00 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/base/attribute_container.c: use mutex instead of binary semaphore
Message-ID: <20070419211600.GH5013@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	gregkh@suse.de, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

use mutex instead of binary semaphore in
drivers/base/attribute_container.c

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com> 

--

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
Matthias Kaehlcke
Linux Application Developer
Barcelona

     The assumption that what currently exists must necessarily
      exist is the acid that corrodes all visionary thinking
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
