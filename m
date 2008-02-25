Return-Path: <linux-kernel-owner+w=401wt.eu-S1760581AbYBYGLi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760581AbYBYGLi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 01:11:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758669AbYBYGLH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 01:11:07 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:50534 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbYBYGLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 01:11:02 -0500
Message-ID: <47C25BEB.3040405@ak.jp.nec.com>
Date: Mon, 25 Feb 2008 15:10:51 +0900
From: Kohei KaiGai <kaigai@ak.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Kohei KaiGai <kaigai@ak.jp.nec.com>
CC: greg@kroah.com, morgan@kernel.org, serue@us.ibm.com,
       linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] a new example to use kobject/kobj_attribute (final#2)
References: <47C25AE9.7080305@ak.jp.nec.com>
In-Reply-To: <47C25AE9.7080305@ak.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 3/3] a new example to use kobject/kobj_attribute

This patch can provide a new exmple to use kobject and attribute.
The _show() and _store() method can refer/store the private data field of
kobj_attribute structure to know what entries are accessed by users.
It will make easier to share a single _show()/_store() method with several
entries.

Signed-off-by: KaiGai Kohei <kaigai@ak.jp.nec.com>
--
 samples/kobject/kobject-example.c |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/samples/kobject/kobject-example.c b/samples/kobject/kobject-example.c
index 08d0d3f..5486a14 100644
--- a/samples/kobject/kobject-example.c
+++ b/samples/kobject/kobject-example.c
@@ -77,6 +77,35 @@ static struct kobj_attribute baz_attribute =
 static struct kobj_attribute bar_attribute =
 	__ATTR(bar, 0666, b_show, b_store);

+/*
+ * You can store a private data within 'data' field of kobj_attribute.
+ * It enables to share a single _show() or _store() method with several
+ * entries.
+ */
+static ssize_t integer_show(struct kobject *kobj,
+			    struct kobj_attribute *attr,
+			    char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%ld\n", (long) attr->data);
+}
+
+static ssize_t integer_store(struct kobject *kobj,
+			     struct kobj_attribute *attr,
+			     const char *buf, size_t count)
+{
+	long code;
+
+	sscanf(buf, "%ld", &code);
+	attr->data = (void *) code;
+	return count;
+}
+
+static struct kobj_attribute hoge_attribute =
+	__ATTR_DATA(hoge, 0666, integer_show, integer_store, (long) 123);
+static struct kobj_attribute piyo_attribute =
+	__ATTR_DATA(piyo, 0666, integer_show, integer_store, (long) 456);
+static struct kobj_attribute fuga_attribute =
+	__ATTR_DATA(fuga, 0444, integer_show, NULL, (long) 789);

 /*
  * Create a group of attributes so that we can create and destory them all
@@ -86,6 +115,9 @@ static struct attribute *attrs[] = {
 	&foo_attribute.attr,
 	&baz_attribute.attr,
 	&bar_attribute.attr,
+	&hoge_attribute.attr,
+	&piyo_attribute.attr,
+	&fuga_attribute.attr,
 	NULL,	/* need to NULL terminate the list of attributes */
 };

-- 
OSS Platform Development Division, NEC
KaiGai Kohei <kaigai@ak.jp.nec.com>
