Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933236Ab0BYSQZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 13:16:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932681Ab0BYSQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 13:16:12 -0500
Date: Thu, 25 Feb 2010 19:15:00 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Neil Horman <nhorman@tuxdriver.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH -mm 1/2] umh && creds: convert call_usermodehelper_keys()
	to use subprocess_info->init()
Message-ID: <20100225181500.GA18008@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

call_usermodehelper_keys() uses call_usermodehelper_setkeys() to change
subprocess_info->cred in advance. Now that we have info->init() we can
change this code to set tgcred->session_keyring in context of execing
kernel thread.

Note: since currently call_usermodehelper_keys() is never called with
UMH_NO_WAIT, umh_keys_cleanup() is not really needed, we could just move
key_get() from call_usermodehelper_keys() to umh_keys_init().

Compile tested.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/kmod.h        |   17 -----------------
 kernel/kmod.c               |   18 ------------------
 security/keys/request_key.c |   37 +++++++++++++++++++++++++++++++++++++
 3 files changed, 37 insertions(+), 35 deletions(-)

--- mm/include/linux/kmod.h~1_CONVERT_KEYS	2010-02-25 17:37:41.000000000 +0100
+++ mm/include/linux/kmod.h	2010-02-25 18:56:41.000000000 +0100
@@ -71,8 +71,6 @@ struct subprocess_info *call_usermodehel
 						  char **envp, gfp_t gfp_mask);
 
 /* Set various pieces of state into the subprocess_info structure */
-void call_usermodehelper_setkeys(struct subprocess_info *info,
-				 struct key *session_keyring);
 void call_usermodehelper_setfns(struct subprocess_info *info,
 		    int (*init)(struct subprocess_info *info),
 		    void (*cleanup)(struct subprocess_info *info),
@@ -108,21 +106,6 @@ call_usermodehelper(char *path, char **a
 				       wait, NULL, NULL, NULL);
 }
 
-static inline int
-call_usermodehelper_keys(char *path, char **argv, char **envp,
-			 struct key *session_keyring, enum umh_wait wait)
-{
-	struct subprocess_info *info;
-	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
-
-	info = call_usermodehelper_setup(path, argv, envp, gfp_mask);
-	if (info == NULL)
-		return -ENOMEM;
-
-	call_usermodehelper_setkeys(info, session_keyring);
-	return call_usermodehelper_exec(info, wait);
-}
-
 extern void usermodehelper_init(void);
 
 extern int usermodehelper_disable(void);
--- mm/kernel/kmod.c~1_CONVERT_KEYS	2010-02-25 17:37:41.000000000 +0100
+++ mm/kernel/kmod.c	2010-02-25 18:56:41.000000000 +0100
@@ -386,24 +386,6 @@ struct subprocess_info *call_usermodehel
 EXPORT_SYMBOL(call_usermodehelper_setup);
 
 /**
- * call_usermodehelper_setkeys - set the session keys for usermode helper
- * @info: a subprocess_info returned by call_usermodehelper_setup
- * @session_keyring: the session keyring for the process
- */
-void call_usermodehelper_setkeys(struct subprocess_info *info,
-				 struct key *session_keyring)
-{
-#ifdef CONFIG_KEYS
-	struct thread_group_cred *tgcred = info->cred->tgcred;
-	key_put(tgcred->session_keyring);
-	tgcred->session_keyring = key_get(session_keyring);
-#else
-	BUG();
-#endif
-}
-EXPORT_SYMBOL(call_usermodehelper_setkeys);
-
-/**
  * call_usermodehelper_setfns - set a cleanup/init function
  * @info: a subprocess_info returned by call_usermodehelper_setup
  * @cleanup: a cleanup function
--- mm/security/keys/request_key.c~1_CONVERT_KEYS	2010-02-25 17:37:41.000000000 +0100
+++ mm/security/keys/request_key.c	2010-02-25 19:01:26.000000000 +0100
@@ -58,6 +58,43 @@ void complete_request_key(struct key_con
 }
 EXPORT_SYMBOL(complete_request_key);
 
+static int umh_keys_init(struct subprocess_info *info)
+{
+	struct thread_group_cred *tgcred = current_cred()->tgcred;
+	struct key *session_keyring = info->data;
+	/*
+	 * This is called in context of freshly forked kthread before
+	 * kernel_execve(), we can just change our ->session_keyring.
+	 */
+	WARN_ON(tgcred->session_keyring);
+	tgcred->session_keyring = session_keyring;
+
+	info->data = NULL;		/* for umh_keys_cleanup() */
+	return 0;
+}
+
+static void umh_keys_cleanup(struct subprocess_info *info)
+{
+	struct key *session_keyring = info->data;
+	key_put(session_keyring);	/* NULL if successs */
+}
+
+static inline int
+call_usermodehelper_keys(char *path, char **argv, char **envp,
+			 struct key *session_keyring, enum umh_wait wait)
+{
+	gfp_t gfp_mask = (wait == UMH_NO_WAIT) ? GFP_ATOMIC : GFP_KERNEL;
+	struct subprocess_info *info =
+		call_usermodehelper_setup(path, argv, envp, gfp_mask);
+
+	if (!info)
+		return -ENOMEM;
+
+	call_usermodehelper_setfns(info, umh_keys_init, umh_keys_cleanup,
+					key_get(session_keyring));
+	return call_usermodehelper_exec(info, wait);
+}
+
 /*
  * request userspace finish the construction of a key
  * - execute "/sbin/request-key <op> <key> <uid> <gid> <keyring> <keyring> <keyring>"

