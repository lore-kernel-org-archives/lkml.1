Return-Path: <linux-kernel-owner+w=401wt.eu-S1752226AbZHNEPR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752226AbZHNEPR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 00:15:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751640AbZHNEPP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 00:15:15 -0400
Received: from mail-gx0-f205.google.com ([209.85.217.205]:41287 "EHLO
	mail-gx0-f205.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751453AbZHNEPL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 00:15:11 -0400
MIME-Version: 1.0
Date: Thu, 13 Aug 2009 23:15:11 -0500
Message-ID: <2359eed20908132115t2f6cea3by2429d54914d5ac6f@mail.gmail.com>
Subject: [RFC][PATCH 1/1] support optional non-VFS capability inheritance 
	without disabling file caps
From: Will Drewry <redpig@dataspill.org>
To: linux-kernel@vger.kernel.org
Cc: James Morris <jmorris@namei.org>, linux-security-module@vger.kernel.org,
       morgan@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Capabilities marked as inheritable (+i) are inaccessible when inherited
by a child process (after exec()) with CONFIG_SECURITY_FILE_CAPABILITIES
enabled unless the VFS entry of the child also provides the capability (or
cap_setpcap) in the permitted/effective sets.

This change adds a securebit, SECURE_INHERIT_CAPS, which enableѕ
inherited capabilities to be propagated to the permitted set of the
child process.  If it doesn't conflict with VFS_CAP_FLAGS_EFFECTIVE, it
will also mark the capabilities effective.  This bit and change only
take effect when SECURE_NOROOT is set.

The securebit guard is used because this change violates the following
constraint:
        pP' = (X & fP) | (pI & fI)
With bit-6 enabled, the constraint becomes:
        pP' = (X & fP) | (pI)
and pE' varying based on VFS bits and if there are any file-based capabilities.

This allows for a purely runtime capabilities-based environment without
requiring every file to be annotated with an extended attribute.  This
also means that SECURE_NOROOT process trees using capabilities become
more accessible, especially for filesystems without extended attribute
support - or in mixed FS environments.

For example, a daemon like dhcpcd may be launched with cap_net_raw by a
more privileged daemon.  Once dhcpcd drops the cap_net_raw privilege, it
will not be able to regain it.  Even if a local user runs dhcpcd
manually, the capability will not be granted because the capability was
not derived from the filesystem.  However, the calling capability
manager could either gain its permissions from init or by having a
file-based capability set.

Nb, I may be missing something obvious - any insights will be appreciated,
    and there is a good bit of flexibility in what can be done here.

Signed-off-by: Will Drewry <redpig@dataspill.org>
---
include/linux/securebits.h |   12 +++++++++++-
security/commoncap.c       |    7 +++++++
2 files changed, 18 insertions(+), 1 deletions(-)

diff --git a/include/linux/securebits.h b/include/linux/securebits.h
index d2c5ed8..ed50b80 100644
--- a/include/linux/securebits.h
+++ b/include/linux/securebits.h
@@ -27,6 +27,15 @@
 #define SECURE_KEEP_CAPS		4
 #define SECURE_KEEP_CAPS_LOCKED		5  /* make bit-4 immutable */

+/* When set, any capabilities inherited from a parent process will
+   start in the permitted, and possibly effective, capability set
+   if SECURE_NOROOT is set.
+     pP' = (X & fP) | (pI & fI)
+   becomes
+     pP' = (X & fP) | (pI) */
+#define SECURE_INHERIT_CAPS		6
+#define SECURE_INHERIT_CAPS_LOCKED	7  /* make bit-6 immutable */
+
 /* Each securesetting is implemented using two bits. One bit specifies
    whether the setting is on or off. The other bit specify whether the
    setting is locked or not. A setting which is locked cannot be
@@ -36,7 +45,8 @@

 #define SECURE_ALL_BITS		(issecure_mask(SECURE_NOROOT) | \
 				 issecure_mask(SECURE_NO_SETUID_FIXUP) | \
-				 issecure_mask(SECURE_KEEP_CAPS))
+				 issecure_mask(SECURE_KEEP_CAPS) | \
+				 issecure_mask(SECURE_INHERIT_CAPS))
 #define SECURE_ALL_LOCKS	(SECURE_ALL_BITS << 1)

 #endif /* !_LINUX_SECUREBITS_H */
diff --git a/security/commoncap.c b/security/commoncap.c
index 48b7e02..9b4590d 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -508,6 +508,13 @@ int cap_bprm_set_creds(struct linux_binprm *bprm)
 		}
 		if (new->euid == 0)
 			effective = true;
+	} else if (issecure(SECURE_INHERIT_CAPS)) {
+		/* Only enable permitted-to-effective inheritance if it doesn't
+		 * override VFS_CAP_FLAGS_EFFECTIVE behavior. */
+		if (!effective && cap_isclear(new->cap_permitted))
+			effective = true;
+		new->cap_permitted = cap_combine(new->cap_permitted,
+						 new->cap_inheritable);
 	}
 skip:
