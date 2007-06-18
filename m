Return-Path: <linux-kernel-owner+w=401wt.eu-S1757284AbXFRE5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284AbXFRE5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2007 00:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755571AbXFRE5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jun 2007 00:57:30 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:56908 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755375AbXFRE52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2007 00:57:28 -0400
Message-ID: <46761081.9040503@us.ibm.com>
Date: Sun, 17 Jun 2007 21:56:33 -0700
From: David Wilder <dwilder@us.ibm.com>
User-Agent: Mozilla Thunderbird 1.0.7 (X11/20050923)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: systemtap@sources.redhat.com
Subject: [RFC] Generic Trace Setup and Control (GTSC) kernel API (1/3)
Content-Type: multipart/mixed;
 boundary="------------050302010105080400010903"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050302010105080400010903
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Generic Trace Setup and Control (GTSC) kernel API.

This patch and the patches to follow create a kernel API that simplifies
the use of the relay subsystem.  Any "relay" based tracing application has
a common set of operations that they must performed to setup and control its
relay channel(s).  Block trace is an example of such an application.

The goal of GTSC is to simply abstract out this generic code from block
trace and make it available for other services to use.  Doing so we can 
reduce
the code in block trace as well as build a common trace control interface.

I am submitting 3 patches for review.  The first is included in this email,
2 and 3 will follow in separate emails.

1/3  GTSC documentation patch.  (gtsc-documentation.patch)
2/3  The GTSC code itself. (gtsc.patch)
3/3  Patches to convert blktrace to the new GTSC API. 
(convert-blktrace-to-gtsc.patch, blktrace-gtsc-user.patch)

The documentation patch describes the API and includes a simple kernel 
module
that demonstrates the GTSC.

I will be sending one additional patch not directly related to the 
GTSC.  This
patch fixes a bug in the relay read interface.  I mention it here only 
because
to make the GTSC example work properly you will need to apply this 
patch.  This
patch is named relay-file-read-start-pos-fix.patch.


-- 
David Wilder
IBM Linux Technology Center
Beaverton, Oregon, USA 
dwilder@us.ibm.com
(503)578-3789


--------------050302010105080400010903
Content-Type: text/x-patch;
 name="gtsc-documentation.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="gtsc-documentation.patch"

This patch provides the documentation for the Generic Trace
Setup and Control (GTSC) API.  In the kernel, GTSC provides a simple
API for starting and managing data channels to user space.  GTSC
builds on the relay interface.   The GTSC itself is provided in a separate
patch.

Signed-off-by: David Wilder <dwilder@us.ibm.com>

 Documentation/gtsc.txt |  239 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 239 insertions(+), 0 deletions(-)

diff --git a/Documentation/gtsc.txt b/Documentation/gtsc.txt
new file mode 100644
index 0000000..5a3a1b5
--- /dev/null
+++ b/Documentation/gtsc.txt
@@ -0,0 +1,239 @@
+Generic Trace Setup and Control (GTSC)
+==================================
+In the kernel, GTSC provides a simple API for starting and managing
+data channels to user space.  GTSC builds on the relay interface. For a
+complete description of the relay interface, please see:
+Documentation/filesystems/relay.txt.
+
+GTSC provides one layer in a complete tracing application.  The idea of
+the GTSC is to provide a kernel API for the setup and control of tracing
+channels.  User of GTSC must provide a data layer responsible for formatting
+and writing data into the trace channels.  
+
+A layered approach to tracing
+=============================
+A complete kernel tracing application consists of a data provider and a data
+consumer.  Both provider and consumer contain three layers; each layer works
+in tandem with the corresponding layer in the opposite side.  The layers are
+represented in the following diagram.
+  
+Provider Data layer
+	Formats raw trace data and provides data-related service.
+	For example, adding timestamps used by consumer to sort data.
+
+Provider Control layer
+	Provided by GTSC. Creates trace channels and informs the data layer
+	and consumer of the current state of the trace channels.
+
+Provider Buffering layer
+	Provided by relay. This layer buffers data in the
+	kernel for consumption by the consumer's buffer
+	layer.
+
+Provider (in-kernel facility)
+-----------------------------------------------------------------------------
+Consumer (user application)
+
+
+Consumer Buffer layer
+	Reads/consumes data from the provider's data buffers.
+
+Consumer Control layer
+	Communicates to the provider's control layer to control the state
+	of the trace channels. 
+
+Consumer Data layer
+	Sorts and formats data as provided by the provider's data layer.
+
+The provider is coded as a kernel facility.  The consumer is coded as
+a user application.
+ 
+
+GTSC - Features
+==============
+The GTSC exploits services and features provided by relay.  These features are:
+- The creation and destruction of relay channels.
+- Buffer management.  Overwrite or non-overwrite modes can be selected
+  as well as global or per-CPU buffering.
+
+Overwrite mode can be called "flight recorder mode".  Flight recorder mode
+is selected by setting the GTSC_FLIGHT flag when creating trace channels.
+In flight mode when a tracing buffer is full, the oldest records in the buffer
+will be discarded to make room as new records arrive.  In the default
+non-overwrite mode, new records may be written only if the buffer has room.
+In either case, to prevent data loss, a user space reader must keep the buffers
+drained. GTSC provides a means to detect the number of records that have been
+dropped due to a buffer-full condition (non-overwrite mode only).
+
+When per-CPU buffers are used, relay creates one debugfs file for each running
+CPU.  The user-space consumer of the data is responsible for reading the 
+per-CPU buffers and collating the records presumably using a time stamp or
+sequence number included in the trace records.  The use of global buffers
+eliminates this extra work of sequencing records; however the provider's data
+layer must hold a lock when writing records.  The lock prevents writers
+running on different CPUs from overwriting each other's data.  However,
+buffering may be slower because write to the buffer are serialized. Global 
+buffering is selected by setting the GTSC_GLOBAL flag when creating trace
+channels.
+
+GTSC User Interface
+===================
+When a GTSC channel is created and tracing has been started, the following
+directories and files are created in the root of the mounted debugfs.
+
+/debug (root of the debugfs)
+        /<trace-root-dir>
+                /<trace-name>
+                        trace0 ... traceN  (Per-CPU trace data, one per CPU)
+                        dropped            (number of records dropped due
+                                            to a full-buffer condition)
+	        	state		   (Used to  start and stop tracing)
+
+Trace data is gathered from the trace[0...N] files using one of the available 
+interfaces provided by relay (see Documentation/filesystems/relay.txt).
+When using the READ(2) interface, as data is read it is marked as consumed by
+the relay subsystem.  Therefore, subsequent reads will only return unconsumed
+data.
+
+GTSC Kernel API
+===============
+An overview of the GTSC Kernel API is now given. More details of the API can
+be found in linux/gtsc.h.
+
+The steps a kernel data provider takes to utilize the GTSC are:
+1) Set up a gtsc channel - gtsc_trace_setup()
+2) Start the GTSC channel - gtsc_trace_startstop()
+3) Write one or more trace records into the channel (using the relay API).
+4) Optionally stop and start tracing as desired - gtsc_trace_startstop()
+5) Destroy the GTSC channel and underlying relay channel - gtsc_trace_cleanup().
+
+GTSC Example
+===========
+This small sample module creates a GTSC channel. It places a kprobe on the
+function do_fork().  The kprobe handler will write a timestamp and
+current->pid to the GTSC channel.  
+
+You can build the kernel module kprobes_gtsc.ko using the following Makefile:
+------------------------------------CUT-------------------------------------
+obj-m := kprobes_gtsc.o
+KDIR := /lib/modules/$(shell uname -r)/build
+PWD := $(shell pwd)
+default:
+	$(MAKE) -C $(KDIR) SUBDIRS=$(PWD) modules
+clean:
+	rm -f *.mod.c *.ko *.o
+----------------------------------CUT--------------------------------------
+/* kprobes_gtsc.c - An example of using GTSC in a kprobes module */
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/kprobes.h>
+#include <linux/gtsc.h>
+
+#define PROBE_POINT "do_fork"
+
+static struct kprobe kp;
+struct gtsc_trace *kprobes_trace;
+
+#define GTSC_PRINTF_TMPBUF_SIZE (1024)
+static char gtsc_printf_tmpbuf[NR_CPUS][GTSC_PRINTF_TMPBUF_SIZE];
+
+/* This lock is needed only when using global relay buffers */
+static DEFINE_SPINLOCK(gtsc_printf_lock);
+
+void gtsc_printf(struct gtsc_trace *trace, const char *format, ...)
+{
+	va_list args;
+	void *buf;
+	int len;
+	char *record;
+
+	if (!trace)
+		return;
+	if (!gtsc_trace_running(trace))
+		return;
+
+	/* get a timestamp */
+	buf = gtsc_printf_tmpbuf[smp_processor_id()];
+	len = sprintf(buf,"[%lld] ",gtsc_timestamp());
+
+	/* get the data */
+	va_start(args, format);
+	len += vsnprintf(buf+len, GTSC_PRINTF_TMPBUF_SIZE, format, args);
+	va_end(args);
+
+	/*
+	 * Locking can be eliminated by specifying per-cpu buffers
+	 * when calling gtsc_trace_setup().
+	 */
+	spin_lock(&gtsc_printf_lock);
+
+	/* Send everything to the relay buffer */
+	if ((record = relay_reserve(trace->rchan, len)))
+		memcpy(record, buf, len);
+
+	spin_unlock(&gtsc_printf_lock);
+}
+
+
+int handler_pre(struct kprobe *p, struct pt_regs *regs)
+{
+	gtsc_printf(kprobes_trace,"%d\n", current->pid);
+	return 0;
+}
+
+int init_module(void)
+{
+	int ret;
+	/* setup gtsc, use a global relay buffer */
+	kprobes_trace = gtsc_trace_setup("gtsc_example",PROBE_POINT,
+					1024,8,
+					GTSC_GLOBAL|GTSC_FLIGHT);
+	if (!kprobes_trace)
+		return -1;
+
+	gtsc_trace_startstop(kprobes_trace, 1);
+
+	/* setup the kprobe */
+	kp.pre_handler = handler_pre;
+	kp.post_handler = NULL;
+	kp.fault_handler = NULL;
+	kp.symbol_name = PROBE_POINT;
+	if ((ret=register_kprobe(&kp)) < 0) 
+		gtsc_printf(kprobes_trace,"register_kprobe failed  %d\n", ret);
+	return 0;
+}
+
+
+void cleanup_module(void)
+{
+	unregister_kprobe(&kp);
+	/* close down the gtsc channel */
+	gtsc_trace_startstop(kprobes_trace, 0);
+	gtsc_trace_cleanup(kprobes_trace);
+}
+
+MODULE_LICENSE("GPL");
+-----------------------------CUT--------------------------------------------
+How to run the example:
+$ mount -t debugfs /debug 
+$ make
+$ insmod kprobes_gtsc.ko
+
+To view the data produced by the module:
+$ cat /debug/gtsc_example/do_fork/trace0
+
+Remove the module.
+$ rmmod kprobes_gtsc
+
+The function gtsc_trace_cleanup() is called when the module
+is removed.  This will cause the GTSC channel to be destroyed and the
+corresponding files to disappear from the debug file system.
+
+Credits
+=======
+GTSC adapted from blktrace authored by Jens Axboe (axboe@suse.de).
+
+Major contributions to GTSC were made by:
+Tom Zanussi <zanussi@us.ibm.com>
+Martin Hunt <hunt@redhat.com>
+David Wilder <dwilder@us.ibm.com>

--------------050302010105080400010903--
