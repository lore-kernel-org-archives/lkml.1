Return-Path: <linux-kernel-owner+w=401wt.eu-S1755828AbYLCT4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828AbYLCT4W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 14:56:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754636AbYLCTu1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 14:50:27 -0500
Received: from kroah.org ([198.145.64.141]:59542 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754562AbYLCTuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 14:50:18 -0500
Date: Wed, 3 Dec 2008 11:48:47 -0800
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
       alan@lxorguk.ukuu.org.uk, Helge Deller <deller@gmx.de>,
       Grant Grundler <grundler@parisc-linux.org>,
       Matthew Wilcox <matthew@wil.cx>, Kyle McMartin <kyle@mcmartin.ca>
Subject: [patch 015/104] parisc: fix kernel crash when unwinding a
	userspace process
Message-ID: <20081203194847.GP8950@kroah.com>
References: <20081203193901.715896543@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="parisc-fix-kernel-crash-when-unwinding-a-userspace-process.patch"
In-Reply-To: <20081203194725.GA8950@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Helge Deller <deller@gmx.de>

commit 7a3f5134a8f5bd7fa38b5645eef05e8a4eb62951 upstream.

Any user on existing parisc 32- and 64bit-kernels can easily crash
the kernel and as such enforce a DSO.
A simple testcase is available here:
        http://gsyprf10.external.hp.com/~deller/crash.tgz

The problem is introduced by the fact, that the handle_interruption()
crash handler calls the show_regs() function, which in turn tries to
unwind the stack by calling parisc_show_stack().  Since the stack contains
userspace addresses, a try to unwind the stack is dangerous and useless
and leads to the crash.

The fix is trivial: For userspace processes
a) avoid to unwind the stack, and
b) avoid to resolve userspace addresses to kernel symbol names.

While touching this code, I converted print_symbol() to %pS
printk formats and made parisc_show_stack() static.

An initial patch for this was written by Kyle McMartin back in August:
http://marc.info/?l=linux-parisc&m=121805168830283&w=2

Compile and run-tested with a 64bit parisc kernel.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: Grant Grundler <grundler@parisc-linux.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kyle McMartin <kyle@mcmartin.ca>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/parisc/kernel/traps.c |   41 ++++++++++++++++++++---------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

--- a/arch/parisc/kernel/traps.c
+++ b/arch/parisc/kernel/traps.c
@@ -24,7 +24,6 @@
 #include <linux/init.h>
 #include <linux/interrupt.h>
 #include <linux/console.h>
-#include <linux/kallsyms.h>
 #include <linux/bug.h>
 
 #include <asm/assembly.h>
@@ -51,7 +50,7 @@
 DEFINE_SPINLOCK(pa_dbit_lock);
 #endif
 
-void parisc_show_stack(struct task_struct *t, unsigned long *sp,
+static void parisc_show_stack(struct task_struct *task, unsigned long *sp,
 	struct pt_regs *regs);
 
 static int printbinary(char *buf, unsigned long x, int nbits)
@@ -121,18 +120,19 @@ static void print_fr(char *level, struct
 
 void show_regs(struct pt_regs *regs)
 {
-	int i;
+	int i, user;
 	char *level;
 	unsigned long cr30, cr31;
 
-	level = user_mode(regs) ? KERN_DEBUG : KERN_CRIT;
+	user = user_mode(regs);
+	level = user ? KERN_DEBUG : KERN_CRIT;
 
 	print_gr(level, regs);
 
 	for (i = 0; i < 8; i += 4)
 		PRINTREGS(level, regs->sr, "sr", RFMT, i);
 
-	if (user_mode(regs))
+	if (user)
 		print_fr(level, regs);
 
 	cr30 = mfctl(30);
@@ -145,14 +145,18 @@ void show_regs(struct pt_regs *regs)
 	printk("%s CPU: %8d   CR30: " RFMT " CR31: " RFMT "\n",
 	       level, current_thread_info()->cpu, cr30, cr31);
 	printk("%s ORIG_R28: " RFMT "\n", level, regs->orig_r28);
-	printk(level);
-	print_symbol(" IAOQ[0]: %s\n", regs->iaoq[0]);
-	printk(level);
-	print_symbol(" IAOQ[1]: %s\n", regs->iaoq[1]);
-	printk(level);
-	print_symbol(" RP(r2): %s\n", regs->gr[2]);
 
-	parisc_show_stack(current, NULL, regs);
+	if (user) {
+		printk("%s IAOQ[0]: " RFMT "\n", level, regs->iaoq[0]);
+		printk("%s IAOQ[1]: " RFMT "\n", level, regs->iaoq[1]);
+		printk("%s RP(r2): " RFMT "\n", level, regs->gr[2]);
+	} else {
+		printk("%s IAOQ[0]: %pS\n", level, (void *) regs->iaoq[0]);
+		printk("%s IAOQ[1]: %pS\n", level, (void *) regs->iaoq[1]);
+		printk("%s RP(r2): %pS\n", level, (void *) regs->gr[2]);
+
+		parisc_show_stack(current, NULL, regs);
+	}
 }
 
 
@@ -173,20 +177,15 @@ static void do_show_stack(struct unwind_
 			break;
 
 		if (__kernel_text_address(info->ip)) {
-			printk("%s [<" RFMT ">] ", (i&0x3)==1 ? KERN_CRIT : "", info->ip);
-#ifdef CONFIG_KALLSYMS
-			print_symbol("%s\n", info->ip);
-#else
-			if ((i & 0x03) == 0)
-				printk("\n");
-#endif
+			printk(KERN_CRIT " [<" RFMT ">] %pS\n",
+				info->ip, (void *) info->ip);
 			i++;
 		}
 	}
-	printk("\n");
+	printk(KERN_CRIT "\n");
 }
 
-void parisc_show_stack(struct task_struct *task, unsigned long *sp,
+static void parisc_show_stack(struct task_struct *task, unsigned long *sp,
 	struct pt_regs *regs)
 {
 	struct unwind_frame_info info;

