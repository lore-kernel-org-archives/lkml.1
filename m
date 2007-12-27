Return-Path: <linux-kernel-owner+w=401wt.eu-S1752685AbXL0VD6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752685AbXL0VD6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 16:03:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbXL0VDh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 16:03:37 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:54416 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752083AbXL0VDe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 16:03:34 -0500
Date: Thu, 27 Dec 2007 15:03:32 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Cc: Andrew Morgan <morgan@kernel.org>, linux-security-module@vger.kernel.org,
       Chris Wright <chrisw@sous-sol.org>
Subject: [PATCH 1/1] capabilities: oom_kill: don't set PF_SUPERPRIV for oom
	check
Message-ID: <20071227210332.GA24096@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From ed2e7764917fd56d9743630bd7072f67ff30adc2 Mon Sep 17 00:00:00 2001
From: Serge Hallyn <serue@us.ibm.com>
Date: Wed, 26 Dec 2007 15:04:50 -0800
Subject: [PATCH 1/1] capabilities: oom_kill: don't set PF_SUPERPRIV for oom check

With 64-bit capabilities came an inadvertent change such
that the check for a privileged process, to make it less
likely to be killed when out of memory, sets PF_SUPERPRIV,
which it did not do before.

This patch restores the original behavior of not setting the
PF_SUPERPRIV bit when checking for privileged processes.

Signed-off-by: Serge Hallyn <serue@us.ibm.com>
Acked-by: Andrew G. Morgan <morgan@kernel.org>
---
 include/linux/capability.h |    2 ++
 mm/oom_kill.c              |    3 ++-
 2 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/linux/capability.h b/include/linux/capability.h
index 7d50ff6..0acdd65 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -490,6 +490,8 @@ extern const kernel_cap_t __cap_init_eff_set;
 int capable(int cap);
 int __capable(struct task_struct *t, int cap);
 
+#define CAPABLE_PROBE_ONLY(a,b)		(!security_capable(a,b))
+
 extern long cap_prctl_drop(unsigned long cap);
 
 #endif /* __KERNEL__ */
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 9fd8d5d..cd515f8 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -128,7 +128,8 @@ unsigned long badness(struct task_struct *p, unsigned long uptime,
 	 * Superuser processes are usually more important, so we make it
 	 * less likely that we kill those.
 	 */
-	if (__capable(p, CAP_SYS_ADMIN) || __capable(p, CAP_SYS_RESOURCE))
+	if (CAPABLE_PROBE_ONLY(p, CAP_SYS_ADMIN) ||
+		CAPABLE_PROBE_ONLY(p, CAP_SYS_RESOURCE))
 		points /= 4;
 
 	/*
-- 
1.5.1

