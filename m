Return-Path: <linux-kernel-owner+w=401wt.eu-S1756988AbZEVE5V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988AbZEVE5V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 00:57:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752039AbZEVEzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 00:55:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:3469 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbZEVEzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 00:55:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=P214mOeD2L/XRsksvgAMt5/4oh/Fk3SAGf3D1LwydB6/bRbFfLdqg4K1vqRdOnk4r9
         cgKQglT/W59AM/SVGo7eBTF/0VyT4KiaKmJilUzqgVglKWuRSgKvFUrthCuCsvlWb0Kh
         9IzaVy2w2Tl4mPOmsv29xKCemR2TJNFLUmkgY=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       torvalds@linux-foundation.org, xemul@parallels.com,
       orenl@cs.columbia.edu, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 07/38] pidns 1/2: make create_pid_namespace() accept parent pidns
Date: Fri, 22 May 2009 08:55:01 +0400
Message-Id: <1242968132-1044-7-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1242968132-1044-1-git-send-email-adobriyan@gmail.com>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

create_pid_namespace() creates everything, but caller has to assign parent
pidns by hand, which is unnatural. At the moment of call new ->level has
to be taken from somewhere and parent pidns is already available.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 kernel/pid_namespace.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 2d1001b..495d5de 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -67,9 +67,10 @@ err_alloc:
 	return NULL;
 }
 
-static struct pid_namespace *create_pid_namespace(unsigned int level)
+static struct pid_namespace *create_pid_namespace(struct pid_namespace *parent_pid_ns)
 {
 	struct pid_namespace *ns;
+	unsigned int level = parent_pid_ns->level + 1;
 	int i;
 
 	ns = kmem_cache_zalloc(pid_ns_cachep, GFP_KERNEL);
@@ -86,6 +87,7 @@ static struct pid_namespace *create_pid_namespace(unsigned int level)
 
 	kref_init(&ns->kref);
 	ns->level = level;
+	ns->parent = get_pid_ns(parent_pid_ns);
 
 	set_bit(0, ns->pidmap[0].page);
 	atomic_set(&ns->pidmap[0].nr_free, BITS_PER_PAGE - 1);
@@ -125,9 +127,7 @@ struct pid_namespace *copy_pid_ns(unsigned long flags, struct pid_namespace *old
 	if (flags & CLONE_THREAD)
 		goto out_put;
 
-	new_ns = create_pid_namespace(old_ns->level + 1);
-	if (!IS_ERR(new_ns))
-		new_ns->parent = get_pid_ns(old_ns);
+	new_ns = create_pid_namespace(old_ns);
 
 out_put:
 	put_pid_ns(old_ns);
-- 
1.5.6.5

