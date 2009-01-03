Return-Path: <linux-kernel-owner+w=401wt.eu-S1759832AbZACL7h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759832AbZACL7h (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jan 2009 06:59:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753914AbZACL72
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Jan 2009 06:59:28 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58192 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408AbZACL71 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jan 2009 06:59:27 -0500
Date: Sat, 3 Jan 2009 12:59:04 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Travis <travis@sgi.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] ia64: cpumask fix for is_affinity_mask_valid()
Message-ID: <20090103115904.GA440@elte.hu>
References: <200901011149.18401.rusty@rustcorp.com.au> <alpine.LFD.2.00.0901021149020.5086@localhost.localdomain> <20090102203839.GA26850@elte.hu> <200901031751.00076.rusty@rustcorp.com.au> <20090103105208.GA19080@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090103105208.GA19080@elte.hu>
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


* Ingo Molnar <mingo@elte.hu> wrote:

> * Rusty Russell <rusty@rustcorp.com.au> wrote:
> 
> > On Saturday 03 January 2009 07:08:40 Ingo Molnar wrote:
> > >  - architectures that have no __fls (8 out of 21) fail to build:
> > > 
> > >      arch/cris
> > >      arch/frv
> > >      arch/h8300
> > >      arch/m32r
> > >      arch/m68k
> > >      arch/mn10300
> > >      arch/xtensa
> > 
> > Fixes pushed, m68k should be OK tho; is this actual compile test?  You have
> > to look in include/asm-m68k to see __fls.
> 
> yeah, i stopped the tests after the first two build failures - the rest is 
> a grep result from arch/*/, that's why include/asm-m68k/ was left out.
> 
> > > Rusty, would it be fine with you if we did all the remaining bits via 
> > > tip/cpus4096? It's your tree and your bits and we wanted to send our 
> > > remaining bits after your tree went to Linus but the conflict 
> > > resolutions from Mike are valuable so i think we should reconsider the 
> > > ordering.
> > 
> > Yeah, no reason for us to do the merge twice.  As long as it ends 
> > upstream, I'm a happy camper.
> 
> great - lets do it that way then. I have pulled your fixes into the 
> cpus4096 tree:
> 
>  5ece5c5: xtensa: define __fls
>  5c134da: mn10300: define __fls
>  16a2062: m32r: define __fls
>  9ddabc2: h8300: define __fls
>  ee38e51: frv: define __fls
>  0999769: cris: define __fls

ok, these architectures build fine now.

There's one new build failure due to cpumask changes: ia64. I have fixed 
it via the patch below. (if it looks good to you i'll carry it via 
tip/cpus4096, ok?)

Breakage came via this commit i think:

 d036e67: cpumask: convert kernel/irq

[ia64 is the only architecture that re-defines default_affinity_write().]

	Ingo

----------------------->
>From f1faf35ad450c3d648138b74b9f58b283dc19c5c Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Sat, 3 Jan 2009 12:50:46 +0100
Subject: [PATCH] ia64: cpumask fix for is_affinity_mask_valid()

Impact: build fix on ia64

ia64's default_affinity_write() still had old cpumask_t usage:

 /home/mingo/tip/kernel/irq/proc.c: In function `default_affinity_write':
 /home/mingo/tip/kernel/irq/proc.c:114: error: incompatible type for argument 1 of `is_affinity_mask_valid'
 make[3]: *** [kernel/irq/proc.o] Error 1
 make[3]: *** Waiting for unfinished jobs....

update it to cpumask_var_t.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/ia64/include/asm/irq.h |    2 +-
 arch/ia64/kernel/irq.c      |    4 ++--
 kernel/irq/proc.c           |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/ia64/include/asm/irq.h b/arch/ia64/include/asm/irq.h
index 3627116..36429a5 100644
--- a/arch/ia64/include/asm/irq.h
+++ b/arch/ia64/include/asm/irq.h
@@ -27,7 +27,7 @@ irq_canonicalize (int irq)
 }
 
 extern void set_irq_affinity_info (unsigned int irq, int dest, int redir);
-bool is_affinity_mask_valid(cpumask_t cpumask);
+bool is_affinity_mask_valid(cpumask_var_t cpumask);
 
 #define is_affinity_mask_valid is_affinity_mask_valid
 
diff --git a/arch/ia64/kernel/irq.c b/arch/ia64/kernel/irq.c
index 0b6db53..95ff16c 100644
--- a/arch/ia64/kernel/irq.c
+++ b/arch/ia64/kernel/irq.c
@@ -112,11 +112,11 @@ void set_irq_affinity_info (unsigned int irq, int hwid, int redir)
 	}
 }
 
-bool is_affinity_mask_valid(cpumask_t cpumask)
+bool is_affinity_mask_valid(cpumask_var_t cpumask)
 {
 	if (ia64_platform_is("sn2")) {
 		/* Only allow one CPU to be specified in the smp_affinity mask */
-		if (cpus_weight(cpumask) != 1)
+		if (cpumask_weight(cpumask) != 1)
 			return false;
 	}
 	return true;
diff --git a/kernel/irq/proc.c b/kernel/irq/proc.c
index 2abd3a7..aae3f74 100644
--- a/kernel/irq/proc.c
+++ b/kernel/irq/proc.c
@@ -54,7 +54,7 @@ static ssize_t irq_affinity_proc_write(struct file *file,
 	if (err)
 		goto free_cpumask;
 
-	if (!is_affinity_mask_valid(*new_value)) {
+	if (!is_affinity_mask_valid(new_value)) {
 		err = -EINVAL;
 		goto free_cpumask;
 	}
