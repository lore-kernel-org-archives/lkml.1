Return-Path: <linux-kernel-owner+w=401wt.eu-S1754522Ab0AEAgG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab0AEAgG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:36:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754457Ab0AEAfz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:35:55 -0500
Received: from kroah.org ([198.145.64.141]:34524 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754447Ab0AEAfw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:52 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Geert Uytterhoeven <geert@linux-m68k.org>,
       James Morris <jmorris@namei.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 70/97] Keys: KEYCTL_SESSION_TO_PARENT needs TIF_NOTIFY_RESUME architecture support
Date: Mon,  4 Jan 2010 16:33:23 -0800
Message-Id: <1262651630-7354-70-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

commit a00ae4d21b2fa9379914f270ffffd8d3bec55430 upstream.

As of commit ee18d64c1f632043a02e6f5ba5e045bb26a5465f ("KEYS: Add a keyctl to
install a process's session keyring on its parent [try #6]"), CONFIG_KEYS=y
fails to build on architectures that haven't implemented TIF_NOTIFY_RESUME yet:

security/keys/keyctl.c: In function 'keyctl_session_to_parent':
security/keys/keyctl.c:1312: error: 'TIF_NOTIFY_RESUME' undeclared (first use in this function)
security/keys/keyctl.c:1312: error: (Each undeclared identifier is reported only once
security/keys/keyctl.c:1312: error: for each function it appears in.)

Make KEYCTL_SESSION_TO_PARENT depend on TIF_NOTIFY_RESUME until
m68k, and xtensa have implemented it.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: James Morris <jmorris@namei.org>
Acked-by: Mike Frysinger <vapier@gentoo.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 security/keys/keyctl.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/security/keys/keyctl.c b/security/keys/keyctl.c
index 06ec722..1cad4c7 100644
--- a/security/keys/keyctl.c
+++ b/security/keys/keyctl.c
@@ -1236,6 +1236,7 @@ long keyctl_get_security(key_serial_t keyid,
  */
 long keyctl_session_to_parent(void)
 {
+#ifdef TIF_NOTIFY_RESUME
 	struct task_struct *me, *parent;
 	const struct cred *mycred, *pcred;
 	struct cred *cred, *oldcred;
@@ -1326,6 +1327,15 @@ not_permitted:
 error_keyring:
 	key_ref_put(keyring_r);
 	return ret;
+
+#else /* !TIF_NOTIFY_RESUME */
+	/*
+	 * To be removed when TIF_NOTIFY_RESUME has been implemented on
+	 * m68k/xtensa
+	 */
+#warning TIF_NOTIFY_RESUME not implemented
+	return -EOPNOTSUPP;
+#endif /* !TIF_NOTIFY_RESUME */
 }
 
 /*****************************************************************************/
-- 
1.6.6

