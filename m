Return-Path: <linux-kernel-owner+w=401wt.eu-S1759893AbZBMOF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759893AbZBMOF1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 09:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754457AbZBMOFO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 09:05:14 -0500
Received: from mx2.redhat.com ([66.187.237.31]:46934 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754788AbZBMOFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 09:05:13 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] User namespaces: Only put the userns when we unhash the uid
To: torvalds@osdl.org, jmorris@namei.sys
Cc: akpm@linux-foundation.org, dhowells@redhat.com, serue@us.ibm.com,
       mingo@elte.hu, kosaki.motohiro@jp.fujitsu.com,
       linux-kernel@vger.kernel.org, vegard.nossum@gmail.com,
       containers@lists.osdl.org, snakebyte@gmx.de
Date: Fri, 13 Feb 2009 14:04:21 +0000
Message-ID: <20090213140421.5698.86876.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Serge E. Hallyn <serue@us.ibm.com>

uids in namespaces other than init don't get a sysfs entry.

For those in the init namespace, while we're waiting to remove
the sysfs entry for the uid the uid is still hashed, and
alloc_uid() may re-grab that uid without getting a new
reference to the user_ns, which we've already put in free_user
before scheduling remove_user_sysfs_dir().

Reported-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Acked-by: David Howells <dhowells@redhat.com>
Tested-by: Ingo Molnar <mingo@elte.hu>
---

 kernel/user.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)


diff --git a/kernel/user.c b/kernel/user.c
index 477b666..3551ac7 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -72,6 +72,7 @@ static void uid_hash_insert(struct user_struct *up, struct hlist_head *hashent)
 static void uid_hash_remove(struct user_struct *up)
 {
 	hlist_del_init(&up->uidhash_node);
+	put_user_ns(up->user_ns);
 }
 
 static struct user_struct *uid_hash_find(uid_t uid, struct hlist_head *hashent)
@@ -334,7 +335,6 @@ static void free_user(struct user_struct *up, unsigned long flags)
 	atomic_inc(&up->__count);
 	spin_unlock_irqrestore(&uidhash_lock, flags);
 
-	put_user_ns(up->user_ns);
 	INIT_WORK(&up->work, remove_user_sysfs_dir);
 	schedule_work(&up->work);
 }
@@ -357,7 +357,6 @@ static void free_user(struct user_struct *up, unsigned long flags)
 	sched_destroy_user(up);
 	key_put(up->uid_keyring);
 	key_put(up->session_keyring);
-	put_user_ns(up->user_ns);
 	kmem_cache_free(uid_cachep, up);
 }
 

