Return-Path: <linux-kernel-owner+w=401wt.eu-S1753794AbXJBFTS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbXJBFTS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2007 01:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750803AbXJBFTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Oct 2007 01:19:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60793 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750799AbXJBFTI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2007 01:19:08 -0400
Date: Tue, 2 Oct 2007 07:18:52 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Willy Tarreau <w@1wt.eu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org
Subject: [patch] printk: add KERN_CONT annotation
Message-ID: <20071002051852.GC28345@elte.hu>
References: <20070928105345.GC18163@shadowen.org> <20071001064448.GA4239@elte.hu> <20071001003007.4e90143b.akpm@linux-foundation.org> <20071002043408.GM10199@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071002043408.GM10199@1wt.eu>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.1.7-deb
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Willy Tarreau <w@1wt.eu> wrote:

> Well, I think that we could do something like this :
> 
> #define KERN_CONT ""
> ...
> 	printk(KERN_ERR "foo");
> 	<100 lines of whatever>
> 	printk(KERN_CONT "bar\n");
> 
> It would indicate the author's *intent* which is to continue a line 
> which has already been started. It would both permit us to remove 
> false positives from automated scripts, and to read the code more 
> easily. And this is not a big constaint for the author, given that 
> such constructs are quite rare.

ah, this is even nicer than the raw_printk() thing i suggested, and it 
also nicely documents the intention of the author. Patch attached below.

And i'd like to stress the principle that is followed here: in this 
particular case the checkpatch.pl warning is very useful, but still 
there are false positives. Fortunately they are so rare that it's worth 
annotating those few exceptions in the source. Note that the goal is 
still to be able to achieve 100% warning-free source code. _That_ should 
be the driving principle behind checkpatch.pl warnings.

	Ingo

------------------>
Subject: printk: add KERN_CONT annotation
From: Ingo Molnar <mingo@elte.hu>

printk: add the KERN_CONT annotation (which is empty string but via 
which checkpatch.pl can notice that the lacking KERN_ level is fine). 
This useful for multiple calls of hand-crafted printk output done by 
early debug code or similar.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/kernel.h |    7 +++++++
 kernel/sched.c         |   22 +++++++++++-----------
 2 files changed, 18 insertions(+), 11 deletions(-)

Index: linux/include/linux/kernel.h
===================================================================
--- linux.orig/include/linux/kernel.h
+++ linux/include/linux/kernel.h
@@ -61,6 +61,13 @@ extern const char linux_proc_banner[];
 #define	KERN_INFO	"<6>"	/* informational			*/
 #define	KERN_DEBUG	"<7>"	/* debug-level messages			*/
 
+/*
+ * Annotation for a "continued" line of log printout (only done after a
+ * line that had no enclosing \n). Only to be used by core/arch code
+ * during early bootup (a continued line is not SMP-safe otherwise).
+ */
+#define	KERN_CONT	""
+
 extern int console_printk[];
 
 #define console_loglevel (console_printk[0])
Index: linux/kernel/sched.c
===================================================================
--- linux.orig/kernel/sched.c
+++ linux/kernel/sched.c
@@ -4770,18 +4770,18 @@ static void show_task(struct task_struct
 	unsigned state;
 
 	state = p->state ? __ffs(p->state) + 1 : 0;
-	printk("%-13.13s %c", p->comm,
+	printk(KERN_INFO "%-13.13s %c", p->comm,
 		state < sizeof(stat_nam) - 1 ? stat_nam[state] : '?');
 #if BITS_PER_LONG == 32
 	if (state == TASK_RUNNING)
-		printk(" running  ");
+		printk(KERN_CONT " running  ");
 	else
-		printk(" %08lx ", thread_saved_pc(p));
+		printk(KERN_CONT " %08lx ", thread_saved_pc(p));
 #else
 	if (state == TASK_RUNNING)
-		printk("  running task    ");
+		printk(KERN_CONT "  running task    ");
 	else
-		printk(" %016lx ", thread_saved_pc(p));
+		printk(KERN_CONT " %016lx ", thread_saved_pc(p));
 #endif
 #ifdef CONFIG_DEBUG_STACK_USAGE
 	{
@@ -4791,7 +4791,7 @@ static void show_task(struct task_struct
 		free = (unsigned long)n - (unsigned long)end_of_stack(p);
 	}
 #endif
-	printk("%5lu %5d %6d\n", free, p->pid, p->parent->pid);
+	printk(KERN_CONT "%5lu %5d %6d\n", free, p->pid, p->parent->pid);
 
 	if (state != TASK_RUNNING)
 		show_stack(p, NULL);
@@ -5527,20 +5527,20 @@ static void sched_domain_debug(struct sc
 			}
 
 			if (!group->__cpu_power) {
-				printk("\n");
+				printk(KERN_CONT "\n");
 				printk(KERN_ERR "ERROR: domain->cpu_power not "
 						"set\n");
 				break;
 			}
 
 			if (!cpus_weight(group->cpumask)) {
-				printk("\n");
+				printk(KERN_CONT "\n");
 				printk(KERN_ERR "ERROR: empty group\n");
 				break;
 			}
 
 			if (cpus_intersects(groupmask, group->cpumask)) {
-				printk("\n");
+				printk(KERN_CONT "\n");
 				printk(KERN_ERR "ERROR: repeated CPUs\n");
 				break;
 			}
@@ -5548,11 +5548,11 @@ static void sched_domain_debug(struct sc
 			cpus_or(groupmask, groupmask, group->cpumask);
 
 			cpumask_scnprintf(str, NR_CPUS, group->cpumask);
-			printk(" %s", str);
+			printk(KERN_CONT " %s", str);
 
 			group = group->next;
 		} while (group != sd->groups);
-		printk("\n");
+		printk(KERN_CONT "\n");
 
 		if (!cpus_equal(sd->span, groupmask))
 			printk(KERN_ERR "ERROR: groups don't span "
