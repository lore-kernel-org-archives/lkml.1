Return-Path: <linux-kernel-owner+w=401wt.eu-S1756778AbZBVAGr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778AbZBVAGr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 19:06:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756513AbZBVAG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 19:06:28 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:35364 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756505AbZBVAG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 19:06:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=gQwWenSrFJiWXdaBFrPHGuBF3a1exX0t2tAQzJ5K6j0EFVGKTBvHMWxi4dutJDGT3U
         Q29u6aME74k+M90LJmGTbJY0q4P+iqALFGAtwZNdCmhjiHfnaUpLCgstBv0DyynnNbuo
         IjR6T5rhR6232e/szaFFtddj1oobRhbFSCH1k=
Date: Sun, 22 Feb 2009 03:12:57 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: kosaki.motohiro@jp.fujitsu.com, serue@us.ibm.com, dhowells@redhat.com,
       mingo@elte.hu
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
Subject: Broken "User namespaces: Only put the userns when we unhash the
	uid"
Message-ID: <20090222001257.GA15755@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following commit breaks clone(CLONE_NEWUSER)
with an oops.

	__lock_acquire
	lock_acquire
	_spin_lock
	_atomic_dec_and_lock
	free_uid
	free_user_ns
	kref_put
	free_uid
	put_cred_rcu
	rcu_process_callbacks

commit fb5ae64fdde29236e1a15e0366946df7060f41f2
Author: Serge E. Hallyn <serue@us.ibm.com>
Date:   Fri Feb 13 14:04:21 2009 +0000

    User namespaces: Only put the userns when we unhash the uid
    
    uids in namespaces other than init don't get a sysfs entry.
    
    For those in the init namespace, while we're waiting to remove
    the sysfs entry for the uid the uid is still hashed, and
    alloc_uid() may re-grab that uid without getting a new
    reference to the user_ns, which we've already put in free_user
    before scheduling remove_user_sysfs_dir().
    
    Reported-and-tested-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
    Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
    Acked-by: David Howells <dhowells@redhat.com>
    Tested-by: Ingo Molnar <mingo@elte.hu>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

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
 
