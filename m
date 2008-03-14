Return-Path: <linux-kernel-owner+w=401wt.eu-S1756169AbYCNJsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169AbYCNJsG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 05:48:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752057AbYCNJrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 05:47:55 -0400
Received: from sacred.ru ([62.205.161.221]:44375 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751902AbYCNJry (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 05:47:54 -0400
Message-ID: <47DA48D5.8040902@openvz.org>
Date: Fri, 14 Mar 2008 12:43:49 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] Cgroups: add the trigger callback to struct cftype
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Fri, 14 Mar 2008 12:43:50 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trigger callback can be used to receive a kick-up from the
user space. The string written is ignored.

The cftype->private is used for multiplexing events.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Acked-by: Paul Menage <menage@google.com>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

---
 include/linux/cgroup.h |    8 ++++++++
 kernel/cgroup.c        |    4 ++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 785a01c..2d1d151 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -243,6 +243,14 @@ struct cftype {
 	 */
 	int (*write_s64) (struct cgroup *cgrp, struct cftype *cft, s64 val);
 
+	/*
+	 * trigger() callback can be used to get some kick from the
+	 * userspace, when the actual string written is not important
+	 * at all. The private field can be used to determine the
+	 * kick type for multiplexing.
+	 */
+	int (*trigger)(struct cgroup *cgrp, unsigned int event);
+
 	int (*release) (struct inode *inode, struct file *file);
 };
 
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e8e8ec4..f2d8f25 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1410,6 +1410,10 @@ static ssize_t cgroup_file_write(struct file *file, const char __user *buf,
 		return cft->write(cgrp, cft, file, buf, nbytes, ppos);
 	if (cft->write_u64 || cft->write_s64)
 		return cgroup_write_X64(cgrp, cft, file, buf, nbytes, ppos);
+	if (cft->trigger) {
+		int ret = cft->trigger(cgrp, (unsigned int)cft->private);
+		return ret ? ret : nbytes;
+	}
 	return -EINVAL;
 }
 
-- 
1.5.3.4


