Return-Path: <linux-kernel-owner+w=401wt.eu-S933235AbYBTQST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235AbYBTQST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2008 11:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765101AbYBTQKI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Feb 2008 11:10:08 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45423 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764988AbYBTQJe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2008 11:09:34 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 04/37] KEYS: Add keyctl function to get a security label
To: Trond.Myklebust@netapp.com, chuck.lever@oracle.com, casey@schaufler-ca.com
Cc: nfsv4@linux-nfs.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, selinux@tycho.nsa.gov,
       linux-security-module@vger.kernel.org, dhowells@redhat.com
Date: Wed, 20 Feb 2008 16:06:19 +0000
Message-ID: <20080220160619.4715.98266.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
References: <20080220160557.4715.66608.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a keyctl() function to get the security label of a key.

The following is added to Documentation/keys.txt:

 (*) Get the LSM security context attached to a key.

	long keyctl(KEYCTL_GET_SECURITY, key_serial_t key, char *buffer,
		    size_t buflen)

     This function returns a string that represents the LSM security context
     attached to a key in the buffer provided.

     Unless there's an error, it always returns the amount of data it could
     produce, even if that's too big for the buffer, but it won't copy more
     than requested to userspace. If the buffer pointer is NULL then no copy
     will take place.

     A NUL character is included at the end of the string if the buffer is
     sufficiently big.  This is included in the returned count.  If no LSM is
     in force then an empty string will be returned.

     A process must have view permission on the key for this function to be
     successful.

Signed-off-by: David Howells <dhowells@redhat.com>
Acked-by:  Stephen Smalley <sds@tycho.nsa.gov>
---

 Documentation/keys.txt   |   21 +++++++++++++++
 include/linux/keyctl.h   |    1 +
 include/linux/security.h |   20 +++++++++++++-
 security/dummy.c         |    8 ++++++
 security/keys/compat.c   |    3 ++
 security/keys/keyctl.c   |   66 ++++++++++++++++++++++++++++++++++++++++++++++
 security/security.c      |    5 +++
 security/selinux/hooks.c |   21 +++++++++++++--
 8 files changed, 141 insertions(+), 4 deletions(-)


diff --git a/Documentation/keys.txt b/Documentation/keys.txt
index b82d38d..be424b0 100644
--- a/Documentation/keys.txt
+++ b/Documentation/keys.txt
@@ -711,6 +711,27 @@ The keyctl syscall functions are:
      The assumed authoritative key is inherited across fork and exec.
 
 
+ (*) Get the LSM security context attached to a key.
+
+	long keyctl(KEYCTL_GET_SECURITY, key_serial_t key, char *buffer,
+		    size_t buflen)
+
+     This function returns a string that represents the LSM security context
+     attached to a key in the buffer provided.
+
+     Unless there's an error, it always returns the amount of data it could
+     produce, even if that's too big for the buffer, but it won't copy more
+     than requested to userspace. If the buffer pointer is NULL then no copy
+     will take place.
+
+     A NUL character is included at the end of the string if the buffer is
+     sufficiently big.  This is included in the returned count.  If no LSM is
+     in force then an empty string will be returned.
+
+     A process must have view permission on the key for this function to be
+     successful.
+
+
 ===============
 KERNEL SERVICES
 ===============
diff --git a/include/linux/keyctl.h b/include/linux/keyctl.h
index 3365945..656ee6b 100644
--- a/include/linux/keyctl.h
+++ b/include/linux/keyctl.h
@@ -49,5 +49,6 @@
 #define KEYCTL_SET_REQKEY_KEYRING	14	/* set default request-key keyring */
 #define KEYCTL_SET_TIMEOUT		15	/* set key timeout */
 #define KEYCTL_ASSUME_AUTHORITY		16	/* assume request_key() authorisation */
+#define KEYCTL_GET_SECURITY		17	/* get key security label */
 
 #endif /*  _LINUX_KEYCTL_H */
