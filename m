Return-Path: <linux-kernel-owner+w=401wt.eu-S934416AbYBBX5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934416AbYBBX5w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 18:57:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764774AbYBBX5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 18:57:44 -0500
Received: from ns2.suse.de ([195.135.220.15]:40082 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753503AbYBBX5o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 18:57:44 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Paul Mundt <lethal@linux-sh.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 01/10] kobject: Always build in kernel/ksysfs.o.
Date: Sat,  2 Feb 2008 15:55:55 -0800
Message-Id: <1201996564-21951-1-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.5.3.8
In-Reply-To: <20080202234357.GA21721@suse.de>
References: <20080202234357.GA21721@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mundt <lethal@linux-sh.org>

kernel/ksysfs.c seems to be a random dumping group for misc globals
that the rest of the tree depend on. This has caused problems with
exports in the past when sysfs is disabled, which can already be
observed in commit-id 51107301b629640f9ab76fe23bf385e187b9ac29.

The latest one is the kernel_kobj usage, which presently results in:

fs/built-in.o: In function `debugfs_init':
inode.c:(.init.text+0xc34): undefined reference to `kernel_kobj'
make: *** [.tmp_vmlinux1] Error 1

kernel/ksysfs.c itself at this point only contains globals and some
basic sysfs initialization, the sysfs initialization code is optimized
out when we build with sysfs disabled. Given that, it's easier to just
build in unconditionally, rather than trying to find some other random
place to dump and initialize the globals.

Additionally, the current trend seems to be decoupling of kobjects from
sysfs, in which case it still makes sense to perform the kernel_kobj
initialization that happens here even if sysfs is disabled, as
lib/kobject.o is built-in unconditionally.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/Makefile |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index 8885627..db9af70 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -9,7 +9,7 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o profile.o \
 	    rcupdate.o extable.o params.o posix-timers.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o latency.o nsproxy.o srcu.o \
-	    utsname.o notifier.o
+	    utsname.o notifier.o ksysfs.o
 
 obj-$(CONFIG_SYSCTL) += sysctl_check.o
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
@@ -49,7 +49,6 @@ obj-$(CONFIG_AUDIT) += audit.o auditfilter.o
 obj-$(CONFIG_AUDITSYSCALL) += auditsc.o
 obj-$(CONFIG_AUDIT_TREE) += audit_tree.o
 obj-$(CONFIG_KPROBES) += kprobes.o
-obj-$(CONFIG_SYSFS) += ksysfs.o
 obj-$(CONFIG_DETECT_SOFTLOCKUP) += softlockup.o
 obj-$(CONFIG_GENERIC_HARDIRQS) += irq/
 obj-$(CONFIG_SECCOMP) += seccomp.o
-- 
1.5.3.8

