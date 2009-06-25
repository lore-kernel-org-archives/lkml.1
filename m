Return-Path: <linux-kernel-owner+w=401wt.eu-S1759527AbZFYUHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759527AbZFYUHU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 16:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752875AbZFYUHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 16:07:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:54706 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752719AbZFYUHH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 16:07:07 -0400
Date: Thu, 25 Jun 2009 20:06:34 GMT
From: tip-bot for Kurt Garloff <garloff@suse.de>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       ebiederm@xmission.com, gregkh@suse.de, tglx@linutronix.de,
       robertangelino@gmail.com, mingo@elte.hu, garloff@suse.de
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       ebiederm@xmission.com, gregkh@suse.de, tglx@linutronix.de,
       robertangelino@gmail.com, garloff@suse.de, mingo@elte.hu
In-Reply-To: <20090624213211.GA11291@kroah.com>
References: <20090624213211.GA11291@kroah.com>
Subject: [tip:x86/urgent] x86: Add sysctl to allow panic on IOCK NMI error
Message-ID: <tip-0b2f282236572b333d5d74264b04f214c24aba18@git.kernel.org>
Git-Commit-ID: 0b2f282236572b333d5d74264b04f214c24aba18
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 25 Jun 2009 20:06:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0b2f282236572b333d5d74264b04f214c24aba18
Gitweb:     http://git.kernel.org/tip/0b2f282236572b333d5d74264b04f214c24aba18
Author:     Kurt Garloff <garloff@suse.de>
AuthorDate: Wed, 24 Jun 2009 14:32:11 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 25 Jun 2009 22:02:58 +0200

x86: Add sysctl to allow panic on IOCK NMI error

This patch introduces a new sysctl:

    /proc/sys/kernel/panic_on_io_nmi

which defaults to 0 (off).

When enabled, the kernel panics when the kernel receives an NMI
caused by an IO error.

The IO error triggered NMI indicates a serious system
condition, which could result in IO data corruption. Rather
than contiuing, panicing and dumping might be a better choice,
so one can figure out what's causing the IO error.

This could be especially important to companies running IO
intensive applications where corruption must be avoided, e.g. a
bank's databases.

[ SuSE has been shipping it for a while, it was done at the
  request of a large database vendor, for their users. ]

Signed-off-by: Kurt Garloff <garloff@suse.de>
Signed-off-by: Roberto Angelino <robertangelino@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
LKML-Reference: <20090624213211.GA11291@kroah.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/dumpstack.c |    1 +
 arch/x86/kernel/traps.c     |    3 +++
 include/linux/kernel.h      |    1 +
 kernel/sysctl.c             |    8 ++++++++
 kernel/sysctl_check.c       |    1 +
 5 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 95ea5fa..c840571 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -22,6 +22,7 @@
 #include "dumpstack.h"
 
 int panic_on_unrecovered_nmi;
+int panic_on_io_nmi;
 unsigned int code_bytes = 64;
 int kstack_depth_to_print = 3 * STACKSLOTS_PER_LINE;
 static int die_counter;
diff --git a/arch/x86/kernel/traps.c b/arch/x86/kernel/traps.c
index a0f48f5..5204332 100644
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -346,6 +346,9 @@ io_check_error(unsigned char reason, struct pt_regs *regs)
 	printk(KERN_EMERG "NMI: IOCK error (debug interrupt?)\n");
 	show_registers(regs);
 
+	if (panic_on_io_nmi)
+		panic("NMI IOCK error: Not continuing");
+
 	/* Re-enable the IOCK line, wait for a few seconds */
 	reason = (reason & 0xf) | 8;
 	outb(reason, 0x61);
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index fac104e..d6320a3 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -303,6 +303,7 @@ extern int oops_in_progress;		/* If set, an oops, panic(), BUG() or die() is in
 extern int panic_timeout;
 extern int panic_on_oops;
 extern int panic_on_unrecovered_nmi;
+extern int panic_on_io_nmi;
 extern const char *print_tainted(void);
 extern void add_taint(unsigned flag);
 extern int test_taint(unsigned flag);
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index 62e4ff9..fba42ed 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -744,6 +744,14 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
+		.ctl_name	= CTL_UNNUMBERED,
+		.procname	= "panic_on_io_nmi",
+		.data		= &panic_on_io_nmi,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= &proc_dointvec,
+	},
+	{
 		.ctl_name	= KERN_BOOTLOADER_TYPE,
 		.procname	= "bootloader_type",
 		.data		= &bootloader_type,
diff --git a/kernel/sysctl_check.c b/kernel/sysctl_check.c
index b38423c..e1d8e0f 100644
--- a/kernel/sysctl_check.c
+++ b/kernel/sysctl_check.c
@@ -104,6 +104,7 @@ static const struct trans_ctl_table trans_kern_table[] = {
 	{ KERN_MAX_LOCK_DEPTH,		"max_lock_depth" },
 	{ KERN_NMI_WATCHDOG,		"nmi_watchdog" },
 	{ KERN_PANIC_ON_NMI,		"panic_on_unrecovered_nmi" },
+	{ KERN_PANIC_ON_IO_NMI,		"panic_on_io_nmi" },
 	{}
 };
 
