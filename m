Return-Path: <linux-kernel-owner+w=401wt.eu-S1753897AbZJ1ODM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbZJ1ODM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 10:03:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753824AbZJ1ODL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 10:03:11 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:44950 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753774AbZJ1ODK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 10:03:10 -0400
Date: Wed, 28 Oct 2009 09:02:36 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: "Andrew G. Morgan" <morgan@kernel.org>,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       Ulrich Drepper <drepper@redhat.com>, linux-api@vger.kernel.org,
       Stephen Rothwell <sfr@canb.auug.org.au>
Subject: [PATCH resend] define convenient securebits masks for prctl users
Message-ID: <20091028140236.GA8157@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ Are there any objections to exporting securebits.h?  If not,
can this patch be pushed to linux-next? ]

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
---
 include/linux/Kbuild       |    1 +
 include/linux/securebits.h |   22 ++++++++++++++++------
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 3e8bd18..94fe9f7 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -328,6 +328,7 @@ unifdef-y += scc.h
 unifdef-y += sched.h
 unifdef-y += screen_info.h
 unifdef-y += sdla.h
+unifdef-y += securebits.h
 unifdef-y += selinux_netlink.h
 unifdef-y += sem.h
 unifdef-y += serial_core.h
diff --git a/include/linux/securebits.h b/include/linux/securebits.h
index d2c5ed8..9ad109e 100644
--- a/include/linux/securebits.h
+++ b/include/linux/securebits.h
@@ -1,6 +1,13 @@
 #ifndef _LINUX_SECUREBITS_H
 #define _LINUX_SECUREBITS_H 1
 
+/* Each securesetting is implemented using two bits. One bit specifies
+   whether the setting is on or off. The other bit specify whether the
+   setting is locked or not. A setting which is locked cannot be
+   changed from user-level. */
+#define issecure_mask(X)	(1 << (X))
+#define issecure(X)		(issecure_mask(X) & current_cred_xxx(securebits))
+
 #define SECUREBITS_DEFAULT 0x00000000
 
 /* When set UID 0 has no special privileges. When unset, we support
@@ -12,6 +19,9 @@
 #define SECURE_NOROOT			0
 #define SECURE_NOROOT_LOCKED		1  /* make bit-0 immutable */
 
+#define SECBIT_NOROOT		(issecure_mask(SECURE_NOROOT))
+#define SECBIT_NOROOT_LOCKED	(issecure_mask(SECURE_NOROOT_LOCKED))
+
 /* When set, setuid to/from uid 0 does not trigger capability-"fixup".
    When unset, to provide compatiblility with old programs relying on
    set*uid to gain/lose privilege, transitions to/from uid 0 cause
@@ -19,6 +29,10 @@
 #define SECURE_NO_SETUID_FIXUP		2
 #define SECURE_NO_SETUID_FIXUP_LOCKED	3  /* make bit-2 immutable */
 
+#define SECBIT_NO_SETUID_FIXUP	(issecure_mask(SECURE_NO_SETUID_FIXUP))
+#define SECBIT_NO_SETUID_FIXUP_LOCKED \
+			(issecure_mask(SECURE_NO_SETUID_FIXUP_LOCKED))
+
 /* When set, a process can retain its capabilities even after
    transitioning to a non-root user (the set-uid fixup suppressed by
    bit 2). Bit-4 is cleared when a process calls exec(); setting both
@@ -27,12 +41,8 @@
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

