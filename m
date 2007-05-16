Return-Path: <linux-kernel-owner+w=401wt.eu-S1761340AbXEPTDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761340AbXEPTDb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 15:03:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757979AbXEPTDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 15:03:24 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51648 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756534AbXEPTDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 15:03:23 -0400
Date: Wed, 16 May 2007 15:03:20 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Roland McGrath <roland@redhat.com>
cc: Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] hwbkpt: Hardware breakpoints (was Kwatch)
In-Reply-To: <20070514212509.EC8261F84C7@magilla.localdomain>
Message-ID: <Pine.LNX.4.44L0.0705151150320.3192-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 May 2007, Roland McGrath wrote:

> > It seems to me that signal handlers must run with a copy of the original
> > EFLAGS stored on the stack.
> 
> Of course.  I'm talking about how the registers get changed to set up the
> signal handler to start running, not how the interrupted registers are
> saved on the user stack.  There is no issue with the stored eflags image;
> the "privileged" flags like RF are ignored by sigreturn anyway.

Ah, okay.  Yes, clearly the new EFLAGS for the signal handler should 
have RF turned off.  This should always be true, regardless of 
debugging.

> > Also, what if the signal handler was entered as a result of encountering 
> > an instruction breakpoint?  
> 
> This does not happen in reality.  Breakpoints can only be set by the
> debugger, not by the program itself.  The debugger should always eat the trap.

Hmmm.  I put in a little extra code to account for the possibility that
a program might want to set hardware breakpoints in itself.  Should
this be removed?

> The earlier quote I gave was from an AMD64 manual.  A 1995 Intel manual I
> have says, "All Intel Architecture processors manage the RF flag as follows,"
> and proceeds to give the "all faults except instruction breakpoint" behavior
> I quoted from the AMD manual earlier.  Hence I sincerely doubt that this
> varies among Intel and AMD processors.  Someone else will have to help us
> know about other makers' processors.  So far I have no reason to suspect that
> any processor behaves differently (aside from generic cynicism ;-).

And I no longer have any 386 CPUs to test...

> > It's a relatively minor issue.  On machines with fixed-length breakpoints, 
> > the .len field can be ignored.  Conversely, leaving it out would require 
> > using bitmasks to extract the type and length values from a combined .bits 
> > field.  I don't see any advantage.
> 
> I guess my main objection to having .type and .len is the false implied
> documentation of their presence and names, leading to people thinking they
> can look at those values.  In fact, they are machine-specific and
> implementation-specific bits of no intrinsic use to anyone else.

The fact that they are machine-specific and implementation-specific 
doesn't necessarily make them of no use.  See the driver below.

> That line from the manual is what we were both going on originally, and
> then you described the conflicting behavior.  I was trying to ascertain
> whether chips really do vary, or if the manual was just inaccurate about
> the single common way it actually behaves.  I take it you have in fact
> observed different behaviors on different chips?

No; I have tested only a couple of systems and I don't have a wide
variety of machines available.

> There are two possible kinds of "conservative" here.  To be conservative
> with respect to the existing behavior on a given chip, whatever that may
> be, we should never clear %dr6 completely, and instead should always
> mirror its bits to vdr7, only mapping the low four bits around to present
> the virtualized order.  The only bits we'd ever clear in hardware are
> those DR_TRAPn bits corresponding to the registers allocated to non-ptrace
> uses, and kprobes should clear DR_STEP.  And note that when vdr6 is
> changed by ptrace, we should reset the hardware %dr6 accordingly, to match
> existing kernel behavior should users change debugreg[6] via ptrace.
> 
> To be conservative in the sense of reliable user-level behavior despite
> chip oddities would be a little different.  Firstly, I think we should
> mirror all the "extra" bits from hardware to vdr7 blindly, i.e. everything
> but DR_STEP and DR_TRAPn.  That way if any chip comes along that sets new
> bits for new features or whatnot, users can at least see the new hardware
> bits via ptrace before hw_breakpoint gets updated to support them more
> directly.  For the low four bits, I think what users expect is that no
> bits are ever implicitly cleared, so they accumulate to say which drN has
> hit since the last time ptrace was used to clear vdr6.

