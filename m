Return-Path: <linux-kernel-owner+w=401wt.eu-S1761395AbZC1VcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761395AbZC1VcT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Mar 2009 17:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761039AbZC1V3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Mar 2009 17:29:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:51476 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761024AbZC1V3w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Mar 2009 17:29:52 -0400
Date: Sat, 28 Mar 2009 21:29:12 GMT
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       seto.hidetoshi@jp.fujitsu.com, ak@linux.intel.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       seto.hidetoshi@jp.fujitsu.com, ak@linux.intel.com, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <49CB3F4B.8070406@jp.fujitsu.com>
References: <49CB3F4B.8070406@jp.fujitsu.com>
Subject: [tip:x86/mce2] x86, mce: Add mce=nopoll option to disable timer polling
Message-ID: <tip-f5b3ca6efb64aa3ab5fa32f0fc9cc0f6cfedee95@git.kernel.org>
Git-Commit-ID: f5b3ca6efb64aa3ab5fa32f0fc9cc0f6cfedee95
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 28 Mar 2009 21:29:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f5b3ca6efb64aa3ab5fa32f0fc9cc0f6cfedee95
Gitweb:     http://git.kernel.org/tip/f5b3ca6efb64aa3ab5fa32f0fc9cc0f6cfedee95
Author:     Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
AuthorDate: Thu, 26 Mar 2009 17:39:39 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Sat, 28 Mar 2009 13:13:01 +0100

x86, mce: Add mce=nopoll option to disable timer polling

Impact: add new boot option

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
LKML-Reference: <49CB3F4B.8070406@jp.fujitsu.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
index 9bf52bd..fe21883 100644
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
