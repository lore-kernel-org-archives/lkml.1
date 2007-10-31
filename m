Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbXJaXtz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbXJaXtz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 19:49:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752530AbXJaXtr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 19:49:47 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:54817 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbXJaXtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 19:49:46 -0400
Date: Wed, 31 Oct 2007 18:49:45 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-security-module@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Andrew Morgan <morgan@kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       "Theodore Ts'o" <tytso@mit.edu>, Stephen Smalley <sds@epoch.ncsc.mil>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Natalie Protasevich <protasnb@gmail.com>
Subject: [PATCH] file capabilities: allow sigcont within session (v2)
Message-ID: <20071031234945.GA16455@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 5bff8967f45a35f858b96ca673d9bf98eac53d49 Mon Sep 17 00:00:00 2001
From: Serge E. Hallyn <serue@us.ibm.com>
Date: Wed, 31 Oct 2007 11:22:04 -0500
Subject: [PATCH 1/1] file capabilities: allow sigcont within session (v2)

(This is a proposed fix to http://bugzilla.kernel.org/show_bug.cgi?id=9247)

Allow sigcont to be sent to a process with greater capabilities
if it is in the same session.  Otherwise, a shell from which
I've started a root shell and done 'suspend' can't be restarted
by the parent shell.

Also don't do file-capabilities signaling checks when uids for
the processes don't match, since the standard check_kill_permission
will have done those checks.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>
---
 security/commoncap.c |    9 +++++++++
 1 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/security/commoncap.c b/security/commoncap.c
index bf67871..4de6857 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -526,6 +526,15 @@ int cap_task_kill(struct task_struct *p, struct siginfo *info,
 	if (info != SEND_SIG_NOINFO && (is_si_special(info) || SI_FROMKERNEL(info)))
 		return 0;
 
+	/* if tasks have same uid, then check_kill_permission did check */
+	if (current->uid == p->uid || current->euid == p->uid ||
+		current->uid == p->suid || current->euid == p->suid)
+		return 0;
+
+	/* sigcont is permitted within same session */
+	if (sig == SIGCONT && (task_session_nr(current)==task_session_nr(p)))
+		return 0;
+
 	if (secid)
 		/*
 		 * Signal sent as a particular user.
-- 
1.5.1.1.GIT

