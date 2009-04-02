Return-Path: <linux-kernel-owner+w=401wt.eu-S933167AbZDBXrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167AbZDBXrb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 19:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756249AbZDBXrT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 19:47:19 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:47467 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755202AbZDBXrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 19:47:18 -0400
Date: Thu, 2 Apr 2009 18:47:14 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: linux-security-module@vger.kernel.org
Cc: lkml <linux-kernel@vger.kernel.org>, Andrew Morgan <morgan@kernel.org>,
       James Morris <jmorris@namei.org>,
       Casey Schaufler <casey@schaufler-ca.com>
Subject: [PATCH] don't raise all privs on setuid-root file with fE set (v2)
Message-ID: <20090402234714.GA2220@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Distributions face a backward compatibility problem with starting to use
file capabilities.  For instance, removing setuid root from ping and
doing setcap cap_net_raw=pe means that booting with an older kernel
or one compiled without file capabilities means ping won't work for
non-root users.

In order to replace the setuid root bit on a capability-unaware
program, one has to set the effective, or legacy, file capability,
which makes the capability effective immediately.  This patch
uses the legacy bit as a queue to not automatically add full
privilege to a setuid-root program.

So, with this patch, an ordinary setuid-root program will run with
privilege.  But if /bin/ping has both setuid-root and cap_net_raw in
fP and fE, then ping (when run by non-root user) will not run
with only cap_net_raw.

Changelog:
	Apr 2 2009: Print a message once when such a binary is loaded,
		as per James Morris' suggestion.
	Apr 2 2009: Fix the condition to only catch uid!=0 && euid==0.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
Acked-by: Casey Schaufler <casey@schaufler-ca.com>
---
 security/commoncap.c |   32 ++++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/security/commoncap.c b/security/commoncap.c
index 7cd61a5..97ac1f1 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -28,6 +28,28 @@
 #include <linux/prctl.h>
 #include <linux/securebits.h>
 
+/*
+ * If a non-root user executes a setuid-root binary in
+ * !secure(SECURE_NOROOT) mode, then we raise capabilities.
+ * However if fE is also set, then the intent is for only
+ * the file capabilities to be applied, and the setuid-root
+ * bit is left on either to change the uid (plausible) or
+ * to get full privilege on a kernel without file capabilities
+ * support.  So in that case we do not raise capabilities.
+ *
+ * Warn if that happens, once per boot.
+ */
+static void warn_setuid_and_fcaps_mixed(char *fname)
+{
+	static int warned;
+	if (!warned) {
+		printk(KERN_INFO "warning: `%s' has both setuid-root and"
+			" effective capabilities. Therefore not raising all"
+			" capabilities.\n", fname);
+		warned = 1;
+	}
+}
+
 int cap_netlink_send(struct sock *sk, struct sk_buff *skb)
 {
 	NETLINK_CB(skb).eff_cap = current_cap();
@@ -464,6 +486,15 @@ int cap_bprm_set_creds(struct linux_binprm *bprm)
 
 	if (!issecure(SECURE_NOROOT)) {
 		/*
+		 * If the legacy file capability is set, then don't set privs
+		 * for a setuid root binary run by a non-root user.  Do set it
+		 * for a root user just to cause least surprise to an admin.
+		 */
+		if (effective && new->uid != 0 && new->euid == 0) {
+			warn_setuid_and_fcaps_mixed(bprm->filename);
+			goto skip;
+		}
+		/*
 		 * To support inheritance of root-permissions and suid-root
 		 * executables under compatibility mode, we override the
 		 * capability sets for the file.
@@ -478,6 +509,7 @@ int cap_bprm_set_creds(struct linux_binprm *bprm)
 		if (new->euid == 0)
 			effective = true;
 	}
+skip:
 
 	/* Don't let someone trace a set[ug]id/setpcap binary with the revised
 	 * credentials unless they have the appropriate permit
-- 
1.5.4.3