Allow me to rephrase: When a debug exception occurs, the real DR6 value
should be copied to vdr6, except that kprobes should adjust DR_STEP and
hw_breakpoint should adjust the DR_TRAPn bits appropriately.  There's
some question about what value the debug exception handler should write
back to DR6, if anything.  When switching to a new task, the DR_TRAPn
bits in vdr6 could be de-virtualized somehow and the result loaded into
DR6, but again, it might be safest to leave DR6 alone.

As for what users expect of the low four bits, you are definitely 
wrong.  My tests with gdb show that it relies on the CPU to clear those 
bits whenever a data breakpoint is hit; it doesn't clear them itself 
and it doesn't work properly if the kernel keeps virtualized versions 
of them set.  That's on a Pentium 4 and on an AMD Duron.

I did some testing to see how the CPU behaves when the debug handler
writes different values back to DR6.  The results were:

	Values written back to DR6 were retained in the register until 
	the next debug exception occurred.

	When the exception handler read DR6, the 0xffff0ff0 bits were
	set every time.  The 0x00001000 bit was never set, even if it
	had been turned on before the exception occurred.

	No matter what values were stored in the low four bits
	beforehand, when the exception occurred DR6 had only the
	bit for the debug register which was triggered.

	If the handler wrote back any of BS, BT, or BD to DR6, then
	the system misbehaved.  I don't know exactly what happened,
	but my shell process ended and the debug handler got called
	over and over again (as if stuck in a loop) for several
	seconds.

In light of these results, the best approach appears to be either to 
leave DR6 alone or to set it to 0.


Below is a patch containing a driver meant for testing kernel hardware 
breakpoints.  Instructions are in the comments at the top.  You can 
build the driver by typing "make M=bptest" at the top level.

The patch also adjust the Alt-SysRq-P handler to print out the debug 
register values along with all the other stuff.

Alan Stern



