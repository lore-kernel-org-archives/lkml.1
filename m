Return-Path: <linux-kernel-owner+w=401wt.eu-S1757879AbZCZIkz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879AbZCZIkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 04:40:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757622AbZCZIkF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 04:40:05 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37445 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757056AbZCZIkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 04:40:01 -0400
Message-ID: <49CB3F4B.8070406@jp.fujitsu.com>
Date: Thu, 26 Mar 2009 17:39:39 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: [PATCH -tip 3/3] x86, mce: Add mce=nopoll option to disable timer
 polling
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds "mce=nopoll" option to disable timer polling
for corrected errors from boot.  Unlike "mce=off", it doesn't
prevent handling for uncorrected errors.

It is useful if:
 - You don't have any interests in corrected errors. You may
   use option mce_threshold=0 to disable cmci too.
 - You'd like to care banks only which cmci are supported.
 - You have an application such as hardware monitor that
   checks error banks, and that can conflict with OS's polling.
 - Your system have an intelligent BIOS which can provide
   enough health information, so reports from OS is redundant.

Once booted, we can disable polling by setting check_interval
to 0, but there are no mention about the fact.
Some additional comments are help for this.

Signed-off-by: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
---
 Documentation/x86/x86_64/boot-options.txt |    2 ++
 arch/x86/kernel/cpu/mcheck/mce_64.c       |   10 ++++++++--
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/Documentation/x86/x86_64/boot-options.txt b/Documentation/x86/x86_64/boot-options.txt
index 34c1304..5d55158 100644
--- a/Documentation/x86/x86_64/boot-options.txt
+++ b/Documentation/x86/x86_64/boot-options.txt
@@ -13,6 +13,8 @@ Machine check
                in a reboot. On Intel systems it is enabled by default.
    mce=nobootlog
 		Disable boot machine check logging.
+   mce=nopoll
+		Disable timer polling for corrected errors
    mce=tolerancelevel (number)
 		0: always panic on uncorrected errors, log corrected errors
 		1: panic or SIGBUS on uncorrected errors, log corrected errors
diff --git a/arch/x86/kernel/cpu/mcheck/mce_64.c b/arch/x86/kernel/cpu/mcheck/mce_64.c
index 33d612e..80ec191 100644
--- a/arch/x86/kernel/cpu/mcheck/mce_64.c
+++ b/arch/x86/kernel/cpu/mcheck/mce_64.c
@@ -449,6 +449,8 @@ void mce_log_therm_throt_event(__u64 status)
  * Periodic polling timer for "silent" machine check errors.  If the
  * poller finds an MCE, poll 2x faster.  When the poller finds no more
  * errors, poll 2x slower (up to check_interval seconds).
+ *
+ * If check_interval is 0, polling is disabled.
  */
 
 static int check_interval = 5 * 60; /* 5 minutes */
@@ -633,11 +635,12 @@ static void mce_init_timer(void)
 {
 	struct timer_list *t = &__get_cpu_var(mce_timer);
 
+	/* Disable polling if check_interval is 0 */
+	if (!check_interval)
+		return;
 	/* data race harmless because everyone sets to the same value */
 	if (!next_interval)
 		next_interval = check_interval * HZ;
-	if (!next_interval)
-		return;
 	setup_timer(t, mcheck_timer, smp_processor_id());
 	t->expires = round_jiffies(jiffies + next_interval);
 	add_timer(t);
@@ -845,11 +848,14 @@ __setup("nomce", mcheck_disable);
  * mce=TOLERANCELEVEL (number, see above)
  * mce=bootlog Log MCEs from before booting. Disabled by default on AMD.
  * mce=nobootlog Don't log MCEs from before booting.
+ * mce=nopoll Disable timer polling for corrected errors
  */
 static int __init mcheck_enable(char *str)
 {
 	if (!strcmp(str, "off"))
 		mce_dont_init = 1;
+	else if (!strcmp(str, "nopoll"))
+		check_interval = 0;
 	else if (!strcmp(str, "bootlog") || !strcmp(str, "nobootlog"))
 		mce_bootlog = (str[0] == 'b');
 	else if (isdigit(str[0]))
-- 
1.6.2.1

