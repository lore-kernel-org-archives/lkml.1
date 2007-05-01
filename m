Return-Path: <linux-kernel-owner+w=401wt.eu-S1030367AbXEAKRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030367AbXEAKRa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:17:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030346AbXEAKR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:17:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030323AbXEAKR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:17:26 -0400
Subject: [DLM] interface for purge (2/2) [18/34]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, David Teigland <teigland@redhat.com>
In-Reply-To: <1178013376.5462.127.camel@quoit.chygwyn.com>
References: <1178013376.5462.127.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 01 May 2007 11:12:51 +0100
Message-Id: <1178014371.5462.163.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 72c2be776bd6eec5186e316e6d9dd4aab78d314d Mon Sep 17 00:00:00 2001
From: David Teigland <teigland@redhat.com>
Date: Fri, 30 Mar 2007 15:06:16 -0500
Subject: [PATCH] [DLM] interface for purge (2/2)

Add code to accept purge commands from userland.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/lock.h b/fs/dlm/lock.h
index 0843a30..64fc4ec 100644
--- a/fs/dlm/lock.h
+++ b/fs/dlm/lock.h
@@ -41,6 +41,8 @@ int dlm_user_unlock(struct dlm_ls *ls, struct dlm_user_args *ua_tmp,
 	uint32_t flags, uint32_t lkid, char *lvb_in);
 int dlm_user_cancel(struct dlm_ls *ls,  struct dlm_user_args *ua_tmp,
 	uint32_t flags, uint32_t lkid);
+int dlm_user_purge(struct dlm_ls *ls, struct dlm_user_proc *proc,
+	int nodeid, int pid);
 void dlm_clear_proc_locks(struct dlm_ls *ls, struct dlm_user_proc *proc);
 
 static inline int is_master(struct dlm_rsb *r)
diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index c978c67..3e746a6 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -56,6 +56,7 @@ struct dlm_write_request32 {
 	union  {
 		struct dlm_lock_params32 lock;
 		struct dlm_lspace_params lspace;
+		struct dlm_purge_params purge;
 	} i;
 };
 
@@ -92,6 +93,9 @@ static void compat_input(struct dlm_write_request *kb,
 		kb->i.lspace.flags = kb32->i.lspace.flags;
 		kb->i.lspace.minor = kb32->i.lspace.minor;
 		strcpy(kb->i.lspace.name, kb32->i.lspace.name);
+	} else if (kb->cmd == DLM_USER_PURGE) {
+		kb->i.purge.nodeid = kb32->i.purge.nodeid;
+		kb->i.purge.pid = kb32->i.purge.pid;
 	} else {
 		kb->i.lock.mode = kb32->i.lock.mode;
 		kb->i.lock.namelen = kb32->i.lock.namelen;
@@ -320,6 +324,22 @@ fail:
 	return error;
 }
 
+static int device_user_purge(struct dlm_user_proc *proc,
+			     struct dlm_purge_params *params)
+{
+	struct dlm_ls *ls;
+	int error;
+
+	ls = dlm_find_lockspace_local(proc->lockspace);
+	if (!ls)
+		return -ENOENT;
+
+	error = dlm_user_purge(ls, proc, params->nodeid, params->pid);
+
+	dlm_put_lockspace(ls);
+	return error;
+}
+
 static int device_create_lockspace(struct dlm_lspace_params *params)
 {
 	dlm_lockspace_t *lockspace;
@@ -522,6 +542,14 @@ static ssize_t device_write(struct file *file, const char __user *buf,
 		error = device_remove_lockspace(&kbuf->i.lspace);
 		break;
 
+	case DLM_USER_PURGE:
+		if (!proc) {
+			log_print("no locking on control device");
+			goto out_sig;
+		}
+		error = device_user_purge(proc, &kbuf->i.purge);
+		break;
+
 	default:
 		log_print("Unknown command passed to DLM device : %d\n",
 			  kbuf->cmd);
diff --git a/include/linux/dlm_device.h b/include/linux/dlm_device.h
index 2a2dd18..c2735ca 100644
--- a/include/linux/dlm_device.h
+++ b/include/linux/dlm_device.h
@@ -19,7 +19,7 @@
 
 /* Version of the device interface */
 #define DLM_DEVICE_VERSION_MAJOR 5
-#define DLM_DEVICE_VERSION_MINOR 0
+#define DLM_DEVICE_VERSION_MINOR 1
 #define DLM_DEVICE_VERSION_PATCH 0
 
 /* struct passed to the lock write */
@@ -44,6 +44,11 @@ struct dlm_lspace_params {
 	char name[0];
 };
 
+struct dlm_purge_params {
+	__u32 nodeid;
+	__u32 pid;
+};
+
 struct dlm_write_request {
 	__u32 version[3];
 	__u8 cmd;
@@ -53,6 +58,7 @@ struct dlm_write_request {
 	union  {
 		struct dlm_lock_params   lock;
 		struct dlm_lspace_params lspace;
+		struct dlm_purge_params  purge;
 	} i;
 };
 
@@ -76,6 +82,7 @@ struct dlm_lock_result {
 #define DLM_USER_QUERY        3
 #define DLM_USER_CREATE_LOCKSPACE  4
 #define DLM_USER_REMOVE_LOCKSPACE  5
+#define DLM_USER_PURGE        6
 
 /* Arbitrary length restriction */
 #define MAX_LS_NAME_LEN 64
-- 
1.5.1.2



