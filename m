Return-Path: <linux-kernel-owner+w=401wt.eu-S964808AbYHFPmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964808AbYHFPmA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 11:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759951AbYHFPj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 11:39:29 -0400
Received: from mx1.redhat.com ([66.187.233.31]:38220 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755624AbYHFPjQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 11:39:16 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 13/24] CRED: Separate per-task-group keyrings from
	signal_struct [ver #7]
To: jmorris@namei.org, akpm@linux-foundation.org, morgan@kernel.org
Cc: sfr@canb.auug.org.au, dhowells@redhat.com, viro@ftp.linux.org.uk,
       casey@schaufler-ca.com, linux-security-module@vger.kernel.org,
       linux-kernel@vger.kernel.org
Date: Wed, 06 Aug 2008 16:38:21 +0100
Message-ID: <20080806153821.14351.95508.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
References: <20080806153713.14351.91448.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separate per-task-group keyrings from signal_struct and dangle their anchor
from the cred struct rather than the signal_struct.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: James Morris <jmorris@namei.org>
---

 include/linux/cred.h         |   16 +++++++
 include/linux/key.h          |    8 +--
 include/linux/sched.h        |    6 ---
 kernel/cred.c                |   61 ++++++++++++++++++++++++++
 kernel/fork.c                |    8 ---
 security/keys/process_keys.c |   99 +++++++++++++++++-------------------------
 security/keys/request_key.c  |   34 ++++++--------
 7 files changed, 132 insertions(+), 100 deletions(-)


diff --git a/include/linux/cred.h b/include/linux/cred.h
index 5c4e098..28e1d0e 100644
--- a/include/linux/cred.h
+++ b/include/linux/cred.h
@@ -72,6 +72,21 @@ extern int in_group_p(gid_t);
 extern int in_egroup_p(gid_t);
 
 /*
+ * The common credentials for a thread group
+ * - shared by CLONE_THREAD
+ */
+#ifdef CONFIG_KEYS
+struct thread_group_cred {
+	atomic_t	usage;
+	pid_t		tgid;			/* thread group process ID */
+	spinlock_t	lock;
+	struct key	*session_keyring;	/* keyring inherited over fork */
+	struct key	*process_keyring;	/* keyring private to this process */
+	struct rcu_head	rcu;			/* RCU deletion hook */
+};
+#endif
+
+/*
  * The security context of a task
  *
  * The parts of the context break down into two categories:
@@ -114,6 +129,7 @@ struct cred {
 					 * keys to */
 	struct key	*thread_keyring; /* keyring private to this thread */
 	struct key	*request_key_auth; /* assumed request_key authority */
+	struct thread_group_cred *tgcred; /* thread-group shared credentials */
 #endif
 #ifdef CONFIG_SECURITY
 	void		*security;	/* subjective LSM security */
diff --git a/include/linux/key.h b/include/linux/key.h
index 599a37c..1a18ae9 100644
--- a/include/linux/key.h
+++ b/include/linux/key.h
@@ -278,9 +278,7 @@ extern ctl_table key_sysctls[];
  */
 extern void switch_uid_keyring(struct user_struct *new_user);
 extern int copy_keys(unsigned long clone_flags, struct task_struct *tsk);
-extern int copy_thread_group_keys(struct task_struct *tsk);
 extern void exit_keys(struct task_struct *tsk);
-extern void exit_thread_group_keys(struct signal_struct *tg);
 extern int suid_keys(struct task_struct *tsk);
 extern int exec_keys(struct task_struct *tsk);
 extern void key_fsuid_changed(struct task_struct *tsk);
@@ -289,8 +287,8 @@ extern void key_init(void);
 
 #define __install_session_keyring(keyring)				\
 ({									\
-	struct key *old_session = current->signal->session_keyring;	\
-	current->signal->session_keyring = keyring;			\
+	struct key *old_session = current->cred->tgcred->session_keyring; \
+	current->cred->tgcred->session_keyring = keyring;		\
 	old_session;							\
 })
 
@@ -307,9 +305,7 @@ extern void key_init(void);
 #define switch_uid_keyring(u)		do { } while(0)
 #define __install_session_keyring(k)	NULL
 #define copy_keys(f,t)			0
-#define copy_thread_group_keys(t)	0
 #define exit_keys(t)			do { } while(0)
-#define exit_thread_group_keys(tg)	do { } while(0)
 #define suid_keys(t)			do { } while(0)
 #define exec_keys(t)			do { } while(0)
 #define key_fsuid_changed(t)		do { } while(0)
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 041b153..7916519 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -529,12 +529,6 @@ struct signal_struct {
 
 	struct list_head cpu_timers[3];
 
-	/* keep the process-shared keyrings here so that they do the right
-	 * thing in threads created with CLONE_THREAD */
-#ifdef CONFIG_KEYS
-	struct key *session_keyring;	/* keyring inherited over fork */
-	struct key *process_keyring;	/* keyring private to this process */
-#endif
 #ifdef CONFIG_BSD_PROCESS_ACCT
 	struct pacct_struct pacct;	/* per-process accounting information */
 #endif
diff --git a/kernel/cred.c b/kernel/cred.c
index 2195841..6090cb6 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -17,6 +17,17 @@
 #include <linux/security.h>
 
 /*
+ * The common credentials for the initial task's thread group
+ */
+#ifdef CONFIG_KEYS
+static struct thread_group_cred init_tgcred = {
+	.usage	= ATOMIC_INIT(2),
+	.tgid	= 0,
+	.lock	= SPIN_LOCK_UNLOCKED,
+};
+#endif
+
+/*
  * The initial credentials for the initial task
  */
 struct cred init_cred = {
@@ -28,9 +39,40 @@ struct cred init_cred = {
 	.cap_bset		= CAP_INIT_BSET,
 	.user			= INIT_USER,
 	.group_info		= &init_groups,
+#ifdef CONFIG_KEYS
+	.tgcred			= &init_tgcred,
+#endif
 };
 
 /*
+ * Dispose of the shared task group credentials
+ */
+#ifdef CONFIG_KEYS
+static void put_tgcred_rcu(struct rcu_head *rcu)
+{
+	struct thread_group_cred *tgcred =
+		container_of(rcu, struct thread_group_cred, rcu);
+
+	BUG_ON(atomic_read(&tgcred->usage) != 0);
+
+	key_put(tgcred->session_keyring);
+	key_put(tgcred->process_keyring);
+	kfree(tgcred);
+}
+#endif
+
+/*
+ * Release a set of thread group credentials.
+ */
+static void put_tgcred(struct thread_group_cred *tgcred)
+{
+#ifdef CONFIG_KEYS
+	if (atomic_dec_and_test(&tgcred->usage))
+		call_rcu(&tgcred->rcu, put_tgcred_rcu);
+#endif
+}
+
+/*
  * The RCU callback to actually dispose of a set of credentials
  */
 static void put_cred_rcu(struct rcu_head *rcu)
@@ -41,6 +83,7 @@ static void put_cred_rcu(struct rcu_head *rcu)
 
 	key_put(cred->thread_keyring);
 	key_put(cred->request_key_auth);
+	put_tgcred(cred->tgcred);
 	put_group_info(cred->group_info);
 	free_uid(cred->user);
 	security_cred_free(cred);
@@ -71,12 +114,30 @@ int copy_creds(struct task_struct *p, unsigned long clone_flags)
 	if (!pcred)
 		return -ENOMEM;
 
+#ifdef CONFIG_KEYS
+	if (clone_flags & CLONE_THREAD) {
+		atomic_inc(&pcred->tgcred->usage);
+	} else {
+		pcred->tgcred = kmalloc(sizeof(struct cred), GFP_KERNEL);
+		if (!pcred->tgcred) {
+			kfree(pcred);
+			return -ENOMEM;
+		}
+		atomic_set(&pcred->tgcred->usage, 1);
+		spin_lock_init(&pcred->tgcred->lock);
+		pcred->tgcred->process_keyring = NULL;
+		pcred->tgcred->session_keyring =
+			key_get(p->cred->tgcred->session_keyring);
+	}
+#endif
+
 #ifdef CONFIG_SECURITY
 	pcred->security = NULL;
 #endif
 
 	ret = security_cred_alloc(pcred);
 	if (ret < 0) {
+		put_tgcred(pcred->tgcred);
 		kfree(pcred);
 		return ret;
 	}
diff --git a/kernel/fork.c b/kernel/fork.c
index 8993a45..b3254d5 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -760,7 +760,6 @@ void __cleanup_sighand(struct sighand_struct *sighand)
 static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 {
 	struct signal_struct *sig;
-	int ret;
 
 	if (clone_flags & CLONE_THREAD) {
 		atomic_inc(&current->signal->count);
@@ -772,12 +771,6 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 	if (!sig)
 		return -ENOMEM;
 
-	ret = copy_thread_group_keys(tsk);
-	if (ret < 0) {
-		kmem_cache_free(signal_cachep, sig);
-		return ret;
-	}
-
 	atomic_set(&sig->count, 1);
 	atomic_set(&sig->live, 1);
 	init_waitqueue_head(&sig->wait_chldexit);
@@ -835,7 +828,6 @@ static int copy_signal(unsigned long clone_flags, struct task_struct *tsk)
 
 void __cleanup_signal(struct signal_struct *sig)
 {
-	exit_thread_group_keys(sig);
 	kmem_cache_free(signal_cachep, sig);
 }
 
diff --git a/security/keys/process_keys.c b/security/keys/process_keys.c
index d3fa0ae..b0a6060 100644
--- a/security/keys/process_keys.c
+++ b/security/keys/process_keys.c
@@ -189,7 +189,7 @@ int install_process_keyring(void)
 
 	might_sleep();
 
-	if (!tsk->signal->process_keyring) {
+	if (!tsk->cred->tgcred->process_keyring) {
 		sprintf(buf, "_pid.%u", tsk->tgid);
 
 		keyring = keyring_alloc(buf, tsk->cred->uid, tsk->cred->gid, tsk,
@@ -200,12 +200,12 @@ int install_process_keyring(void)
 		}
 
 		/* attach keyring */
-		spin_lock_irq(&tsk->sighand->siglock);
-		if (!tsk->signal->process_keyring) {
-			tsk->signal->process_keyring = keyring;
+		spin_lock_irq(&tsk->cred->tgcred->lock);
+		if (!tsk->cred->tgcred->process_keyring) {
+			tsk->cred->tgcred->process_keyring = keyring;
 			keyring = NULL;
 		}
-		spin_unlock_irq(&tsk->sighand->siglock);
+		spin_unlock_irq(&tsk->cred->tgcred->lock);
 
 		key_put(keyring);
 	}
@@ -235,11 +235,11 @@ static int install_session_keyring(struct key *keyring)
 		sprintf(buf, "_ses.%u", tsk->tgid);
 
 		flags = KEY_ALLOC_QUOTA_OVERRUN;
-		if (tsk->signal->session_keyring)
+		if (tsk->cred->tgcred->session_keyring)
 			flags = KEY_ALLOC_IN_QUOTA;
 
-		keyring = keyring_alloc(buf, tsk->cred->uid, tsk->cred->gid, tsk,
-					flags, NULL);
+		keyring = keyring_alloc(buf, tsk->cred->uid, tsk->cred->gid,
+					tsk, flags, NULL);
 		if (IS_ERR(keyring))
 			return PTR_ERR(keyring);
 	}
@@ -248,10 +248,10 @@ static int install_session_keyring(struct key *keyring)
 	}
 
 	/* install the keyring */
-	spin_lock_irq(&tsk->sighand->siglock);
-	old = tsk->signal->session_keyring;
-	rcu_assign_pointer(tsk->signal->session_keyring, keyring);
-	spin_unlock_irq(&tsk->sighand->siglock);
+	spin_lock_irq(&tsk->cred->tgcred->lock);
+	old = tsk->cred->tgcred->session_keyring;
+	rcu_assign_pointer(tsk->cred->tgcred->session_keyring, keyring);
+	spin_unlock_irq(&tsk->cred->tgcred->lock);
 
 	/* we're using RCU on the pointer, but there's no point synchronising
 	 * on it if it didn't previously point to anything */
@@ -266,28 +266,6 @@ static int install_session_keyring(struct key *keyring)
 
 /*****************************************************************************/
 /*
- * copy the keys in a thread group for fork without CLONE_THREAD
- */
-int copy_thread_group_keys(struct task_struct *tsk)
-{
-	key_check(current->thread_group->session_keyring);
-	key_check(current->thread_group->process_keyring);
-
-	/* no process keyring yet */
-	tsk->signal->process_keyring = NULL;
-
-	/* same session keyring */
-	rcu_read_lock();
-	tsk->signal->session_keyring =
-		key_get(rcu_dereference(current->signal->session_keyring));
-	rcu_read_unlock();
-
-	return 0;
-
-} /* end copy_thread_group_keys() */
-
-/*****************************************************************************/
-/*
  * copy the keys for fork
  */
 int copy_keys(unsigned long clone_flags, struct task_struct *tsk)
@@ -307,17 +285,6 @@ int copy_keys(unsigned long clone_flags, struct task_struct *tsk)
 
 /*****************************************************************************/
 /*
- * dispose of thread group keys upon thread group destruction
- */
-void exit_thread_group_keys(struct signal_struct *tg)
-{
-	key_put(tg->session_keyring);
-	key_put(tg->process_keyring);
-
-} /* end exit_thread_group_keys() */
-
-/*****************************************************************************/
-/*
  * dispose of per-thread keys upon thread exit
  */
 void exit_keys(struct task_struct *tsk)
@@ -344,10 +311,10 @@ int exec_keys(struct task_struct *tsk)
 	key_put(old);
 
 	/* discard the process keyring from a newly exec'd task */
-	spin_lock_irq(&tsk->sighand->siglock);
-	old = tsk->signal->process_keyring;
-	tsk->signal->process_keyring = NULL;
-	spin_unlock_irq(&tsk->sighand->siglock);
+	spin_lock_irq(&tsk->cred->tgcred->lock);
+	old = tsk->cred->tgcred->process_keyring;
+	tsk->cred->tgcred->process_keyring = NULL;
+	spin_unlock_irq(&tsk->cred->tgcred->lock);
 
 	key_put(old);
 
@@ -452,9 +419,9 @@ key_ref_t search_process_keyrings(struct key_type *type,
 	}
 
 	/* search the process keyring second */
-	if (context->signal->process_keyring) {
+	if (cred->tgcred->process_keyring) {
 		key_ref = keyring_search_aux(
-			make_key_ref(context->signal->process_keyring, 1),
+			make_key_ref(cred->tgcred->process_keyring, 1),
 			context, type, description, match);
 		if (!IS_ERR(key_ref))
 			goto found;
@@ -473,11 +440,11 @@ key_ref_t search_process_keyrings(struct key_type *type,
 	}
 
 	/* search the session keyring */
-	if (context->signal->session_keyring) {
+	if (cred->tgcred->session_keyring) {
 		rcu_read_lock();
 		key_ref = keyring_search_aux(
 			make_key_ref(rcu_dereference(
-					     context->signal->session_keyring),
+					     cred->tgcred->session_keyring),
 				     1),
 			context, type, description, match);
 		rcu_read_unlock();
@@ -586,11 +553,13 @@ key_ref_t lookup_user_key(key_serial_t id, int create, int partial,
 {
 	struct request_key_auth *rka;
 	struct task_struct *t = current;
-	struct cred *cred = current_cred();
+	struct cred *cred;
 	struct key *key;
 	key_ref_t key_ref, skey_ref;
 	int ret;
 
+try_again:
+	cred = get_current_cred();
 	key_ref = ERR_PTR(-ENOKEY);
 
 	switch (id) {
@@ -604,6 +573,7 @@ key_ref_t lookup_user_key(key_serial_t id, int create, int partial,
 				key = ERR_PTR(ret);
 				goto error;
 			}
+			goto reget_creds;
 		}
 
 		key = cred->thread_keyring;
@@ -612,7 +582,7 @@ key_ref_t lookup_user_key(key_serial_t id, int create, int partial,
 		break;
 
 	case KEY_SPEC_PROCESS_KEYRING:
-		if (!t->signal->process_keyring) {
+		if (!cred->tgcred->process_keyring) {
 			if (!create)
 				goto error;
 
@@ -621,15 +591,16 @@ key_ref_t lookup_user_key(key_serial_t id, int create, int partial,
 				key = ERR_PTR(ret);
 				goto error;
 			}
+			goto reget_creds;
 		}
 
-		key = t->signal->process_keyring;
+		key = cred->tgcred->process_keyring;
 		atomic_inc(&key->usage);
 		key_ref = make_key_ref(key, 1);
 		break;
 
 	case KEY_SPEC_SESSION_KEYRING:
-		if (!t->signal->session_keyring) {
+		if (!cred->tgcred->session_keyring) {
 			/* always install a session keyring upon access if one
 			 * doesn't exist yet */
 			ret = install_user_keyrings();
@@ -639,10 +610,11 @@ key_ref_t lookup_user_key(key_serial_t id, int create, int partial,
 				cred->user->session_keyring);
 			if (ret < 0)
 				goto error;
+			goto reget_creds;
 		}
 
 		rcu_read_lock();
-		key = rcu_dereference(t->signal->session_keyring);
+		key = rcu_dereference(cred->tgcred->session_keyring);
 		atomic_inc(&key->usage);
 		rcu_read_unlock();
 		key_ref = make_key_ref(key, 1);
@@ -765,6 +737,12 @@ invalid_key:
 	key_ref = ERR_PTR(ret);
 	goto error;
 
+	/* if we attempted to install a keyring, then it may have caused new
+	 * creds to be installed */
+reget_creds:
+	put_cred(cred);
+	goto try_again;
+
 } /* end lookup_user_key() */
 
 /*****************************************************************************/
@@ -777,6 +755,7 @@ invalid_key:
 long join_session_keyring(const char *name)
 {
 	struct task_struct *tsk = current;
+	struct cred *cred = current->cred;
 	struct key *keyring;
 	long ret;
 
@@ -787,7 +766,7 @@ long join_session_keyring(const char *name)
 			goto error;
 
 		rcu_read_lock();
-		ret = rcu_dereference(tsk->signal->session_keyring)->serial;
+		ret = rcu_dereference(cred->tgcred->session_keyring)->serial;
 		rcu_read_unlock();
 		goto error;
 	}
@@ -799,7 +778,7 @@ long join_session_keyring(const char *name)
 	keyring = find_keyring_by_name(name, false);
 	if (PTR_ERR(keyring) == -ENOKEY) {
 		/* not found - try and create a new one */
-		keyring = keyring_alloc(name, tsk->cred->uid, tsk->cred->gid, tsk,
+		keyring = keyring_alloc(name, cred->uid, cred->gid, tsk,
 					KEY_ALLOC_IN_QUOTA, NULL);
 		if (IS_ERR(keyring)) {
 			ret = PTR_ERR(keyring);
diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index 650cc3e..fe5d4fb 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -66,7 +66,6 @@ static int call_sbin_request_key(struct key_construction *cons,
 				 const char *op,
 				 void *aux)
 {
-	struct task_struct *tsk = current;
 	const struct cred *cred = current_cred();
 	key_serial_t prkey, sskey;
 	struct key *key = cons->key, *authkey = cons->authkey, *keyring;
@@ -105,18 +104,13 @@ static int call_sbin_request_key(struct key_construction *cons,
 		cred->thread_keyring->serial : 0);
 
 	prkey = 0;
-	if (tsk->signal->process_keyring)
-		prkey = tsk->signal->process_keyring->serial;
+	if (cred->tgcred->process_keyring)
+		prkey = cred->tgcred->process_keyring->serial;
 
-	sprintf(keyring_str[1], "%d", prkey);
-
-	if (tsk->signal->session_keyring) {
-		rcu_read_lock();
-		sskey = rcu_dereference(tsk->signal->session_keyring)->serial;
-		rcu_read_unlock();
-	} else {
+	if (cred->tgcred->session_keyring)
+		sskey = rcu_dereference(cred->tgcred->session_keyring)->serial;
+	else
 		sskey = cred->user->session_keyring->serial;
-	}
 
 	sprintf(keyring_str[2], "%d", sskey);
 
@@ -218,7 +212,7 @@ static int construct_key(struct key *key, const void *callout_info,
 static void construct_get_dest_keyring(struct key **_dest_keyring)
 {
 	struct request_key_auth *rka;
-	struct task_struct *tsk = current;
+	const struct cred *cred = current_cred();
 	struct key *dest_keyring = *_dest_keyring, *authkey;
 
 	kenter("%p", dest_keyring);
@@ -230,11 +224,11 @@ static void construct_get_dest_keyring(struct key **_dest_keyring)
 	} else {
 		/* use a default keyring; falling through the cases until we
 		 * find one that we actually have */
-		switch (tsk->cred->jit_keyring) {
+		switch (cred->jit_keyring) {
 		case KEY_REQKEY_DEFL_DEFAULT:
 		case KEY_REQKEY_DEFL_REQUESTOR_KEYRING:
-			if (tsk->cred->request_key_auth) {
-				authkey = tsk->cred->request_key_auth;
+			if (cred->request_key_auth) {
+				authkey = cred->request_key_auth;
 				down_read(&authkey->sem);
 				rka = authkey->payload.data;
 				if (!test_bit(KEY_FLAG_REVOKED,
@@ -247,19 +241,19 @@ static void construct_get_dest_keyring(struct key **_dest_keyring)
 			}
 
 		case KEY_REQKEY_DEFL_THREAD_KEYRING:
-			dest_keyring = key_get(tsk->cred->thread_keyring);
+			dest_keyring = key_get(cred->thread_keyring);
 			if (dest_keyring)
 				break;
 
 		case KEY_REQKEY_DEFL_PROCESS_KEYRING:
-			dest_keyring = key_get(tsk->signal->process_keyring);
+			dest_keyring = key_get(cred->tgcred->process_keyring);
 			if (dest_keyring)
 				break;
 
 		case KEY_REQKEY_DEFL_SESSION_KEYRING:
 			rcu_read_lock();
 			dest_keyring = key_get(
-				rcu_dereference(tsk->signal->session_keyring));
+				rcu_dereference(cred->tgcred->session_keyring));
 			rcu_read_unlock();
 
 			if (dest_keyring)
@@ -267,11 +261,11 @@ static void construct_get_dest_keyring(struct key **_dest_keyring)
 
 		case KEY_REQKEY_DEFL_USER_SESSION_KEYRING:
 			dest_keyring =
-				key_get(tsk->cred->user->session_keyring);
+				key_get(cred->user->session_keyring);
 			break;
 
 		case KEY_REQKEY_DEFL_USER_KEYRING:
-			dest_keyring = key_get(tsk->cred->user->uid_keyring);
+			dest_keyring = key_get(cred->user->uid_keyring);
 			break;
 
 		case KEY_REQKEY_DEFL_GROUP_KEYRING:

