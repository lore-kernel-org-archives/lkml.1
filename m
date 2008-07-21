Return-Path: <linux-kernel-owner+w=401wt.eu-S1753254AbYGUSFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbYGUSFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 14:05:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751061AbYGUSE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 14:04:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:57288 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750935AbYGUSE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 14:04:58 -0400
Date: Mon, 21 Jul 2008 20:04:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh <jaswinder@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] x86: declaration fixes
Message-ID: <20080721180439.GA13720@elte.hu>
References: <1216662432.28271.30.camel@jaswinder.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216662432.28271.30.camel@jaswinder.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Jaswinder Singh <jaswinder@infradead.org> wrote:

> Hello Ingo,
> 
> Please pull the declaration fixes for x86-tip from :
> 
> git://git.infradead.org/users/jaswinder/linux-2.6-tip.git

pulled this into tip/x86/prototypes, thanks Jaswinder.

Btw., when sending pull requests it's best to use git-request-pull. I.e. 
something like:

git-request-pull tip/master git://git.infradead.org/users/jaswinder/linux-2.6-tip.git

would have generated the proper output.

The changes still need some fixing though. For example, this change:

> 2. [PATCH] x86: process_32.c declare cpu_number before they get used

why is cpu_number moved over from smp.h to current.h? I think it's more 
logical in smp.h. If it's missing somewhere then add an #include 
<asm/smp.h> to that file?

also, this change:

+++ b/include/linux/timer.h
@@ -6,6 +6,10 @@
 #include <linux/stddef.h>
 #include <linux/debugobjects.h>

+#ifdef CONFIG_X86
+#include <asm/timer.h>
+#endif /* CONFIG_X86 */

is not really acceptable in a generic header, nor is:

--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -65,6 +67,10 @@ struct getcpu_cache;
 #include <linux/quota.h>
 #include <linux/key.h>

+#ifdef CONFIG_X86
+#include <asm/syscalls.h>
+#endif /* CONFIG_X86 */

i'd suggest we just do asm-x86/syscall.h and asm-x86/timer.h changes and 
add #include <asm/syscall.h> and #include <asm/timer.h> to the affected 
x86 .c files. Once every architecture has it, linux/syscall.h can be 
extended with an unconditional asm/syscall.h include.

Or, like Matthew has suggested, a 'complete' collection of all syscalls 
should be assembled into linux/syscall.h. In that case it has extra 
documentation value if there's an #ifdef CONFIG_X86 for certain 
syscalls. (say the LDT or VM86 syscalls make only sense on x86 
platforms)

another thing:

--- a/include/asm-x86/signal.h
+++ b/include/asm-x86/signal.h

+void do_notify_resume(struct pt_regs *, void *, __u32);
+

please add "extern" to each such prototype declaration. (the same is 
true for a handful of other prototypes you've added - please re-review 
and fix them)

 +#ifdef CONFIG_X86_32
  extern int timer_ack;
 -extern int no_timer_check;
  extern int recalibrate_cpu_khz(void);
 +#endif /* CONFIG_X86_32 */
 +
 +extern int no_timer_check;

hm, why was this needed?

	Ingo
