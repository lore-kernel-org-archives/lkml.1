Return-Path: <linux-kernel-owner+w=401wt.eu-S1756606AbZETJn2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbZETJn2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 05:43:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754232AbZETJnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 05:43:20 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60617 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169AbZETJnU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 05:43:20 -0400
Message-ID: <4A13D077.3010806@jp.fujitsu.com>
Date: Wed, 20 May 2009 18:42:15 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org
Subject: [PATCH -tip 2/2] x86, mce: Revert "add mce=nopoll option to disable
 timer polling"
References: <20090519215631.GA15626@basil.nowhere.org>
In-Reply-To: <20090519215631.GA15626@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit f5b3ca6efb64aa3ab5fa32f0fc9cc0f6cfedee95.

Disabling only polling but not cmci is pointless setting.
Instead of "mce=nopoll" which should be paired with cmci disablement,
it rather make sense to have a "mce=ignore_ce" option that disable
both of polling and cmci at once.  A patch for this replacement
will follow this reverting patch.

OTOH, once booted, we can disable polling by setting check_interval
to 0, but there are no mention about the fact.  Later Andi will post
updated documents that can respond this issue.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
---
 Documentation/x86/x86_64/boot-options.txt |    2 --
 arch/x86/kernel/cpu/mcheck/mce.c          |   10 ++--------
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
index 5d55158..34c1304 100644
--- a/Documentation/x86/x86_64/boot-options.txt
+++ b/Documentation/x86/x86_64/boot-options.txt
@@ -13,8 +13,6 @@ Machine check
                in a reboot. On Intel systems it is enabled by default.
    mce=nobootlog
 		Disable boot machine check logging.
-   mce=nopoll
-		Disable timer polling for corrected errors
    mce=tolerancelevel (number)
 		0: always panic on uncorrected errors, log corrected errors
 		1: panic or SIGBUS on uncorrected errors, log corrected errors
diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index d7dccfe..d3628f3 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -465,8 +465,6 @@ void mce_log_therm_throt_event(__u64 status)
  * Periodic polling timer for "silent" machine check errors.  If the
  * poller finds an MCE, poll 2x faster.  When the poller finds no more
  * errors, poll 2x slower (up to check_interval seconds).
- *
- * If check_interval is 0, polling is disabled.
  */
 
 static int		check_interval = 5 * 60;	/* 5 minutes */
@@ -665,12 +663,11 @@ static void mce_init_timer(void)
 {
 	struct timer_list *t = &__get_cpu_var(mce_timer);
 
-	/* Disable polling if check_interval is 0 */
-	if (!check_interval)
-		return;
 	/* data race harmless because everyone sets to the same value */
 	if (!next_interval)
 		next_interval = check_interval * HZ;
+	if (!next_interval)
+		return;
 	setup_timer(t, mcheck_timer, smp_processor_id());
 	t->expires = round_jiffies(jiffies + next_interval);
 	add_timer(t);
@@ -885,14 +882,11 @@ __setup("nomce", mcheck_disable);
  * mce=TOLERANCELEVEL (number, see above)
  * mce=bootlog Log MCEs from before booting. Disabled by default on AMD.
  * mce=nobootlog Don't log MCEs from before booting.
- * mce=nopoll Disable timer polling for corrected errors
  */
 static int __init mcheck_enable(char *str)
 {
 	if (!strcmp(str, "off"))
 		mce_dont_init = 1;
-	else if (!strcmp(str, "nopoll"))
-		check_interval = 0;
 	else if (!strcmp(str, "bootlog") || !strcmp(str, "nobootlog"))
 		mce_bootlog = (str[0] == 'b');
 	else if (isdigit(str[0]))
-- 
1.6.3

