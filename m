Return-Path: <linux-kernel-owner+w=401wt.eu-S1757422AbZECX2p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422AbZECX2p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 19:28:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756673AbZECX2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 19:28:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:63129 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754888AbZECX2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 19:28:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=I8ivtq2+kP2R1ruG1FdirN3Y38EAupT3hz5Jq65D75CQ0mUUUGcp8LgLYha8PHoM1f
         eCqVnYrMOgeBjigAkPmEYWyqcUiWwbv8DkpAJvLSm+GNeB1UfeGJgbtr21UhqmBP2fW1
         xYPgKH3cV4OSj5tcJR0d2tsVb5WpgfhkxuSEA=
Date: Mon, 4 May 2009 03:29:22 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: [PATCH] nsproxy: extract create_nsproxy()
Message-ID: <20090503232922.GH16631@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

clone_nsproxy() does useless copying of old nsproxy -- every pointer will be
rewritten to new ns or to old ns. Remove copying, rename clone_nsproxy(),
create_nsproxy() will be used by C/R code to create fresh nsproxy on restart.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
---
 kernel/nsproxy.c |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/kernel/nsproxy.c b/kernel/nsproxy.c
index 63598dc..09b4ff9 100644
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
 
