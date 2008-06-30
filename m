Return-Path: <linux-kernel-owner+w=401wt.eu-S932183AbYF3NbI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183AbYF3NbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 09:31:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755180AbYF3Naz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 09:30:55 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45808 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754442AbYF3Nay (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 09:30:54 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <29651.1214831711@redhat.com>
References: <29651.1214831711@redhat.com> <48635799.3010500@kernel.org>
Cc: dhowells@redhat.com, "Andrew G. Morgan" <morgan@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Linux Security Modules List 
	<linux-security-module@vger.kernel.org>
Subject: Re: [PATCH 1/4] security: filesystem capabilities bugfix1
X-Mailer: MH-E 8.0.3+cvs; nmh 1.3; GNU Emacs 23.0.50
Date: Mon, 30 Jun 2008 14:30:35 +0100
Message-ID: <18390.1214832635@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> > +kernel_cap_t cap_set_effective(const kernel_cap_t pE_new)
> 
> Hmmm... kernel_cap_t is a structure that might not fit into a single register.
> It occurs to me that you might be better off returing the old caps through a
> pointer argument.

Apply something like the attached, perhaps?  (Note the attached patch is
missing the change from linux/capability.h because my version is not
compatible with your submitted patch).

David

diff --git a/fs/open.c b/fs/open.c
index 3b53948..24b4a11 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -451,9 +451,9 @@ asmlinkage long sys_faccessat(int dfd, const char __user *filename, int mode)
 		 */
 #endif /* ndef CONFIG_SECURITY_FILE_CAPABILITIES */
 		if (current->uid)
-			old_cap = cap_set_effective(__cap_empty_set);
+			cap_set_effective(&__cap_empty_set, &old_cap);
 		else
-			old_cap = cap_set_effective(current->cap_permitted);
+			cap_set_effective(&current->cap_permitted, &old_cap);
 	}
 
 	res = __user_walk_fd(dfd, filename, LOOKUP_FOLLOW|LOOKUP_ACCESS, &nd);
@@ -484,9 +484,8 @@ out:
 	current->fsuid = old_fsuid;
 	current->fsgid = old_fsgid;
 
-	if (!issecure(SECURE_NO_SETUID_FIXUP)) {
-		(void) cap_set_effective(old_cap);
-	}
+	if (!issecure(SECURE_NO_SETUID_FIXUP))
+		cap_set_effective(&old_cap, NULL);
 
 	return res;
 }
diff --git a/kernel/capability.c b/kernel/capability.c
index c3bf957..13c496a 100644
--- a/kernel/capability.c
+++ b/kernel/capability.c
@@ -126,18 +126,16 @@ static int cap_validate_magic(cap_user_header_t header, unsigned *tocopy)
  * value. No permission check is performed here - it is assumed that the
  * caller is permitted to set the desired effective capabilities.
  */
-kernel_cap_t cap_set_effective(const kernel_cap_t pE_new)
+void cap_set_effective(const kernel_cap_t *pE_new,
+		       kernel_cap_t *_pE_old)
 {
-	kernel_cap_t pE_old;
-
 	spin_lock(&task_capability_lock);
 
-	pE_old = current->cap_effective;
-	current->cap_effective = pE_new;
+	if (_pE_old)
+		*_pE_old = current->cap_effective;
+	current->cap_effective = *pE_new;
 
 	spin_unlock(&task_capability_lock);
-
-	return pE_old;
 }
 
 EXPORT_SYMBOL(cap_set_effective);
