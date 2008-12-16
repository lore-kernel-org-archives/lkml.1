Return-Path: <linux-kernel-owner+w=401wt.eu-S1752946AbYLPGVr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbYLPGVr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 01:21:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbYLPGVk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 01:21:40 -0500
Received: from mailgw.miraclelinux.com ([122.216.84.157]:32008 "EHLO
	mailgw.miraclelinux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbYLPGVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 01:21:40 -0500
Date: Tue, 16 Dec 2008 15:21:43 +0900
From: Yoshihiro Takahashi <ytakahashi@miraclelinux.com>
To: linux-kernel@vger.kernel.org
Subject: kdump hangs up by Sysrq+C trigger in high load.
Message-Id: <20081216152143.88caba51.ytakahashi@miraclelinux.com>
Organization: miraclelinux.com
X-Mailer: Sylpheed 2.6.0beta1 (GTK+ 2.10.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

kdump hangs up by Sysrq+C trigger once in about 10 times in high load.
After the above occurs, kdump cannot collect vmcores with NMI button.
When waiting_for_crash_ipi does case more than 0, mdelay seem to make 
a stall.

While nmi_shootdown_cpus(), mdelay may not work since interruption is
disable.  (ex. when crashing kernel by NMI interruption, all
interruption may be disabled.).

So I think that it should use other way (TSC) instead of mdelay() in
nmi_shootdown_cpus().

Here is the log.
--
SysRq : Trigger a crashdump
BUG: warning at arch/x86/kernel/crash.c:107/nmi_shootdown_cpus() (Not tainted)


    Signed-off-by: Yoshihiro Takahashi <ytakahashi@miraclelinux.com>
---
 crash.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 2685538..fc63636 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -89,7 +89,8 @@ static struct notifier_block crash_nmi_nb = {
 
 static void nmi_shootdown_cpus(void)
 {
-	unsigned long msecs;
+	int i, tsc_wait, tsc_count;
+	unsigned long tsc_start, tsc_now, tsc_delay;
 
 	atomic_set(&waiting_for_crash_ipi, num_online_cpus() - 1);
 	/* Would it be better to replace the trap vector here? */
@@ -102,10 +103,25 @@ static void nmi_shootdown_cpus(void)
 
 	smp_send_nmi_allbutself();
 
-	msecs = 1000; /* Wait at most a second for the other cpus to stop */
-	while ((atomic_read(&waiting_for_crash_ipi) > 0) && msecs) {
-		mdelay(1);
-		msecs--;
+	tsc_delay = HZ; /* Wait at most a second for the other cpus to stop */
+	while ((atomic_read(&waiting_for_crash_ipi) > 0) && tsc_delay) {
+		tsc_wait = 1000000; /* msec */
+		tsc_count = 16384;
+		while (tsc_wait > 0) {
+			if (tsc_count-- < 0) {
+				break;
+			}
+			tsc_start = get_cycles();
+			for (i = 0; i < 100000; i++) {
+				;
+			}
+			tsc_now = get_cycles();
+			tsc_wait -= tsc_now - tsc_start;
+		}
+		if (tsc_count < 0) {
+			break;
+		}
+		tsc_delay--;
 	}
 
 	/* Leave the nmi callback set */
