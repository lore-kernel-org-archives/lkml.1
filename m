Return-Path: <linux-kernel-owner+w=401wt.eu-S1755586AbZJ2Qkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586AbZJ2Qkk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 12:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755516AbZJ2Qkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 12:40:39 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:39489 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754109AbZJ2Qki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 12:40:38 -0400
Date: Thu, 29 Oct 2009 11:40:17 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: James Morris <jmorris@namei.org>
Cc: linux-security-module@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       "Andrew G. Morgan" <morgan@kernel.org>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Ulrich Drepper <drepper@redhat.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH] define convenient securebits masks for prctl users (v2)
Message-ID: <20091029164016.GA21797@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James, would you mind taking the following into
security-testing?

The securebits are used by passing them to prctl with the
PR_{S,G}ET_SECUREBITS commands.  But the defines must be
shifted to be used in prctl, which begs to be confused and
misused by userspace.  So define some more convenient
values for userspace to specify.  This way userspace does

	prctl(PR_SET_SECUREBITS, SECBIT_NOROOT);

instead of

	prctl(PR_SET_SECUREBITS, 1 << SECURE_NOROOT);

(Thanks to Michael for the idea)

This patch also adds include/linux/securebits to the installed headers.
Then perhaps it can be included by glibc's sys/prctl.h.

Changelog:
	Oct 29: Stephen Rothwell points out that issecure can
		be under __KERNEL__.
	Oct 14: (Suggestions by Michael Kerrisk):
		1. spell out SETUID in SECBIT_NO_SETUID*
		2. SECBIT_X_LOCKED does not imply SECBIT_X
		3. add definitions for keepcaps
        Oct 14: As suggested by Michael Kerrisk, don't
		use SB_* as that convention is already in
		use.  Use SECBIT_ prefix instead.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Acked-by: Andrew G. Morgan <morgan@kernel.org>
Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Ulrich Drepper <drepper@redhat.com>
Cc: James Morris <jmorris@namei.org>
---
 include/linux/Kbuild       |    1 +
 include/linux/securebits.h |   24 ++++++++++++++++++------
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 1feed71..5a53857 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -330,6 +330,7 @@ unifdef-y += scc.h
 unifdef-y += sched.h
 unifdef-y += screen_info.h
 unifdef-y += sdla.h
+unifdef-y += securebits.h
 unifdef-y += selinux_netlink.h
 unifdef-y += sem.h
 unifdef-y += serial_core.h
diff --git a/include/linux/securebits.h b/include/linux/securebits.h
index d2c5ed8..3340617 100644
--- a/include/linux/securebits.h
+++ b/include/linux/securebits.h
@@ -1,6 +1,15 @@
 #ifndef _LINUX_SECUREBITS_H
 #define _LINUX_SECUREBITS_H 1
 
+/* Each securesetting is implemented using two bits. One bit specifies
+   whether the setting is on or off. The other bit specify whether the
+   setting is locked or not. A setting which is locked cannot be
+   changed from user-level. */
+#define issecure_mask(X)	(1 << (X))
+#ifdef __KERNEL__
+#define issecure(X)		(issecure_mask(X) & current_cred_xxx(securebits))
+#endif
+
 #define SECUREBITS_DEFAULT 0x00000000
 
 /* When set UID 0 has no special privileges. When unset, we support
@@ -12,6 +21,9 @@
 #define SECURE_NOROOT			0
 #define SECURE_NOROOT_LOCKED		1  /* make bit-0 immutable */
 
+#define SECBIT_NOROOT		(issecure_mask(SECURE_NOROOT))
+#define SECBIT_NOROOT_LOCKED	(issecure_mask(SECURE_NOROOT_LOCKED))
+
 /* When set, setuid to/from uid 0 does not trigger capability-"fixup".
    When unset, to provide compatiblility with old programs relying on
    set*uid to gain/lose privilege, transitions to/from uid 0 cause
@@ -19,6 +31,10 @@
 #define SECURE_NO_SETUID_FIXUP		2
 #define SECURE_NO_SETUID_FIXUP_LOCKED	3  /* make bit-2 immutable */
 
+#define SECBIT_NO_SETUID_FIXUP	(issecure_mask(SECURE_NO_SETUID_FIXUP))
+#define SECBIT_NO_SETUID_FIXUP_LOCKED \
+			(issecure_mask(SECURE_NO_SETUID_FIXUP_LOCKED))
+
 /* When set, a process can retain its capabilities even after
    transitioning to a non-root user (the set-uid fixup suppressed by
    bit 2). Bit-4 is cleared when a process calls exec(); setting both
@@ -27,12 +43,8 @@
 #define SECURE_KEEP_CAPS		4
 #define SECURE_KEEP_CAPS_LOCKED		5  /* make bit-4 immutable */
 
-/* Each securesetting is implemented using two bits. One bit specifies
-   whether the setting is on or off. The other bit specify whether the
-   setting is locked or not. A setting which is locked cannot be
-   changed from user-level. */
-#define issecure_mask(X)	(1 << (X))
-#define issecure(X)		(issecure_mask(X) & current_cred_xxx(securebits))
+#define SECBIT_KEEP_CAPS	(issecure_mask(SECURE_KEEP_CAPS))
+#define SECBIT_KEEP_CAPS_LOCKED (issecure_mask(SECURE_KEEP_CAPS_LOCKED))
 
 #define SECURE_ALL_BITS		(issecure_mask(SECURE_NOROOT) | \
 				 issecure_mask(SECURE_NO_SETUID_FIXUP) | \
-- 
1.6.1

