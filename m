Return-Path: <linux-kernel-owner+w=401wt.eu-S932392AbXFRUx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392AbXFRUx2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 16:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763321AbXFRUxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 16:53:21 -0400
Received: from mtagate4.de.ibm.com ([195.212.29.153]:3587 "EHLO
	mtagate4.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763119AbXFRUxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 16:53:20 -0400
Message-ID: <4676F0B9.3080408@fr.ibm.com>
Date: Mon, 18 Jun 2007 22:53:13 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Herbert Poetzl <herbert@13thfloor.at>,
       Pavel Emelianov <xemul@openvz.org>
Subject: [PATCH -mm] add a kmem_cache for nsproxy objects
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

It should improve performance in some scenarii where a lot of 
these nsproxy objects are created by unsharing namespaces. This is
a typical use of virtual servers that are being created or entered.

This is also a good tool to find leaks and gather statistics on
namespace usage.

Signed-off-by: Cedric Le Goater <clg@fr.ibm.com>
---
 kernel/nsproxy.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

Index: 2.6.22-rc4-mm2/kernel/nsproxy.c
===================================================================
--- 2.6.22-rc4-mm2.orig/kernel/nsproxy.c
+++ 2.6.22-rc4-mm2/kernel/nsproxy.c
@@ -21,6 +21,8 @@
 #include <linux/utsname.h>
 #include <linux/pid_namespace.h>
 
+static struct kmem_cache *nsproxy_cachep;
+
 struct nsproxy init_nsproxy = INIT_NSPROXY(init_nsproxy);
 
 static inline void get_nsproxy(struct nsproxy *ns)
@@ -43,9 +45,11 @@ static inline struct nsproxy *clone_nspr
 {
 	struct nsproxy *ns;
 
-	ns = kmemdup(orig, sizeof(struct nsproxy), GFP_KERNEL);
-	if (ns)
+	ns = kmem_cache_alloc(nsproxy_cachep, GFP_KERNEL);
+	if (ns) {
+		memcpy(ns, orig, sizeof(struct nsproxy));
 		atomic_set(&ns->count, 1);
+	}
 	return ns;
 }
 
@@ -109,7 +113,7 @@ out_uts:
 	if (new_nsp->mnt_ns)
 		put_mnt_ns(new_nsp->mnt_ns);
 out_ns:
-	kfree(new_nsp);
+	kmem_cache_free(nsproxy_cachep, new_nsp);
 	return ERR_PTR(err);
 }
 
@@ -160,7 +164,7 @@ void free_nsproxy(struct nsproxy *ns)
 		put_pid_ns(ns->pid_ns);
 	if (ns->user_ns)
 		put_user_ns(ns->user_ns);
-	kfree(ns);
+	kmem_cache_free(nsproxy_cachep, ns);
 }
 
 /*
@@ -191,3 +195,12 @@ int unshare_nsproxy_namespaces(unsigned 
 	}
 	return err;
 }
+
+static int __init nsproxy_cache_init(void)
+{
+	nsproxy_cachep = kmem_cache_create("nsproxy", sizeof(struct nsproxy),
+					   0, SLAB_PANIC, NULL, NULL);
+	return 0;
+}
+
+module_init(nsproxy_cache_init);
