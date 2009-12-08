Return-Path: <linux-kernel-owner+w=401wt.eu-S965407AbZLHCWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965407AbZLHCWJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 21:22:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965392AbZLHCWI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 21:22:08 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56201 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965378AbZLHCWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 21:22:07 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B1DB831.2030801@jp.fujitsu.com>
Date: Tue, 08 Dec 2009 11:21:37 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/mce: timer must be setup unconditionally
References: <4B162A3C0200007800022F98@vpn.id2.novell.com>
In-Reply-To: <4B162A3C0200007800022F98@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, Peter,

Could you pick his patch up?
I confirmed that now it can be applied on Linus's tree and
also tip:x86/urgent.

Thanks,
H.Seto

===

From: Jan Beulich <jbeulich@novell.com>
Subject: [PATCH] x86/mce: timer must be setup unconditionally

mce_timer must be passed to setup_timer() in all cases, no matter
whether it is going to be actually used. Otherwise, when the CPU gets
brought down, its call to del_timer_sync() will never return, as the
timer won't have a base associated, and hence lock_timer_base() will
loop infinitely.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Reviewed-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: <stable@kernel.org>
---
 arch/x86/kernel/cpu/mcheck/mce.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index d7ebf25..a96e5cd 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -1388,13 +1388,14 @@ static void __mcheck_cpu_init_timer(void)
 	struct timer_list *t = &__get_cpu_var(mce_timer);
 	int *n = &__get_cpu_var(mce_next_interval);
 
+	setup_timer(t, mce_start_timer, smp_processor_id());
+
 	if (mce_ignore_ce)
 		return;
 
 	*n = check_interval * HZ;
 	if (!*n)
 		return;
-	setup_timer(t, mce_start_timer, smp_processor_id());
 	t->expires = round_jiffies(jiffies + *n);
 	add_timer_on(t, smp_processor_id());
 }
-- 
1.6.5.3


