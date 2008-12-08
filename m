Return-Path: <linux-kernel-owner+w=401wt.eu-S1754710AbYLHPKA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710AbYLHPKA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 10:10:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754332AbYLHPJu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 10:09:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33959 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132AbYLHPJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 10:09:49 -0500
Date: Mon, 8 Dec 2008 16:09:42 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rakib Mullick <rakib.mullick@gmail.com>
Cc: Linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH ] x86 : Fix compilation warning on paravirt-spinlocks.c
Message-ID: <20081208150942.GA22016@elte.hu>
References: <b9df5fa10812080656l21385db3ob08fc4f9ad3f1f76@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b9df5fa10812080656l21385db3ob08fc4f9ad3f1f76@mail.gmail.com>
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


* Rakib Mullick <rakib.mullick@gmail.com> wrote:

> Impact: Fix compilation warning.
> 
>  CC      arch/x86/kernel/paravirt-spinlocks.o
> arch/x86/kernel/paravirt-spinlocks.c: In function `default_spin_lock_flags':
> arch/x86/kernel/paravirt-spinlocks.c:12: warning: passing arg 1 of
> `__raw_spin_lock' from incompatible pointer type
> 
> This patch fixes the above warning.  __raw_spin_lock(lock) is declared
> when CONFIG_SMP is defined. Thus, a call to __raw_spin_lock requires
> checking CONFIG_SMP is defined or not.
> 
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
> 
> --- linux-2.6-orig/arch/x86/kernel/paravirt-spinlocks.c	2008-12-05
> 19:53:15.000000000 +0600
> +++ linux-2.6/arch/x86/kernel/paravirt-spinlocks.c	2008-12-07
> 23:52:59.000000000 +0600
> @@ -9,7 +9,9 @@
> 
>  static void default_spin_lock_flags(struct raw_spinlock *lock,
> unsigned long flags)
>  {
> +#ifdef	CONFIG_SMP
>  	__raw_spin_lock(lock);
> +#endif

no - this just works around the compiler warning.

Look at the real fix below i did some time ago. If you are into fixing 
warnings you should try tip/master, that has a ton of warning fixes 
already:

  http://people.redhat.com/mingo/tip.git/README

	Ingo

------------------------>
>From ecd05381e26b9a61e49fa485baea1595bd3d1b40 Mon Sep 17 00:00:00 2001
From: Ingo Molnar <mingo@elte.hu>
Date: Fri, 17 Oct 2008 16:09:57 +0200
Subject: [PATCH] x86: fix default_spin_lock_flags() prototype
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

these warnings:

  arch/x86/kernel/paravirt-spinlocks.c: In function ‘default_spin_lock_flags’:
  arch/x86/kernel/paravirt-spinlocks.c:12: warning: passing argument 1 of ‘__raw_spin_lock’ from incompatible pointer type
  arch/x86/kernel/paravirt-spinlocks.c: At top level:
  arch/x86/kernel/paravirt-spinlocks.c:11: warning: ‘default_spin_lock_flags’ defined but not used

showed that the prototype of default_spin_lock_flags() was confused about
what type spinlocks have.

the proper type on UP is raw_spinlock_t.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/paravirt-spinlocks.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/paravirt-spinlocks.c b/arch/x86/kernel/paravirt-spinlocks.c
index 0e9f198..95777b0 100644
--- a/arch/x86/kernel/paravirt-spinlocks.c
+++ b/arch/x86/kernel/paravirt-spinlocks.c
@@ -7,7 +7,8 @@
 
 #include <asm/paravirt.h>
 
-static void default_spin_lock_flags(struct raw_spinlock *lock, unsigned long flags)
+static inline void
+default_spin_lock_flags(raw_spinlock_t *lock, unsigned long flags)
 {
 	__raw_spin_lock(lock);
 }
