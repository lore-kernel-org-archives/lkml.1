Return-Path: <linux-kernel-owner+w=401wt.eu-S936906AbYBVBvO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936906AbYBVBvO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 20:51:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762138AbYBVBuf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 20:50:35 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:41224 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936634AbYBVBud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 20:50:33 -0500
Message-ID: <47BE2A26.1080806@ak.jp.nec.com>
Date: Fri, 22 Feb 2008 10:49:26 +0900
From: Kohei KaiGai <kaigai@ak.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: greg@kroah.com, morgan@kernel.org, serue@us.ibm.com
CC: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] exporting capability name/code pairs (final)
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[1/3] Add a private data field within kobj_attribute structure.

This patch add a private data field, declared as void *, within kobj_attribute
structure. The _show() and _store() method in the sysfs attribute entries can
refer this information to identify what entry is accessed.
It makes easier to share a single method implementation with several similar
entries, like ones to export the list of capabilities the running kernel
supported.

Signed-off-by: KaiGai Kohei <kaigai@ak.jp.nec.com>
--
 include/linux/kobject.h |    1 +
 include/linux/sysfs.h   |    7 +++++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/include/linux/kobject.h b/include/linux/kobject.h
index caa3f41..57d5bf1 100644
--- a/include/linux/kobject.h
+++ b/include/linux/kobject.h
@@ -130,6 +130,7 @@ struct kobj_attribute {
 			char *buf);
 	ssize_t (*store)(struct kobject *kobj, struct kobj_attribute *attr,
 			 const char *buf, size_t count);
+	void *data;	/* a private field */
 };

 extern struct sysfs_ops kobj_sysfs_ops;
diff --git a/include/linux/sysfs.h b/include/linux/sysfs.h
index 8027104..6f40ff9 100644
--- a/include/linux/sysfs.h
+++ b/include/linux/sysfs.h
@@ -50,6 +50,13 @@ struct attribute_group {
 	.store	= _store,					\
 }

+#define __ATTR_DATA(_name,_mode,_show,_store,_data) {		\
+	.attr = {.name = __stringify(_name), .mode = _mode },   \
+	.show	= _show,					\
+	.store	= _store,					\
+	.data	= (void *)(_data),				\
+}
+	
 #define __ATTR_RO(_name) { \
 	.attr	= { .name = __stringify(_name), .mode = 0444 },	\
 	.show	= _name##_show,					\

-- 
OSS Platform Development Division, NEC
KaiGai Kohei <kaigai@ak.jp.nec.com>
