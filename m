Return-Path: <linux-kernel-owner+w=401wt.eu-S1764470AbYBTGU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764470AbYBTGU7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 01:20:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754256AbYBTGUs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 01:20:48 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:56533 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752436AbYBTGUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 01:20:46 -0500
Message-ID: <47BBC682.1040106@ak.jp.nec.com>
Date: Wed, 20 Feb 2008 15:19:46 +0900
From: Kohei KaiGai <kaigai@ak.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: "Serge E. Hallyn" <serue@us.ibm.com>, Li Zefan <lizf@cn.fujitsu.com>,
       akpm@osdl.org, "Andrew G. Morgan" <morgan@kernel.org>,
       jmorris@namei.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, adobriyan@gmail.com
Subject: Re: [PATCH] exporting capability code/name pairs (try #6.1)
References: <47B4ED1B.6070206@ak.jp.nec.com> <47B4F1C5.9010408@cn.fujitsu.com> <47B4FFE0.3000702@ak.jp.nec.com> <20080215183802.GA3925@sergelap.austin.ibm.com> <20080215185003.GA7495@kroah.com> <47B92FF5.1080301@ak.jp.nec.com> <20080218074056.GA19915@kroah.com> <47B945BA.2060107@ak.jp.nec.com> <20080219161610.GA3344@kroah.com> <47BBAEE3.6040301@ak.jp.nec.com> <20080220050236.GA20181@kroah.com> <47BBBCC8.7070707@ak.jp.nec.com>
In-Reply-To: <47BBBCC8.7070707@ak.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Could you also modify the documentation and the sample code to use this
>> new field, showing how it is to be used, and testing that it works
>> properly at the same time?
> 
> OK, Please wait for a while.

[3/3] Add a new example of kobject/attribute

The attached patch can provide a new exmple to use kobject and attribute.
The _show() and _store() method can refer/store the private data field of
kobj_attribute structure to know what entries are refered by users.
It will make easier to share a single _show()/_store() method with several
entries.

Signed-off-by: KaiGai Kohei <kaigai@ak.jp.nec.com>
--
 samples/kobject/kobject-example.c |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/samples/kobject/kobject-example.c b/samples/kobject/kobject-example.c
index 08d0d3f..f99d734 100644
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
+	return scnprintf(buf, PAGE_SIZE, "%d\n", (int) attr->data);
+}
+
+static ssize_t integer_store(struct kobject *kobj,
+			     struct kobj_attribute *attr,
+			     const char *buf, size_t count)
+{
+	int code;
+
+	sscanf(buf, "%du", &code);
+	attr->data = (void *) code;
+	return count;
+}
+
+static struct kobj_attribute hoge_attribute =
+	__ATTR_DATA(hoge, 0666, integer_show, integer_store, 123);
+static struct kobj_attribute piyo_attribute =
+	__ATTR_DATA(piyo, 0666, integer_show, integer_store, 456);
+static struct kobj_attribute fuga_attribute =
+	__ATTR_DATA(fuga, 0444, integer_show, NULL, 789);

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
