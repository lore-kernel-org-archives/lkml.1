Return-Path: <linux-kernel-owner+w=401wt.eu-S1031653AbXEAKIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031653AbXEAKIZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031648AbXEAKIZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:08:25 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49030 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031653AbXEAKIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:08:23 -0400
Subject: [DLM] Don't delete misc device if lockspace removal fails [7/43]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, Patrick Caulfield <pcaulfie@redhat.com>
In-Reply-To: <1178013376.5462.127.camel@quoit.chygwyn.com>
References: <1178013376.5462.127.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 01 May 2007 11:03:49 +0100
Message-Id: <1178013829.5462.140.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 254da030dfb1b13d42d07e4292a4790d88c6874f Mon Sep 17 00:00:00 2001
From: Patrick Caulfield <pcaulfie@redhat.com>
Date: Wed, 21 Mar 2007 09:23:53 +0000
Subject: [PATCH] [DLM] Don't delete misc device if lockspace removal fails

Currently if the lockspace removal fails the misc device associated with a
lockspace is left deleted. After that there is no way to access the orphaned
lockspace from userland.

This patch recreates the misc device if th dlm_release_lockspace fails. I
believe this is better than attempting to remove the lockspace first because
that leaves an unattached device lying around. The potential gap in which there
is no access to the lockspace between removing the misc device and recreating it
is acceptable ... after all the application is trying to remove it, and only new
users of the lockspace will be affected.

Signed-Off-By: Patrick Caulfield <pcaulfie@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/user.c b/fs/dlm/user.c
index 3870150..27a75ce 100644
--- a/fs/dlm/user.c
+++ b/fs/dlm/user.c
@@ -286,11 +286,34 @@ static int device_user_unlock(struct dlm_user_proc *proc,
 	return error;
 }
 
+static int create_misc_device(struct dlm_ls *ls, char *name)
+{
+	int error, len;
+
+	error = -ENOMEM;
+	len = strlen(name) + strlen(name_prefix) + 2;
+	ls->ls_device.name = kzalloc(len, GFP_KERNEL);
+	if (!ls->ls_device.name)
+		goto fail;
+
+	snprintf((char *)ls->ls_device.name, len, "%s_%s", name_prefix,
+		 name);
+	ls->ls_device.fops = &device_fops;
+	ls->ls_device.minor = MISC_DYNAMIC_MINOR;
+
+	error = misc_register(&ls->ls_device);
+	if (error) {
+		kfree(ls->ls_device.name);
+	}
+fail:
+	return error;
+}
+
 static int device_create_lockspace(struct dlm_lspace_params *params)
 {
 	dlm_lockspace_t *lockspace;
 	struct dlm_ls *ls;
-	int error, len;
+	int error;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
@@ -304,29 +327,14 @@ static int device_create_lockspace(struct dlm_lspace_params *params)
 	if (!ls)
 		return -ENOENT;
 
-	error = -ENOMEM;
-	len = strlen(params->name) + strlen(name_prefix) + 2;
-	ls->ls_device.name = kzalloc(len, GFP_KERNEL);
-	if (!ls->ls_device.name)
-		goto fail;
-	snprintf((char *)ls->ls_device.name, len, "%s_%s", name_prefix,
-		 params->name);
-	ls->ls_device.fops = &device_fops;
-	ls->ls_device.minor = MISC_DYNAMIC_MINOR;
-
-	error = misc_register(&ls->ls_device);
-	if (error) {
-		kfree(ls->ls_device.name);
-		goto fail;
-	}
-
-	error = ls->ls_device.minor;
+	error = create_misc_device(ls, params->name);
 	dlm_put_lockspace(ls);
-	return error;
 
- fail:
-	dlm_put_lockspace(ls);
-	dlm_release_lockspace(lockspace, 0);
+	if (error)
+		dlm_release_lockspace(lockspace, 0);
+	else
+		error = ls->ls_device.minor;
+
 	return error;
 }
 
@@ -343,6 +351,10 @@ static int device_remove_lockspace(struct dlm_lspace_params *params)
 	if (!ls)
 		return -ENOENT;
 
+	/* Deregister the misc device first, so we don't have
+	 * a device that's not attached to a lockspace. If
+	 * dlm_release_lockspace fails then we can recreate it
+	 */
 	error = misc_deregister(&ls->ls_device);
 	if (error) {
 		dlm_put_lockspace(ls);
@@ -361,6 +373,8 @@ static int device_remove_lockspace(struct dlm_lspace_params *params)
 
 	dlm_put_lockspace(ls);
 	error = dlm_release_lockspace(lockspace, force);
+	if (error)
+		create_misc_device(ls, ls->ls_name);
  out:
 	return error;
 }
-- 
1.5.1.2