Index: usb-2.6/bptest/Makefile
===================================================================
--- /dev/null
+++ usb-2.6/bptest/Makefile
@@ -0,0 +1 @@
+obj-m	+= bptest.o
Index: usb-2.6/bptest/bptest.c
===================================================================
--- /dev/null
+++ usb-2.6/bptest/bptest.c
@@ -0,0 +1,459 @@
+/*
+ * Test driver for hardware breakpoints.
+ *
+ * Copyright (C) 2007 Alan Stern <stern@rowland.harvard.edu>
+ */
+
+/*
+ * When this driver is loaded, it will create several attribute files
+ * under /sys/bus/platform/drivers/bptest:
+ *
+ *	 call, read, write, and bp0,..., bp3.
+ *
+ * It also allocates a 32-byte array (called "bytes") for testing data
+ * breakpoints, and it contains four do-nothing routines, r0(),..., r3(),
+ * for testing execution breakpoints.
+ *
+ * Writing to the "call" attribute causes the rN routines to be called;
+ * "echo >call N" will call rN(), where N is 0, 1, 2, or 3.  Similarly,
+ * "echo >call" will call all four routines.
+ *
+ * The byte array can be accessed through the "read" and "write"
+ * attributes.  "echo >read N" will read bytes[N], and "echo >write N V"
+ * will store V in bytes[N], where N is between 0 and 31.  There are
+ * no provision for multi-byte accesses; they shouldn't be needed for
+ * simple testing.
+ *
+ * The driver contains four hw_breakpoint structures, which can be
+ * accessed through the "bpN" attributes.  Reading the attribute file
+ * will yield the hw_breakpoint's current settings.  The settings can be
+ * altered by writing the attribute.  The format to use is:
+ *
+ *	echo >bpN priority type address [len]
+ *
+ * priority must be a number between 0 and 255.  type must be one of 'e'
+ * (execution), 'r' (read), 'w' (write), or 'b' (both read/write).
+ * address must be a number between 0 and 31; if type is 'e' then address
+ * must be between 0 and 3.  len must 1, 2, 4, or 8, but if type is 'e'
+ * then len is optional and ignored.
+ *
+ * Execution breakpoints are set on the rN routine and data breakpoints
+ * are set on bytes[N], where N is the address value.  You can unregister
+ * a breakpoint by doing "echo >bpN u", where 'u' is any non-digit.
+ *
+ * (Note: On i386 certain values are not implemented.  len cannot be set
+ * to 8 and type cannot be set to 'r'.)
+ *
+ * The driver prints lots of information to the system log as it runs.
+ * To best see things as they happen, use a VT console and set the
+ * logging level high (I use Alt-SysRq-9).
+ */
+
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <asm/hw_breakpoint.h>
+
+MODULE_AUTHOR("Alan Stern <stern@rowland.harvard.edu>");
+MODULE_DESCRIPTION("Hardware Breakpoint test driver");
+MODULE_LICENSE("GPL");
+
+
+static struct hw_breakpoint bps[4];
+
+
+#define NUM_BYTES	32
+static unsigned char bytes[NUM_BYTES] __attribute__((aligned(8)));
+
+/* Write n to read bytes[n] */
+static ssize_t read_store(struct device_driver *d, const char *buf,
+		size_t count)
+{
+	int n = -1;
+
+	if (sscanf(buf, "%d", &n) < 1 || n < 0 || n >= NUM_BYTES) {
+		printk(KERN_WARNING "bptest: read: invalid index %d\n", n);
+		return -EINVAL;
+	}
+	printk(KERN_INFO "bptest: read: bytes[%d] = %d\n", n, bytes[n]);
+	return count;
+}
+static DRIVER_ATTR(read, 0200, NULL, read_store);
+
+/* Write n v to set bytes[n] = v */
+static ssize_t write_store(struct device_driver *d, const char *buf,
+		size_t count)
+{
+	int n = -1;
+	int v;
+
+	if (sscanf(buf, "%d %d", &n, &v) < 2 || n < 0 || n >= NUM_BYTES) {
+		printk(KERN_WARNING "bptest: write: invalid index %d\n", n);
+		return -EINVAL;
+	}
+	bytes[n] = v;
+	printk(KERN_INFO "bptest: write: bytes[%d] <- %d\n", n, v);
+	return count;
+}
+static DRIVER_ATTR(write, 0200, NULL, write_store);
+
+
+/* Dummy routines for testing instruction breakpoints */
+static void r0(void)
+{
+	printk(KERN_INFO "This is r%d\n", 0);
+}
+static void r1(void)
+{
+	printk(KERN_INFO "This is r%d\n", 1);
+}
+static void r2(void)
+{
+	printk(KERN_INFO "This is r%d\n", 2);
+}
+static void r3(void)
+{
+	printk(KERN_INFO "This is r%d\n", 3);
+}
+
+static void (*rtns[])(void) = {
+	r0, r1, r2, r3
+};
+
+
+/* Write n to call routine r##n, or a blank line to call them all */
+static ssize_t call_store(struct device_driver *d, const char *buf,
+		size_t count)
+{
+	int n;
+
+	if (sscanf(buf, "%d", &n) == 0) {
+		printk(KERN_INFO "bptest: call all routines\n");
+		r0();
+		r1();
+		r2();
+		r3();
+	} else if (n >= 0 && n < 4) {
+		printk(KERN_INFO "bptest: call r%d\n", n);
+		rtns[n]();
+	} else {
+		printk(KERN_WARNING "bptest: call: invalid index: %d\n", n);
+		count = -EINVAL;
+	}
+	return count;
+}
+static DRIVER_ATTR(call, 0200, NULL, call_store);
+
+
+/* Breakpoint callbacks */
+static void bptest_triggered(struct hw_breakpoint *bp, struct pt_regs *regs)
+{
+	printk(KERN_INFO "Breakpoint %d triggered\n", bp - bps);
+}
+
+static void bptest_installed(struct hw_breakpoint *bp)
+{
+	printk(KERN_INFO "Breakpoint %d installed\n", bp - bps);
+}
+
+static void bptest_uninstalled(struct hw_breakpoint *bp)
+{
+	printk(KERN_INFO "Breakpoint %d uninstalled\n", bp - bps);
+}
+
+
+/* Breakpoint attribute files for testing */
+static ssize_t bp_show(int n, char *buf)
+{
+	struct hw_breakpoint *bp = &bps[n];
+	int a, len, type;
+
+	if (!bp->status)
+		return sprintf(buf, "bp%d: unregistered\n", n);
+
+	len = -1;
+	switch (bp->len) {
+#ifdef HW_BREAKPOINT_LEN_1
+	case HW_BREAKPOINT_LEN_1:	len = 1;	break;
+#endif
+#ifdef HW_BREAKPOINT_LEN_2
+	case HW_BREAKPOINT_LEN_2:	len = 2;	break;
+#endif
+#ifdef HW_BREAKPOINT_LEN_4
+	case HW_BREAKPOINT_LEN_4:	len = 4;	break;
+#endif
+#ifdef HW_BREAKPOINT_LEN_8
+	case HW_BREAKPOINT_LEN_4:	len = 8;	break;
+#endif
+	}
+
+	type = '?';
+	switch (bp->type) {
+#ifdef HW_BREAKPOINT_READ
+	case HW_BREAKPOINT_READ:	type = 'r';	break;
+#endif
+#ifdef HW_BREAKPOINT_WRITE
+	case HW_BREAKPOINT_WRITE:	type = 'w';	break;
+#endif
+#ifdef HW_BREAKPOINT_RW
+	case HW_BREAKPOINT_RW:		type = 'b';	break;
+#endif
+#ifdef HW_BREAKPOINT_EXECUTE
+	case HW_BREAKPOINT_EXECUTE:	type = 'e';	break;
+#endif
+	}
+
+	a = -1;
+	if (type == 'e') {
+		if (bp->address.kernel == r0)
+			a = 0;
+		else if (bp->address.kernel == r1)
+			a = 1;
+		else if (bp->address.kernel == r2)
+			a = 2;
+		else if (bp->address.kernel == r3)
+			a = 3;
+	} else {
+		const unsigned char *p = bp->address.kernel;
+
+		if (p >= bytes && p < bytes + NUM_BYTES)
+			a = p - bytes;
+	}
+
+	return sprintf(buf, "bp%d: %d %c %d %d [%sinstalled]\n",
+			n, bp->priority, type, a, len,
+			(bp->status < HW_BREAKPOINT_INSTALLED ? "not " : ""));
+}
+
+static ssize_t bp_store(int n, const char *buf, size_t count)
+{
+	struct hw_breakpoint *bp = &bps[n];
+	int prio, a, len;
+	char type;
+	int i;
+
+	if (count <= 1) {
+		printk(KERN_INFO "bptest: bp%d: format:  priority type "
+				"address len\n", n);
+		printk(KERN_INFO "  type = r, w, b, or e; address = 0 - 31; "
+				"len = 1, 2, 4, or 8\n");
+		printk(KERN_INFO "  Write any non-digit to unregister\n");
+		return count;
+	}
+
+	unregister_kernel_hw_breakpoint(bp);
+	printk(KERN_INFO "bptest: bp%d unregistered\n", n);
+
+	len = -1;
+	i = sscanf(buf, "%d %c %d %d", &prio, &type, &a, &len);
+	if (i == 0)
+		return count;
+	if (i < 3) {
+		printk(KERN_WARNING "bptest: bp%d: too few fields\n", n);
+		return -EINVAL;
+	}
+
+	bp->priority = prio;
+	switch (type) {
+#ifdef HW_BREAKPOINT_EXECUTE
+	case 'e':
+		bp->type = HW_BREAKPOINT_EXECUTE;
+		bp->len = HW_BREAKPOINT_LEN_EXECUTE;
+		break;
+#endif
+#ifdef HW_BREAKPOINT_READ
+	case 'r':
+		bp->type = HW_BREAKPOINT_READ;
+		break;
+#endif
+#ifdef HW_BREAKPOINT_WRITE
+	case 'w':
+		bp->type = HW_BREAKPOINT_WRITE;
+		break;
+#endif
+#ifdef HW_BREAKPOINT_RW
+	case 'b':
+		bp->type = HW_BREAKPOINT_RW;
+		break;
+#endif
+	default:
+		printk(KERN_WARNING "bptest: bp%d: invalid type %c\n",
+				n, type);
+		return -EINVAL;
+	}
+
+	if (a < 0 || a >= NUM_BYTES || (a >= 4 && type == 'e')) {
+		printk(KERN_WARNING "bptest: bp%d: invalid address %d\n",
+				n, a);
+		return -EINVAL;
+	}
+	if (type == 'e')
+		bp->address.kernel = rtns[a];
+	else {
+		bp->address.kernel = &bytes[a];
+
+		switch (len) {
+#ifdef HW_BREAKPOINT_LEN_1
+		case 1:		bp->len = HW_BREAKPOINT_LEN_1;	break;
+#endif
+#ifdef HW_BREAKPOINT_LEN_2
+		case 2:		bp->len = HW_BREAKPOINT_LEN_2;	break;
+#endif
+#ifdef HW_BREAKPOINT_LEN_4
+		case 4:		bp->len = HW_BREAKPOINT_LEN_4;	break;
+#endif
+#ifdef HW_BREAKPOINT_LEN_8
+		case 8:		bp->len = HW_BREAKPOINT_LEN_8;	break;
+#endif
+		default:
+			printk(KERN_WARNING "bptest: bp%d: invalid len %d\n",
+					n, len);
+			return -EINVAL;
+			break;
+		}
+	}
+
+	bp->triggered = bptest_triggered;
+	bp->installed = bptest_installed;
+	bp->uninstalled = bptest_uninstalled;
+
+	i = register_kernel_hw_breakpoint(bp);
+	if (i < 0) {
+		printk(KERN_WARNING "bptest: bp%d: failed to register %d\n",
+				n, i);
+		count = i;
+	} else
+		printk(KERN_INFO "bptest: bp%d registered: %d\n", n, i);
+	return count;
+}
+
+
+static ssize_t bp0_show(struct device_driver *d, char *buf)
+{
+	return bp_show(0, buf);
+}
+static ssize_t bp0_store(struct device_driver *d, const char *buf,
+		size_t count)
+{
+	return bp_store(0, buf, count);
+}
+static DRIVER_ATTR(bp0, 0600, bp0_show, bp0_store);
+
+static ssize_t bp1_show(struct device_driver *d, char *buf)
+{
+	return bp_show(1, buf);
+}
+static ssize_t bp1_store(struct device_driver *d, const char *buf,
+		size_t count)
+{
+	return bp_store(1, buf, count);
+}
+static DRIVER_ATTR(bp1, 0600, bp1_show, bp1_store);
+
+static ssize_t bp2_show(struct device_driver *d, char *buf)
+{
+	return bp_show(2, buf);
+}
+static ssize_t bp2_store(struct device_driver *d, const char *buf,
+		size_t count)
+{
+	return bp_store(2, buf, count);
+}
+static DRIVER_ATTR(bp2, 0600, bp2_show, bp2_store);
+
+static ssize_t bp3_show(struct device_driver *d, char *buf)
+{
+	return bp_show(3, buf);
+}
+static ssize_t bp3_store(struct device_driver *d, const char *buf,
+		size_t count)
+{
+	return bp_store(3, buf, count);
+}
+static DRIVER_ATTR(bp3, 0600, bp3_show, bp3_store);
+
+
+static int bptest_probe(struct platform_device *pdev)
+{
+	return -ENODEV;
+}
+
+static int bptest_remove(struct platform_device *pdev)
+{
+	return 0;
+}
+
+static struct platform_driver bptest_driver = {
+	.probe = bptest_probe,
+	.remove = bptest_remove,
+	.driver = {
+		.name = "bptest",
+		.owner = THIS_MODULE,
+	}
+};
+
+
+static struct driver_attribute *(bptest_group[]) = {
+	&driver_attr_bp0,
+	&driver_attr_bp1,
+	&driver_attr_bp2,
+	&driver_attr_bp3,
+	&driver_attr_call,
+	&driver_attr_read,
+	&driver_attr_write,
+	NULL
+};
+
+static int add_files(void)
+{
+	int rc = 0;
+	struct driver_attribute **g;
+
+	for (g = bptest_group; *g; ++g) {
+		rc = driver_create_file(&bptest_driver.driver, *g);
+		if (rc)
+			break;
+	}
+	return rc;
+}
+
+static void remove_files(void)
+{
+	struct driver_attribute **g;
+
+	for (g = bptest_group; *g; ++g)
+		driver_remove_file(&bptest_driver.driver, *g);
+}
+
+static int __init bptest_init(void)
+{
+	int rc;
+
+	rc = platform_driver_register(&bptest_driver);
+	if (rc) {
+		printk(KERN_ERR "Failed to register bptest driver: %d\n", rc);
+		return rc;
+	}
+	rc = add_files();
+	if (rc) {
+		remove_files();
+		platform_driver_unregister(&bptest_driver);
+		return rc;
+	}
+	printk("bptest loaded\n");
+	return 0;
+}
+
+static void __exit bptest_exit(void)
+{
+	int n;
+
+	remove_files();
+	for (n = 0; n < 4; ++n)
+		unregister_kernel_hw_breakpoint(&bps[n]);
+	platform_driver_unregister(&bptest_driver);
+	printk("bptest unloaded\n");
+}
+
+module_init(bptest_init);
+module_exit(bptest_exit);
Index: usb-2.6/arch/i386/kernel/process.c
===================================================================
--- usb-2.6.orig/arch/i386/kernel/process.c
+++ usb-2.6/arch/i386/kernel/process.c
@@ -296,6 +296,7 @@ __setup("idle=", idle_setup);
 void show_regs(struct pt_regs * regs)
 {
 	unsigned long cr0 = 0L, cr2 = 0L, cr3 = 0L, cr4 = 0L;
+	unsigned long d0, d1, d2, d3;
 
 	printk("\n");
 	printk("Pid: %d, comm: %20s\n", current->pid, current->comm);
@@ -320,6 +321,17 @@ void show_regs(struct pt_regs * regs)
 	cr3 = read_cr3();
 	cr4 = read_cr4_safe();
 	printk("CR0: %08lx CR2: %08lx CR3: %08lx CR4: %08lx\n", cr0, cr2, cr3, cr4);
+
+	get_debugreg(d0, 0);
+	get_debugreg(d1, 1);
+	get_debugreg(d2, 2);
+	get_debugreg(d3, 3);
+	printk("DR0: %08lx DR1: %08lx DR2: %08lx DR3: %08lx\n",
+			d0, d1, d2, d3);
+	get_debugreg(d2, 6);
+	get_debugreg(d3, 7);
+	printk("    DR6: %08lx DR7: %08lx\n", d2, d3);
+
 	show_trace(NULL, regs, &regs->esp);
 }
 

