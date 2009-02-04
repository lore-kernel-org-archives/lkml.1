Return-Path: <linux-kernel-owner+w=401wt.eu-S1755159AbZBDW7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755159AbZBDW7Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 17:59:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751683AbZBDW7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 17:59:07 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:56909 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751564AbZBDW7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 17:59:06 -0500
Date: Wed, 4 Feb 2009 23:58:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, Kirill Korotaev <dev@openvz.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [git pull] timer fix
Message-ID: <20090204225848.GA3251@elte.hu>
References: <20090204192551.GA19539@elte.hu> <alpine.LFD.2.00.0902041400100.3247@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0902041400100.3247@localhost.localdomain>
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


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 	} while ((s32)(hpet_readl(HPET_COUNTER) - hpet_t1_cmp) > 0);

that is also more efficient code by 6 bytes:

before:

ffffffff81020856:	ff c3                	inc    %ebx
ffffffff81020858:	48 05 f0 00 00 00    	add    $0xf0,%rax
ffffffff8102085e:	8b 00                	mov    (%rax),%eax
ffffffff81020860:	8b 15 2a 79 85 00    	mov    0x85792a(%rip),%edx        # ffffffff81878190 <hpet_t1_cmp>
ffffffff81020866:	89 c0                	mov    %eax,%eax
ffffffff81020868:	48 29 d0             	sub    %rdx,%rax
ffffffff8102086b:	48 85 c0             	test   %rax,%rax
ffffffff8102086e:	7f bf                	jg     ffffffff8102082f <hpet_rtc_interrupt+0x68>
ffffffff81020870:	85 db                	test   %ebx,%ebx

after:

ffffffff81020856:	ff c3                	inc    %ebx
ffffffff81020858:	48 05 f0 00 00 00    	add    $0xf0,%rax
ffffffff8102085e:	8b 00                	mov    (%rax),%eax
ffffffff81020860:	2b 05 2a 79 85 00    	sub    0x85792a(%rip),%eax        # ffffffff81878190 <hpet_t1_cmp>
ffffffff81020866:	85 c0                	test   %eax,%eax
ffffffff81020868:	7f c5                	jg     ffffffff8102082f <hpet_rtc_interrupt+0x68>
ffffffff8102086a:	85 db                	test   %ebx,%ebx

Kirill, Pavel, could you please re-test the updated commit attached below?

	Ingo

---------------->
>From 66a36a1e95fe9de9c6a56f0bcd01f4ba21929f86 Mon Sep 17 00:00:00 2001
From: Pavel Emelyanov <xemul@openvz.org>
Date: Wed, 4 Feb 2009 13:40:31 +0300
Subject: [PATCH] x86: fix hpet timer reinit for x86_64

There's a small problem with hpet_rtc_reinit function - it checks
for the:

	hpet_readl(HPET_COUNTER) - hpet_t1_cmp > 0

to continue increasing both the HPET_T1_CMP (register) and the
hpet_t1_cmp (variable).

But since the HPET_COUNTER is always 32-bit, if the hpet_t1_cmp
is 64-bit this condition will always be FALSE once the latter hits
the 32-bit boundary, and we can have a situation, when we don't
increase the HPET_T1_CMP register high enough.

The result - timer stops ticking, since HPET_T1_CMP becomes less,
than the COUNTER and never increased again.

The solution is (based on Linus's suggestion) to compare 64-bits
(on 64-bit x86), but to do the comparison on 32-bit signed
integers.

Reported-by: Kirill Korotaev <dev@openvz.org>
Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/hpet.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/hpet.c b/arch/x86/kernel/hpet.c
index 64d5ad0..c761f91 100644
--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -1075,7 +1075,7 @@ static void hpet_rtc_timer_reinit(void)
 		hpet_t1_cmp += delta;
 		hpet_writel(hpet_t1_cmp, HPET_T1_CMP);
 		lost_ints++;
-	} while ((long)(hpet_readl(HPET_COUNTER) - hpet_t1_cmp) > 0);
+	} while ((s32)(hpet_readl(HPET_COUNTER) - hpet_t1_cmp) > 0);
 
 	if (lost_ints) {
 		if (hpet_rtc_flags & RTC_PIE)
