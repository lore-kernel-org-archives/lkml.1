Return-Path: <linux-kernel-owner+w=401wt.eu-S1753099AbZBKTjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099AbZBKTjI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 14:39:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756126AbZBKTi6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 14:38:58 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:44478 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755665AbZBKTi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 14:38:57 -0500
Date: Wed, 11 Feb 2009 13:38:46 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: David Howells <dhowells@redhat.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Eric Sesterhenn <snakebyte@gmx.de>, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: namespaces?: bug at mm/slub.c:2750
Message-ID: <20090211193846.GB1344@us.ibm.com>
References: <20090211172416.GA30756@us.ibm.com> <20090211163753.GA29372@us.ibm.com> <20090206113556.GA3161@alice> <20090206161518.81e7d42c.akpm@linux-foundation.org> <19f34abd0902102355o5bf51096o9aa3737e87104fb9@mail.gmail.com> <20090211000740.f1de7cec.akpm@linux-foundation.org> <19f34abd0902110248n22f8de12lccfa99faafafb942@mail.gmail.com> <1538.1234371764@redhat.com> <2532.1234375381@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2532.1234375381@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting David Howells (dhowells@redhat.com):
> Serge E. Hallyn <serue@us.ibm.com> wrote:
> 
> > It's called under uidhash_lock spinlock so should be ok, but in
> > principle you're right so it's probably a good idea.
> 
> The lock is nothing to do with it.  put_user_ns() may call kfree() on the
> user_namespace, but the user_struct given to uid_hash_remove() may still be
> attached to it.

Yes, but noone will pull the user_struct off the list without
taking the lock.

what am I missing?

Anyway, I do like swapping the lines (as below) better.

-serge


>From 8b83d11023c1064e99bffae3c2a05580b915de60 Mon Sep 17 00:00:00 2001
From: Serge E. Hallyn <serue@us.ibm.com>
Date: Wed, 11 Feb 2009 11:29:52 -0500
Subject: [PATCH 1/1] user namespaces: only put the userns when we unhash the uid

uids in namespaces other than init don't get a sysfs entry.

For those in the init namespace, while we're waiting to remove
the sysfs entry for the uid the uid is still hashed, and
alloc_uid() may re-grab that uid without getting a new
reference to the user_ns, which we've already put in free_user
before scheduling remove_user_sysfs_dir().

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
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
 
-- 
1.6.1

