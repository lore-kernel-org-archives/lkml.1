Return-Path: <linux-kernel-owner+w=401wt.eu-S1757647AbXKFMYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757647AbXKFMYS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 07:24:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbXKFMYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 07:24:01 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:45131 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755599AbXKFMYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 07:24:00 -0500
Date: Tue, 6 Nov 2007 15:23:50 +0300
From: Alexey Dobriyan <adobriyan@sw.ru>
To: davem@davemloft.net
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, devel@openvz.org
Subject: [PATCH -net 2/2] Put proc_net_create() on death row
Message-ID: <20071106122350.GB6215@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

proc_net_create() stands on the way of shrinking the number of
interfaces one can use for /proc files, namely, it uses ->get_info
hook which will be converted, deprecated and deleted on its own
schedule.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 Documentation/feature-removal-schedule.txt |    9 +++++++++
 include/linux/proc_fs.h                    |    8 ++++++--
 2 files changed, 15 insertions(+), 2 deletions(-)

--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -130,6 +130,15 @@ Who:	Christoph Hellwig <hch@lst.de>
 
 ---------------------------
 
+What:	proc_net_create()
+When:	2.6.25
+Why:	proc_net_create() stands on the way of shrinking the number of
+	interfaces one can use for /proc files, namely, it uses ->get_info
+	hook which will be deleted later.
+Who:	Alexey Dobriyan <adobriyan@gmail.com>
+
+---------------------------
+
 What:	CONFIG_FORCED_INLINING
 When:	June 2006
 Why:	Config option is there to see if gcc is good enough. (in january
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -196,7 +196,7 @@ static inline struct proc_dir_entry *create_proc_info_entry(const char *name,
 	return res;
 }
 
-extern struct proc_dir_entry *proc_net_create(struct net *net,
+extern __deprecated struct proc_dir_entry *proc_net_create(struct net *net,
 	const char *name, mode_t mode, get_info_t *get_info);
 extern struct proc_dir_entry *proc_net_fops_create(struct net *net,
 	const char *name, mode_t mode, const struct file_operations *fops);
@@ -208,7 +208,11 @@ extern void proc_net_remove(struct net *net, const char *name);
 #define proc_bus NULL
 
 #define proc_net_fops_create(net, name, mode, fops)  ({ (void)(mode), NULL; })
-#define proc_net_create(net, name, mode, info)	({ (void)(mode), NULL; })
+static inline __deprecated struct proc_dir_entry *proc_net_create(
+	struct net *net, const char *name, mode_t mode, get_info_t *get_info)
+{
+	return NULL;
+}
 static inline void proc_net_remove(struct net *net, const char *name) {}
 
 static inline void proc_flush_task(struct task_struct *task)

