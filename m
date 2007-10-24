Return-Path: <linux-kernel-owner+w=401wt.eu-S1758136AbXJXMd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136AbXJXMd3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 08:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756310AbXJXMdV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 08:33:21 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60769 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756249AbXJXMdU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 08:33:20 -0400
Date: Wed, 24 Oct 2007 14:32:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@qumranet.com>
Cc: Jeff Garzik <jeff@garzik.org>, Adrian Bunk <bunk@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [patch] kvm: fix !SMP build error
Message-ID: <20071024123258.GA28653@elte.hu>
References: <tueoct232007613pm.likjasfdlkjdas987@havoc.gtf.org> <20071023223640.EADF31F81AC@havoc.gtf.org> <20071023224455.GY30533@stusta.de> <471E79E2.2090204@garzik.org> <471F03F5.7090608@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <471F03F5.7090608@qumranet.com>
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


* Avi Kivity <avi@qumranet.com> wrote:

> Of course SMP is not required.  I'll submit a patch to make 
> smp_call_function_mask() available on UP kernels.  Andrew, please 
> don't apply the KVM Kconfig patch.

i have triggered this and fixed it the right way - see the patch below. 
This fixes the 2.6.24-rc1 build error.

	Ingo

------------------->
Subject: kvm: fix !SMP build error
From: Ingo Molnar <mingo@elte.hu>

fix !SMP build error:

drivers/kvm/kvm_main.c: In function 'kvm_flush_remote_tlbs':
drivers/kvm/kvm_main.c:220: error: implicit declaration of function 'smp_call_function_mask'

(and also avoid unused function warning related to up_smp_call_function()
not making use of the 'func' parameter.)

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/smp.h |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

Index: linux/include/linux/smp.h
===================================================================
--- linux.orig/include/linux/smp.h
+++ linux/include/linux/smp.h
@@ -84,11 +84,12 @@ void smp_prepare_boot_cpu(void);
  *	These macros fold the SMP functionality into a single CPU system
  */
 #define raw_smp_processor_id()			0
-static inline int up_smp_call_function(void)
+static inline int up_smp_call_function(void (*func)(void *), void *info)
 {
 	return 0;
 }
-#define smp_call_function(func,info,retry,wait)	(up_smp_call_function())
+#define smp_call_function(func,info,retry,wait) \
+			(up_smp_call_function(func, info))
 #define on_each_cpu(func,info,retry,wait)	\
 	({					\
 		local_irq_disable();		\
@@ -107,6 +108,8 @@ static inline void smp_send_reschedule(i
 	local_irq_enable();	\
 	0;			\
 })
+#define smp_call_function_mask(mask,func,info,wait) \
+			(up_smp_call_function(func, info))
 
 #endif /* !SMP */
 
