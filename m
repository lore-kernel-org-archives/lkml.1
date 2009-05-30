Return-Path: <linux-kernel-owner+w=401wt.eu-S1760242AbZE3WpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760242AbZE3WpV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 18:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759330AbZE3WnW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 18:43:22 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48877 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759147AbZE3WnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 18:43:19 -0400
Date: Sun, 31 May 2009 00:38:45 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: [RFC PATCH 11/12 v3] ptrace: mv task_struct->ptrace_message
	ptrace_ctx->message
Message-ID: <20090530223845.GA30524@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move task_struct->ptrace_message into ptrace_ctx->message.

ptrace_event() can use current->ptrace_ctx safely. If mask == 0 and we do
not check task_ptrace() we are called from tracehook_report_clone_complete(),
in this case trace == T means current was traced when it called do_fork().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/sched.h  |    1 -
 include/linux/ptrace.h |    3 ++-
 kernel/ptrace.c        |    6 ++++--
 3 files changed, 6 insertions(+), 4 deletions(-)

--- PTRACE/include/linux/sched.h~11_MESSAGE	2009-05-30 23:55:58.000000000 +0200
+++ PTRACE/include/linux/sched.h	2009-05-30 23:58:55.000000000 +0200
@@ -1347,7 +1347,6 @@ struct task_struct {
 
 	struct io_context *io_context;
 
-	unsigned long ptrace_message;
 	struct task_io_accounting ioac;
 #if defined(CONFIG_TASK_XACCT)
 	u64 acct_rss_mem1;	/* accumulated rss usage */
--- PTRACE/include/linux/ptrace.h~11_MESSAGE	2009-05-30 23:55:58.000000000 +0200
+++ PTRACE/include/linux/ptrace.h	2009-05-30 23:58:55.000000000 +0200
@@ -79,6 +79,7 @@ struct ptrace_context {
 	unsigned long		flags;
 	struct task_struct	*tracer;
 	struct siginfo		*infop;
+	unsigned long		message;
 };
 
 extern int alloc_ptrace_context(struct task_struct *child);
@@ -159,7 +160,7 @@ static inline int ptrace_event(int mask,
 {
 	if (mask && likely(!(task_ptrace(current) & mask)))
 		return 0;
-	current->ptrace_message = message;
+	current->ptrace_ctx->message = message;
 	ptrace_notify((event << 8) | SIGTRAP);
 	return 1;
 }
--- PTRACE/kernel/ptrace.c~11_MESSAGE	2009-05-30 23:55:58.000000000 +0200
+++ PTRACE/kernel/ptrace.c	2009-05-30 23:58:55.000000000 +0200
@@ -569,7 +569,8 @@ int ptrace_request(struct task_struct *c
 		ret = ptrace_setoptions(child->ptrace_ctx, data);
 		break;
 	case PTRACE_GETEVENTMSG:
-		ret = put_user(child->ptrace_message, (unsigned long __user *) data);
+		ret = put_user(child->ptrace_ctx->message,
+				(unsigned long __user *) data);
 		break;
 
 	case PTRACE_GETSIGINFO:
@@ -729,7 +730,8 @@ int compat_ptrace_request(struct task_st
 		break;
 
 	case PTRACE_GETEVENTMSG:
-		ret = put_user((compat_ulong_t) child->ptrace_message, datap);
+		ret = put_user((compat_ulong_t) child->ptrace_ctx->message,
+				datap);
 		break;
 
 	case PTRACE_GETSIGINFO:

