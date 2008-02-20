Return-Path: <linux-kernel-owner+w=401wt.eu-S1760158AbYBTGSu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760158AbYBTGSu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 01:18:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754256AbYBTGSk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 01:18:40 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:55661 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbYBTGSj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 01:18:39 -0500
Message-ID: <47BBC5A7.5080802@ak.jp.nec.com>
Date: Wed, 20 Feb 2008 15:16:07 +0900
From: Kohei KaiGai <kaigai@ak.jp.nec.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: "Serge E. Hallyn" <serue@us.ibm.com>, Li Zefan <lizf@cn.fujitsu.com>,
       akpm@osdl.org, "Andrew G. Morgan" <morgan@kernel.org>,
       jmorris@namei.org, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, adobriyan@gmail.com
Subject: Re: [PATCH] exporting capability code/name pairs (try #6.1)
References: <20080212180859.GA12876@sergelap.austin.ibm.com> <47B2A3F3.8060701@ak.jp.nec.com> <47B4ED1B.6070206@ak.jp.nec.com> <47B4F1C5.9010408@cn.fujitsu.com> <47B4FFE0.3000702@ak.jp.nec.com> <20080215183802.GA3925@sergelap.austin.ibm.com> <20080215185003.GA7495@kroah.com> <47B92FF5.1080301@ak.jp.nec.com> <20080218074056.GA19915@kroah.com> <47B945BA.2060107@ak.jp.nec.com> <20080219161610.GA3344@kroah.com> <47BBAEE3.6040301@ak.jp.nec.com>
In-Reply-To: <47BBAEE3.6040301@ak.jp.nec.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Sorry, I sent a patch with TABs translated into spaces.]

[1/3] Add a private data field within kobj_attribute structure.

This patch add a private data field, declared as void *, within kobj_attribute
structure. Anyone wants to use sysfs can store their private data to refer at
_show() and _store() method.
It enables to share a single method function with several similar entries,
like ones to export the list of capabilities the running kernel supported.

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
