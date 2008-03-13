Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbYCMWW1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbYCMWW1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 18:22:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752667AbYCMWWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 18:22:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46270 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750814AbYCMWWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 18:22:15 -0400
Date: Thu, 13 Mar 2008 15:20:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: torvalds@linux-foundation.org, kwc@citi.umich.edu, arunsr@cse.iitk.ac.in,
       dwalsh@redhat.com, linux-security-module@vger.kernel.org,
       dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] KEYS: Don't generate user and user session keyrings
 unless they're accessed
Message-Id: <20080313152059.90681241.akpm@linux-foundation.org>
In-Reply-To: <20080313191437.28959.4396.stgit@warthog.procyon.org.uk>
References: <20080313191432.28959.52722.stgit@warthog.procyon.org.uk>
	<20080313191437.28959.4396.stgit@warthog.procyon.org.uk>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2008 19:14:37 +0000
David Howells <dhowells@redhat.com> wrote:

> Don't generate the per-UID user and user session keyrings unless they're
> explicitly accessed.  This solves a problem during a login process whereby
> set*uid() is called before the SELinux PAM module, resulting in the per-UID
> keyrings having the wrong security labels.
> 
> This also cures the problem of multiple per-UID keyrings sometimes appearing
> due to PAM modules (including pam_keyinit) setuiding and causing user_structs
> to come into and go out of existence whilst the session keyring pins the user
> keyring.  This is achieved by first searching for extant per-UID keyrings before
> inventing new ones.
> 
> The serial bound argument is also dropped from find_keyring_by_name() as it's
> not currently made use of (setting it to 0 disables the feature).
> 
> ..
>
> -/* Initial keyrings */
> -extern struct key root_user_keyring;
> -extern struct key root_session_keyring;

hm, I didn't realise that the keys code had special knowlege of "root". 
How does that play alongside the containers stuff?

> --- a/kernel/user.c
> +++ b/kernel/user.c
> ...
> +#ifdef CONFIG_KEYS
> +		new->uid_keyring = new->session_keyring = NULL;
> +#endif

		new->uid_keyring = NULL;
		new->session_keyring = NULL;

would be more conventional.

But better would be to teach alloc_uid() about kmem_cache_zalloc() then
take a chainsaw to it.

It's sorely tempting to say that initialising an atomic_t with memset(0) is
OK.  Heck, if it ever becomes not OK then we're screwed anwyay, because
vast tracts of code assumes that atomic_set(uninitalised_atomic, 0) works
OK.


I'll queue this up:


From: Andrew Morton <akpm@linux-foundation.org>

Use kmem_cache_zalloc(), remove large amounts of initialsiation code and
ifdeffery.

Note: this assumes that memset(*atomic_t, 0) correctly initialises the
atomic_t.  This is true for all present archtiectures and if it becomes false
for a future architecture then we'll need to make large changes all over the
place anyway.


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/user.c |   18 ++----------------
 1 file changed, 2 insertions(+), 16 deletions(-)

diff -puN kernel/user.c~alloc_uid-cleanup kernel/user.c
--- a/kernel/user.c~alloc_uid-cleanup
+++ a/kernel/user.c
@@ -356,7 +356,7 @@ void free_uid(struct user_struct *up)
 		local_irq_restore(flags);
 }
 
-struct user_struct * alloc_uid(struct user_namespace *ns, uid_t uid)
+struct user_struct *alloc_uid(struct user_namespace *ns, uid_t uid)
 {
 	struct hlist_head *hashent = uidhashentry(ns, uid);
 	struct user_struct *up, *new;
@@ -371,26 +371,12 @@ struct user_struct * alloc_uid(struct us
 	spin_unlock_irq(&uidhash_lock);
 
 	if (!up) {
-		new = kmem_cache_alloc(uid_cachep, GFP_KERNEL);
+		new = kmem_cache_zalloc(uid_cachep, GFP_KERNEL);
 		if (!new)
 			goto out_unlock;
 
 		new->uid = uid;
 		atomic_set(&new->__count, 1);
-		atomic_set(&new->processes, 0);
-		atomic_set(&new->files, 0);
-		atomic_set(&new->sigpending, 0);
-#ifdef CONFIG_INOTIFY_USER
-		atomic_set(&new->inotify_watches, 0);
-		atomic_set(&new->inotify_devs, 0);
-#endif
-#ifdef CONFIG_POSIX_MQUEUE
-		new->mq_bytes = 0;
-#endif
-		new->locked_shm = 0;
-#ifdef CONFIG_KEYS
-		new->uid_keyring = new->session_keyring = NULL;
-#endif
 
 		if (sched_create_user(new) < 0)
 			goto out_free_user;
_

