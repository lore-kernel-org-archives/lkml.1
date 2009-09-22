Return-Path: <linux-kernel-owner+w=401wt.eu-S1755730AbZIVNfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755730AbZIVNfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Sep 2009 09:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755394AbZIVNfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Sep 2009 09:35:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:33914 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755587AbZIVNf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Sep 2009 09:35:29 -0400
Date: Tue, 22 Sep 2009 13:34:57 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       seto.hidetoshi@jp.fujitsu.com, ying.huang@intel.com, ak@linux.intel.com,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: ying.huang@intel.com, mingo@redhat.com, hpa@zytor.com,
       linux-kernel@vger.kernel.org, seto.hidetoshi@jp.fujitsu.com,
       ak@linux.intel.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <new-submission>
References: <new-submission>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: mce: Fix thermal throttling message storm
Message-ID: <tip-b417c9fd8690637f0c91479435ab3e2bf450c038@git.kernel.org>
Git-Commit-ID: b417c9fd8690637f0c91479435ab3e2bf450c038
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 22 Sep 2009 13:34:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b417c9fd8690637f0c91479435ab3e2bf450c038
Gitweb:     http://git.kernel.org/tip/b417c9fd8690637f0c91479435ab3e2bf450c038
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 22 Sep 2009 15:50:24 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 22 Sep 2009 17:30:45 +0200

x86: mce: Fix thermal throttling message storm

If a system switches back and forth between hot and cold mode,
the MCE code will print a stream of critical kernel messages.

Extend the throttling code to properly notice this, by
only printing the first hot + cold transition and omitting
the rest up to CHECK_INTERVAL (5 minutes).

This way we'll only get a single incident of:

 [  102.356584] CPU0: Temperature above threshold, cpu clock throttled (total events = 1)
 [  102.357000] Disabling lock debugging due to kernel taint
 [  102.369223] CPU0: Temperature/speed normal

Every 5 minutes. The 'total events' count tells the number of cold/hot
transitions detected, should overheating occur after 5 minutes again:

[  402.357580] CPU0: Temperature above threshold, cpu clock throttled (total events = 24891)
[  402.358001] CPU0: Temperature/speed normal
[  450.704142] Machine check events logged

Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/cpu/mcheck/therm_throt.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/therm_throt.c b/arch/x86/kernel/cpu/mcheck/therm_throt.c
index db80b57..b3a1dba 100644
--- a/arch/x86/kernel/cpu/mcheck/therm_throt.c
+++ b/arch/x86/kernel/cpu/mcheck/therm_throt.c
@@ -42,6 +42,7 @@ struct thermal_state {
 
 	u64			next_check;
 	unsigned long		throttle_count;
+	unsigned long		last_throttle_count;
 };
 
 static DEFINE_PER_CPU(struct thermal_state, thermal_state);
@@ -120,11 +121,12 @@ static int therm_throt_process(bool is_throttled)
 	if (is_throttled)
 		state->throttle_count++;
 
-	if (!(was_throttled ^ is_throttled) &&
-			time_before64(now, state->next_check))
+	if (time_before64(now, state->next_check) &&
+			state->throttle_count != state->last_throttle_count)
 		return 0;
 
 	state->next_check = now + CHECK_INTERVAL;
+	state->last_throttle_count = state->throttle_count;
 
 	/* if we just entered the thermal event */
 	if (is_throttled) {
