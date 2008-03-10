Return-Path: <linux-kernel-owner+w=401wt.eu-S1752035AbYCJN44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbYCJN44 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 09:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751027AbYCJN4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 09:56:48 -0400
Received: from mail.windriver.com ([147.11.1.11]:47580 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750962AbYCJN4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 09:56:47 -0400
Message-ID: <47D53E09.9030107@windriver.com>
Date: Mon, 10 Mar 2008 08:56:25 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] kgdb: Add kgdb internal test suite
References: <1204929257-9967-1-git-send-email-jason.wessel@windriver.com> <1204929257-9967-2-git-send-email-jason.wessel@windriver.com> <1204929257-9967-3-git-send-email-jason.wessel@windriver.com> <20080310074047.GA16906@elte.hu>
In-Reply-To: <20080310074047.GA16906@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Mar 2008 13:56:26.0076 (UTC) FILETIME=[8832F9C0:01C882B6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jason Wessel <jason.wessel@windriver.com> wrote:
> 
>> This patch adds regression tests for testing the kgdb core and arch
>> specific implementation.
> 
> nice!
> 
>> When using the "kgdbts=" you only choose one of the following core
>> test types:
>> A = Run all the core tests silently
>> V1 = Run all the core tests with minimal output
>> V2 = Run all the core tests in debug mode
> 
> please also add a Kconfig way to activate them and let them be executed 
> automatically upon bootup. If any test fails it should generate a 
> WARN_ON() type of message (for automated testers to find).
> 
> 	Ingo


Easy enough.  I folded the attached patch into the original kgdbts
patch in the for_ingo branch.

Jason.

-----CLIP HERE-----
>From a855efa51466cc6e46ed11355d7cc3e1ac24a5bf Mon Sep 17 00:00:00 2001
From: Jason Wessel <jason.wessel@windriver.com>
Date: Mon, 10 Mar 2008 08:43:54 -0500
Subject: [PATCH 3/3] kgdb: allow static kgdbts boot configuration

This patch adds in the ability to compile the kgdb internal test
string into the kernel so as to run the tests at boot without changing
the kernel boot arguments.  This patch also changes all the error
paths to invoke WARN_ON(1) which will emit the line number of the file
and dump the kernel stack when an error occurs.

You can disable the tests in a kernel that is built this way
using "kgdbts="

Jason.

Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
---
 drivers/misc/kgdbts.c |   41 ++++++++++++++++++++++++-----------------
 lib/Kconfig.kgdb      |   18 ++++++++++++++++++
 2 files changed, 42 insertions(+), 17 deletions(-)

diff --git a/drivers/misc/kgdbts.c b/drivers/misc/kgdbts.c
index cbc4822..8e5618a 100644
--- a/drivers/misc/kgdbts.c
+++ b/drivers/misc/kgdbts.c
@@ -112,6 +112,10 @@
 		printk(KERN_INFO a); \
 		touch_nmi_watchdog();	\
 	} while (0)
+#define eprintk(a...) do { \
+		printk(KERN_ERR a); \
+		WARN_ON(1); \
+	} while (0)
 #define MAX_CONFIG_LEN		40
 
 static const char hexchars[] = "0123456789abcdef";
@@ -145,7 +149,11 @@ static struct pt_regs kgdbts_regs;
 /* -1 = init not run yet, 0 = unconfigured, 1 = configured. */
 static int configured		= -1;
 
+#ifdef CONFIG_KGDB_TESTS_BOOT_STRING
+static char config[MAX_CONFIG_LEN] = CONFIG_KGDB_TESTS_BOOT_STRING;
+#else
 static char config[MAX_CONFIG_LEN];
+#endif
 static struct kparam_string kps = {
 	.string			= config,
 	.maxlen			= MAX_CONFIG_LEN,
@@ -289,7 +297,7 @@ static int check_and_rewind_pc(char *put_str, char *arg)
 #endif
 	if (strcmp(arg, "silent") &&
 		instruction_pointer(&kgdbts_regs) + offset != addr) {
-		printk(KERN_ERR "kgdbts: BP mismatch %lx expected %lx\n",
+		eprintk("kgdbts: BP mismatch %lx expected %lx\n",
 			   instruction_pointer(&kgdbts_regs) + offset, addr);
 		return 1;
 	}
@@ -313,7 +321,7 @@ static int check_single_step(char *put_str, char *arg)
 	v2printk("Singlestep stopped at IP: %lx\n",
 		   instruction_pointer(&kgdbts_regs));
 	if (instruction_pointer(&kgdbts_regs) == addr) {
-		printk(KERN_ERR "kgdbts: SingleStep failed at %lx\n",
+		eprintk("kgdbts: SingleStep failed at %lx\n",
 			   instruction_pointer(&kgdbts_regs));
 		return 1;
 	}
@@ -378,7 +386,7 @@ static void emul_sstep_get(char *arg)
 		break_helper("z0", 0, sstep_addr);
 		break;
 	default:
-		printk(KERN_ERR "kgdbts: ERROR failed sstep get emulation\n");
+		eprintk("kgdbts: ERROR failed sstep get emulation\n");
 	}
 	sstep_state++;
 }
@@ -404,26 +412,26 @@ static int emul_sstep_put(char *put_str, char *arg)
 		break;
 	case 2:
 		if (strncmp(put_str, "$OK", 3)) {
-			printk(KERN_ERR "kgdbts: failed sstep break set\n");
+			eprintk("kgdbts: failed sstep break set\n");
 			return 1;
 		}
 		break;
 	case 3:
 		if (strncmp(put_str, "$T0", 3)) {
-			printk(KERN_ERR "kgdbts: failed continue sstep\n");
+			eprintk("kgdbts: failed continue sstep\n");
 			return 1;
 		}
 		break;
 	case 4:
 		if (strncmp(put_str, "$OK", 3)) {
-			printk(KERN_ERR "kgdbts: failed sstep break unset\n");
+			eprintk("kgdbts: failed sstep break unset\n");
 			return 1;
 		}
 		/* Single step is complete so continue on! */
 		sstep_state = 0;
 		return 0;
 	default:
-		printk(KERN_ERR "kgdbts: ERROR failed sstep put emulation\n");
+		eprintk("kgdbts: ERROR failed sstep put emulation\n");
 	}
 
 	/* Continue on the same test line until emulation is complete */
