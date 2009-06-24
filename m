Return-Path: <linux-kernel-owner+w=401wt.eu-S1759537AbZFXVg1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759537AbZFXVg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 17:36:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751721AbZFXVgU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 17:36:20 -0400
Received: from kroah.org ([198.145.64.141]:54818 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971AbZFXVgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 17:36:19 -0400
Date: Wed, 24 Jun 2009 14:32:11 -0700
From: Greg KH <gregkh@suse.de>
To: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Kurt Garloff <garloff@suse.de>,
       linux-kernel@vger.kernel.org
Subject: [PATCH] x86: sysctl to allow panic on IOCK NMI error
Message-ID: <20090624213211.GA11291@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kurt Garloff <garloff@suse.de>

This patch introduces a sysctl /proc/sys/kernel/panic_on_io_nmi, which
defaults to 0 (off).

When enabled, the kernel panics when the kernel receives an NMI caused
by an IO error.

The IO error triggered NMI indicates a serious system condition, which
could result in IO data corruption. Rather than contiuing, panicing and
dumping might be a better choice, so one can figure out what's causing
the IO error.

This could be especially important to companies running IO intensive
applications where corruption must be avoided, e.g. a banks databases.


Signed-off-by: Kurt Garloff <garloff@suse.de>
Signed-off-by: Roberto Angelino <robertangelino@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---

I don't know why this wasn't sent to you before now, sorry about that.
SuSE has been shipping it for a while, it was done at the request of a
large database vendor, for their users.  Can you queue it up for .32?
  - gregkh

 arch/x86/kernel/dumpstack.c |    1 +
 arch/x86/kernel/traps.c     |    3 +++
 include/linux/kernel.h      |    1 +
 include/linux/sysctl.h      |    1 +
 kernel/sysctl.c             |    8 ++++++++
 kernel/sysctl_check.c       |    1 +
 6 files changed, 15 insertions(+)

--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -22,6 +22,7 @@
 #include "dumpstack.h"
 
 int panic_on_unrecovered_nmi;
+int panic_on_io_nmi;
 unsigned int code_bytes = 64;
 int kstack_depth_to_print = 3 * STACKSLOTS_PER_LINE;
 static int die_counter;
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -346,6 +346,9 @@ io_check_error(unsigned char reason, str
 	printk(KERN_EMERG "NMI: IOCK error (debug interrupt?)\n");
 	show_registers(regs);
 
+	if (panic_on_io_nmi)
+		panic("NMI IOCK error: Not continuing");
+
 	/* Re-enable the IOCK line, wait for a few seconds */
 	reason = (reason & 0xf) | 8;
 	outb(reason, 0x61);
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -303,6 +303,7 @@ extern int oops_in_progress;		/* If set,
 extern int panic_timeout;
 extern int panic_on_oops;
 extern int panic_on_unrecovered_nmi;
+extern int panic_on_io_nmi;
 extern const char *print_tainted(void);
 extern void add_taint(unsigned flag);
 extern int test_taint(unsigned flag);
--- a/include/linux/sysctl.h
+++ b/include/linux/sysctl.h
@@ -163,6 +163,7 @@ enum
 	KERN_MAX_LOCK_DEPTH=74,
 	KERN_NMI_WATCHDOG=75, /* int: enable/disable nmi watchdog */
 	KERN_PANIC_ON_NMI=76, /* int: whether we will panic on an unrecovered */
+	KERN_PANIC_ON_IO_NMI=77, /* int: whether we will panic on an io NMI */
 };
 
 
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -744,6 +744,14 @@ static struct ctl_table kern_table[] = {
 		.proc_handler	= &proc_dointvec,
 	},
 	{
+		.ctl_name	= KERN_PANIC_ON_IO_NMI,
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
--- a/kernel/sysctl_check.c
+++ b/kernel/sysctl_check.c
@@ -104,6 +104,7 @@ static const struct trans_ctl_table tran
 	{ KERN_MAX_LOCK_DEPTH,		"max_lock_depth" },
 	{ KERN_NMI_WATCHDOG,		"nmi_watchdog" },
 	{ KERN_PANIC_ON_NMI,		"panic_on_unrecovered_nmi" },
+	{ KERN_PANIC_ON_IO_NMI,		"panic_on_io_nmi" },
 	{}
 };
 

