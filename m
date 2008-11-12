Return-Path: <linux-kernel-owner+w=401wt.eu-S1753394AbYKLIfM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394AbYKLIfM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 03:35:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbYKLIei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 03:34:38 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:33708 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663AbYKLIeg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 03:34:36 -0500
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
Subject: [PATCH][cfq-cgroups][04/12] Register or unregister "cfq-cgroups" module.
Date: Wed, 12 Nov 2008 17:26:18 +0900
Message-ID: <001101c944a0$561b0fc0$02512f40$@jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: AclEnsU5YPNAeH0jT4OGyB1wwkbE/wAAX1dw
Content-Language: ja
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  This patch introduce a register/unregister functions of 
  "cfq-cgroups" module.
  A elevator_type variables is inherited one of the original CFQ
  scheduler.


    Signed-off-by: Satoshi UCHIDA <s-uchida@ap.jp.nec.com>

---
 block/cfq-cgroup.c          |  122 +++++++++++++++++++++++++++++++++++++++++++
 block/cfq-iosched.c         |    2 +-
 include/linux/cfq-iosched.h |    2 +
 3 files changed, 125 insertions(+), 1 deletions(-)

diff --git a/block/cfq-cgroup.c b/block/cfq-cgroup.c
index 3deef41..aaa00ef 100644
--- a/block/cfq-cgroup.c
+++ b/block/cfq-cgroup.c
@@ -15,13 +15,135 @@
 #include <linux/cgroup.h>
 #include <linux/cfq-iosched.h>
 
