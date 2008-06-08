Return-Path: <linux-kernel-owner+w=401wt.eu-S1754687AbYFHNjN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687AbYFHNjN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 09:39:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752165AbYFHNiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 09:38:55 -0400
Received: from ug-out-1314.google.com ([66.249.92.168]:48515 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbYFHNiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 09:38:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=jG3iG6CxuhDIXLsCvmXSKgop4Xy1HtSjSWiYI3EDtwJxr+YBF++cSz+0GxeJuNNQKO
         B9PvkQ/g+vyY3at2FV2vsMU3j8HfT6lFnon+acAFWCoOMzpl76EN6cnt2Kep0txTOb83
         zNHhlHlsnbb1R2L7h41X+XDI5b1QnmcLaHtXQ=
Subject: Re: [ linus-git ] prctl(PR_SET_KEEPCAPS, ...) is broken for some
	configs, e.g. CONFIG_SECURITY_SELINUX
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: "Andrew G. Morgan" <morgan@kernel.org>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 08 Jun 2008 15:38:41 +0200
Message-Id: <1212932321.4675.9.camel@earth>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



The following move-it-back-to-generic-place patch fixes the problem.


---
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Subject: fix prctl()'s handling of PR_{SET,GET}_KEEPCAPS
    
with the commit 3898b1b4ebff8dcfbcf1807e0661585e06c9a91c

prctl(PR_SET_KEEPCAPS, {1 | 0}, 0, 0, 0);

always returns -EINVAL for the following configs:

1) CONFIG_SECURITY but without any of CONFIG_SECURITY_* modules;

2) CONFIG_SECURITY + CONFIG_SECURITY_SELINUX + CONFIG_SECURITY_SELINUX_DISABLE

both fall back to 'dummy' implementation.

3) CONFIG_SECURITY + CONFIG_SECURITY_SELINUX

for this config it will work when there is a secondary security module.

Here is what happens:

Processing of PR_SET_KEEPCAPS (and a couple of other options) has been
moved from kernel/sys.c::sys_prctl() to security/commoncap.c::cap_task_prctl().

For the aforementioned configs cap_task_prctl() is not called
(moreover, security/commoncap.c is not compiled).

SELinux's implementation of .task_prctl callback resorts to
secondary_ops->task_prctl() which is dummy_task_prctl() (in the
absence of CONFIG_SECURITY_CAPABILITIES (or any other) as a secondary
module).

So the relevant code should be either moved back to sys_prctl() or
placed in some generic function (not in security/commoncap.c) which is
accessible for all configs.

Move it back to sys_prctl().
    
Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>

----

diff --git a/kernel/sys.c b/kernel/sys.c
index 14e9728..5b8e583 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -24,6 +24,7 @@
 #include <linux/times.h>
 #include <linux/posix-timers.h>
 #include <linux/security.h>
+#include <linux/securebits.h>
 #include <linux/dcookies.h>
 #include <linux/suspend.h>
 #include <linux/tty.h>
@@ -1658,6 +1659,21 @@ asmlinkage long sys_prctl(int option, unsigned long arg2, unsigned long arg3,
 		return error;
 
 	switch (option) {
+		case PR_GET_KEEPCAPS:
+			if (issecure(SECURE_KEEP_CAPS))
+				error = 1;
+			break;
+		case PR_SET_KEEPCAPS:
+			if (arg2 > 1) /* Note, we rely on arg2 being unsigned here */
+				error = -EINVAL;
+			else if (issecure(SECURE_KEEP_CAPS_LOCKED))
+				error = -EPERM;
+			else if (arg2)
+				current->securebits |= issecure_mask(SECURE_KEEP_CAPS);
+			else
+				current->securebits &=
+					~issecure_mask(SECURE_KEEP_CAPS);
+			break;
 		case PR_SET_PDEATHSIG:
 			if (!valid_signal(arg2)) {
 				error = -EINVAL;
@@ -1744,6 +1760,12 @@ asmlinkage long sys_prctl(int option, unsigned long arg2, unsigned long arg3,
 		case PR_SET_TSC:
 			error = SET_TSC_CTL(arg2);
 			break;
+		case PR_CAPBSET_READ:
+			if (!cap_valid(arg2))
+				error = -EINVAL;
+			else
+				error = !!cap_raised(current->cap_bset, arg2);
+			break;
 		default:
 			error = -EINVAL;
 			break;
diff --git a/security/commoncap.c b/security/commoncap.c
index 5edabc7..76f3a76 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -576,12 +576,6 @@ int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 	long error = 0;
 
 	switch (option) {
-	case PR_CAPBSET_READ:
-		if (!cap_valid(arg2))
-			error = -EINVAL;
-		else
-			error = !!cap_raised(current->cap_bset, arg2);
-		break;
 #ifdef CONFIG_SECURITY_FILE_CAPABILITIES
 	case PR_CAPBSET_DROP:
 		error = cap_prctl_drop(arg2);
@@ -631,22 +625,6 @@ int cap_task_prctl(int option, unsigned long arg2, unsigned long arg3,
 
 #endif /* def CONFIG_SECURITY_FILE_CAPABILITIES */
 
-	case PR_GET_KEEPCAPS:
-		if (issecure(SECURE_KEEP_CAPS))
-			error = 1;
-		break;
-	case PR_SET_KEEPCAPS:
-		if (arg2 > 1) /* Note, we rely on arg2 being unsigned here */
-			error = -EINVAL;
-		else if (issecure(SECURE_KEEP_CAPS_LOCKED))
-			error = -EPERM;
-		else if (arg2)
-			current->securebits |= issecure_mask(SECURE_KEEP_CAPS);
-		else
-			current->securebits &=
-				~issecure_mask(SECURE_KEEP_CAPS);
-		break;
-
 	default:
 		/* No functionality available - continue with default */
 		return 0;

---

