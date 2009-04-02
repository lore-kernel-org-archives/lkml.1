Return-Path: <linux-kernel-owner+w=401wt.eu-S1754932AbZDBE4A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754932AbZDBE4A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 00:56:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763785AbZDBEzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 00:55:40 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:49234 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317AbZDBEzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 00:55:39 -0400
Message-ID: <49D44542.6080902@jp.fujitsu.com>
Date: Thu, 02 Apr 2009 13:55:30 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <ak@linux.intel.com>
Subject: [PATCH -tip 2/3] x86, mce: Revert "add mce=nopoll option to disable
 timer polling"
References: <49CB3F24.8040804@jp.fujitsu.com> <20090328120825.GB14464@elte.hu> <49D183B0.6060306@jp.fujitsu.com> <20090401150711.GA20037@elte.hu> <49D44285.9070808@jp.fujitsu.com>
In-Reply-To: <49D44285.9070808@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disabling only polling but not cmci is pointless setting.
Instead of "mce=nopoll" which tend to be paired with cmci disablement,
it rather make sense to have a "mce=ignore_ce" option that disable
both of polling and cmci at once.  A patch for this new implementation
will follow this reverting patch.

OTOH, once booted, we can disable polling by setting check_interval
to 0, but there are no mention about the fact.  Later Andi will post
updated documents that can respond this issue.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 Documentation/x86/x86_64/boot-options.txt |    2 --
 arch/x86/kernel/cpu/mcheck/mce_64.c       |   10 ++--------
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
diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c b/arch/x86/kernel/cpu/mcheck/mce_64.c
index 80ec191..33d612e 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -449,8 +449,6 @@ void mce_log_therm_throt_event(__u64 status)
  * Periodic polling timer for "silent" machine check errors.  If the
  * poller finds an MCE, poll 2x faster.  When the poller finds no more
  * errors, poll 2x slower (up to check_interval seconds).
- *
- * If check_interval is 0, polling is disabled.
  */
 
 static int check_interval = 5 * 60; /* 5 minutes */
@@ -635,12 +633,11 @@ static void mce_init_timer(void)
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
@@ -848,14 +845,11 @@ __setup("nomce", mcheck_disable);
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
1.6.2.1