+/*
+ * sysfs parts below -->
+ */
+static ssize_t
+cfq_cgroup_var_show(char *page, struct cfq_data *cfqd,
+		    int (func)(struct cfq_data *))
+{
+	int val, retval = 0;
+
+	val = func(cfqd);
+
+	retval = snprintf(page, PAGE_SIZE, "%d\n", val);
+
+	return retval;
+}
+
+#define SHOW_FUNCTION(__FUNC, __VAR, __CONV)				\
+static int val_transrate_##__FUNC(struct cfq_data *cfqd)		\
+{									\
+	if (__CONV)							\
+		return jiffies_to_msecs(cfqd->__VAR);			\
+	else								\
+		return cfqd->__VAR;					\
+}									\
+static ssize_t __FUNC(elevator_t *e, char *page)			\
+{									\
+	struct cfq_data *cfqd = e->elevator_data;			\
+									\
+	return cfq_cgroup_var_show((page), (cfqd),			\
+				   val_transrate_##__FUNC);		\
+}
+SHOW_FUNCTION(cfq_cgroup_quantum_show, cfq_quantum, 0);
+SHOW_FUNCTION(cfq_cgroup_fifo_expire_sync_show, cfq_fifo_expire[1], 1);
+SHOW_FUNCTION(cfq_cgroup_fifo_expire_async_show, cfq_fifo_expire[0], 1);
+SHOW_FUNCTION(cfq_cgroup_back_seek_max_show, cfq_back_max, 0);
+SHOW_FUNCTION(cfq_cgroup_back_seek_penalty_show, cfq_back_penalty, 0);
+SHOW_FUNCTION(cfq_cgroup_slice_idle_show, cfq_slice_idle, 1);
+SHOW_FUNCTION(cfq_cgroup_slice_sync_show, cfq_slice[1], 1);
+SHOW_FUNCTION(cfq_cgroup_slice_async_show, cfq_slice[0], 1);
+SHOW_FUNCTION(cfq_cgroup_slice_async_rq_show, cfq_slice_async_rq, 0);
+#undef SHOW_FUNCTION
+
+static ssize_t
+cfq_cgroup_var_store(const char *page, size_t count, struct cfq_data *cfqd,
+		     void (func)(struct cfq_data *, unsigned int))
+{
+	int err;
+	unsigned long val;
+
+	err = strict_strtoul(page, 10, &val);
+	if (err)
+		return 0;
+
+	func(cfqd, val);
+
+	return count;
+}
+
+#define STORE_FUNCTION(__FUNC, __VAR, MIN, MAX, __CONV)			\
+static void val_transrate_##__FUNC(struct cfq_data *cfqd,		\
+				   unsigned int __data)			\
+{									\
+	if (__data < (MIN))						\
+		__data = (MIN);						\
+	else if (__data > (MAX))					\
+		__data = (MAX);						\
+	if (__CONV)							\
+		cfqd->__VAR = msecs_to_jiffies(__data);			\
+	else								\
+		cfqd->__VAR = __data;					\
+}									\
+static ssize_t __FUNC(elevator_t *e, const char *page, size_t count)	\
+{									\
+	struct cfq_data *cfqd = e->elevator_data;			\
+	int ret = cfq_cgroup_var_store((page), count, cfqd,		\
+				      val_transrate_##__FUNC);		\
+	return ret;							\
+}
+STORE_FUNCTION(cfq_cgroup_quantum_store, cfq_quantum, 1, UINT_MAX, 0);
+STORE_FUNCTION(cfq_cgroup_fifo_expire_sync_store, cfq_fifo_expire[1], 1,
+		UINT_MAX, 1);
+STORE_FUNCTION(cfq_cgroup_fifo_expire_async_store, cfq_fifo_expire[0], 1,
+		UINT_MAX, 1);
+STORE_FUNCTION(cfq_cgroup_back_seek_max_store, cfq_back_max, 0, UINT_MAX, 0);
+STORE_FUNCTION(cfq_cgroup_back_seek_penalty_store, cfq_back_penalty, 1,
+		UINT_MAX, 0);
+STORE_FUNCTION(cfq_cgroup_slice_idle_store, cfq_slice_idle,
+		0, UINT_MAX, 1);
+STORE_FUNCTION(cfq_cgroup_slice_sync_store, cfq_slice[1], 1, UINT_MAX, 1);
+STORE_FUNCTION(cfq_cgroup_slice_async_store, cfq_slice[0], 1, UINT_MAX, 1);
+STORE_FUNCTION(cfq_cgroup_slice_async_rq_store, cfq_slice_async_rq, 1,
+		UINT_MAX, 0);
+#undef STORE_FUNCTION
+
+#define CFQ_CGROUP_ATTR(name)					\
+	__ATTR(name, S_IRUGO|S_IWUSR, cfq_cgroup_##name##_show,	\
+	       cfq_cgroup_##name##_store)
+
+static struct elv_fs_entry cfq_cgroup_attrs[] = {
+	CFQ_CGROUP_ATTR(quantum),
+	CFQ_CGROUP_ATTR(fifo_expire_sync),
+	CFQ_CGROUP_ATTR(fifo_expire_async),
+	CFQ_CGROUP_ATTR(back_seek_max),
+	CFQ_CGROUP_ATTR(back_seek_penalty),
+	CFQ_CGROUP_ATTR(slice_sync),
+	CFQ_CGROUP_ATTR(slice_async),
+	CFQ_CGROUP_ATTR(slice_async_rq),
+	CFQ_CGROUP_ATTR(slice_idle),
+	__ATTR_NULL
+};
+
+static struct elevator_type iosched_cfq_cgroup = {
+	.elevator_attrs	= cfq_cgroup_attrs,
+	.elevator_name	= "cfq-cgroups",
+	.elevator_owner	= THIS_MODULE,
+};
+
 static int __init cfq_cgroup_init(void)
 {
+	iosched_cfq_cgroup.ops = iosched_cfq.ops;
+
+	elv_register(&iosched_cfq_cgroup);
+
 	return 0;
 }
 
 static void __exit cfq_cgroup_exit(void)
 {
+	elv_unregister(&iosched_cfq_cgroup);
 }
 
 module_init(cfq_cgroup_init);
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index b726e85..e105827 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -2332,7 +2332,7 @@ static struct elv_fs_entry cfq_attrs[] = {
 	__ATTR_NULL
 };
 
-static struct elevator_type iosched_cfq = {
+struct elevator_type iosched_cfq = {
 	.ops = {
 		.elevator_merge_fn = 		cfq_merge,
 		.elevator_merged_fn =		cfq_merged_request,
diff --git a/include/linux/cfq-iosched.h b/include/linux/cfq-iosched.h
index 50003f7..a28ef00 100644
--- a/include/linux/cfq-iosched.h
+++ b/include/linux/cfq-iosched.h
@@ -82,4 +82,6 @@ struct cfq_data {
 	struct cfq_driver_data *cfqdd;
 };
 
+extern struct elevator_type iosched_cfq;
+
 #endif  /* _LINUX_CFQ_IOSCHED_H */
-- 
1.5.6.5


