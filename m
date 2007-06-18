Return-Path: <linux-kernel-owner+w=401wt.eu-S932470AbXFRUMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470AbXFRUMn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 16:12:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764397AbXFRUMc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 16:12:32 -0400
Received: from mtagate5.uk.ibm.com ([195.212.29.138]:16730 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764361AbXFRUMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 16:12:31 -0400
Message-ID: <4676E725.6010708@fr.ibm.com>
Date: Mon, 18 Jun 2007 22:12:21 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Badari Pulavarty <pbadari@us.ibm.com>,
       Herbert Poetzl <herbert@13thfloor.at>, Oleg Nesterov <oleg@tv-sign.ru>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] fix refcounting of nsproxy object when unshared
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When a namespace is unshared, a refcount on the previous nsproxy is
abusively taken, leading to a memory leak of nsproxy objects. 
 
Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>

---
 kernel/nsproxy.c |   10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

Index: 2.6.22-rc5/kernel/nsproxy.c
===================================================================
--- 2.6.22-rc5.orig/kernel/nsproxy.c
+++ 2.6.22-rc5/kernel/nsproxy.c
@@ -145,13 +145,11 @@ void free_nsproxy(struct nsproxy *ns)
 
 /*
  * Called from unshare. Unshare all the namespaces part of nsproxy.
- * On sucess, returns the new nsproxy and a reference to old nsproxy
- * to make sure it stays around.
+ * On success, returns the new nsproxy.
  */
 int unshare_nsproxy_namespaces(unsigned long unshare_flags,
 		struct nsproxy **new_nsp, struct fs_struct *new_fs)
 {
-	struct nsproxy *old_ns = current->nsproxy;
 	int err = 0;
 
 	if (!(unshare_flags & (CLONE_NEWNS | CLONE_NEWUTS | CLONE_NEWIPC)))
@@ -170,13 +168,9 @@ int unshare_nsproxy_namespaces(unsigned 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
-	get_nsproxy(old_ns);
-
 	*new_nsp = create_new_namespaces(unshare_flags, current,
 				new_fs ? new_fs : current->fs);
-	if (IS_ERR(*new_nsp)) {
+	if (IS_ERR(*new_nsp))
 		err = PTR_ERR(*new_nsp);
-		put_nsproxy(old_ns);
-	}
 	return err;
 }
