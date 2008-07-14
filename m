Return-Path: <linux-kernel-owner+w=401wt.eu-S1757392AbYGNQ3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392AbYGNQ3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 12:29:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755762AbYGNQ2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 12:28:41 -0400
Received: from www.tglx.de ([62.245.132.106]:49336 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757580AbYGNQ2k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 12:28:40 -0400
Date: Mon, 14 Jul 2008 18:28:21 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: [GIT pull] timer updates for 2.6.27
Message-ID: <alpine.LFD.1.10.0807141827340.3283@apollo.tec.linutronix.de>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers/for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers/for-linus

Thanks,

	tglx

------------------>
Carlos R. Mafra (1):
      hrtimer: Remove unused variables in ktime_divns()

Heiko Carstens (1):
      nohz: don't stop idle tick if softirqs are pending.

Hiroshi Shimamoto (1):
      posix-timers: print RT watchdog message

Ingo Molnar (1):
      nohz: reduce jiffies polling overhead

Jeremy Fitzhardinge (1):
      hrtimer: remove warning in hres_timers_resume

Joe Buehler (1):
      x86: add PCI ID for 6300ESB force hpet

Krzysztof Oledzki (1):
      x86: add another PCI ID for ICH6 force-hpet

Randy Dunlap (1):
      acpi_pm clccksource: fix printk format warning

Thomas Gleixner (2):
      pmtmr: allow command line override of ioport
      kernel-paramaters: document pmtmr= command line option


 Documentation/kernel-parameters.txt |    4 ++++
 arch/x86/kernel/quirks.c            |    4 ++++
 drivers/clocksource/acpi_pm.c       |   19 +++++++++++++++++++
 kernel/hrtimer.c                    |    7 ++-----
 kernel/posix-cpu-timers.c           |    3 +++
 kernel/time/tick-sched.c            |    8 ++++++++
 6 files changed, 40 insertions(+), 5 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index b52f47d..f223863 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1571,6 +1571,10 @@ and is between 256 and 4096 characters. It is defined in the file
 			Format: { parport<nr> | timid | 0 }
 			See also Documentation/parport.txt.
 
+	pmtmr=		[X86] Manual setup of pmtmr I/O Port. 
+			Override pmtimer IOPort with a hex value.
+			e.g. pmtmr=0x508
+
 	pnpacpi=	[ACPI]
 			{ off }
 
diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index d89a648..f327aba 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -158,6 +158,8 @@ static void ich_force_enable_hpet(struct pci_dev *dev)
 
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ESB2_0,
 			 ich_force_enable_hpet);
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH6_0,
+			 ich_force_enable_hpet);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH6_1,
 			 ich_force_enable_hpet);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ICH7_0,
@@ -255,6 +257,8 @@ static void old_ich_force_enable_hpet_user(struct pci_dev *dev)
 		old_ich_force_enable_hpet(dev);
 }
 
+DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ESB_1,
+			 old_ich_force_enable_hpet_user);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801CA_0,
 			 old_ich_force_enable_hpet_user);
 DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_82801CA_12,
diff --git a/drivers/clocksource/acpi_pm.c b/drivers/clocksource/acpi_pm.c
index 7b46faf..bcd7d0e 100644
--- a/drivers/clocksource/acpi_pm.c
+++ b/drivers/clocksource/acpi_pm.c
@@ -215,3 +215,22 @@ pm_good:
  * but we still need to load before device_initcall
  */
 fs_initcall(init_acpi_pm_clocksource);
+
+/*
+ * Allow an override of the IOPort. Stupid BIOSes do not tell us about
+ * the PMTimer, but we might know where it is.
+ */
+static int __init parse_pmtmr(char *arg)
+{
+	unsigned long base;
+
+	if (strict_strtoul(arg, 16, &base))
+		return -EINVAL;
+
+	printk(KERN_INFO "PMTMR IOPort override: 0x%04x -> 0x%04x\n",
+	       (unsigned int)pmtmr_ioport, base);
+	pmtmr_ioport = base;
+
+	return 1;
+}
+__setup("pmtmr=", parse_pmtmr);
diff --git a/kernel/hrtimer.c b/kernel/hrtimer.c
index ab80515..ffca825 100644
--- a/kernel/hrtimer.c
+++ b/kernel/hrtimer.c
@@ -300,11 +300,10 @@ EXPORT_SYMBOL_GPL(ktime_sub_ns);
  */
 u64 ktime_divns(const ktime_t kt, s64 div)
 {
-	u64 dclc, inc, dns;
+	u64 dclc;
 	int sft = 0;
 
-	dclc = dns = ktime_to_ns(kt);
-	inc = div;
+	dclc = ktime_to_ns(kt);
 	/* Make sure the divisor is less than 2^32: */
 	while (div >> 32) {
 		sft++;
@@ -632,8 +631,6 @@ void clock_was_set(void)
  */
 void hres_timers_resume(void)
 {
-	WARN_ON_ONCE(num_online_cpus() > 1);
-
 	/* Retrigger the CPU local events: */
 	retrigger_next_event(NULL);
 }
diff --git a/kernel/posix-cpu-timers.c b/kernel/posix-cpu-timers.c
index f1525ad..c42a03a 100644
--- a/kernel/posix-cpu-timers.c
+++ b/kernel/posix-cpu-timers.c
@@ -1037,6 +1037,9 @@ static void check_thread_timers(struct task_struct *tsk,
 				sig->rlim[RLIMIT_RTTIME].rlim_cur +=
 								USEC_PER_SEC;
 			}
+			printk(KERN_INFO
+				"RT Watchdog Timeout: %s[%d]\n",
+				tsk->comm, task_pid_nr(tsk));
 			__group_send_sig_info(SIGXCPU, SEND_SIG_PRIV, tsk);
 		}
 	}
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index b854a89..86baa4f 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -48,6 +48,13 @@ static void tick_do_update_jiffies64(ktime_t now)
 	unsigned long ticks = 0;
 	ktime_t delta;
 
+	/*
+	 * Do a quick check without holding xtime_lock:
+	 */
+	delta = ktime_sub(now, last_jiffies_update);
+	if (delta.tv64 < tick_period.tv64)
+		return;
+
 	/* Reevalute with xtime_lock held */
 	write_seqlock(&xtime_lock);
 
@@ -228,6 +235,7 @@ void tick_nohz_stop_sched_tick(void)
 			       local_softirq_pending());
 			ratelimit++;
 		}
+		goto end;
 	}
 
 	ts->idle_calls++;
