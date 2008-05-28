Return-Path: <linux-kernel-owner+w=401wt.eu-S1759440AbYE1BiW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440AbYE1BiW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2008 21:38:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751698AbYE1BiO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 May 2008 21:38:14 -0400
Received: from mail.windriver.com ([147.11.1.11]:48393 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbYE1BiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2008 21:38:13 -0400
Message-ID: <483CB74D.3030203@windriver.com>
Date: Tue, 27 May 2008 20:37:17 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080502)
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Alexander Beregalov <a.beregalov@gmail.com>,
       kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: kgdb test suite failure
References: <a4423d670805090714iaae7d4fj2883889ede15a4be@mail.gmail.com>  <4832EBCF.2000407@windriver.com> <a4423d670805201130l649440acl3ef31f60503b279d@mail.gmail.com> <48344D5B.1020308@windriver.com> <alpine.LFD.1.10.0805222304250.3295@apollo.tec.linutronix.de>
In-Reply-To: <alpine.LFD.1.10.0805222304250.3295@apollo.tec.linutronix.de>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 May 2008 01:37:11.0348 (UTC) FILETIME=[595AD740:01C8C063]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner wrote:
> On Wed, 21 May 2008, Jason Wessel wrote:
>> An RFC type patch follows which addresses the problem, but in my
>> opinion not in a terribly clean way...  Perhaps other folks will
>> comment on a different or better way to approach the problem or chime
>> in on if it should be fixed at all.  Certainly the test suite could be
>> changed to use HW breakpoints for the case where the text segments are
>> going to be read only as an example.
> 
> Please use HW breakpoints in the test suite. The RFC patch looks
> horrible :)
> 
> Thanks,
> 	tglx


I believe the kgdb tests should pass for this configuration, and the
tests have been adjusted to support boards that do and don't have
working hardware breakpoints.

I queued the patch below into the for_linus branch for the 2.6.26
tree.

Jason.


---
From: Jason Wessel <jason.wessel@windriver.com>
Subject: kgdbts: Use HW breakpoints with CONFIG_DEBUG_RODATA

Whenever CONFIG_DEBUG_RODATA is set in the kernel config many kernel
text sections become read-only, and the use of software breakpoints in
the kgdb tests will cause the kernel to fail to complete the start up.

Until such time that there is an official API for modifying read-only
text sections hardware breakpoints must be used to run the do_fork or
sys_open tests or the tests get skipped.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>

---
 drivers/misc/kgdbts.c |   27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

--- a/drivers/misc/kgdbts.c
+++ b/drivers/misc/kgdbts.c
@@ -130,6 +130,8 @@ static int repeat_test;
 static int test_complete;
 static int send_ack;
 static int final_ack;
+static int force_hwbrks;
+static int hwbreaks_ok;
 static int hw_break_val;
 static int hw_break_val2;
 #if defined(CONFIG_ARM) || defined(CONFIG_MIPS) || defined(CONFIG_SPARC)
@@ -233,12 +235,12 @@ static void break_helper(char *bp_type, 
 
 static void sw_break(char *arg)
 {
-	break_helper("Z0", arg, 0);
+	break_helper(force_hwbrks ? "Z1" : "Z0", arg, 0);
 }
 
 static void sw_rem_break(char *arg)
 {
-	break_helper("z0", arg, 0);
+	break_helper(force_hwbrks ? "z1" : "z0", arg, 0);
 }
 
 static void hw_break(char *arg)
@@ -780,6 +782,8 @@ static void run_breakpoint_test(int is_h
 		return;
 
 	eprintk("kgdbts: ERROR %s test failed\n", ts.name);
+	if (is_hw_breakpoint)
+		hwbreaks_ok = 0;
 }
 
 static void run_hw_break_test(int is_write_test)
@@ -797,9 +801,11 @@ static void run_hw_break_test(int is_wri
 	kgdb_breakpoint();
 	hw_break_val_access();
 	if (is_write_test) {
-		if (test_complete == 2)
+		if (test_complete == 2) {
 			eprintk("kgdbts: ERROR %s broke on access\n",
 				ts.name);
+			hwbreaks_ok = 0;
+		}
 		hw_break_val_write();
 	}
 	kgdb_breakpoint();
@@ -808,6 +814,7 @@ static void run_hw_break_test(int is_wri
 		return;
 
 	eprintk("kgdbts: ERROR %s test failed\n", ts.name);
+	hwbreaks_ok = 0;
 }
 
 static void run_nmi_sleep_test(int nmi_sleep)
@@ -911,6 +918,7 @@ static void kgdbts_run_tests(void)
 
 	/* All HW break point tests */
 	if (arch_kgdb_ops.flags & KGDB_HW_BREAKPOINT) {
+		hwbreaks_ok = 1;
 		v1printk("kgdbts:RUN hw breakpoint test\n");
 		run_breakpoint_test(1);
 		v1printk("kgdbts:RUN hw write breakpoint test\n");
@@ -924,6 +932,19 @@ static void kgdbts_run_tests(void)
 		run_nmi_sleep_test(nmi_sleep);
 	}
 
+#ifdef CONFIG_DEBUG_RODATA
+	/* Until there is an api to write to read-only text segments, use
+	 * HW breakpoints for the remainder of any tests, else print a
+	 * failure message if hw breakpoints do not work.
+	 */
+	if (!(arch_kgdb_ops.flags & KGDB_HW_BREAKPOINT && hwbreaks_ok)) {
+		eprintk("kgdbts: HW breakpoints do not work,"
+			"skipping remaining tests\n");
+		return;
+	}
+	force_hwbrks = 1;
+#endif /* CONFIG_DEBUG_RODATA */
+
 	/* If the do_fork test is run it will be the last test that is
 	 * executed because a kernel thread will be spawned at the very
 	 * end to unregister the debug hooks.


