Return-Path: <linux-kernel-owner+w=401wt.eu-S1754390AbXLDN1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390AbXLDN1p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 08:27:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbXLDN1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 08:27:34 -0500
Received: from styx.suse.cz ([82.119.242.94]:52758 "EHLO elijah.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752603AbXLDN1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 08:27:33 -0500
Subject: [PATCH] prevent sending wrong signals to a traced process whose
	tracer gets killed
From: Petr Tesarik <ptesarik@suse.cz>
To: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
X-Identity-Key: id2
X-Mozilla-Draft-Info: internal/draft; vcard=0; receipt=0; uuencode=0
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: SuSE CR
Date: Tue, 04 Dec 2007 14:27:25 +0100
Message-Id: <1196774846.19677.3.camel@elijah.suse.cz>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I experienced troubles when tracing a process with strace. Sometimes,
when I killed the strace process (SIGKILL), the traced process was also
killed. I found out that it was getting SIGTRAP and, indeed, when the
traced process set up a signal handler for SIGTRAP, it no longer died.

I noticed that normally, when the traced process is continued (via
PTRACE_CONT or similar), the signal to be sent to it is stored in
current->exit_code, which is then examined by the arch-specific code and
usually leads to something like:

                send_sig(current->exit_code, current, 1);

The exit_code is set in ptrace_stop(), but the tracing process may go
away while the traced process waits for it, and in that case exit_code
is left as-is. I think we must set it to zero in ptrace_untrace().

Signed-off-by: Petr Tesarik <ptesarik@suse.cz>

 ptrace.c |    1 +
 1 file changed, 1 insertion(+)

diff -pru a/kernel/ptrace.c b/kernel/ptrace.c
--- a/kernel/ptrace.c	2007-12-04 14:12:51.000000000 +0100
+++ b/kernel/ptrace.c	2007-12-04 14:13:28.000000000 +0100
@@ -52,6 +52,7 @@ void ptrace_untrace(struct task_struct *
 {
 	spin_lock(&child->sighand->siglock);
 	if (child->state == TASK_TRACED) {
+		child->exit_code = 0;
 		if (child->signal->flags & SIGNAL_STOP_STOPPED) {
 			child->state = TASK_STOPPED;
 		} else {

