Return-Path: <linux-kernel-owner+w=401wt.eu-S1760658AbXKUKuC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760658AbXKUKuC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 05:50:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbXKUKty
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 05:49:54 -0500
Received: from sacred.ru ([62.205.161.221]:42186 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753484AbXKUKtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 05:49:53 -0500
Message-ID: <47440D3D.3040609@openvz.org>
Date: Wed, 21 Nov 2007 13:49:33 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, devel@openvz.org,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>
Subject: [PATCH 1/2] Don't forget to unlock uids_mutex on error paths
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 21 Nov 2007 13:49:37 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The commit

commit 5cb350baf580017da38199625b7365b1763d7180
Author: Dhaval Giani <dhaval@linux.vnet.ibm.com>
Date:   Mon Oct 15 17:00:14 2007 +0200

    sched: group scheduling, sysfs tunables

introduced the uids_mutex and the helpers to lock/unlock it.
Unfortunately, the error paths of alloc_uid() were not patched
to unlock it.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/kernel/user.c b/kernel/user.c
index 56327ee..3549c4b 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -343,8 +343,11 @@ struct user_struct * alloc_uid(struct user_namespace *ns, uid_t uid)
 		struct user_struct *new;
 
 		new = kmem_cache_alloc(uid_cachep, GFP_KERNEL);
-		if (!new)
+		if (!new) {
+			uids_mutex_unlock();
 			return NULL;
+		}
+
 		new->uid = uid;
 		atomic_set(&new->__count, 1);
 		atomic_set(&new->processes, 0);
@@ -361,6 +364,7 @@ struct user_struct * alloc_uid(struct user_namespace *ns, uid_t uid)
 
 		if (alloc_uid_keyring(new, current) < 0) {
 			kmem_cache_free(uid_cachep, new);
+			uids_mutex_unlock();
 			return NULL;
 		}
 
@@ -368,6 +372,7 @@ struct user_struct * alloc_uid(struct user_namespace *ns, uid_t uid)
 			key_put(new->uid_keyring);
 			key_put(new->session_keyring);
 			kmem_cache_free(uid_cachep, new);
+			uids_mutex_unlock();
 			return NULL;
 		}
 
-- 
1.5.3.4

