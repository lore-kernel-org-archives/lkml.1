Return-Path: <linux-kernel-owner+w=401wt.eu-S1765629AbXJZUob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765629AbXJZUob (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 16:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764775AbXJZUoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 16:44:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43879 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764270AbXJZUoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 16:44:18 -0400
Date: Fri, 26 Oct 2007 13:42:28 -0700
From: Tony Jones <tonyj@suse.de>
To: linux-kernel@vger.kernel.org
Cc: linux-audit@redhat.com, viro@ftp.linux.org.uk, chrisw@sous-sol.org
Subject: [PATCH] audit: clear thread flag for new children
Message-ID: <20071026204228.GA1519@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tony Jones <tonyj@suse.de>

Minor performance enhancement.

Thread flag TIF_SYSCALL_AUDIT is not cleared for new children when audit 
context creation has been disabled (auditctl -e0). This can cause new children 
forked from a parent created when audit was enabled to not take the fastest 
syscall path thru entry.S

Signed-off-by: Tony Jones <tonyj@suse.de>
---
 kernel/auditsc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -814,8 +814,10 @@ int audit_alloc(struct task_struct *tsk)
 	struct audit_context *context;
 	enum audit_state     state;
 
-	if (likely(!audit_enabled))
+	if (likely(!audit_enabled)) {
+		clear_tsk_thread_flag(tsk, TIF_SYSCALL_AUDIT);
 		return 0; /* Return if not auditing. */
+	}
 
 	state = audit_filter_task(tsk);
 	if (likely(state == AUDIT_DISABLED))
