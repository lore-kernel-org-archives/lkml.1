Return-Path: <linux-kernel-owner+w=401wt.eu-S1762029AbYBSLXg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762029AbYBSLXg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 06:23:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759607AbYBSLWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 06:22:51 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:45881 "EHLO amd.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759474AbYBSLWu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 06:22:50 -0500
Date: Tue, 19 Feb 2008 11:02:30 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Thomas Gleixner <tglx@linutronix.de>, jbohac@suse.cz
Cc: kernel list <linux-kernel@vger.kernel.org>, jikos@suse.cz,
       Ingo Molnar <mingo@elte.hu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Andrew Morton <akpm@osdl.org>
Subject: notsc is ignored on common configurations
Message-ID: <20080219100230.GA1688@elf.ucw.cz>
References: <20080218133852.GA1573@elf.ucw.cz> <alpine.LFD.1.00.0802181515070.7583@apollo.tec.linutronix.de> <20080218143757.GB1960@elf.ucw.cz> <alpine.LFD.1.00.0802181545090.7583@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802181545090.7583@apollo.tec.linutronix.de>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


notsc is ignored in 32-bit kernels if CONFIG_X86_TSC is on.. which is
bad, fix it.

Signed-off-by: Pavel Machek <pavel@suse.cz>

diff --git a/arch/x86/kernel/tsc_32.c b/arch/x86/kernel/tsc_32.c
index fafd9dc..3804fbe 100644
--- a/arch/x86/kernel/tsc_32.c
+++ b/arch/x86/kernel/tsc_32.c
@@ -28,7 +28,8 @@ #ifdef CONFIG_X86_TSC
 static int __init tsc_setup(char *str)
 {
 	printk(KERN_WARNING "notsc: Kernel compiled with CONFIG_X86_TSC, "
-				"cannot disable TSC.\n");
+				"cannot disable TSC completely.\n");
+	mark_tsc_unstable("user disabled TSC");
 	return 1;
 }
 #else
@@ -221,9 +222,9 @@ #ifdef CONFIG_CPU_FREQ
  * if the CPU frequency is scaled, TSC-based delays will need a different
  * loops_per_jiffy value to function properly.
  */
-static unsigned int ref_freq = 0;
-static unsigned long loops_per_jiffy_ref = 0;
-static unsigned long cpu_khz_ref = 0;
+static unsigned int ref_freq;
+static unsigned long loops_per_jiffy_ref;
+static unsigned long cpu_khz_ref;
 
 static int
 time_cpufreq_notifier(struct notifier_block *nb, unsigned long val, void *data)
@@ -285,7 +286,7 @@ #endif
 
 /* clock source code */
 
-static unsigned long current_tsc_khz = 0;
+static unsigned long current_tsc_khz;
 
 static cycle_t read_tsc(void)
 {

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
