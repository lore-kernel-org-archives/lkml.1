Return-Path: <linux-kernel-owner+w=401wt.eu-S1756457AbYJLJW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756457AbYJLJW4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 05:22:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbYJLJWs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 05:22:48 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35781 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbYJLJWr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 05:22:47 -0400
Date: Sun, 12 Oct 2008 11:22:37 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Petr Vandrovec <petr@vandrovec.name>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: thomas.petazzoni@free-electrons.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix early panic on amd64 due to typo in supported CPU
	section
Message-ID: <20081012092237.GA29766@elte.hu>
References: <20081012080126.GA29649@vana.vc.cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081012080126.GA29649@vana.vc.cvut.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Petr Vandrovec <petr@vandrovec.name> wrote:

> Do not crash when enumerating supported CPU architectures
> 
> SECURITY_INIT somehow ended up in x86_cpu_dev.init section.  That caused printk
> in code which prints supported architectures to hit #GP due to non-canonical
> address being used.
> 
> Signed-off-by: Petr Vandrovec <petr@vandrovec.name>

thanks Petr, we had this bug fixed later in the patches but lets pick 
your fix right now before merging anything else. Applied it to 
tip/x86/urgent.

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Alan Cox (1):
      x86, early_ioremap: fix fencepost error

David Rientjes (1):
      x86: avoid dereferencing beyond stack + THREAD_SIZE

Petr Vandrovec (1):
      x86: fix early panic on amd64 due to typo in supported CPU section


 arch/x86/kernel/process_64.c     |    4 ++--
 arch/x86/kernel/vmlinux_64.lds.S |    2 +-
 arch/x86/mm/ioremap.c            |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/process_64.c b/arch/x86/kernel/process_64.c
index 2a8ccb9..b6b508e 100644
--- a/arch/x86/kernel/process_64.c
+++ b/arch/x86/kernel/process_64.c
@@ -754,12 +754,12 @@ unsigned long get_wchan(struct task_struct *p)
 	if (!p || p == current || p->state == TASK_RUNNING)
 		return 0;
 	stack = (unsigned long)task_stack_page(p);
-	if (p->thread.sp < stack || p->thread.sp > stack+THREAD_SIZE)
+	if (p->thread.sp < stack || p->thread.sp >= stack+THREAD_SIZE)
 		return 0;
 	fp = *(u64 *)(p->thread.sp);
 	do {
 		if (fp < (unsigned long)stack ||
-		    fp > (unsigned long)stack+THREAD_SIZE)
+		    fp >= (unsigned long)stack+THREAD_SIZE)
 			return 0;
 		ip = *(u64 *)(fp+8);
 		if (!in_sched_functions(ip))
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index 201e81a..46e0544 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -172,8 +172,8 @@ SECTIONS
   .x86_cpu_dev.init : AT(ADDR(.x86_cpu_dev.init) - LOAD_OFFSET) {
 	*(.x86_cpu_dev.init)
   }
-  SECURITY_INIT
   __x86_cpu_dev_end = .;
+  SECURITY_INIT
 
   . = ALIGN(8);
   .parainstructions : AT(ADDR(.parainstructions) - LOAD_OFFSET) {
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 6ab3196..10b5230 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -614,7 +614,7 @@ void __init *early_ioremap(unsigned long phys_addr, unsigned long size)
 	 */
 	offset = phys_addr & ~PAGE_MASK;
 	phys_addr &= PAGE_MASK;
-	size = PAGE_ALIGN(last_addr) - phys_addr;
+	size = PAGE_ALIGN(last_addr + 1) - phys_addr;
 
 	/*
 	 * Mappings have to fit in the FIX_BTMAP area.
