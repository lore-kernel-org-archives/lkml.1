Return-Path: <linux-kernel-owner+w=401wt.eu-S1755136AbZDNIev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbZDNIev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 04:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753405AbZDNIe2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 04:34:28 -0400
Received: from hera.kernel.org ([140.211.167.34]:59634 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751805AbZDNIeZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 04:34:25 -0400
Date: Tue, 14 Apr 2009 08:33:54 GMT
From: tip-bot for Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jeremy@goop.org, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, jeremy@goop.org,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49E4413F.7070700@goop.org>
References: <49E4413F.7070700@goop.org>
Subject: [tip:tracing/core] tracing: make the trace clocks available generally
Message-ID: <tip-f071f5f3ca9dc29062bf1c3ad6ec8bf136f0087c@git.kernel.org>
Git-Commit-ID: f071f5f3ca9dc29062bf1c3ad6ec8bf136f0087c
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 14 Apr 2009 08:33:57 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  f071f5f3ca9dc29062bf1c3ad6ec8bf136f0087c
Gitweb:     http://git.kernel.org/tip/f071f5f3ca9dc29062bf1c3ad6ec8bf136f0087c
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Tue, 14 Apr 2009 11:24:36 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 14 Apr 2009 11:31:07 +0200

tracing: make the trace clocks available generally

Jeremy Fitzhardinge reported this build failure:

 LD	 .tmp_vmlinux1
 arch/x86/kernel/built-in.o: In function `ds_take_timestamp':
 git/linux/arch/x86/kernel/ds.c:1380: undefined reference to `trace_clock_global'
 git/linux/arch/x86/kernel/ds.c:1380: undefined reference to `trace_clock_global'

Which is due to !CONFIG_TRACING && CONFIG_X86_DS=y.

Librarize the tracing clock code.

Reported-by: Jeremy Fitzhardinge <jeremy@goop.org>
LKML-Reference: <49E4413F.7070700@goop.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/Makefile       |    1 +
 kernel/trace/Makefile |    7 ++++++-
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/kernel/Makefile b/kernel/Makefile
index 4242366..f341f35 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -93,6 +93,7 @@ obj-$(CONFIG_LATENCYTOP) += latencytop.o
 obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
 obj-$(CONFIG_FUNCTION_TRACER) += trace/
 obj-$(CONFIG_TRACING) += trace/
+obj-y += trace/
 obj-$(CONFIG_SMP) += sched_cpupri.o
 obj-$(CONFIG_SLOW_WORK) += slow-work.o
 
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 3ad367e..674d790 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -15,11 +15,16 @@ ifdef CONFIG_TRACING_BRANCHES
 KBUILD_CFLAGS += -DDISABLE_BRANCH_PROFILING
 endif
 
+#
+# Make the trace clocks available generally: it's infrastructure
+# relied on by ptrace for example:
+#
+obj-y += trace_clock.o
+
 obj-$(CONFIG_FUNCTION_TRACER) += libftrace.o
 obj-$(CONFIG_RING_BUFFER) += ring_buffer.o
 
 obj-$(CONFIG_TRACING) += trace.o
-obj-$(CONFIG_TRACING) += trace_clock.o
 obj-$(CONFIG_TRACING) += trace_output.o
 obj-$(CONFIG_TRACING) += trace_stat.o
 obj-$(CONFIG_TRACING) += trace_printk.o
