Return-Path: <linux-kernel-owner+w=401wt.eu-S1756977AbYBOT4w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756977AbYBOT4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 14:56:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756106AbYBOT4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 14:56:38 -0500
Received: from mx1.riseup.net ([204.13.164.18]:54858 "EHLO mx1.riseup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754523AbYBOT4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 14:56:37 -0500
Date: Fri, 15 Feb 2008 20:56:48 +0100
From: matthias@kaehlcke.net
To: mcgrof@gmail.com, linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Matthias Kaehlcke <matthias@kaehlcke.net>
Subject: [patch 1/3] Convert acl->sem in a mutex
Message-ID: <20080215195648.GB22741@traven>
Mail-Followup-To: matthias@kaehlcke.net, mcgrof@gmail.com,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20080215195329.912560854@kaehlcke.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="net-wireless-prism54-acl_sem-to-mutex.diff"
User-Agent: quilt/0.46-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The semaphore acl->sem is used as mutex, convert it to the mutex API

Signed-off-by: Matthias Kaehlcke <matthias@kaehlcke.net>

Index: linux-2.6/drivers/net/wireless/prism54/isl_ioctl.c
===================================================================
--- linux-2.6.orig/drivers/net/wireless/prism54/isl_ioctl.c	2008-02-15 20:42:17.000000000 +0100
+++ linux-2.6/drivers/net/wireless/prism54/isl_ioctl.c	2008-02-15 20:43:05.000000000 +0100
@@ -1780,7 +1780,7 @@
 void
 prism54_acl_init(struct islpci_acl *acl)
 {
-	sema_init(&acl->sem, 1);
+	mutex_init(&acl->lock);
 	INIT_LIST_HEAD(&acl->mac_list);
 	acl->size = 0;
 	acl->policy = MAC_POLICY_OPEN;
@@ -1792,10 +1792,10 @@
 	struct list_head *ptr, *next;
 	struct mac_entry *entry;
 
-	down(&acl->sem);
+	mutex_lock(&acl->lock);
 
 	if (acl->size == 0) {
-		up(&acl->sem);
+		mutex_unlock(&acl->lock);
 		return;
 	}
 
@@ -1806,7 +1806,7 @@
 		kfree(entry);
 	}
 	acl->size = 0;
-	up(&acl->sem);
+	mutex_unlock(&acl->lock);
 }
 
 void
@@ -1833,13 +1833,13 @@
 
 	memcpy(entry->addr, addr->sa_data, ETH_ALEN);
 
-	if (down_interruptible(&acl->sem)) {
+	if (mutex_lock_interruptible(&acl->lock)) {
 		kfree(entry);
 		return -ERESTARTSYS;
 	}
 	list_add_tail(&entry->_list, &acl->mac_list);
 	acl->size++;
-	up(&acl->sem);
+	mutex_unlock(&acl->lock);
 
 	return 0;
 }
@@ -1856,18 +1856,18 @@
 	if (addr->sa_family != ARPHRD_ETHER)
 		return -EOPNOTSUPP;
 
-	if (down_interruptible(&acl->sem))
+	if (mutex_lock_interruptible(&acl->lock))
 		return -ERESTARTSYS;
 	list_for_each_entry(entry, &acl->mac_list, _list) {
 		if (memcmp(entry->addr, addr->sa_data, ETH_ALEN) == 0) {
 			list_del(&entry->_list);
 			acl->size--;
 			kfree(entry);
-			up(&acl->sem);
+			mutex_unlock(&acl->lock);
 			return 0;
 		}
 	}
-	up(&acl->sem);
+	mutex_unlock(&acl->lock);
 	return -EINVAL;
 }
 
@@ -1882,7 +1882,7 @@
 
 	dwrq->length = 0;
 
-	if (down_interruptible(&acl->sem))
+	if (mutex_lock_interruptible(&acl->lock))
 		return -ERESTARTSYS;
 
 	list_for_each_entry(entry, &acl->mac_list, _list) {
@@ -1891,7 +1891,7 @@
 		dwrq->length++;
 		dst++;
 	}
-	up(&acl->sem);
+	mutex_unlock(&acl->lock);
 	return 0;
 }
 
@@ -1955,11 +1955,11 @@
 	struct mac_entry *entry;
 	int res = 0;
 
-	if (down_interruptible(&acl->sem))
+	if (mutex_lock_interruptible(&acl->lock))
 		return -ERESTARTSYS;
 
 	if (acl->policy == MAC_POLICY_OPEN) {
-		up(&acl->sem);
+		mutex_unlock(&acl->lock);
 		return 1;
 	}
 
@@ -1970,7 +1970,7 @@
 		}
 	}
 	res = (acl->policy == MAC_POLICY_ACCEPT) ? !res : res;
-	up(&acl->sem);
+	mutex_unlock(&acl->lock);
 
 	return res;
 }
Index: linux-2.6/drivers/net/wireless/prism54/islpci_dev.h
===================================================================
--- linux-2.6.orig/drivers/net/wireless/prism54/islpci_dev.h	2008-02-15 20:43:27.000000000 +0100
+++ linux-2.6/drivers/net/wireless/prism54/islpci_dev.h	2008-02-15 20:43:49.000000000 +0100
@@ -55,7 +55,7 @@
    enum { MAC_POLICY_OPEN=0, MAC_POLICY_ACCEPT=1, MAC_POLICY_REJECT=2 } policy;
    struct list_head mac_list;  /* a list of mac_entry */
    int size;   /* size of queue */
-   struct semaphore sem;   /* accessed in ioctls and trap_work */
+   struct mutex lock;   /* accessed in ioctls and trap_work */
 };
 
 struct islpci_membuf {

-- 
Matthias Kaehlcke
Linux System Developer
Barcelona

              We build too many walls and not enough bridges
                             (Isaac Newton)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
