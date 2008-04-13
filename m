Return-Path: <linux-kernel-owner+w=401wt.eu-S1757809AbYDMTz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757809AbYDMTz0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 15:55:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757065AbYDMTtX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 15:49:23 -0400
Received: from pne-smtpout4-sn1.fre.skanova.net ([81.228.11.168]:60404 "EHLO
	pne-smtpout4-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753775AbYDMTtT convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 15:49:19 -0400
Date: Sun, 13 Apr 2008 22:48:59 +0300
From: Pekka Paalanen <pq@iki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Paalanen <pq@iki.fi>, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, Pavel Roskin <proski@gnu.org>
Subject: [PATCH] mmiotrace: add user documentation
Message-ID: <20080413224859.4e3f5ddb@daedalus.pq.iki.fi>
In-Reply-To: <20080413224207.4430a09c@daedalus.pq.iki.fi>
References: <20080413224207.4430a09c@daedalus.pq.iki.fi>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.8; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 498b7856a5096797c76cefd15f27785bfc1392ce Mon Sep 17 00:00:00 2001
From: Pekka Paalanen <pq@iki.fi>
Date: Sat, 12 Apr 2008 23:38:12 +0300
Subject: [PATCH] mmiotrace: add user documentation

Signed-off-by: Pekka Paalanen <pq@iki.fi>
---
 Documentation/tracers/mmiotrace.txt |  153 +++++++++++++++++++++++++++++++++++
 arch/x86/Kconfig.debug              |    8 +-
 2 files changed, 156 insertions(+), 5 deletions(-)
 create mode 100644 Documentation/tracers/mmiotrace.txt

diff --git a/Documentation/tracers/mmiotrace.txt b/Documentation/tracers/mmiotrace.txt
new file mode 100644
index 0000000..84246f7
--- /dev/null
+++ b/Documentation/tracers/mmiotrace.txt
@@ -0,0 +1,153 @@
+		In-kernel memory-mapped I/O tracing
+
+
+Home page and links to optional user space tools:
+
+	http://nouveau.freedesktop.org/wiki/MmioTrace
+
+MMIO tracing was originally developed by Intel around 2003 for their Fault
+Injection Test Harness. In Dec 2006 - Jan 2007, using the code from Intel,
+Jeff Muizelaar created a tool for tracing MMIO accesses with the Nouveau
+project in mind. Since then many people have contributed.
+
+Mmiotrace was built for reverse engineering any memory-mapped IO device with
+the Nouveau project as the first real user. Only x86 and x86_64 architectures
+are supported.
+
+Out-of-tree mmiotrace was originally modified for mainline inclusion and
+ftrace framework by Pekka Paalanen <pq@iki.fi>.
+
+
+Preparation
+-----------
+
+Mmiotrace feature is compiled in by the CONFIG_MMIOTRACE option. Tracing is
+disabled by default, so it is safe to have this set to yes. SMP systems are
+supported, but tracing is unreliable and may miss events if more than one CPU
+is on-line, therefore mmiotrace takes all but one CPU off-line during run-time
+activation [not implemented].
+
+
+Usage Quick Reference
+---------------------
+
+$ mount -t debugfs debugfs /debug
+$ echo mmiotrace > /debug/tracing/current_tracer
+$ cat /debug/tracing/trace_pipe > mydump.txt &
+Start X or whatever.
+$ echo "X is up" > /debug/tracing/marker
+$ echo none > /debug/tracing/current_tracer
+Check kernel log.
+
+
+Usage
+-----
+
+Make sure debugfs is mounted to /debug. If not, (requires root privileges)
+$ mount -t debugfs debugfs /debug
+
+Check that the driver you are about to trace is not loaded.
+
+Activate mmiotrace (requires root privileges):
+$ echo mmiotrace > /debug/tracing/current_tracer
+
+Start storing the trace:
+$ cat /debug/tracing/trace_pipe > mydump.txt &
+The 'cat' process should stay running (sleeping) in the background.
+
+Load the driver you want to trace and use it. Mmiotrace will only catch MMIO
+accesses to areas that are ioremapped while mmiotrace is active.
+
+[Unimplemented feature:]
+During tracing you can place comments (markers) into the trace by
+$ echo "X is up" > /debug/tracing/marker
+This makes it easier to see which part of the (huge) trace corresponds to
+which action. It is recommended to place descriptive markers about what you
+do.
+
+Shut down mmiotrace (requires root privileges):
+$ echo none > /debug/tracing/current_tracer
+The 'cat' process exits. If it does not, kill it by 'fg' and pressing ctrl+c.
+
+[This feature is not implemented yet!]
+Check your kernel log. If there are messages about mmiotrace losing events,
+this is due to buffer overrun, and the trace is incomplete. You should enlarge
+the buffers and try again. [How?]
+
+If you are doing a trace for a driver project, e.g. Nouveau, you should also
+do the following before sending your results:
+$ lspci -vvv > lspci.txt
+$ dmesg > dmesg.txt
+$ tar zcf pciid-nick-mmiotrace.tar.gz mydump.txt lspci.txt dmesg.txt
+and then send the .tar.gz file. The trace compresses considerably. Replace
+"pciid" and "nick" with the PCI ID or model name of your piece of hardware
+under investigation and your nick name.
+
+
+How Mmiotrace Works
+-------------------
+
+Access to hardware IO-memory is gained by mapping addresses from PCI bus by
+calling one of the ioremap_*() functions. Mmiotrace is hooked into the
+__ioremap() function and gets called whenever a mapping is created. Mapping is
+an event that is recorded into the trace log. Note, that ISA range mappings
+are not caught, since the mapping always exists and is returned directly.
+
+MMIO accesses are recorded via page faults. Just before __ioremap() returns,
+the mapped pages are marked as not present. Any access to the pages causes a
+fault. The page fault handler calls mmiotrace to handle the fault. Mmiotrace
+marks the page present, sets TF flag to achieve single stepping and exits the
+fault handler. The instruction that faulted is executed and debug trap is
+entered. Here mmiotrace again marks the page as not present. The instruction
+is decoded to get the type of operation (read/write), data width and the value
+read or written. These are stored to the trace log.
+
+Setting the page present in the page fault handler has a race condition on SMP
+machines. During the single stepping other CPUs may run freely on that page
+and events can be missed without a notice. Re-enabling other CPUs during
+tracing is discouraged.
+
+
+Trace Log Format
+----------------
+
+The raw log is text and easily filtered with e.g. grep and awk. One record is
+one line in the log. A record starts with a keyword, followed by keyword
+dependant arguments. Arguments are separated by a space, or continue until the
+end of line. The format for version 20070824 is as follows:
+
+Explanation	Keyword	Space separated arguments
+---------------------------------------------------------------------------
+
+read event	R	width, timestamp, map id, physical, value, PC, PID
+write event	W	width, timestamp, map id, physical, value, PC, PID
+ioremap event	MAP	timestamp, map id, physical, virtual, length, PC, PID
+iounmap event	UNMAP	timestamp, map id, PC, PID
+marker		MARK	timestamp, text
+version		VERSION	the string "20070824"
+info for reader	LSPCI	one line from lspci -v
+PCI address map	PCIDEV	space separated /proc/bus/pci/devices data
+unk. opcode	UNKNOWN	timestamp, map id, physical, data, PC, PID
+
+Timestamp is in seconds with decimals. Physical is a PCI bus address, virtual
+is a kernel virtual address. Width is the data width in bytes and value is the
+data value. Map id is an arbitrary id number identifying the mapping that was
+used in an operation. PC is the program counter and PID is process id. PC is
+zero if it is not recorded. PID is always zero as tracing MMIO accesses
+originating in user space memory is not yet supported.
+
+For instance, the following awk filter will pass all 32-bit writes that target
+physical addresses in the range [0xfb73ce40, 0xfb800000[
+
+$ awk '/W 4 / { adr=strtonum($5); if (adr >= 0xfb73ce40 &&
+adr < 0xfb800000) print; }'
+
+
+Tools for Developers
+--------------------
+
+The user space tools include utilities for:
+- replacing numeric addresses and values with hardware register names
+- replaying MMIO logs, i.e., re-executing the recorded writes
+
+
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 53dfec6..f8ed677 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -193,12 +193,10 @@ config MMIOTRACE
 	help
 	  Mmiotrace traces Memory Mapped I/O access and is meant for
 	  debugging and reverse engineering. It is called from the ioremap
-	  implementation and works via page faults. A user space program is
-	  required to collect the MMIO data from debugfs files.
-	  Tracing is disabled by default and can be enabled from a debugfs
-	  file.
+	  implementation and works via page faults. Tracing is disabled by
+	  default and can be enabled run-time.
 
-	  See http://nouveau.freedesktop.org/wiki/MmioTrace
+	  See Documentation/tracers/mmiotrace.txt.
 	  If you are not helping to develop drivers, say N.
 
 config MMIOTRACE_TEST
-- 
1.5.3.7

