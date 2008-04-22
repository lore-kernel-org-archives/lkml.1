Return-Path: <linux-kernel-owner+w=401wt.eu-S1762502AbYDVLW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762502AbYDVLW2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 07:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762603AbYDVLWH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 07:22:07 -0400
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:36062 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462AbYDVLWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 07:22:05 -0400
Message-ID: <480DC963.8050007@ak.jp.nec.com>
Date: Tue, 22 Apr 2008 20:17:55 +0900
From: KaiGai Kohei <kaigai@ak.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: greg@kroah.com, morgan@kernel.org, serue@us.ibm.com, chrisw@sous-sol.org
CC: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] add a private data field within kobj_attribute structure.
References: <47C25AE9.7080305@ak.jp.nec.com> <480DC80F.3060403@ak.jp.nec.com>
In-Reply-To: <480DC80F.3060403@ak.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 1/3] add a private data field within kobj_attribute structure.

This patch add a private data field, declared as void *, within kobj_attribute
structure. The _show() and _store() method in the sysfs attribute entries can
refer this information to identify what entry is accessed.
It makes easier to share a single method implementation with several similar
entries, like ones to export the list of capabilities the running kernel
supports.

Signed-off-by: KaiGai Kohei <kaigai@ak.jp.nec.com>
--
 Documentation/kobject.txt |    6 ++++++
 include/linux/kobject.h   |    1 +
 include/linux/sysfs.h     |    7 +++++++
 3 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/Documentation/kobject.txt b/Documentation/kobject.txt
index bf3256e..efa5d71 100644
--- a/Documentation/kobject.txt
+++ b/Documentation/kobject.txt
@@ -207,6 +207,12 @@ Both types of attributes used here, with a kobject that has been created
 with the kobject_create_and_add(), can be of type kobj_attribute, so no
 special custom attribute is needed to be created.

+The simple kobj_attribute is prototyped at include/linux/kobject.h, and can
+contain your own show()/store() method and private data.
+When an attribute is accessed, these methods are invoked with kobject,
+kobj_attribute and read/write buffer. The method can refer the private data
+via given kobj_attribute, to show/store itself in the text representation.
+
 See the example module, samples/kobject/kobject-example.c for an
 implementation of a simple kobject and attributes.

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
index 03378e3..c43b0f5 100644
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
