Return-Path: <linux-kernel-owner+w=401wt.eu-S1754876AbYKTLRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbYKTLRL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 06:17:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbYKTLQ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 06:16:57 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:50841 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753468AbYKTLQ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 06:16:56 -0500
Message-ID: <4925467C.9000509@cn.fujitsu.com>
Date: Thu, 20 Nov 2008 19:14:04 +0800
From: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Andrea Righi <righi.andrea@gmail.com>, Ryo Tsuruta <ryov@valinux.co.jp>,
       Hirokazu Takahashi <taka@valinux.co.jp>
CC: menage@google.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [PATCH 5/7] announce tasks moving in bio-cgroup
References: <4925445C.10302@cn.fujitsu.com>
In-Reply-To: <4925445C.10302@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some subsystems may be of interest to task moving in bio-cgroups.
So just announce each task moving.

Signed-of-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
---
 include/linux/biotrack.h |    9 +++++++++
 mm/biotrack.c            |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/include/linux/biotrack.h b/include/linux/biotrack.h
index 371d263..546017c 100644
--- a/include/linux/biotrack.h
+++ b/include/linux/biotrack.h
@@ -7,6 +7,15 @@
 
 #ifdef	CONFIG_CGROUP_BIO
 
+struct tsk_move_msg {
+	int old_id;
+	int new_id;
+	struct task_struct *tsk;
+};
+
+extern int register_biocgroup_notifier(struct notifier_block *nb);
+extern int unregister_biocgroup_notifier(struct notifier_block *nb);
+
 struct io_context;
 struct block_device;
 
diff --git a/mm/biotrack.c b/mm/biotrack.c
index ba6b45b..979efcd 100644
--- a/mm/biotrack.c
+++ b/mm/biotrack.c
@@ -21,6 +21,22 @@
 #include <linux/blkdev.h>
 #include <linux/biotrack.h>
 
+#define MOVETASK 0
+static BLOCKING_NOTIFIER_HEAD(biocgroup_chain);
+
+int register_biocgroup_notifier(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_register(&biocgroup_chain, nb);
+}
+EXPORT_SYMBOL(register_biocgroup_notifier);
+
+int unregister_biocgroup_notifier(struct notifier_block *nb)
+{
+	return blocking_notifier_chain_unregister(&biocgroup_chain, nb);
+}
+EXPORT_SYMBOL(unregister_biocgroup_notifier);
+
+
 /*
  * The block I/O tracking mechanism is implemented on the cgroup memory
  * controller framework. It helps to find the the owner of an I/O request 
@@ -299,11 +315,27 @@ static int bio_cgroup_populate(struct cgroup_subsys *ss, struct cgroup *cgrp)
 	return cgroup_add_files(cgrp, ss, bio_files, ARRAY_SIZE(bio_files));
 }
 
+static void bio_cgroup_attach(struct cgroup_subsys *ss,
+			      struct cgroup *cont, struct cgroup *oldcont,
+			      struct task_struct *tsk)
+{
+	struct tsk_move_msg tmm;
+	struct bio_cgroup *old_biog, *new_biog;
+	
+	old_biog = cgroup_bio(oldcont);
+	new_biog = cgroup_bio(cont);
+	tmm.old_id = old_biog->id;
+	tmm.new_id = new_biog->id;
+	tmm.tsk = tsk;
+	blocking_notifier_call_chain(&biocgroup_chain, MOVETASK, &tmm);
+}
+
 struct cgroup_subsys bio_cgroup_subsys = {
 	.name		= "bio",
 	.create		= bio_cgroup_create,
 	.destroy	= bio_cgroup_destroy,
 	.populate	= bio_cgroup_populate,
+	.attach         = bio_cgroup_attach,
 	.subsys_id	= bio_cgroup_subsys_id,
 };
 
-- 1.5.4.rc3 

