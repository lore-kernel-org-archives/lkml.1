Return-Path: <linux-kernel-owner+w=401wt.eu-S1753921AbZBQQhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753921AbZBQQhe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 11:37:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751967AbZBQQhW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 11:37:22 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:40580 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921AbZBQQhV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 11:37:21 -0500
Date: Tue, 17 Feb 2009 17:37:11 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [git pull] tracing fixes
Message-ID: <20090217163711.GA3680@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest tracing-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git tracing-fixes-for-linus

 Thanks,

	Ingo

------------------>
Pekka Paalanen (3):
      mmiotrace: count events lost due to not recording
      trace: mmiotrace to the tracer menu in Kconfig
      doc: mmiotrace.txt, buffer size control change


 Documentation/tracers/mmiotrace.txt |    6 ++----
 arch/x86/Kconfig.debug              |   24 ++----------------------
 kernel/trace/Kconfig                |   23 +++++++++++++++++++++++
 kernel/trace/trace_mmiotrace.c      |   14 ++++++++++----
 4 files changed, 37 insertions(+), 30 deletions(-)

diff --git a/Documentation/tracers/mmiotrace.txt b/Documentation/tracers/mmiotrace.txt
index cde23b4..5731c67 100644
--- a/Documentation/tracers/mmiotrace.txt
+++ b/Documentation/tracers/mmiotrace.txt
@@ -78,12 +78,10 @@ to view your kernel log and look for "mmiotrace has lost events" warning. If
 events were lost, the trace is incomplete. You should enlarge the buffers and
 try again. Buffers are enlarged by first seeing how large the current buffers
 are:
-$ cat /debug/tracing/trace_entries
+$ cat /debug/tracing/buffer_size_kb
 gives you a number. Approximately double this number and write it back, for
 instance:
-$ echo 0 > /debug/tracing/tracing_enabled
-$ echo 128000 > /debug/tracing/trace_entries
-$ echo 1 > /debug/tracing/tracing_enabled
+$ echo 128000 > /debug/tracing/buffer_size_kb
 Then start again from the top.
 
 If you are doing a trace for a driver project, e.g. Nouveau, you should also
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 10d6cc3..e1983fa 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -174,28 +174,8 @@ config IOMMU_LEAK
 	  Add a simple leak tracer to the IOMMU code. This is useful when you
 	  are debugging a buggy device driver that leaks IOMMU mappings.
 
-config MMIOTRACE
-	bool "Memory mapped IO tracing"
-	depends on DEBUG_KERNEL && PCI
-	select TRACING
-	help
-	  Mmiotrace traces Memory Mapped I/O access and is meant for
-	  debugging and reverse engineering. It is called from the ioremap
-	  implementation and works via page faults. Tracing is disabled by
-	  default and can be enabled at run-time.
-
-	  See Documentation/tracers/mmiotrace.txt.
-	  If you are not helping to develop drivers, say N.
-
-config MMIOTRACE_TEST
-	tristate "Test module for mmiotrace"
-	depends on MMIOTRACE && m
-	help
-	  This is a dumb module for testing mmiotrace. It is very dangerous
-	  as it will write garbage to IO memory starting at a given address.
-	  However, it should be safe to use on e.g. unused portion of VRAM.
-
-	  Say N, unless you absolutely know what you are doing.
+config HAVE_MMIOTRACE_SUPPORT
+	def_bool y
 
 #
 # IO delay types:
diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index e2a4ff6..58a93fb 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -302,4 +302,27 @@ config FTRACE_STARTUP_TEST
 	  functioning properly. It will do tests on all the configured
 	  tracers of ftrace.
 
+config MMIOTRACE
+	bool "Memory mapped IO tracing"
+	depends on HAVE_MMIOTRACE_SUPPORT && DEBUG_KERNEL && PCI
+	select TRACING
+	help
+	  Mmiotrace traces Memory Mapped I/O access and is meant for
+	  debugging and reverse engineering. It is called from the ioremap
+	  implementation and works via page faults. Tracing is disabled by
+	  default and can be enabled at run-time.
+
+	  See Documentation/tracers/mmiotrace.txt.
+	  If you are not helping to develop drivers, say N.
+
+config MMIOTRACE_TEST
+	tristate "Test module for mmiotrace"
+	depends on MMIOTRACE && m
+	help
+	  This is a dumb module for testing mmiotrace. It is very dangerous
+	  as it will write garbage to IO memory starting at a given address.
+	  However, it should be safe to use on e.g. unused portion of VRAM.
+
+	  Say N, unless you absolutely know what you are doing.
+
 endmenu
diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index fffcb06..80e503e 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -9,6 +9,7 @@
 #include <linux/kernel.h>
 #include <linux/mmiotrace.h>
 #include <linux/pci.h>
+#include <asm/atomic.h>
 
 #include "trace.h"
 
@@ -19,6 +20,7 @@ struct header_iter {
 static struct trace_array *mmio_trace_array;
 static bool overrun_detected;
 static unsigned long prev_overruns;
+static atomic_t dropped_count;
 
 static void mmio_reset_data(struct trace_array *tr)
 {
@@ -121,11 +123,11 @@ static void mmio_close(struct trace_iterator *iter)
 
 static unsigned long count_overruns(struct trace_iterator *iter)
 {
-	unsigned long cnt = 0;
+	unsigned long cnt = atomic_xchg(&dropped_count, 0);
 	unsigned long over = ring_buffer_overruns(iter->tr->buffer);
 
 	if (over > prev_overruns)
-		cnt = over - prev_overruns;
+		cnt += over - prev_overruns;
 	prev_overruns = over;
 	return cnt;
 }
@@ -310,8 +312,10 @@ static void __trace_mmiotrace_rw(struct trace_array *tr,
 
 	event	= ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
 					   &irq_flags);
-	if (!event)
+	if (!event) {
+		atomic_inc(&dropped_count);
 		return;
+	}
 	entry	= ring_buffer_event_data(event);
 	tracing_generic_entry_update(&entry->ent, 0, preempt_count());
 	entry->ent.type			= TRACE_MMIO_RW;
@@ -338,8 +342,10 @@ static void __trace_mmiotrace_map(struct trace_array *tr,
 
 	event	= ring_buffer_lock_reserve(tr->buffer, sizeof(*entry),
 					   &irq_flags);
-	if (!event)
+	if (!event) {
+		atomic_inc(&dropped_count);
 		return;
+	}
 	entry	= ring_buffer_event_data(event);
 	tracing_generic_entry_update(&entry->ent, 0, preempt_count());
 	entry->ent.type			= TRACE_MMIO_MAP;
