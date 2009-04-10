Return-Path: <linux-kernel-owner+w=401wt.eu-S933742AbZDJCes@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933742AbZDJCes (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 22:34:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932906AbZDJCeM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 22:34:12 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:45875 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932905AbZDJCeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 22:34:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=CiuXTJyiSluDbc1BQaDBXEWNN9cJasfA98GVLE9e3cn56v1N50r8q1gfNxAgSb8oXS
         EwWHbxCZvAS0SBHz2W+yPX1jsi6VmBD0R2ql2tBvAud5EIqBHDzlObJO7e/XGDronLII
         y4ubxnf27DI8agmUAiJpdDzrQqKKa6SZkM7NM=
Date: Fri, 10 Apr 2009 06:34:13 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org, containers@lists.linux-foundation.org
Cc: xemul@parallels.com, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, orenl@cs.columbia.edu, hch@infradead.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 05/30] nsproxy: add create_nsproxy()
Message-ID: <20090410023413.GF27788@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clone_nsproxy() does useless copying of old nsproxy -- every pointer
will be rewritten to new ns or to old ns.

Remove copying, rename clone_nsproxy(), it will be used by C/R code
to create fresh nsproxy on restart.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 kernel/nsproxy.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

--- a/kernel/nsproxy.c
+++ b/kernel/nsproxy.c
@@ -26,19 +26,14 @@ static struct kmem_cache *nsproxy_cachep;
 
 struct nsproxy init_nsproxy = INIT_NSPROXY(init_nsproxy);
 
-/*
- * creates a copy of "orig" with refcount 1.
- */
-static inline struct nsproxy *clone_nsproxy(struct nsproxy *orig)
+static inline struct nsproxy *create_nsproxy(void)
 {
-	struct nsproxy *ns;
+	struct nsproxy *nsproxy;
 
-	ns = kmem_cache_alloc(nsproxy_cachep, GFP_KERNEL);
-	if (ns) {
-		memcpy(ns, orig, sizeof(struct nsproxy));
-		atomic_set(&ns->count, 1);
-	}
-	return ns;
+	nsproxy = kmem_cache_alloc(nsproxy_cachep, GFP_KERNEL);
+	if (nsproxy)
+		atomic_set(&nsproxy->count, 1);
+	return nsproxy;
 }
 
 /*
@@ -52,7 +47,7 @@ static struct nsproxy *create_new_namespaces(unsigned long flags,
 	struct nsproxy *new_nsp;
 	int err;
 
-	new_nsp = clone_nsproxy(tsk->nsproxy);
+	new_nsp = create_nsproxy();
 	if (!new_nsp)
 		return ERR_PTR(-ENOMEM);
 
