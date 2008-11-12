Return-Path: <linux-kernel-owner+w=401wt.eu-S1753197AbYKLIi1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197AbYKLIi1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 03:38:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753543AbYKLIha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 03:37:30 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:46004 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753683AbYKLIh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 03:37:28 -0500
From: "Satoshi UCHIDA" <s-uchida@ap.jp.nec.com>
To: <linux-kernel@vger.kernel.org>, <containers@lists.linux-foundation.org>,
       <virtualization@lists.linux-foundation.org>, <jens.axboe@oracle.com>,
       "'Ryo Tsuruta'" <ryov@valinux.co.jp>,
       "'Andrea Righi'" <righi.andrea@gmail.com>, <ngupta@google.com>,
       <fernando@oss.ntt.co.jp>, <vtaras@openvz.org>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
       "'SUGAWARA Tomoyoshi'" <tom-sugawara@ap.jp.nec.com>,
       <menage@google.com>, <balbir@linux.vnet.ibm.com>
References: <000c01c9449e$c5bcdc20$51369460$@jp.nec.com>
In-Reply-To: <000c01c9449e$c5bcdc20$51369460$@jp.nec.com>
Subject: [PATCH][cfq-cgroups][12/12] Interface for parameter of cfq driver data
Date: Wed, 12 Nov 2008 17:31:39 +0900
Message-ID: <001901c944a1$15798a40$406c9ec0$@jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AclEnsU5YPNAeH0jT4OGyB1wwkbE/wAAkArg
Content-Language: ja
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8bdb6a318fbc266cf359aea699c97a964baeff35 Mon Sep 17 00:00:00 2001
From: Satoshi UCHIDA <s-uchida@ap.jp.nec.com>
Date: Fri, 31 Oct 2008 20:49:57 +0900
Subject: [PATCH][cfq-cgroups] Interface for parameter of cfq driver data

  This patch add a interface for parameter of cfq driver data.
 
 
    Signed-off-by: Satoshi UCHIDA <s-uchida@ap.jp.nec.com>

---
 block/cfq-cgroup.c |   59 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 58 insertions(+), 1 deletions(-)

diff --git a/block/cfq-cgroup.c b/block/cfq-cgroup.c
index 4938fa0..776874d 100644
--- a/block/cfq-cgroup.c
+++ b/block/cfq-cgroup.c
@@ -1028,6 +1028,62 @@ STORE_FUNCTION(cfq_cgroup_slice_async_rq_store, cfq_slice_async_rq, 1,
 STORE_FUNCTION(cfq_cgroup_ioprio_store, ioprio, 0, CFQ_CGROUP_MAX_IOPRIO, 0);
 #undef STORE_FUNCTION
 
+static ssize_t
+cfq_cgroup_var_show2(unsigned int var, char *page)
+{
+	return snprintf(page, PAGE_SIZE, "%d\n", var);
+}
+
+static ssize_t
+cfq_cgroup_var_store2(unsigned int *var, const char *page, size_t count)
+{
+	int err;
+	char *p = (char *) page;
+	unsigned long new_var;
+
+	err = strict_strtoul(p, 10, &new_var);
+	if (err)
+		count = 0;
+
+	*var = new_var;
+
+	return count;
+}
+
+#define SHOW_FUNCTION2(__FUNC, __VAR, __CONV)				\
+static ssize_t __FUNC(elevator_t *e, char *page)			\
+{									\
+	struct cfq_data *cfqd = e->elevator_data;			\
+	struct cfq_driver_data *cfqdd = cfqd->cfqdd;			\
+	unsigned int __data = __VAR;					\
+	if (__CONV)							\
+		__data = jiffies_to_msecs(__data);			\
+	return cfq_cgroup_var_show2(__data, (page));			\
+}
+SHOW_FUNCTION2(cfq_cgroup_slice_cgroup_show, cfqdd->cfq_cgroup_slice, 1);
+#undef SHOW_FUNCTION2
+
+#define STORE_FUNCTION2(__FUNC, __PTR, MIN, MAX, __CONV)		\
+static ssize_t __FUNC(elevator_t *e, const char *page, size_t count)	\
+{									\
+	struct cfq_data *cfqd = e->elevator_data;			\
+	struct cfq_driver_data *cfqdd = cfqd->cfqdd;			\
+	unsigned int __data;						\
+	int ret = cfq_cgroup_var_store2(&__data, (page), count);	\
+	if (__data < (MIN))						\
+		__data = (MIN);						\
+	else if (__data > (MAX))					\
+		__data = (MAX);						\
+	if (__CONV)							\
+		*(__PTR) = msecs_to_jiffies(__data);			\
+	else								\
+		*(__PTR) = __data;					\
+	return ret;							\
+}
+STORE_FUNCTION2(cfq_cgroup_slice_cgroup_store, &cfqdd->cfq_cgroup_slice, 1,
+		UINT_MAX, 1);
+#undef STORE_FUNCTION2
+
 #define CFQ_CGROUP_ATTR(name)					\
 	__ATTR(name, S_IRUGO|S_IWUSR, cfq_cgroup_##name##_show,	\
 	       cfq_cgroup_##name##_store)
@@ -1043,6 +1099,7 @@ static struct elv_fs_entry cfq_cgroup_attrs[] = {
 	CFQ_CGROUP_ATTR(slice_async_rq),
 	CFQ_CGROUP_ATTR(slice_idle),
 	CFQ_CGROUP_ATTR(ioprio),
+	CFQ_CGROUP_ATTR(slice_cgroup),
 	__ATTR_NULL
 };
 
-- 
1.5.6.5


