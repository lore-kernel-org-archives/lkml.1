Return-Path: <linux-kernel-owner+w=401wt.eu-S1758474AbXFISkY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758474AbXFISkY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jun 2007 14:40:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753919AbXFISkQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jun 2007 14:40:16 -0400
Received: from smtp-out.google.com ([216.239.33.17]:8428 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527AbXFISkO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jun 2007 14:40:14 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:date:to:cc:subject:message-id:mime-version:
	content-type:content-disposition:user-agent:from;
	b=wdEsgy/BROPiNQ+RuRK5Lp8HnIr7m+yTJtPwVXJdm1GIf2fxLmThqpq5ESQ7wEMOo
	QMJnuzM8ccv12mG54ScSA==
Date: Sat, 9 Jun 2007 11:38:31 -0700
To: bunk@stusta.de
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Ratelimit printks due to unhandled signals in x86_64
Message-ID: <20070609183831.GA24688@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
From: masouds@google.com (Masoud Asgharifard Sharbiani)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, 
The following patch enables ratelimiting of unhandled signals in x86_64.
Without this, a malicious user could inflict local DoS and fill up the
logs with a code like this:

main()
{
	while(1)
		if (!fork())
			*(int *)0 = 0;
}

The patch is against 2.6.16.y tree. I've sent a similar one to Andrew
for inclusion in the -mm tree.
cheers,
Masoud

Signed-off-by: Masoud Sharbiani <masouds@google.com>

diff --git a/arch/x86_64/kernel/signal.c b/arch/x86_64/kernel/signal.c
index 5876df1..4b3cd29 100644
--- a/arch/x86_64/kernel/signal.c
+++ b/arch/x86_64/kernel/signal.c
@@ -505,7 +505,7 @@ void do_notify_resume(struct pt_regs *regs, sigset_t *oldset, __u32 thread_info_
 void signal_fault(struct pt_regs *regs, void __user *frame, char *where)
 { 
 	struct task_struct *me = current; 
-	if (exception_trace)
+	if (exception_trace && printk_ratelimit())
 		printk("%s[%d] bad frame in %s frame:%p rip:%lx rsp:%lx orax:%lx\n",
 	       me->comm,me->pid,where,frame,regs->rip,regs->rsp,regs->orig_rax); 
 
diff --git a/arch/x86_64/kernel/traps.c b/arch/x86_64/kernel/traps.c
index a5209fd..4f22aaa 100644
--- a/arch/x86_64/kernel/traps.c
+++ b/arch/x86_64/kernel/traps.c
@@ -480,7 +480,8 @@ static void __kprobes do_trap(int trapnr, int signr, char *str,
 	tsk->thread.trap_no = trapnr;
 
 	if (user_mode(regs)) {
-		if (exception_trace && unhandled_signal(tsk, signr))
+		if (exception_trace && unhandled_signal(tsk, signr) && 
+		    printk_ratelimit())
 			printk(KERN_INFO
 			       "%s[%d] trap %s rip:%lx rsp:%lx error:%lx\n",
 			       tsk->comm, tsk->pid, str,
diff --git a/arch/x86_64/mm/fault.c b/arch/x86_64/mm/fault.c
index 2e7c3c8..92f6448 100644
--- a/arch/x86_64/mm/fault.c
+++ b/arch/x86_64/mm/fault.c
@@ -475,7 +475,8 @@ bad_area_nosemaphore:
 		    (address >> 32))
 			return;
 
-		if (exception_trace && unhandled_signal(tsk, SIGSEGV)) {
+		if (exception_trace && unhandled_signal(tsk, SIGSEGV) &&
+		    printk_ratelimit()) {
 			printk(
 		       "%s%s[%d]: segfault at %016lx rip %016lx rsp %016lx error %lx\n",
 					tsk->pid > 1 ? KERN_INFO : KERN_EMERG,
