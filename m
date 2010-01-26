Return-Path: <linux-kernel-owner+w=401wt.eu-S1754541Ab0AZPRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754541Ab0AZPRS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 10:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753852Ab0AZPRR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 10:17:17 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:46755 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753204Ab0AZPRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 10:17:16 -0500
Subject: Re: [RFC PATCH 1/2] Fix 1 untangling ima mess, part 2 with counters
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       James Morris <jmorris@namei.org>,
       David Safford <safford@watson.ibm.com>,
       "Serge E. Hallyn" <serue@linux.vnet.ibm.com>,
       Mimi Zohar <zohar@us.ibm.com>
In-Reply-To: <20100126130349.GH19799@ZenIV.linux.org.uk>
References: <cover.1264018123.git.zohar@linux.vnet.ibm.com>
	 <4ad974923eae7a8f52be0786a630b6c64bee9d32.1264018123.git.zohar@linux.vnet.ibm.com>
	 <20100123230735.GW19799@ZenIV.linux.org.uk>
	 <1264447477.3696.30.camel@dyn9002018117.watson.ibm.com>
	 <20100126130349.GH19799@ZenIV.linux.org.uk>
Content-Type: text/plain
Date: Tue, 26 Jan 2010 10:16:55 -0500
Message-Id: <1264519015.3789.28.camel@dyn9002018117.watson.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-01-26 at 13:03 +0000, Al Viro wrote:
> OK, this stuff is in for-next, with the following changes:
> 	* nfsd call has been moved to nfsd_open()
> 	* patches reordered
> 	* masking irrelevant bits (i.e. leaving only MAY_{READ,WRITE,EXEC})
> has been taken to ima_path_check(); all callers do it and it's safer that
> way anyway.
> 
> Please, see if it's OK with you in this form; other calls of dentry_open()
> are separate story, we'll have to see which ones should and which ones
> should not get ima_path_check().  Do you have any other problems with that
> one?  If not, it's going to migrate into for-linus and into the mainline;
> this stuff is definitely 2.6.33 fodder.

I'll look at the patches, but in the meantime we also needed the
following patch.

commit 8262bb85da4a71c4ff8c9b22e03aff11f8427b6d
Author: Eric Paris <eparis@redhat.com>
Date:   Wed Dec 9 15:29:01 2009 -0500

    ima: initialize ima before inodes can be allocated
    
    ima wants to create an inode information struct (iint) when inodes are
    allocated.  This means that at least the part of ima which does this
    allocation (the allocation is filled with information later) should
    before any inodes are created.  To accomplish this we split the ima
    initialization routine placing the kmem cache allocator inside a
    security_initcall() function.  Since this makes use of radix trees we also
    need to make sure that is initialized before security_initcall().
    
    Signed-off-by: Eric Paris <eparis@redhat.com>
    Acked-by: Mimi Zohar <zohar@linux.vnet.ibm.com>

Index: security-testing-2.6/init/main.c
===================================================================
--- security-testing-2.6.orig/init/main.c
+++ security-testing-2.6/init/main.c
@@ -663,9 +663,9 @@ asmlinkage void __init start_kernel(void
 	proc_caches_init();
 	buffer_init();
 	key_init();
+	radix_tree_init();
 	security_init();
 	vfs_caches_init(totalram_pages);
-	radix_tree_init();
 	signals_init();
 	/* rootfs populating might need page-writeback */
 	page_writeback_init();
Index: security-testing-2.6/security/integrity/ima/ima.h
===================================================================
--- security-testing-2.6.orig/security/integrity/ima/ima.h
+++ security-testing-2.6/security/integrity/ima/ima.h
@@ -65,7 +65,6 @@ void integrity_audit_msg(int audit_msgno
 			 const char *cause, int result, int info);
 
 /* Internal IMA function definitions */
-void ima_iintcache_init(void);
 int ima_init(void);
 void ima_cleanup(void);
 int ima_fs_init(void);
Index: security-testing-2.6/security/integrity/ima/ima_iint.c
===================================================================
--- security-testing-2.6.orig/security/integrity/ima/ima_iint.c
+++ security-testing-2.6/security/integrity/ima/ima_iint.c
@@ -52,9 +52,6 @@ int ima_inode_alloc(struct inode *inode)
 	struct ima_iint_cache *iint = NULL;
 	int rc = 0;
 
-	if (!ima_initialized)
-		return 0;
-
 	iint = kmem_cache_alloc(iint_cache, GFP_NOFS);
 	if (!iint)
 		return -ENOMEM;
@@ -118,8 +115,6 @@ void ima_inode_free(struct inode *inode)
 {
 	struct ima_iint_cache *iint;
 
-	if (!ima_initialized)
-		return;
 	spin_lock(&ima_iint_lock);
 	iint = radix_tree_delete(&ima_iint_store, (unsigned long)inode);
 	spin_unlock(&ima_iint_lock);
@@ -141,9 +136,11 @@ static void init_once(void *foo)
 	kref_set(&iint->refcount, 1);
 }
 
-void __init ima_iintcache_init(void)
+static int __init ima_iintcache_init(void)
 {
 	iint_cache =
 	    kmem_cache_create("iint_cache", sizeof(struct ima_iint_cache), 0,
 			      SLAB_PANIC, init_once);
+	return 0;
 }
+security_initcall(ima_iintcache_init);
Index: security-testing-2.6/security/integrity/ima/ima_main.c
===================================================================
--- security-testing-2.6.orig/security/integrity/ima/ima_main.c
+++ security-testing-2.6/security/integrity/ima/ima_main.c
@@ -319,7 +319,6 @@ static int __init init_ima(void)
 {
 	int error;
 
-	ima_iintcache_init();
 	error = ima_init();
 	ima_initialized = 1;
 	return error;
 