@@ -668,8 +676,7 @@ static int run_simple_test(int is_get_char, int chr)
 		}
 
 		if (get_buf[get_buf_cnt] == '\0') {
-			printk(KERN_ERR
-			   "kgdbts: ERROR GET: end of buffer on '%s' at %i\n",
+			eprintk("kgdbts: ERROR GET: EOB on '%s' at %i\n",
 			   ts.name, ts.idx);
 			get_buf_cnt = 0;
 			fill_get_buf("D");
@@ -684,13 +691,13 @@ static int run_simple_test(int is_get_char, int chr)
 	 */
 	if (ts.tst[ts.idx].get[0] == '\0' &&
 		ts.tst[ts.idx].put[0] == '\0') {
-		printk(KERN_ERR "kgdbts: ERROR: beyond end of test on"
+		eprintk("kgdbts: ERROR: beyond end of test on"
 			   " '%s' line %i\n", ts.name, ts.idx);
 		return 0;
 	}
 
 	if (put_buf_cnt >= BUFMAX) {
-		printk(KERN_ERR "kgdbts: ERROR: put buffer overflow on"
+		eprintk("kgdbts: ERROR: put buffer overflow on"
 			   " '%s' line %i\n", ts.name, ts.idx);
 		put_buf_cnt = 0;
 		return 0;
@@ -708,7 +715,7 @@ static int run_simple_test(int is_get_char, int chr)
 		v2printk("put%i: %s\n", ts.idx, put_buf);
 		/* Trigger check here */
 		if (ts.validate_put && ts.validate_put(put_buf)) {
-			printk(KERN_ERR "kgdbts: ERROR PUT: end of test "
+			eprintk("kgdbts: ERROR PUT: end of test "
 			   "buffer on '%s' line %i expected %s got %s\n",
 			   ts.name, ts.idx, ts.tst[ts.idx].put, put_buf);
 		}
@@ -772,7 +779,7 @@ static void run_breakpoint_test(int is_hw_breakpoint)
 	if (test_complete)
 		return;
 
-	printk(KERN_ERR "kgdbts: ERROR %s test failed\n", ts.name);
+	eprintk("kgdbts: ERROR %s test failed\n", ts.name);
 }
 
 static void run_hw_break_test(int is_write_test)
@@ -791,7 +798,7 @@ static void run_hw_break_test(int is_write_test)
 	hw_break_val_access();
 	if (is_write_test) {
 		if (test_complete == 2)
-			printk(KERN_ERR "kgdbts: ERROR %s broke on access\n",
+			eprintk("kgdbts: ERROR %s broke on access\n",
 				ts.name);
 		hw_break_val_write();
 	}
@@ -800,7 +807,7 @@ static void run_hw_break_test(int is_write_test)
 	if (test_complete == 1)
 		return;
 
-	printk(KERN_ERR "kgdbts: ERROR %s test failed\n", ts.name);
+	eprintk("kgdbts: ERROR %s test failed\n", ts.name);
 }
 
 static void run_nmi_sleep_test(int nmi_sleep)
@@ -817,12 +824,12 @@ static void run_nmi_sleep_test(int nmi_sleep)
 	touch_nmi_watchdog();
 	local_irq_restore(flags);
 	if (test_complete != 2)
-		printk(KERN_ERR "kgdbts: ERROR nmi_test did not hit nmi\n");
+		eprintk("kgdbts: ERROR nmi_test did not hit nmi\n");
 	kgdb_breakpoint();
 	if (test_complete == 1)
 		return;
 
-	printk(KERN_ERR "kgdbts: ERROR %s test failed\n", ts.name);
+	eprintk("kgdbts: ERROR %s test failed\n", ts.name);
 }
 
 static void run_bad_read_test(void)
diff --git a/lib/Kconfig.kgdb b/lib/Kconfig.kgdb
index aaabcdd..f2e01ac 100644
--- a/lib/Kconfig.kgdb
+++ b/lib/Kconfig.kgdb
@@ -38,3 +38,21 @@ config KGDB_TESTS
 	  See the drivers/misc/kgdbts.c for the details about
 	  the tests.  The most basic of this I/O module is to boot
 	  a kernel boot arguments "kgdbwait kgdbts=V1F100"
+
+config KGDB_TESTS_ON_BOOT
+	bool "KGDB: Run tests on boot"
+	depends on KGDB_TESTS
+	default n
+	help
+	  Run the kgdb tests on boot up automatically without the need
+	  to pass in a kernel parameter
+
+config KGDB_TESTS_BOOT_STRING
+	string "KGDB: which internal kgdb tests to run"
+	depends on KGDB_TESTS_ON_BOOT
+	default "V1F100"
+	help
+	  This is the command string to send the kgdb test suite on
+	  boot.  See the drivers/misc/kgdbts.c for detailed
+	  information about other strings you could use beyond the
+	  default of V1F100.
-- 
1.5.4

