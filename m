Return-Path: <linux-kernel-owner+w=401wt.eu-S1756823AbXIUJja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756823AbXIUJja (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 05:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755896AbXIUJjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 05:39:16 -0400
Received: from mailhub.sw.ru ([195.214.233.200]:42359 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754728AbXIUJjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 05:39:15 -0400
Date: Fri, 21 Sep 2007 13:39:06 +0400
From: Alexey Dobriyan <adobriyan@sw.ru>
To: akpm@osdl.org
Cc: linux-kernel@vger.kernel.org, devel@openvz.org
Subject: [PATCH 2/3] user.c: use kmem_cache_zalloc()
Message-ID: <20070921093906.GB6812@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Quite a few fields are zeroed during user_struct creation, so use
kmem_cache_zalloc() --  save a few lines and #ifdef. Also will help avoid
 #ifdef CONFIG_POSIX_MQUEUE in next patch.

Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
---

 kernel/user.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

--- a/kernel/user.c
+++ b/kernel/user.c
@@ -129,21 +129,11 @@ struct user_struct * alloc_uid(struct user_namespace *ns, uid_t uid)
 	if (!up) {
 		struct user_struct *new;
 
-		new = kmem_cache_alloc(uid_cachep, GFP_KERNEL);
+		new = kmem_cache_zalloc(uid_cachep, GFP_KERNEL);
 		if (!new)
 			return NULL;
 		new->uid = uid;
 		atomic_set(&new->__count, 1);
-		atomic_set(&new->processes, 0);
-		atomic_set(&new->files, 0);
-		atomic_set(&new->sigpending, 0);
-#ifdef CONFIG_INOTIFY_USER
-		atomic_set(&new->inotify_watches, 0);
-		atomic_set(&new->inotify_devs, 0);
-#endif
-
-		new->mq_bytes = 0;
-		new->locked_shm = 0;
 
 		if (alloc_uid_keyring(new, current) < 0) {
 			kmem_cache_free(uid_cachep, new);

