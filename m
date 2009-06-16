Return-Path: <linux-kernel-owner+w=401wt.eu-S1758828AbZFPWdD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758828AbZFPWdD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 18:33:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753726AbZFPWct
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 18:32:49 -0400
Received: from mx2.redhat.com ([66.187.237.31]:52355 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500AbZFPWct (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 18:32:49 -0400
Date: Wed, 17 Jun 2009 00:27:10 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Howells <dhowells@redhat.com>, Eugene Teo <eugene@redhat.com>,
       James Morris <jmorris@namei.org>, Roland McGrath <roland@redhat.com>,
       solar@openwall.com, linux-kernel@vger.kernel.org
Subject: [PATCH] send_sigio_to_task: sanitize the usage of fown->signum
Message-ID: <20090616222710.GA7620@redhat.com>
References: <4A36532E.3050006@redhat.com> <20090615174544.GA10467@redhat.com> <4A36E555.80206@redhat.com> <20090616183829.GA10027@redhat.com> <alpine.LFD.2.01.0906161224110.3282@localhost.localdomain> <20090616204941.GB28663@redhat.com> <alpine.LFD.2.01.0906161433270.16802@localhost.localdomain> <20090616215103.GA4853@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090616215103.GA4853@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

send_sigio_to_task() reads fown->signum several times, we can race with
F_SETSIG which changes ->signum lockless. In theory, this can fool security
checks or we can call group_send_sig_info() with the wrong ->si_signo which
does not match "int sig".

Change the code to cache ->signum.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>

--- a/fs/fcntl.c~signum	2009-06-16 21:41:18.000000000 +0200
+++ b/fs/fcntl.c	2009-06-17 00:11:38.000000000 +0200
@@ -426,14 +426,20 @@ static inline int sigio_perm(struct task
 }
 
 static void send_sigio_to_task(struct task_struct *p,
-			       struct fown_struct *fown, 
+			       struct fown_struct *fown,
 			       int fd,
 			       int reason)
 {
-	if (!sigio_perm(p, fown, fown->signum))
+	/*
+	 * F_SETSIG can change ->signum lockless in parallel, make
+	 * sure we read it once and use the same value throughout.
+	 */
+	int signum = ACCESS_ONCE(fown->signum);
+
+	if (!sigio_perm(p, fown, signum))
 		return;
 
-	switch (fown->signum) {
+	switch (signum) {
 		siginfo_t si;
 		default:
 			/* Queue a rt signal with the appropriate fd as its
@@ -442,7 +448,7 @@ static void send_sigio_to_task(struct ta
 			   delivered even if we can't queue.  Failure to
 			   queue in this case _should_ be reported; we fall
 			   back to SIGIO in that case. --sct */
-			si.si_signo = fown->signum;
+			si.si_signo = signum;
 			si.si_errno = 0;
 		        si.si_code  = reason;
 			/* Make sure we are called with one of the POLL_*
@@ -454,7 +460,7 @@ static void send_sigio_to_task(struct ta
 			else
 				si.si_band = band_table[reason - POLL_IN];
 			si.si_fd    = fd;
-			if (!group_send_sig_info(fown->signum, &si, p))
+			if (!group_send_sig_info(signum, &si, p))
 				break;
 		/* fall-through: fall back on the old plain SIGIO signal */
 		case 0:

