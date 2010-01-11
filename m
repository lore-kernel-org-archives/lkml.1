Return-Path: <linux-kernel-owner+w=401wt.eu-S1753494Ab0AKM0W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab0AKM0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 07:26:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753378Ab0AKM0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 07:26:17 -0500
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:55439 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753377Ab0AKM0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 07:26:13 -0500
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Mark Wielaard <mjw@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Date: Mon, 11 Jan 2010 17:56:08 +0530
Message-Id: <20100111122608.22050.94088.sendpatchset@srikar.in.ibm.com>
In-Reply-To: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
Subject: [RFC] [PATCH 7/7] Ftrace plugin for Uprobes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch implements ftrace plugin for uprobes.

Description:
Ftrace plugin provides an interface to dump data at a given address, top of
the stack and function arguments when a user program calls a specific
function.

To dump the data at a given address issue
echo up <pid> <address to probe> D <data address> <size> >>/sys/kernel/tracing/uprobes_events

To dump the data from top of stack issue
echo up <pid> <address to probe> S <size> >>/sys/kernel/tracing/uprobes_events

To dump the function arguments issue
echo up <pid> <address to probe> A <num-args> >>/sys/kernel/tracing/uprobes_events

D       => Dump the data at a given address.
S       => Dump the data from top of stack.
A       => Dump probed function arguments. Supported only for x86_64 arch.

For example:
Input:
$ cd /sys/kernel/debug/tracing/
$ echo "up 6424 0x4004d8 S 100" > uprobe_events
$ echo "up 6424 0x4004d8 D 0x7fff6bf587d0 35" >> uprobe_events
$ echo "up 6424 0x4004d8 A 5" >> uprobe_events
$
$ cat uprobe_events
up 6424 0x4004d8 S 100
up 6424 0x4004d8 D 7fff6bf587d0 35
up 6424 0x4004d8 A 5
$
$ echo 1 > tracing_on


Output:

$ cat trace
! tracer: nop
!
!           TASK-PID    CPU#    TIMESTAMP  FUNCTION
!              | |       |          |         |
           <...>-6424  [004]  1156.853343: : 0x4004d8: S 0x7fff6bf587a8: 31 06 40 00 00 00 00 00  1.@.....
           <...>-6424  [004]  1156.853348: : 0x4004d8: S 0x7fff6bf587b0: 00 00 00 00 00 00 00 00  ........
           <...>-6424  [004]  1156.853350: : 0x4004d8: S 0x7fff6bf587b8: c0 bb c1 4a 3b 00 00 00  ...J;...
           <...>-6424  [004]  1156.853352: : 0x4004d8: S 0x7fff6bf587c0: 50 06 40 00 c8 00 00 00  P.@.....
           <...>-6424  [004]  1156.853353: : 0x4004d8: S 0x7fff6bf587c8: ed 00 00 ff 00 00 00 00  ........
           <...>-6424  [004]  1156.853355: : 0x4004d8: S 0x7fff6bf587d0: 54 68 69 73 20 73 74 72  This str
           <...>-6424  [004]  1156.853357: : 0x4004d8: S 0x7fff6bf587d8: 69 6e 67 20 69 73 20 6f  ing is o
           <...>-6424  [004]  1156.853359: : 0x4004d8: S 0x7fff6bf587e0: 6e 20 74 68 65 20 73 74  n the st
           <...>-6424  [004]  1156.853361: : 0x4004d8: S 0x7fff6bf587e8: 61 63 6b 20 69 6e 20 6d  ack in m
           <...>-6424  [004]  1156.853363: : 0x4004d8: S 0x7fff6bf587f0: 61 69 6e 00 00 00 00 00  ain.....
           <...>-6424  [004]  1156.853364: : 0x4004d8: S 0x7fff6bf587f8: 00 00 00 00 04 00 00 00  ........
           <...>-6424  [004]  1156.853366: : 0x4004d8: S 0x7fff6bf58800: ff ff ff ff ff ff ff ff  ........
           <...>-6424  [004]  1156.853367: : 0x4004d8: S 0x7fff6bf58808: 00 00 00 00              ....
           <...>-6424  [004]  1156.853388: : 0x4004d8: D 0x7fff6bf587d0: 54 68 69 73 20 73 74 72  This str
           <...>-6424  [004]  1156.853389: : 0x4004d8: D 0x7fff6bf587d8: 69 6e 67 20 69 73 20 6f  ing is o
           <...>-6424  [004]  1156.853391: : 0x4004d8: D 0x7fff6bf587e0: 6e 20 74 68 65 20 73 74  n the st
           <...>-6424  [004]  1156.853393: : 0x4004d8: D 0x7fff6bf587e8: 61 63 6b 20 69 6e 20 6d  ack in m
           <...>-6424  [004]  1156.853394: : 0x4004d8: D 0x7fff6bf587f0: 61 69 6e                 ain
           <...>-6424  [004]  1156.853398: : 0x4004d8: A ARG 1: 0000000000000004
           <...>-6424  [004]  1156.853399: : 0x4004d8: A ARG 2: 00000000000000c8
           <...>-6424  [004]  1156.853400: : 0x4004d8: A ARG 3: 00000000ff0000ed
           <...>-6424  [004]  1156.853401: : 0x4004d8: A ARG 4: ffffffffffffffff
           <...>-6424  [004]  1156.853402: : 0x4004d8: A ARG 5: 0000000000000048

TODO:
- use ringbuffer
- Allow user to specify Nick Name for probe addresses.
- Dump arguments from floating point registers.
- Optimize code to use single probe instead of multiple probes for same probe
  addresses.

--
Signed-off-by: Mahesh Salgaonkar <mahesh@linux.vnet.ibm.com>
Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---
 Documentation/trace/uprobes_trace.txt |  197 ++++++++++++
 kernel/trace/Makefile                 |    1 +
 kernel/trace/trace_uprobes.c          |  537 +++++++++++++++++++++++++++++++++
 3 files changed, 735 insertions(+), 0 deletions(-)

diff --git a/Documentation/trace/uprobes_trace.txt b/Documentation/trace/uprobes_trace.txt
new file mode 100644
index 0000000..3c4482b
--- /dev/null
+++ b/Documentation/trace/uprobes_trace.txt
@@ -0,0 +1,197 @@
+			Uprobes based Event Tracer
+			==========================
+
+			   Mahesh J Salgaonkar
+
+Overview
+--------
+This tracer, based on uprobes, enables a user to put a probe anywhere in the
+user process and dump values from user specified data address or from the top
+of the stack frame when the probe is hit.
+
+For 64-bit processes on x86_64, the tracer can also report function arguments
+when the probe is hit. Currently, this feature is not supported for 32-bit
+processes.
+
+To activate this tracer just set a probe via
+/sys/kernel/debug/tracing/uprobe_events and traced information can be seen via
+/sys/kernel/debug/tracing/trace.
+
+User can specify probes for multiple processes concurrently.
+
+Synopsis
+--------
+up <pid> <address-to-probe> <type> [<data-address>] {<size>|<numargs>}
+
+up			: set a user probe
+<pid>			: Process ID.
+<address-to-probe>	: Instruction address to probe in user process.
+<type>			: Type of data to dump.
+			  D	=> Dump the data from specified data address
+			  S	=> Dump the data from top of the stack
+			  A	=> Dump the function arguments (x86_64 only).
+[<data-address>]	: Data address. Applicable only for type 'D'
+<size>			: Number of bytes of data to dump.
+<numargs>		: Number of arguments to dump.
+
+To dump the data at a given address when probe is hit, run:
+echo up <pid> <address to probe> D <data address> <size> >>/sys/kernel/tracing/uprobes_events
+
+To dump the data from top of stack when probe is hit, run:
+echo up <pid> <address to probe> S <size> >>/sys/kernel/tracing/uprobes_events
+
+To extract the function arguments when probe is hit, run:
+echo up <pid> <address to probe> A <numargs> >>/sys/kernel/tracing/uprobes_events
+
+Usage Examples
+--------------
+Let us consider following sample C program:
+
+/* SAMPLE C PROGRAM */
+#include <stdio.h>
+#include <stdlib.h>
+
+char *global_str_p = "Global String pointer";
+char global_str[] = "Global String";
+
+int foo(int a, unsigned int b, unsigned long c, long d, char e)
+{
+	return 0;
+}
+
+int main()
+{
+	char str[] = "This string is on the stack in main";
+	int a = 4;
+	unsigned int b = 200;
+	unsigned long c = 0xff0000ed;
+	long d = -1;
+	char e = 'H';
+
+	while (getchar() != EOF)
+		foo(a, b,c,d,e );
+
+	return 0;
+}
+/* SAMPLE C PROGRAM */
+
+This example puts a probe at function foo() and dumps some data values, the
+top of the stack and all five arguments passed to function foo().
+
+The probe address for function foo can be acquired using the 'nm' utility on
+the executable file as below:
+
+	$ gcc sample.c -o sample
+	$ nm sample | grep foo
+	0000000000400498 T foo
+
+We will also dump the data from the global variables 'global_str_p' and
+'global_str'. The DATA addresses for these variable can be acquired as below:
+
+	$ nm sample | grep global
+	0000000000600960 D global_str
+	0000000000600958 D global_str_p
+
+When setting the probe, you need to specify the process id of the user process
+to trace.  The process id can be determined by using the 'ps' command.
+
+	$ ps -a | grep sample
+	3906 pts/6    00:00:00 sample
+
+Now set a probe at function foo() as a new event that dumps 100 bytes from the
+stack as shown below:
+
+$ echo "up 3906 0x0000000000400498 S 100" > /sys/kernel/tracing/uprobes_events
+
+Set additional probes at function foo() to dump the data from the global
+variables as shown below:
+
+$ echo "up 3906 0x0000000000400498 D 0000000000600960 15" >> /sys/kernel/tracing/uprobes_events
+$ echo "up 3906 0x0000000000400498 D 0000000000600958 8" >> /sys/kernel/tracing/uprobes_events
+
+Set another probe at function foo() to dump all five arguments passed to
+function foo(). (This option is only valid for x86_64 architecture.)
+
+$ echo "up 3906 0x0000000000400498 A 5" >> /sys/kernel/tracing/uprobes_events
+
+To see all the current uprobe events:
+
+$ cat /sys/kernel/debug/tracing/uprobe_events
+up 3906 0x400498 S 100
+up 3906 0x400498 D 0x600960 15
+up 3906 0x400498 D 0x600958 8
+up 3906 0x400498 A 5
+
+When the function foo() gets called all the above probes will hit and you can
+see the traced information via /sys/kernel/debug/tracing/trace
+
+$ cat /sys/kernel/debug/tracing/trace
+# tracer: nop
+#
+#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
+#              | |       |          |         |
+           <...>-3906  [001]   391.531431: : 0x400498: S 0x7fffd934eba8: 38 05 40 00 00 00 00 00  8.@.....
+           <...>-3906  [001]   391.531436: : 0x400498: S 0x7fffd934ebb0: 54 68 69 73 20 73 74 72  This str
+           <...>-3906  [001]   391.531438: : 0x400498: S 0x7fffd934ebb8: 69 6e 67 20 69 73 20 6f  ing is o
+           <...>-3906  [001]   391.531439: : 0x400498: S 0x7fffd934ebc0: 6e 20 74 68 65 20 73 74  n the st
+           <...>-3906  [001]   391.531441: : 0x400498: S 0x7fffd934ebc8: 61 63 6b 20 69 6e 20 6d  ack in m
+           <...>-3906  [001]   391.531443: : 0x400498: S 0x7fffd934ebd0: 61 69 6e 00 00 00 00 01  ain.....
+           <...>-3906  [001]   391.531445: : 0x400498: S 0x7fffd934ebd8: c0 bb c1 4a 3b 00 00 00  ...J;...
+           <...>-3906  [001]   391.531446: : 0x400498: S 0x7fffd934ebe0: 04 00 00 00 c8 00 00 00  ........
+           <...>-3906  [001]   391.531448: : 0x400498: S 0x7fffd934ebe8: ed 00 00 ff 00 00 00 00  ........
+           <...>-3906  [001]   391.531450: : 0x400498: S 0x7fffd934ebf0: ff ff ff ff ff ff ff ff  ........
+           <...>-3906  [001]   391.531452: : 0x400498: S 0x7fffd934ebf8: 00 00 00 00 00 00 00 48  .......H
+           <...>-3906  [001]   391.531453: : 0x400498: S 0x7fffd934ec00: 00 00 00 00 00 00 00 00  ........
+           <...>-3906  [001]   391.531455: : 0x400498: S 0x7fffd934ec08: 74 d9 e1 4a              t..J
+           <...>-3906  [001]   391.531489: : 0x400498: D 0x600960: 47 6c 6f 62 61 6c 20 53  Global S
+           <...>-3906  [001]   391.531491: : 0x400498: D 0x600968: 74 72 69 6e 67 00 00     tring..
+           <...>-3906  [001]   391.531500: : 0x400498: D 0x600958: 48 06 40 00 00 00 00 00  H.@.....
+           <...>-3906  [001]   391.531504: : 0x400498: A ARG 1: 0000000000000004
+           <...>-3906  [001]   391.531505: : 0x400498: A ARG 2: 00000000000000c8
+           <...>-3906  [001]   391.531505: : 0x400498: A ARG 3: 00000000ff0000ed
+           <...>-3906  [001]   391.531506: : 0x400498: A ARG 4: ffffffffffffffff
+           <...>-3906  [001]   391.531507: : 0x400498: A ARG 5: 0000000000000048
+
+Under the FUNCTION column, each line shows the probe address, type, data/stack
+address, and 8 bytes of data in hex followed by the ascii representation of the
+hex values. If the size specified is more that 8 bytes then multiple lines
+will be used to dump data values. In case of type A one argument is shown per
+line.
+
+The lines with type 'S' from tracer output display 100 bytes (8 bytes per
+line) from the top of the stack when the probed function foo() is hit. The lines
+with type 'A' dump all the five arguments passed to the function foo(). The
+first two lines with type 'D' dump 15 bytes of data from the global variable
+'global_str' at data address 0x600960. The 3rd line with type 'D' dumps 8 byte
+of data from the global string pointer variable 'global_str_p' at 0x600958.
+The output shows that it holds the address 0x0000000000400648. As per the
+sample program this should point to a const string of 21 characters. Let's
+dump the data values at this address.
+
+echo "up 3906 0x0000000000400498 D 0x0000000000400648 24" > /sys/kernel/tracing/uprobes_events
+
+Please note that we have not used '>>' operator here; as a result, all
+existing probes will be cleared before this new probe is set.
+
+Take look at the tracer output.
+
+$ cat /sys/kernel/debug/tracing/trace
+# tracer: nop
+#
+#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
+#              | |       |          |         |
+           <...>-3906  [001]   442.537669: : 0x400498: D 0x400648: 47 6c 6f 62 61 6c 20 53  Global S
+           <...>-3906  [001]   442.537674: : 0x400498: D 0x400650: 74 72 69 6e 67 20 70 6f  tring po
+           <...>-3906  [001]   442.537676: : 0x400498: D 0x400658: 69 6e 74 65 72 00 00 00  inter...
+
+
+To clear all the probe events, run:
+
+echo > /sys/kernel/tracing/uprobes_events
+
+TODO:
+- Allow user to attach a name to probe addresses for address translation.
+- Support reporting of arguments from 32-bit applications.
+- Dump arguments from floating point registers.
+- Optimize code to use single probe instead of multiple probes for same probe
+  addresses.
diff --git a/kernel/trace/Makefile b/kernel/trace/Makefile
index 26f03ac..623541f 100644
--- a/kernel/trace/Makefile
+++ b/kernel/trace/Makefile
@@ -54,5 +54,6 @@ obj-$(CONFIG_FTRACE_SYSCALLS) += trace_syscalls.o
 obj-$(CONFIG_EVENT_PROFILE) += trace_event_profile.o
 obj-$(CONFIG_EVENT_TRACING) += trace_events_filter.o
 obj-$(CONFIG_EVENT_TRACING) += power-traces.o
