Return-Path: <linux-kernel-owner+w=401wt.eu-S1757006AbZHZHV1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006AbZHZHV1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 03:21:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756893AbZHZHV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 03:21:26 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39500 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756892AbZHZHVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 03:21:25 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4A94E244.3020301@jp.fujitsu.com>
Date: Wed, 26 Aug 2009 16:20:36 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andi Kleen <ak@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jin Dongming <jin.dongming@np.css.fujitsu.com>
Subject: [PATCH -tip] x86, mce: CE in last bank prevents panic by unknown
 MCE
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[based on tip/x86/mce]

If MCE handler is called but none of mces_seen have machine check event
which might signal the MCE (i.e. event higher than MCE_KEEP_SEVERITY),
panic with "Machine check from unknown source" will be taken since the
MCE is assumed to be signaled from external agent or so.

Usually mces_seen never point MCE_KEEP_SEVERITY event such as CE.
But it can happen because initial value of mces_seen is accidentally
modified by mce_no_way_out() - in case if mce_no_way_out() run through
all banks and the last bank has the CE, mces_seen points the CE and
the "panic by unknown" will not be taken.

This patch fix this undesired behavior, and clarify the logic.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Reported-by: Jin Dongming <jin.dongming@np.css.fujitsu.com>

---
 arch/x86/kernel/cpu/mcheck/mce.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index 54bd1b2..7b485e9 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -665,7 +665,7 @@ static void mce_reign(void)
 	 * No machine check event found. Must be some external
 	 * source or one CPU is hung. Panic.
 	 */
-	if (!m && tolerant < 3)
+	if (global_worst <= MCE_KEEP_SEVERITY && tolerant < 3)
 		mce_panic("Machine check from unknown source", NULL, NULL);
 
 	/*
@@ -889,11 +889,11 @@ void do_machine_check(struct pt_regs *regs, long error_code)
 	mce_setup(&m);
 
 	m.mcgstatus = mce_rdmsrl(MSR_IA32_MCG_STATUS);
-	no_way_out = mce_no_way_out(&m, &msg);
-
 	final = &__get_cpu_var(mces_seen);
 	*final = m;
 
+	no_way_out = mce_no_way_out(&m, &msg);
+
 	barrier();
 
 	/*
-- 
1.6.4.1


