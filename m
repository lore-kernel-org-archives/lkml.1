Return-Path: <linux-kernel-owner+w=401wt.eu-S1753586AbXFKObT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753586AbXFKObT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 10:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751912AbXFKObF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 10:31:05 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:38990 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbXFKObC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 10:31:02 -0400
Message-ID: <466D5830.9010200@fr.ibm.com>
Date: Mon, 11 Jun 2007 16:12:00 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070530)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelianov <xemul@openvz.org>,
       Badari Pulavarty <pbadari@us.ibm.com>,
       Herbert Poetzl <herbert@13thfloor.at>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Linux Containers <containers@lists.osdl.org>
Subject: PATCH -mm] fix create_new_namespaces() return value
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch modifies create_new_namespaces() to also use the 
errors returned by the copy_*_ns routines and not to systematically 
return ENOMEM.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
Cc: Serge E. Hallyn <serue@us.ibm.com>
Cc: Badari Pulavarty <pbadari@us.ibm.com>
Cc: Pavel Emelianov <xemul@openvz.org>
Cc: Herbert Poetzl <herbert@13thfloor.at>
Cc: Eric W. Biederman <ebiederm@xmission.com>
---
 kernel/nsproxy.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

Index: 2.6.22-rc4-mm2/kernel/nsproxy.c
===================================================================
--- 2.6.22-rc4-mm2.orig/kernel/nsproxy.c
+++ 2.6.22-rc4-mm2/kernel/nsproxy.c
@@ -58,30 +58,41 @@ static struct nsproxy *create_new_namesp
 			struct fs_struct *new_fs)
 {
 	struct nsproxy *new_nsp;
+	int err;
 
 	new_nsp = clone_nsproxy(tsk->nsproxy);
 	if (!new_nsp)
 		return ERR_PTR(-ENOMEM);
 
 	new_nsp->mnt_ns = copy_mnt_ns(flags, tsk->nsproxy->mnt_ns, new_fs);
-	if (IS_ERR(new_nsp->mnt_ns))
+	if (IS_ERR(new_nsp->mnt_ns)) {
+		err = PTR_ERR(new_nsp->mnt_ns);
 		goto out_ns;
+	}
 
 	new_nsp->uts_ns = copy_utsname(flags, tsk->nsproxy->uts_ns);
-	if (IS_ERR(new_nsp->uts_ns))
+	if (IS_ERR(new_nsp->uts_ns)) {
+		err = PTR_ERR(new_nsp->uts_ns);
 		goto out_uts;
+	}
 
 	new_nsp->ipc_ns = copy_ipcs(flags, tsk->nsproxy->ipc_ns);
-	if (IS_ERR(new_nsp->ipc_ns))
+	if (IS_ERR(new_nsp->ipc_ns)) {
+		err = PTR_ERR(new_nsp->ipc_ns);
 		goto out_ipc;
+	}
 
 	new_nsp->pid_ns = copy_pid_ns(flags, tsk->nsproxy->pid_ns);
-	if (IS_ERR(new_nsp->pid_ns))
+	if (IS_ERR(new_nsp->pid_ns)) {
+		err = PTR_ERR(new_nsp->pid_ns);
 		goto out_pid;
+	}
 
 	new_nsp->user_ns = copy_user_ns(flags, tsk->nsproxy->user_ns);
-	if (IS_ERR(new_nsp->user_ns))
+	if (IS_ERR(new_nsp->user_ns)) {
+		err = PTR_ERR(new_nsp->user_ns);
 		goto out_user;
+	}
 
 	return new_nsp;
 
@@ -99,7 +110,7 @@ out_uts:
 		put_mnt_ns(new_nsp->mnt_ns);
 out_ns:
 	kfree(new_nsp);
-	return ERR_PTR(-ENOMEM);
+	return ERR_PTR(err);
 }
 
 /*