+obj-$(CONFIG_UPROBES) += trace_uprobes.o

 libftrace-y := ftrace.o
diff --git a/kernel/trace/trace_uprobes.c b/kernel/trace/trace_uprobes.c
new file mode 100644
index 0000000..c6e3f90
--- /dev/null
+++ b/kernel/trace/trace_uprobes.c
@@ -0,0 +1,537 @@
+/*
+ *  Ftrace plugin for Userspace Probes (UProbes)
+ *  kernel/trace/trace_uprobes.c
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) IBM Corporation, 2009
+ */
+#include <linux/uaccess.h>
+#include <linux/debugfs.h>
+#include <linux/types.h>
+#include <linux/ctype.h>
+#include <linux/mm.h>
+#include <linux/seq_file.h>
+#include <linux/slab.h>
+#include <linux/regset.h>
+#include <linux/pid.h>
+#include <linux/uprobes.h>
+
+#include "trace.h"
+
+struct trace_uprobe {
+	struct list_head 	list;
+	struct uprobe 		usp;
+	unsigned long 		daddr;
+	size_t	 		length;
+
+#ifdef __x86_64__
+#define TYPE_ARG	'A'
+#endif
+#define TYPE_DATA	'D'
+#define TYPE_STACK	'S'
+	char 			type;
+};
+
+static DEFINE_MUTEX(trace_uprobe_lock);
+static LIST_HEAD(tu_list);
+
+#define NUMVALUES	8	/* Number of data values to print per line*/
+
+/* NUMVALUES*2 for hex values + NUMVALUES for spaces + 1 */
+#define HEXBUFSIZE	((NUMVALUES * 2) + NUMVALUES + 1)
+
+#define CHARBUFSIZE	NUMVALUES	/* NUMVALUES characters */
+#define BUFSIZE		(HEXBUFSIZE + CHARBUFSIZE)
+
+/*
+ * uprobe handler to dump data values and the top of the
+ * stack frame through tracer.
+ *
+ * The output is pushed to tracer in following format:
+ *
+ * <probe-address>: <type> <data/stack-address>: <data o/p>
+ *
+ * The <data o/p> is divided into two parts - the hex area and
+ * the char area. The hex area contains hex data values.
+ * The number of hex data values contained are controlled
+ * by NUMVALUES. The char area is the ascii representation
+ * of hex data values.
+ *
+ *      |<---------- BUFSIZE + 1------------>|
+ *
+ *      +-----------------+---------------+--+
+ * obuf | HEX Area        | CHAR Area     |\0|
+ *      +-----------------+---------------+--+
+ *      ^                 ^               ^
+ *      |<--HEXBUFSIZE -->|<-CHARBUFSIZE->|
+ *
+
+ *
+ *   0x400498: S 0x7fffd934eba8: c8 00 00 00 ed 00 00 ff  ........
+ *   0x400498: S 0x7fffd934ebb0: 54 68 69 73 20 73 74 72  This str
+ */
+
+static void uprobe_handler(struct uprobe *u, struct pt_regs *regs)
+{
+	struct trace_uprobe *tu;
+	char *buf;
+	unsigned long ip = instruction_pointer(regs), daddr;
+	int len;
+	char obuf[BUFSIZE + 1];
+
+	tu = container_of(u, struct trace_uprobe, usp);
+	buf = kzalloc(tu->length + 1, GFP_KERNEL);
+	if (!buf)
+		return;
+
+	if (tu->type == TYPE_STACK) {
+		/* Get Stack Pointer. Dump stack memory */
+		daddr = (unsigned long)user_stack_pointer(regs);
+	} else
+		daddr = tu->daddr;
+
+	len = tu->length;
+	if (!copy_from_user(buf, (void *)daddr, tu->length)) {
+		int pos = 0;
+
+		for (pos = 0; pos < len; pos += NUMVALUES) {
+			char *hp = obuf; /* Hex area buf pointer */
+			char *cp = hp + HEXBUFSIZE; /* char area buf pointer */
+			int i = 0, last;
+
+			memset(obuf, ' ', BUFSIZE);
+			obuf[BUFSIZE] = '\0';
+
+			last = pos + (NUMVALUES - 1);
+			if (last >= len)
+				last = len - 1;
+
+			for (i = pos; i <= last; i++) {
+				sprintf(hp, "%02x", (unsigned char)buf[i]);
+
+				/*
+				 * Character representation..
+				 * ignore non-printable chars
+				 */
+				if ((buf[i] >= ' ') && (buf[i] <= '~'))
+					*cp = buf[i];
+				else
+					*cp = '.';
+
+				hp += 2;
+				*hp++ = ' ';
+				cp++;
+			}
+
+			__trace_bprintk(ip, "0x%lx: %c 0x%lx: %s\n",
+					tu->usp.vaddr, tu->type,
+					(daddr + pos), obuf);
+		}
+	} else {
+		__trace_bprintk(ip, "0x%lx: %c 0x%lx: "
+			"Data capture failed. Invalid address\n",
+			tu->usp.vaddr, tu->type, daddr);
+	}
+	kfree(buf);
+}
+
+#ifdef __x86_64__
+
+/*
+ * uprobe handler to dump function arguments through tracer.
+ * Currently, supported for x86_64 architecture.
+ * Argument extraction as per x86_64 ABI (Application Binary
+ * Interface) document Version 0.99.
+ *
+ * The output is pushed to tracer in following format:
+ *
+ * <probe-address>: A ARG #: <value>
+ *
+ * e.g.
+ * 	0x400498: A ARG 1: 0000000000000004
+ * 	0x400498: A ARG 2: 00000000000000c8
+ */
+static void uprobe_handler_args(struct uprobe *u, struct pt_regs *regs)
+{
+	struct trace_uprobe *tu;
+	unsigned long ip = instruction_pointer(regs);
+	unsigned long args[6];
+	int i;
+
+	tu = container_of(u, struct trace_uprobe, usp);
+
+	/* Function arguments */
+	args[0] = regs->di;
+	args[1] = regs->si;
+	args[2] = regs->dx;
+	args[3] = regs->cx;
+	args[4] = regs->r8;
+	args[5] = regs->r9;
+
+	for (i = 0; i < tu->length; i++) {
+		__trace_bprintk(ip, "0x%lx: %c ARG %d: %016lx\n",
+			u->vaddr, tu->type, i + 1, args[i]);
+	}
+}
+#endif
+
+/*
+ * Updates the size/numargs of existing probe event if found.
+ */
+static struct trace_uprobe *update_trace_probe(pid_t pid,
+		unsigned long taddr, unsigned long daddr, size_t length,
+		char type)
+{
+	struct trace_uprobe *tu, *tmp;
+
+	mutex_lock(&trace_uprobe_lock);
+	list_for_each_entry_safe(tu, tmp, &tu_list, list) {
+		if ((tu->usp.pid == pid) && (tu->usp.vaddr == taddr)
+			&& (tu->type == type) && (tu->daddr == daddr)) {
+			tu->length = length;
+			mutex_unlock(&trace_uprobe_lock);
+			return tu;
+		}
+	}
+	mutex_unlock(&trace_uprobe_lock);
+	return NULL;
+}
+
+/*
+ * Creates a new probe event entry and sets the user probe by calling
+ * register_uprobe()
+ */
+static int trace_register_uprobe(pid_t pid, unsigned long taddr,
+		unsigned long daddr, size_t length, char type)
+{
+	struct trace_uprobe *tu;
+	int ret = 0;
+
+	/* Check for duplication. If probe for same data address
+	 * already exists then just update the length.
+	 */
+	tu = update_trace_probe(pid, taddr, daddr, length, type);
+	if (tu)
+		return 0;
+
+	/* This is a new probe. */
+	tu = kzalloc(sizeof(struct trace_uprobe), GFP_KERNEL);
+	if (!tu)
+		return -ENOMEM;
+
+	INIT_LIST_HEAD(&tu->list);
+	tu->length = length;
+	tu->daddr = daddr;
+	tu->type = type;
+	tu->usp.pid = pid;
+	tu->usp.vaddr = taddr;
+#ifdef __x86_64__
+	tu->usp.handler = (tu->type == TYPE_ARG) ?
+			 uprobe_handler_args : uprobe_handler;
+#else
+	tu->usp.handler = uprobe_handler;
+#endif
+	ret = register_uprobe(&tu->usp);
+
+	if (ret) {
+		pr_err("register_uprobe(pid=%d vaddr=%lx) = ret(%d) failed\n",
+			pid, taddr, ret);
+		kfree(tu);
+		return ret;
+	}
+	mutex_lock(&trace_uprobe_lock);
+	list_add_tail(&tu->list, &tu_list);
+	mutex_unlock(&trace_uprobe_lock);
+	return 0;
+}
+
+static void uprobes_clear_all_events(void)
+{
+	struct trace_uprobe *tu, *tmp;
+
+	mutex_lock(&trace_uprobe_lock);
+	list_for_each_entry_safe(tu, tmp, &tu_list, list) {
+		unregister_uprobe(&tu->usp);
+		list_del(&tu->list);
+		kfree(tu);
+	}
+	mutex_unlock(&trace_uprobe_lock);
+}
+
+/* User probes listing interfaces */
+static void *uprobes_seq_start(struct seq_file *m, loff_t *pos)
+{
+	mutex_lock(&trace_uprobe_lock);
+	return seq_list_start(&tu_list, *pos);
+}
+
+static void *uprobes_seq_next(struct seq_file *m, void *v, loff_t *pos)
+{
+	return seq_list_next(v, &tu_list, pos);
+}
+
+static void uprobes_seq_stop(struct seq_file *m, void *v)
+{
+	mutex_unlock(&trace_uprobe_lock);
+}
+
+static int uprobes_seq_show(struct seq_file *m, void *v)
+{
+	struct trace_uprobe *tu = v;
+
+	if (tu == NULL)
+		return 0;
+
+	if (tu->type == TYPE_DATA)
+		seq_printf(m, "%-3s%d 0x%lx D 0x%lx %zu\n",
+		      "up", tu->usp.pid, tu->usp.vaddr, tu->daddr, tu->length);
+	else
+		seq_printf(m, "%-3s%d 0x%lx %c %zu\n",
+		      "up", tu->usp.pid, tu->usp.vaddr, tu->type, tu->length);
+
+	return 0;
+}
+
+static const struct seq_operations uprobes_seq_ops = {
+	.start	= uprobes_seq_start,
+	.next	= uprobes_seq_next,
+	.stop	= uprobes_seq_stop,
+	.show	= uprobes_seq_show
+};
+
+static int uprobe_events_open(struct inode *inode, struct file *file)
+{
+	if ((file->f_mode & FMODE_WRITE) &&
+	    !(file->f_flags & O_APPEND))
+		uprobes_clear_all_events();
+
+	return seq_open(file, &uprobes_seq_ops);
+}
+
+#ifdef __x86_64__
+static int process_check_64bit(pid_t p)
+{
+	struct pid *pid = NULL;
+	struct task_struct *tsk;
+	int ret = -ESRCH;
+
+	rcu_read_lock();
+	if (current->nsproxy)
+		pid = find_vpid(p);
+
+	if (pid) {
+		tsk = pid_task(pid, PIDTYPE_PID);
+
+		if (tsk) {
+			if (test_tsk_thread_flag(tsk, TIF_IA32)) {
+				pr_err("Option to dump arguments is"
+					"not supported for 32bit process\n");
+				ret = -EPERM;
+			} else
+				ret = 0;
+		}
+	}
+	rcu_read_unlock();
+	return ret;
+}
+#endif
+
+/*
+ * Input syntax:
+ * 	up <pid> <address-to-probe> <type> [<data-address>] <size>
+ */
+
+static int enable_uprobe_trace(int argc, char **argv)
+{
+	unsigned long taddr, daddr = 0, tmpval;
+	size_t dsize;
+	pid_t pid;
+	int ret = -EINVAL;
+	char  type;
+
+	if ((argc < 5) || (argc > 6))
+		return -EINVAL;
+
+	if (strcmp(argv[0], "up"))
+		return -EINVAL;
+
+	/* get the pid */
+	ret = strict_strtoul(argv[1], 10, &tmpval);
+	if (ret)
+		return ret;
+
+	pid = (pid_t) tmpval;
+
+	/* get the address to probe */
+	ret = strict_strtoul(argv[2], 16, &taddr);
+	if (ret)
+		return ret;
+
+	/* See if user asked for Stack or Data address. */
+	if ((strlen(argv[3]) != 1) || (!isalpha(*argv[3])))
+		return -EINVAL;
+
+	switch (*argv[3]) {
+#ifdef __x86_64__
+	/*
+	 * dumping of arguments supported only for x86_64 arch
+	 */
+	case 'A':
+	case 'a':
+			type = TYPE_ARG;
+			if (argc > 5)
+				return -EINVAL;
+			/* Option 'A' is not supported for 32 bit process. */
+			ret = process_check_64bit(pid);
+			if (ret)
+				return ret;
+
+			daddr = 0;
+			break;
+#endif
+	case 'D':
+	case 'd':
+			type = TYPE_DATA;
+			if (argc < 6)
+				return -EINVAL;
+			/* get the data address */
+			ret = strict_strtoul(argv[4], 16, &daddr);
+			if (ret)
+				return ret;
+			break;
+	case 'S':
+	case 's':
+			type = TYPE_STACK;
+			if (argc > 5)
+				return -EINVAL;
+			daddr = 0;
+			break;
+	default:
+		return -EINVAL;
+	}
+
+	/*
+	 * In case of TYPE_DATA and TYPE_STACK: get the size of data to dump.
+	 * In case of TYPE_ARG: this is the number of arguments to dump
+	 */
+	ret = strict_strtoul(((type == TYPE_DATA) ?
+				argv[5] : argv[4]), 10, &tmpval);
+	if (ret)
+		return ret;
+
+	dsize = (size_t) tmpval;
+
+#ifdef __x86_64__
+	/* Only upto 6 args supported */
+	if ((type == TYPE_ARG) && (dsize > 6)) {
+		pr_err("Can not dump more than 6 arguments\n");
+		return -EINVAL;
+	}
+#endif
+
+	ret = trace_register_uprobe(pid, taddr, daddr, dsize, type);
+	return ret;
+}
+
+/*
+ * Process commands written to /sys/kernel/debug/tracing/uprobe_events.
+ * Supports multiple lines. It reads the entire ubuf into local buffer
+ * and then breaks the input into lines. Invokes enable_uprobe_trace()
+ * for each line after splitting them into args array.
+ */
+
+static ssize_t
+uprobe_events_write(struct file *file, const char __user *ubuf,
+			size_t count, loff_t *ppos)
+{
+	char *kbuf, *start, *end = NULL, *tmp;
+	char **argv = NULL;
+	int argc = 0;
+	int ret = 0;
+	size_t done = 0;
+	size_t size;
+
+	if (!count)
+		return 0;
+
+	kbuf = kmalloc(count + 1, GFP_KERNEL);
+	if (!kbuf)
+		return -ENOMEM;
+
+	if (copy_from_user(kbuf, ubuf, count)) {
+		ret = -EFAULT;
+		goto err_out;
+	}
+
+	kbuf[count] = '\0';
+	for (start = kbuf; done < count; start = end + 1) {
+		end = strchr(start, '\n');
+		if (!end) {
+			pr_err("Line length is too long");
+			ret = -EINVAL;
+			goto err_out;
+		}
+		*end = '\0';
+		size = end - start + 1;
+		done += size;
+		/* Remove comments */
+		tmp = strchr(start, '#');
+		if (tmp)
+			*tmp = '\0';
+
+		argv = argv_split(GFP_KERNEL, start, &argc);
+		if (!argv) {
+			ret = -ENOMEM;
+			goto err_out;
+		}
+
+		if (argc)
+			ret = enable_uprobe_trace(argc, argv);
+
+		argv_free(argv);
+		if (ret < 0)
+			goto err_out;
+	}
+	ret = done;
+err_out:
+	kfree(kbuf);
+	return ret;
+}
+
+static const struct file_operations uprobes_events_ops = {
+	.open		= uprobe_events_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+	.write		= uprobe_events_write,
+};
+
+static __init int init_uprobe_trace(void)
+{
+	struct dentry *d_tracer;
+	struct dentry *entry;
+
+	d_tracer = tracing_init_dentry();
+
+	entry = debugfs_create_file("uprobe_events", 0644, d_tracer,
+					NULL, &uprobes_events_ops);
+
+	if (!entry)
+		pr_warning("Could not create debugfs 'uprobe_events' entry\n");
+
+	return 0;
+}
+fs_initcall(init_uprobe_trace);
