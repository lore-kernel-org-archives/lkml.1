Return-Path: <linux-kernel-owner+w=401wt.eu-S1755932AbYDHL1U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932AbYDHL1U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 07:27:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754807AbYDHLTu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 07:19:50 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:33838 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754788AbYDHLTt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 07:19:49 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>
Subject: [PATCH 1/29] proc: introduce proc_create_data to setup de->data
Date: Tue,  8 Apr 2008 15:19:08 +0400
Message-Id: <1207653576-12640-1-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1207653508.7171.18.camel@iris.sw.ru>
References: <1207653508.7171.18.camel@iris.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problem is the same as for de->proc_fops. Right now PDE becomes visible
without data set. So, the entry could be looked up without data. This, in
most cases, will simply OOPS.

proc_create_data call is created to address this issue. proc_create now
becomes a wrapper around it.

Signed-off-by: Denis V. Lunev <den@openvz.org>
---
 fs/proc/generic.c       |    8 +++++---
 fs/proc/root.c          |    2 +-
 include/linux/proc_fs.h |   17 +++++++++++++++--
 3 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 8b406e2..b9ec046 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -680,9 +680,10 @@ struct proc_dir_entry *create_proc_entry(const char *name, mode_t mode,
 	return ent;
 }
 
-struct proc_dir_entry *proc_create(const char *name, mode_t mode,
-				   struct proc_dir_entry *parent,
-				   const struct file_operations *proc_fops)
+struct proc_dir_entry *proc_create_data(const char *name, mode_t mode,
+					struct proc_dir_entry *parent,
+					const struct file_operations *proc_fops,
+					void *data)
 {
 	struct proc_dir_entry *pde;
 	nlink_t nlink;
@@ -703,6 +704,7 @@ struct proc_dir_entry *proc_create(const char *name, mode_t mode,
 	if (!pde)
 		goto out;
 	pde->proc_fops = proc_fops;
+	pde->data = data;
 	if (proc_register(parent, pde) < 0)
 		goto out_free;
 	return pde;
diff --git a/fs/proc/root.c b/fs/proc/root.c
index c741b45..9511753 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -230,5 +230,5 @@ void pid_ns_release_proc(struct pid_namespace *ns)
 EXPORT_SYMBOL(proc_symlink);
 EXPORT_SYMBOL(proc_mkdir);
 EXPORT_SYMBOL(create_proc_entry);
-EXPORT_SYMBOL(proc_create);
+EXPORT_SYMBOL(proc_create_data);
 EXPORT_SYMBOL(remove_proc_entry);
diff --git a/include/linux/proc_fs.h b/include/linux/proc_fs.h
index 2183ffd..c96a791 100644
--- a/include/linux/proc_fs.h
+++ b/include/linux/proc_fs.h
@@ -118,9 +118,10 @@ void de_put(struct proc_dir_entry *de);
 
 extern struct proc_dir_entry *create_proc_entry(const char *name, mode_t mode,
 						struct proc_dir_entry *parent);
-struct proc_dir_entry *proc_create(const char *name, mode_t mode,
+struct proc_dir_entry *proc_create_data(const char *name, mode_t mode,
 				struct proc_dir_entry *parent,
-				const struct file_operations *proc_fops);
+				const struct file_operations *proc_fops,
+				void *data);
 extern void remove_proc_entry(const char *name, struct proc_dir_entry *parent);
 
 extern struct vfsmount *proc_mnt;
@@ -175,6 +176,12 @@ extern struct proc_dir_entry *proc_mkdir(const char *,struct proc_dir_entry *);
 extern struct proc_dir_entry *proc_mkdir_mode(const char *name, mode_t mode,
 			struct proc_dir_entry *parent);
 
+static inline struct proc_dir_entry *proc_create(const char *name, mode_t mode,
+	struct proc_dir_entry *parent, const struct file_operations *proc_fops)
+{
+	return proc_create_data(name, mode, parent, proc_fops, NULL);
+}
+
 static inline struct proc_dir_entry *create_proc_read_entry(const char *name,
 	mode_t mode, struct proc_dir_entry *base, 
 	read_proc_t *read_proc, void * data)
@@ -224,6 +231,12 @@ static inline struct proc_dir_entry *proc_create(const char *name,
 {
 	return NULL;
 }
+static inline struct proc_dir_entry *proc_create_data(const char *name,
+	mode_t mode, struct proc_dir_entry *parent,
+	const struct file_operations *proc_fops, void *data)
+{
+	return NULL;
+}
 #define remove_proc_entry(name, parent) do {} while (0)
 
 static inline struct proc_dir_entry *proc_symlink(const char *name,
-- 
1.5.3.rc5