diff --git a/include/linux/security.h b/include/linux/security.h
index fe52cde..a33fd03 100644
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -970,6 +970,17 @@ struct request_sock;
  *	@perm describes the combination of permissions required of this key.
  *	Return 1 if permission granted, 0 if permission denied and -ve it the
  *      normal permissions model should be effected.
+ * @key_getsecurity:
+ *	Get a textual representation of the security context attached to a key
+ *	for the purposes of honouring KEYCTL_GETSECURITY.  This function
+ *	allocates the storage for the NUL-terminated string and the caller
+ *	should free it.
+ *	@key points to the key to be queried.
+ *	@_buffer points to a pointer that should be set to point to the
+ *	 resulting string (if no label or an error occurs).
+ *	Return the length of the string (including terminating NUL) or -ve if
+ *      an error.
+ *	May also return 0 (and a NULL buffer pointer) if there is no label.
  *
  * Security hooks affecting all System V IPC operations.
  *
@@ -1459,7 +1470,7 @@ struct security_operations {
 	int (*key_permission)(key_ref_t key_ref,
 			      struct task_struct *context,
 			      key_perm_t perm);
-
+	int (*key_getsecurity)(struct key *key, char **_buffer);
 #endif	/* CONFIG_KEYS */
 
 };
@@ -2600,6 +2611,7 @@ int security_key_alloc(struct key *key, struct task_struct *tsk, unsigned long f
 void security_key_free(struct key *key);
 int security_key_permission(key_ref_t key_ref,
 			    struct task_struct *context, key_perm_t perm);
+int security_key_getsecurity(struct key *key, char **_buffer);
 
 #else
 
@@ -2621,6 +2633,12 @@ static inline int security_key_permission(key_ref_t key_ref,
 	return 0;
 }
 
+static inline int security_key_getsecurity(struct key *key, char **_buffer)
+{
+	*_buffer = NULL;
+	return 0;
+}
+
 #endif
 #endif /* CONFIG_KEYS */
 
diff --git a/security/dummy.c b/security/dummy.c
index 649326b..6a0056b 100644
--- a/security/dummy.c
+++ b/security/dummy.c
@@ -977,6 +977,13 @@ static inline int dummy_key_permission(key_ref_t key_ref,
 {
 	return 0;
 }
+
+static int dummy_key_getsecurity(struct key *key, char **_buffer)
+{
+	*_buffer = NULL;
+	return 0;
+}
+
 #endif /* CONFIG_KEYS */
 
 struct security_operations dummy_security_ops;
@@ -1164,6 +1171,7 @@ void security_fixup_ops (struct security_operations *ops)
 	set_to_dummy_if_null(ops, key_alloc);
 	set_to_dummy_if_null(ops, key_free);
 	set_to_dummy_if_null(ops, key_permission);
+	set_to_dummy_if_null(ops, key_getsecurity);
 #endif	/* CONFIG_KEYS */
 
 }
diff --git a/security/keys/compat.c b/security/keys/compat.c
index e10ec99..c766c68 100644
--- a/security/keys/compat.c
+++ b/security/keys/compat.c
@@ -79,6 +79,9 @@ asmlinkage long compat_sys_keyctl(u32 option,
 	case KEYCTL_ASSUME_AUTHORITY:
 		return keyctl_assume_authority(arg2);
 
+	case KEYCTL_GET_SECURITY:
+		return keyctl_get_security(arg2, compat_ptr(arg3), arg4);
+
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 1698bf9..56e963b 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -20,6 +20,7 @@
 #include <linux/string.h>
 #include <linux/err.h>
 #include <linux/vmalloc.h>
+#include <linux/security.h>
 #include <asm/uaccess.h>
 #include "internal.h"
 
@@ -1080,6 +1081,66 @@ error:
 
 } /* end keyctl_assume_authority() */
 
+/*
+ * get the security label of a key
+ * - the key must grant us view permission
+ * - if there's a buffer, we place up to buflen bytes of data into it
+ * - unless there's an error, we return the amount of information available,
+ *   irrespective of how much we may have copied (including the terminal NUL)
+ * - implements keyctl(KEYCTL_GET_SECURITY)
+ */
+long keyctl_get_security(key_serial_t keyid,
+			 char __user *buffer,
+			 size_t buflen)
+{
+	struct key *key, *instkey;
+	key_ref_t key_ref;
+	char *context;
+	long ret;
+
+	key_ref = lookup_user_key(NULL, keyid, 0, 1, KEY_VIEW);
+	if (IS_ERR(key_ref)) {
+		if (PTR_ERR(key_ref) != -EACCES)
+			return PTR_ERR(key_ref);
+
+		/* viewing a key under construction is also permitted if we
+		 * have the authorisation token handy */
+		instkey = key_get_instantiation_authkey(keyid);
+		if (IS_ERR(instkey))
+			return PTR_ERR(key_ref);
+		key_put(instkey);
+
+		key_ref = lookup_user_key(NULL, keyid, 0, 1, 0);
+		if (IS_ERR(key_ref))
+			return PTR_ERR(key_ref);
+	}
+
+	key = key_ref_to_ptr(key_ref);
+	ret = security_key_getsecurity(key, &context);
+	if (ret == 0) {
+		/* if no information was returned, give userspace an empty
+		 * string */
+		ret = 1;
+		if (buffer && buflen > 0 &&
+		    copy_to_user(buffer, "", 1) != 0)
+			ret = -EFAULT;
+	} else if (ret > 0) {
+		/* return as much data as there's room for */
+		if (buffer && buflen > 0) {
+			if (buflen > ret)
+				buflen = ret;
+
+			if (copy_to_user(buffer, context, buflen) != 0)
+				ret = -EFAULT;
+		}
+
+		kfree(context);
+	}
+
+	key_ref_put(key_ref);
+	return ret;
+}
+
 /*****************************************************************************/
 /*
  * the key control system call
@@ -1160,6 +1221,11 @@ asmlinkage long sys_keyctl(int option, unsigned long arg2, unsigned long arg3,
 	case KEYCTL_ASSUME_AUTHORITY:
 		return keyctl_assume_authority((key_serial_t) arg2);
 
+	case KEYCTL_GET_SECURITY:
+		return keyctl_get_security((key_serial_t) arg2,
+					   (char *) arg3,
+					   (size_t) arg4);
+
 	default:
 		return -EOPNOTSUPP;
 	}
diff --git a/security/security.c b/security/security.c
index d15e56c..3e75b90 100644
--- a/security/security.c
+++ b/security/security.c
@@ -1102,4 +1102,9 @@ int security_key_permission(key_ref_t key_ref,
 	return security_ops->key_permission(key_ref, context, perm);
 }
 
+int security_key_getsecurity(struct key *key, char **_buffer)
+{
+	return security_ops->key_getsecurity(key, _buffer);
+}
+
 #endif	/* CONFIG_KEYS */
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index 75c2e99..f42ebfc 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -5216,6 +5216,20 @@ static int selinux_key_permission(key_ref_t key_ref,
 			    SECCLASS_KEY, perm, NULL);
 }
 
+static int selinux_key_getsecurity(struct key *key, char **_buffer)
+{
+	struct key_security_struct *ksec = key->security;
+	char *context = NULL;
+	unsigned len;
+	int rc;
+
+	rc = security_sid_to_context(ksec->sid, &context, &len);
+	if (!rc)
+		rc = len;
+	*_buffer = context;
+	return rc;
+}
+
 #endif
 
 static struct security_operations selinux_ops = {
@@ -5395,9 +5409,10 @@ static struct security_operations selinux_ops = {
 #endif
 
 #ifdef CONFIG_KEYS
-	.key_alloc =                    selinux_key_alloc,
-	.key_free =                     selinux_key_free,
-	.key_permission =               selinux_key_permission,
+	.key_alloc =			selinux_key_alloc,
+	.key_free =			selinux_key_free,
+	.key_permission =		selinux_key_permission,
+	.key_getsecurity =		selinux_key_getsecurity,
 #endif
 };
 

