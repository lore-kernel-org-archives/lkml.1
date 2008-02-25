Return-Path: <linux-kernel-owner+w=401wt.eu-S1756860AbYBYGKx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756860AbYBYGKx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 01:10:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752833AbYBYGKn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 01:10:43 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:46873 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbYBYGKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 01:10:42 -0500
Message-ID: <47C25BD3.3020205@ak.jp.nec.com>
Date: Mon, 25 Feb 2008 15:10:27 +0900
From: Kohei KaiGai <kaigai@ak.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: greg@kroah.com, morgan@kernel.org, serue@us.ibm.com
CC: Kohei KaiGai <kaigai@ak.jp.nec.com>, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] add a private data field within kobj_attribute structure
 (final#2)
References: <47C25AE9.7080305@ak.jp.nec.com>
In-Reply-To: <47C25AE9.7080305@ak.jp.nec.com>
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
