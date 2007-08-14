Return-Path: <linux-kernel-owner+w=401wt.eu-S1753422AbXHNHqv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbXHNHqv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 03:46:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751212AbXHNHp6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 03:45:58 -0400
Received: from canuck.infradead.org ([209.217.80.40]:55342 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893AbXHNHp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 03:45:56 -0400
Date: Tue, 14 Aug 2007 00:28:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Al Viro <viro@zeniv.linux.org.uk>,
       James Morris <jmorris@namei.org>
Subject: [patch 01/12] fix oops in __audit_signal_info()
Message-ID: <20070814072843.GB15025@kroah.com>
References: <20070814072244.882283903@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-oops-in-__audit_signal_info.patch"
In-Reply-To: <20070814072813.GA15025@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------


From: Al Viro <viro@ftp.linux.org.uk>

	Check for audit_signals is misplaced and check for
audit_dummy_context() is missing; as the result, if we send
signal to auditd from task with NULL ->audit_context while
we have audit_signals != 0 we end up with an oops.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Acked-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/auditsc.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1998,19 +1998,19 @@ int __audit_signal_info(int sig, struct 
 	extern uid_t audit_sig_uid;
 	extern u32 audit_sig_sid;
 
-	if (audit_pid && t->tgid == audit_pid &&
-	    (sig == SIGTERM || sig == SIGHUP || sig == SIGUSR1)) {
-		audit_sig_pid = tsk->pid;
-		if (ctx)
-			audit_sig_uid = ctx->loginuid;
-		else
-			audit_sig_uid = tsk->uid;
-		selinux_get_task_sid(tsk, &audit_sig_sid);
+	if (audit_pid && t->tgid == audit_pid) {
+		if (sig == SIGTERM || sig == SIGHUP || sig == SIGUSR1) {
+			audit_sig_pid = tsk->pid;
+			if (ctx)
+				audit_sig_uid = ctx->loginuid;
+			else
+				audit_sig_uid = tsk->uid;
+			selinux_get_task_sid(tsk, &audit_sig_sid);
+		}
+		if (!audit_signals || audit_dummy_context())
+			return 0;
 	}
 
-	if (!audit_signals) /* audit_context checked in wrapper */
-		return 0;
-
 	/* optimize the common case by putting first signal recipient directly
 	 * in audit_context */
 	if (!ctx->target_pid) {

-- 
