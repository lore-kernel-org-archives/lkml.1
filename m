Return-Path: <linux-kernel-owner+w=401wt.eu-S1756144AbXKZSAl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144AbXKZSAl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 13:00:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754561AbXKZSAc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 13:00:32 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:37514 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754319AbXKZSAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 13:00:31 -0500
Date: Mon, 26 Nov 2007 12:00:28 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-security-module@vger.kernel.org,
       Andrew Morgan <morgan@kernel.org>, Stephen Smalley <sds@epoch.ncsc.mil>,
       Chris Wright <chrisw@sous-sol.org>, chris@friedhoff.org
Subject: [PATCH] file capabilities: don't prevent signaling setuid root
	programs.
Message-ID: <20071126180028.GA9106@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is needed to preserve legacy behavior when
CONFIG_SECURITY_FILE_CAPABILITIES=y.  Without this patch, xinit can't
kill X, so manually starting X in runlevel 3 then exiting your window
manager will not cause X to exit. 

thanks,
-serge

>From 81a6d780ad570f9a326fc27912ec0e373f5fa14f Mon Sep 17 00:00:00 2001
From: Serge E. Hallyn <serue@us.ibm.com>
Date: Tue, 20 Nov 2007 08:47:35 +0000
Subject: [PATCH] file capabilities: don't prevent signaling setuid root programs.

An unprivileged process must be able to kill a setuid root
program started by the same user.  This is legacy behavior
needed for instance for xinit to kill X when the window manager
exits.

When an unprivileged user runs a setuid root program in !SECURE_NOROOT
mode, fP, fI, and fE are set full on, so pP' and pE' are full on.
Then cap_task_kill() prevents the user from signaling the setuid root
task.  This is a change in behavior compared to when
!CONFIG_SECURITY_FILE_CAPABILITIES.

This patch introduces a special check into cap_task_kill() just
to check whether a non-root user is signaling a setuid root
program started by the same user.  If so, then signal is allowed.

Changelog:
	Nov 26: move test up above CAP_KILL test as per Andrew
		Morgan's suggestion.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 security/commoncap.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/security/commoncap.c b/security/commoncap.c
index 302e8d0..5bc1895 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -526,6 +526,15 @@ int cap_task_kill(struct task_struct *p, struct siginfo *info,
 	if (info != SEND_SIG_NOINFO && (is_si_special(info) || SI_FROMKERNEL(info)))
 		return 0;
 
+	/*
+	 * Running a setuid root program raises your capabilities.
+	 * Killing your own setuid root processes was previously
+	 * allowed.
+	 * We must preserve legacy signal behavior in this case.
+	 */
+	if (p->euid == 0 && p->uid == current->uid)
+		return 0;
+
 	/* sigcont is permitted within same session */
 	if (sig == SIGCONT && (task_session_nr(current) == task_session_nr(p)))
 		return 0;
-- 
1.5.2.5

