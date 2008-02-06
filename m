Return-Path: <linux-kernel-owner+w=401wt.eu-S1760787AbYBFI1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760787AbYBFI1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 03:27:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758432AbYBFI1K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 03:27:10 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:58387 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754761AbYBFI1I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 03:27:08 -0500
Date: Wed, 6 Feb 2008 09:26:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Hugh Dickins <hugh@veritas.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] stop c_p_a corrupting the pds
Message-ID: <20080206082635.GA13142@elte.hu>
References: <Pine.LNX.4.64.0802052218190.11822@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0802052218190.11822@blonde.site>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Hugh Dickins <hugh@veritas.com> wrote:

> When change_page_attr splits a large page on x86_32 (without PAE), it 
> is currently corrupting every process's page directory: fix that by 
> removing the thinko which passes down a physical instead of a virtual 
> address.
> 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>

thanks Hugh!

  Acked-by: Ingo Molnar <mingo@elte.hu>

bug synopsis and preventive measures:

>  	if (!SHARED_KERNEL_PMD) {
>  		struct page *page;
>  
> -		address = __pa(address);
>  		list_for_each_entry(page, &pgd_list, lru) {

this line itself got inherited from old spaghetti code from 
arch/i386/mm/pageattr.c:split_large_page(). That line was added 6 years 
ago when pageattr.c was written. [see commit c8712aebd in historic-git]

This line was not outright buggy in its original form, but it was an 
inherently dangerous and sloppy construct: why does it transform an 
"address" into a physical address like that? We _always_ use "address" 
as a linear address, and some separate variable name for physical 
addresses. This line was just waiting for a bug to be introduced: the 
moment any virtual-address code is introduced _after_ this line, it can 
easily pass visual inspection because the code "looks" correct.

In all new cpa code we introduced explicit transformations like:

        unsigned long phys_addr = __pa(address);

but this 6 year old line slipped through and we moved it to a place 
where it indeed caused the bug you triggered :-/

Our bad and thanks for fixing it :)

one reason why we didnt trigger the crash (sooner) in qa is because the 
CPA self-tests run while there's essentially no user-space contexts - so 
even though i do test 2G:2G !PAE kernels too, corruption of the 
pagetables went unnoticed. (and the main risk and focus in cpa is on 
kernel pagetables, not on user pagetables)

So, to prevent such bugs in the future, i've just modified the cpa 
self-test to run in a kthread and to be delayed by 30 seconds, that 
places it right into the user-space bootup sequence.

that triggered the following "bad pgd" crash right on the first boot 
attempt:

[   32.597881] CPA exercising pageattr
[   32.601289] CPA mapping 4k 2048 large 254 gb 0 x 2302[80000000-bfc00000] mis0
[   32.047209] pam_console_app[2908]: segfault at 8049956 ip 08049956 sp 7fef40]
[   32.621678] mm/memory.c:115: bad pgd 3e59b163.
[   32.621711] ------------[ cut here ]------------
[   32.621713] kernel BUG at mm/mmap.c:2055!
[   32.621715] invalid opcode: 0000 [#1] SMP
[   32.621717]

and with your fix applied it runs just fine.

	Ingo

------------------->
Subject: x86: delay CPA self-test and repeat it
From: Ingo Molnar <mingo@elte.hu>

delay the CPA self-test so that any impact (corruption) of
user-space pagetables can be triggered.

this would have prevented the bug fixed by 8cb2a7c1e95e472b5
at its source.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/mm/pageattr-test.c |   38 ++++++++++++++++++++++++++++++++------
 1 file changed, 32 insertions(+), 6 deletions(-)

Index: linux-x86.q/arch/x86/mm/pageattr-test.c
===================================================================
--- linux-x86.q.orig/arch/x86/mm/pageattr-test.c
+++ linux-x86.q/arch/x86/mm/pageattr-test.c
@@ -5,6 +5,7 @@
  * and compares page tables forwards and afterwards.
  */
 #include <linux/bootmem.h>
+#include <linux/kthread.h>
 #include <linux/random.h>
 #include <linux/kernel.h>
 #include <linux/init.h>
@@ -15,7 +16,7 @@
 #include <asm/kdebug.h>
 
 enum {
-	NTEST			= 4000,
+	NTEST			= 400,
 #ifdef CONFIG_X86_64
 	LPS			= (1 << PMD_SHIFT),
 #elif defined(CONFIG_X86_PAE)
@@ -31,7 +32,7 @@ struct split_state {
 	long min_exec, max_exec;
 };
 
-static __init int print_split(struct split_state *s)
+static int print_split(struct split_state *s)
 {
 	long i, expected, missed = 0;
 	int printed = 0;
@@ -96,11 +97,11 @@ static __init int print_split(struct spl
 	return err;
 }
 
-static unsigned long __initdata addr[NTEST];
-static unsigned int __initdata len[NTEST];
+static unsigned long addr[NTEST];
+static unsigned int len[NTEST];
 
 /* Change the global bit on random pages in the direct mapping */
-static __init int exercise_pageattr(void)
+static int pageattr_test(void)
 {
 	struct split_state sa, sb, sc;
 	unsigned long *bm;
@@ -216,10 +217,35 @@ static __init int exercise_pageattr(void
 	if (failed) {
 		printk(KERN_ERR "CPA selftests NOT PASSED. Please report.\n");
 		WARN_ON(1);
+		return -EINVAL;
 	} else {
 		printk(KERN_INFO "CPA selftests PASSED\n");
 	}
 
 	return 0;
 }
-module_init(exercise_pageattr);
+
+static int do_pageattr_test(void *__unused)
+{
+	while (!kthread_should_stop()) {
+		schedule_timeout_interruptible(HZ*30);
+		if (pageattr_test() < 0)
+			break;
+	}
+	return 0;
+}
+
+static int start_pageattr_test(void)
+{
+	struct task_struct *p;
+
+	p = kthread_create(do_pageattr_test, NULL, "pageattr-test");
+	if (!IS_ERR(p))
+		wake_up_process(p);
+	else
+		WARN_ON(1);
+
+	return 0;
+}
+
+module_init(start_pageattr_test);
