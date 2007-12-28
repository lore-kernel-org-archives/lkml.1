Return-Path: <linux-kernel-owner+w=401wt.eu-S1753698AbXL1THk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753698AbXL1THk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2007 14:07:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751591AbXL1TH3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Dec 2007 14:07:29 -0500
Received: from verein.lst.de ([213.95.11.210]:39043 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752AbXL1TH2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2007 14:07:28 -0500
Date: Fri, 28 Dec 2007 20:07:18 +0100
From: Christoph Hellwig <hch@lst.de>
To: akpm@osdl.org, linux-kernel@vger.kernel.org
Cc: arndb@de.ibm.com, stefano.brivio@polimi.it
Subject: [PATCH 2/3] libfs: make simple attributes interruptible
Message-ID: <20071228190718.GB4855@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
X-Spam-Score: -0.734 () BAYES_10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use mutex_lock_interruptible in simple_attr_read/write.


Index: linux-2.6.24-rc6/fs/libfs.c
===================================================================
--- linux-2.6.24-rc6.orig/fs/libfs.c	2007-12-28 19:51:56.000000000 +0100
+++ linux-2.6.24-rc6/fs/libfs.c	2007-12-28 19:52:22.000000000 +0100
@@ -634,7 +634,10 @@ ssize_t simple_attr_read(struct file *fi
 	if (!attr->get)
 		return -EACCES;
 
-	mutex_lock(&attr->mutex);
+	ret = mutex_lock_interruptible(&attr->mutex);
+	if (ret)
+		return ret;
+
 	if (*ppos) {		/* continued read */
 		size = strlen(attr->get_buf);
 	} else {		/* first read */
@@ -666,7 +669,10 @@ ssize_t simple_attr_write(struct file *f
 	if (!attr->set)
 		return -EACCES;
 
-	mutex_lock(&attr->mutex);
+	ret = mutex_lock_interruptible(&attr->mutex);
+	if (ret)
+		return ret;
+
 	ret = -EFAULT;
 	size = min(sizeof(attr->set_buf) - 1, len);
 	if (copy_from_user(attr->set_buf, buf, size))
