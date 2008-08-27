Return-Path: <linux-kernel-owner+w=401wt.eu-S1756791AbYH0Nro@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756791AbYH0Nro (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 09:47:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756366AbYH0Nqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 09:46:47 -0400
Received: from mx1.redhat.com ([66.187.233.31]:34265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756587AbYH0Nqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 09:46:46 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 08/59] CRED: Wrap task credential accesses in the tty driver
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>,
       Serge Hallyn <serue@us.ibm.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Date: Wed, 27 Aug 2008 14:46:23 +0100
Message-ID: <20080827134623.19980.38027.stgit@warthog.procyon.org.uk>
In-Reply-To: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
References: <20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrap access to task credentials so that they can be separated more easily from
the task_struct during the introduction of COW creds.

Change most current->(|e|s|fs)[ug]id to current_(|e|s|fs)[ug]id().

Change some task->e?[ug]id to task_e?[ug]id().  In some places it makes more
sense to use RCU directly rather than a convenient wrapper; these will be
addressed by later patches.

Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: James Morris <jmorris@namei.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
---

 drivers/char/tty_audit.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)


diff --git a/drivers/char/tty_audit.c b/drivers/char/tty_audit.c
index 3582f43..570d337 100644
--- a/drivers/char/tty_audit.c
+++ b/drivers/char/tty_audit.c
@@ -86,10 +86,12 @@ static void tty_audit_buf_push(struct task_struct *tsk, uid_t loginuid,
 	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_TTY);
 	if (ab) {
 		char name[sizeof(tsk->comm)];
+		uid_t uid = task_uid(tsk);
 
 		audit_log_format(ab, "tty pid=%u uid=%u auid=%u ses=%u "
-				 "major=%d minor=%d comm=", tsk->pid, tsk->uid,
-				 loginuid, sessionid, buf->major, buf->minor);
+				 "major=%d minor=%d comm=",
+				 tsk->pid, uid, loginuid, sessionid,
+				 buf->major, buf->minor);
 		get_task_comm(name, tsk);
 		audit_log_untrustedstring(ab, name);
 		audit_log_format(ab, " data=");

