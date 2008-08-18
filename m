Return-Path: <linux-kernel-owner+w=401wt.eu-S1759258AbYHRTKU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759258AbYHRTKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:10:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757568AbYHRTFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:05:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:44248 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762824AbYHRTF1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:05:27 -0400
Date: Mon, 18 Aug 2008 11:45:26 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: [patch 51/60] sparc64: Handle stack trace attempts before
	irqstacks are setup.
Message-ID: <20080818184526.GZ29394@suse.de>
References: <20080818183230.966310219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0006-sparc64-Handle-stack-trace-attempts-before-irqstack.patch"
In-Reply-To: <20080818184035.GA29394@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------
From: David S. Miller <davem@davemloft.net>

[ Upstream commit 6f63e781eaf6a741fc65f773017154b20ed4ce3b ]

Things like lockdep can try to do stack backtraces before
the irqstack blocks have been setup.  So don't try to match
their ranges so early on.

Also, remove unused variable in save_stack_trace().

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc64/kernel/kstack.h     |   38 ++++++++++++++++++++------------------
 arch/sparc64/kernel/stacktrace.c |    3 +--
 2 files changed, 21 insertions(+), 20 deletions(-)

--- a/arch/sparc64/kernel/kstack.h
+++ b/arch/sparc64/kernel/kstack.h
@@ -15,15 +15,16 @@ static inline bool kstack_valid(struct t
 	    sp <= (base + THREAD_SIZE - sizeof(struct sparc_stackf)))
 		return true;
 
-	base = (unsigned long) hardirq_stack[tp->cpu];
-	if (sp >= base &&
-	    sp <= (base + THREAD_SIZE - sizeof(struct sparc_stackf)))
-		return true;
-	base = (unsigned long) softirq_stack[tp->cpu];
-	if (sp >= base &&
-	    sp <= (base + THREAD_SIZE - sizeof(struct sparc_stackf)))
-		return true;
-
+	if (hardirq_stack[tp->cpu]) {
+		base = (unsigned long) hardirq_stack[tp->cpu];
+		if (sp >= base &&
+		    sp <= (base + THREAD_SIZE - sizeof(struct sparc_stackf)))
+			return true;
+		base = (unsigned long) softirq_stack[tp->cpu];
+		if (sp >= base &&
+		    sp <= (base + THREAD_SIZE - sizeof(struct sparc_stackf)))
+			return true;
+	}
 	return false;
 }
 
@@ -37,15 +38,16 @@ static inline bool kstack_is_trap_frame(
 	    addr <= (base + THREAD_SIZE - sizeof(*regs)))
 		goto check_magic;
 
-	base = (unsigned long) hardirq_stack[tp->cpu];
-	if (addr >= base &&
-	    addr <= (base + THREAD_SIZE - sizeof(*regs)))
-		goto check_magic;
-	base = (unsigned long) softirq_stack[tp->cpu];
-	if (addr >= base &&
-	    addr <= (base + THREAD_SIZE - sizeof(*regs)))
-		goto check_magic;
-
+	if (hardirq_stack[tp->cpu]) {
+		base = (unsigned long) hardirq_stack[tp->cpu];
+		if (addr >= base &&
+		    addr <= (base + THREAD_SIZE - sizeof(*regs)))
+			goto check_magic;
+		base = (unsigned long) softirq_stack[tp->cpu];
+		if (addr >= base &&
+		    addr <= (base + THREAD_SIZE - sizeof(*regs)))
+			goto check_magic;
+	}
 	return false;
 
 check_magic:
--- a/arch/sparc64/kernel/stacktrace.c
+++ b/arch/sparc64/kernel/stacktrace.c
@@ -8,8 +8,8 @@
 
 void save_stack_trace(struct stack_trace *trace)
 {
-	unsigned long ksp, fp, thread_base;
 	struct thread_info *tp = task_thread_info(current);
+	unsigned long ksp, fp;
 
 	stack_trace_flush();
 
@@ -19,7 +19,6 @@ void save_stack_trace(struct stack_trace
 	);
 
 	fp = ksp + STACK_BIAS;
-	thread_base = (unsigned long) tp;
 	do {
 		struct sparc_stackf *sf;
 		struct pt_regs *regs;

-- 
