Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965972Ab0BZUFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 15:05:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32540 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965876Ab0BZUFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 15:05:52 -0500
Date: Fri, 26 Feb 2010 21:04:35 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: David Howells <dhowells@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Neil Horman <nhorman@tuxdriver.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH v2 -mm 2/2] umh && creds: kill subprocess_info->cred logic
Message-ID: <20100226200435.GC16092@redhat.com>
References: <20100226182325.GA31674@redhat.com> <20100225181500.GA18008@redhat.com> <16951.1267207238@redhat.com> <17603.1267209668@redhat.com> <20100226200313.GA16092@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100226200313.GA16092@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that nobody ever changes subprocess_info->cred we can kill this
member and related code. ____call_usermodehelper() always runs in the
context of freshly forked kernel thread, it has the proper ->cred
copied from its parent kthread, keventd.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/cred.h |    1 
 include/linux/kmod.h |    1 
 kernel/cred.c        |   54 ---------------------------------------------------
 kernel/kmod.c        |   19 -----------------
 4 files changed, 75 deletions(-)

--- mm/include/linux/cred.h~2_KILL_INFO_CRED	2010-02-26 20:18:48.000000000 +0100
+++ mm/include/linux/cred.h	2010-02-26 20:53:04.000000000 +0100
@@ -156,7 +156,6 @@ extern int copy_creds(struct task_struct
 extern struct cred *cred_alloc_blank(void);
 extern struct cred *prepare_creds(void);
 extern struct cred *prepare_exec_creds(void);
-extern struct cred *prepare_usermodehelper_creds(void);
 extern int commit_creds(struct cred *);
 extern void abort_creds(struct cred *);
 extern const struct cred *override_creds(const struct cred *);
--- mm/include/linux/kmod.h~2_KILL_INFO_CRED	2010-02-26 20:18:48.000000000 +0100
+++ mm/include/linux/kmod.h	2010-02-26 20:53:04.000000000 +0100
@@ -55,7 +55,6 @@ enum umh_wait {
 struct subprocess_info {
 	struct work_struct work;
 	struct completion *complete;
-	struct cred *cred;
 	char *path;
 	char **argv;
 	char **envp;
--- mm/kernel/cred.c~2_KILL_INFO_CRED	2010-02-26 20:18:48.000000000 +0100
+++ mm/kernel/cred.c	2010-02-26 20:53:04.000000000 +0100
@@ -347,60 +347,6 @@ struct cred *prepare_exec_creds(void)
 }
 
 /*
- * prepare new credentials for the usermode helper dispatcher
- */
-struct cred *prepare_usermodehelper_creds(void)
-{
-#ifdef CONFIG_KEYS
-	struct thread_group_cred *tgcred = NULL;
-#endif
-	struct cred *new;
-
-#ifdef CONFIG_KEYS
-	tgcred = kzalloc(sizeof(*new->tgcred), GFP_ATOMIC);
-	if (!tgcred)
-		return NULL;
-#endif
-
-	new = kmem_cache_alloc(cred_jar, GFP_ATOMIC);
-	if (!new)
-		return NULL;
-
-	kdebug("prepare_usermodehelper_creds() alloc %p", new);
-
-	memcpy(new, &init_cred, sizeof(struct cred));
-
-	atomic_set(&new->usage, 1);
-	set_cred_subscribers(new, 0);
-	get_group_info(new->group_info);
-	get_uid(new->user);
-
-#ifdef CONFIG_KEYS
-	new->thread_keyring = NULL;
-	new->request_key_auth = NULL;
-	new->jit_keyring = KEY_REQKEY_DEFL_DEFAULT;
-
-	atomic_set(&tgcred->usage, 1);
-	spin_lock_init(&tgcred->lock);
-	new->tgcred = tgcred;
-#endif
-
-#ifdef CONFIG_SECURITY
-	new->security = NULL;
-#endif
-	if (security_prepare_creds(new, &init_cred, GFP_ATOMIC) < 0)
-		goto error;
-	validate_creds(new);
-
-	BUG_ON(atomic_read(&new->usage) != 1);
-	return new;
-
-error:
-	put_cred(new);
-	return NULL;
-}
-
-/*
  * Copy credentials for the new process created by fork()
  *
  * We share if we can, but under some circumstances we have to generate a new
--- mm/kernel/kmod.c~2_KILL_INFO_CRED	2010-02-26 20:18:48.000000000 +0100
+++ mm/kernel/kmod.c	2010-02-26 20:53:04.000000000 +0100
@@ -153,8 +153,6 @@ static int ____call_usermodehelper(void 
 	struct subprocess_info *sub_info = data;
 	int retval;
 
-	BUG_ON(atomic_read(&sub_info->cred->usage) != 1);
-
 	/* Unblock all signals */
 	spin_lock_irq(&current->sighand->siglock);
 	flush_signal_handlers(current, 1);
@@ -162,10 +160,6 @@ static int ____call_usermodehelper(void 
 	recalc_sigpending();
 	spin_unlock_irq(&current->sighand->siglock);
 
-	/* Install the credentials */
-	commit_creds(sub_info->cred);
-	sub_info->cred = NULL;
-
 	/* We can run anywhere, unlike our parent keventd(). */
 	set_cpus_allowed_ptr(current, cpu_all_mask);
 
@@ -193,8 +187,6 @@ void call_usermodehelper_freeinfo(struct
 {
 	if (info->cleanup)
 		(*info->cleanup)(info);
-	if (info->cred)
-		put_cred(info->cred);
 	kfree(info);
 }
 EXPORT_SYMBOL(call_usermodehelper_freeinfo);
@@ -250,8 +242,6 @@ static void __call_usermodehelper(struct
 	pid_t pid;
 	enum umh_wait wait = sub_info->wait;
 
-	BUG_ON(atomic_read(&sub_info->cred->usage) != 1);
-
 	/* CLONE_VFORK: wait until the usermode helper has execve'd
 	 * successfully We need the data structures to stay around
 	 * until that is done.  */
@@ -374,12 +364,6 @@ struct subprocess_info *call_usermodehel
 	sub_info->path = path;
 	sub_info->argv = argv;
 	sub_info->envp = envp;
-	sub_info->cred = prepare_usermodehelper_creds();
-	if (!sub_info->cred) {
-		kfree(sub_info);
-		return NULL;
-	}
-
   out:
 	return sub_info;
 }
@@ -430,9 +414,6 @@ int call_usermodehelper_exec(struct subp
 	DECLARE_COMPLETION_ONSTACK(done);
 	int retval = 0;
 
-	BUG_ON(atomic_read(&sub_info->cred->usage) != 1);
-	validate_creds(sub_info->cred);
-
 	helper_lock();
 	if (sub_info->path[0] == '\0')
 		goto out;

