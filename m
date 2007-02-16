Return-Path: <linux-kernel-owner+w=401wt.eu-S1946132AbXBPUam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946132AbXBPUam (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 15:30:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946135AbXBPUal
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 15:30:41 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:49842 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946132AbXBPUal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 15:30:41 -0500
Subject: [PATCH RT] update of lpptest
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 16 Feb 2007 15:30:21 -0500
Message-Id: <1171657821.13586.6.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo and Thomas,

Here's a clean up of the lpptest. I removed the dependency to the TSC
and I now use the getnstimeofday for measuring the latency. I also added
code to request the port region.

I plan on doing more with this utility, but figured I'd send updates at
stages of progress.

-- Steve

Index: linux-2.6.20-rt7/drivers/char/lpptest.c
===================================================================
--- linux-2.6.20-rt7.orig/drivers/char/lpptest.c	2007-02-16 10:56:01.000000000 -0500
+++ linux-2.6.20-rt7/drivers/char/lpptest.c	2007-02-16 14:12:49.000000000 -0500
@@ -3,11 +3,42 @@
  *
  *      Copyright (C) 2005 Thomas Gleixner, Ingo Molnar
  *
+ * Resurrected by Steven Rostedt:
+ *   - Slight code clean up.
+ *   - Remove dependency on TSC (getnstimeofday is good enough)
+ *
  * licensed under the GPL
  *
  * You need to have CONFIG_PARPORT disabled for this device, it is a
  * completely self-contained device that assumes sole ownership of the
  * parallel port.
+ *
+ * Notes:
+ *   1.  The above is VERY important! Don't even load the parport module
+ *       because once it is loaded, you might as well reboot.  The parport
+ *       modules (specifically parport_pc) screws up the parport and this
+ *       poor simple lpptest module goes haywire.  Removing the module is
+ *       not even good enough. The parport code just ruins it for lpptest.
+ *       So turn CONFIG_PARPORT to No.
+ *
+ *   2.  This has been tested with the parallel port mode settings of both
+ *       SPP(PS/2) and EPP.  Both should work for both test and monitor
+ *       machines.
+ *
+ *   3.  If it doesn't work:
+ *         a. Check to make sure none of the parport drivers were ever
+ *            loaded (including lp).
+ *         b. Check to make sure you have a data transfer cable.
+ *            Min pin layout:
+ *                 5 - 10
+ *                10 -  5
+ *               GRD - GRD
+ *          c. Make sure that the parallel port connector that sticks out
+ *             of the chassis actually connects to the motherboard **.
+ *
+ *  ** - I spent an entire day trying to figure out why it wasn't working,
+ *       until I opened up the box to find that the connector wasn't plugged
+ *       into the motherboard. Needless to say, I wasn't too happy - SDR
  */
 #include <linux/sched.h>
 #include <linux/kernel.h>
@@ -47,11 +78,24 @@
 #define LPPTEST_DISABLE _IOR (LPPTEST_CHAR_MAJOR, 2, unsigned long long)
 #define LPPTEST_ENABLE  _IOR (LPPTEST_CHAR_MAJOR, 3, unsigned long long)
 
+#define LPPTEST_PORT_BASE 0x378
+
+#define LPPTEST_DATA_PORT (LPPTEST_PORT_BASE)
+#define LPPTEST_STAT_PORT (LPPTEST_PORT_BASE+1)
+#define LPPTEST_CTRL_PORT (LPPTEST_PORT_BASE+2)
+
+#define LPPTEST_PORT_SIZE 3
+
 static char dev_id[] = "lpptest";
 
-#define INIT_PORT()	outb(0x04, 0x37a)
-#define ENABLE_IRQ()	outb(0x10, 0x37a)
-#define DISABLE_IRQ()	outb(0, 0x37a)
+#define lpptest_data_out(x)	outb(x, LPPTEST_DATA_PORT)
+#define lpptest_data_in(x)	inb(LPPTEST_DATA_PORT)
+#define lpptest_stat_in()	inb(LPPTEST_STAT_PORT)
+#define lpptest_ctrl_out(x)	outb(x, LPPTEST_CTRL_PORT)
+
+#define INIT_PORT()	lpptest_ctrl_out(0x04)
+#define ENABLE_IRQ()	lpptest_ctrl_out(0x10)
+#define DISABLE_IRQ()	lpptest_ctrl_out(0x00)
 
 static unsigned char out = 0x5a;
 
@@ -61,37 +105,44 @@ static unsigned char out = 0x5a;
 static int lpptest_irq (int irq, void *dev_id)
 {
 	out ^= 0xff;
-	outb(out, 0x378);
+	lpptest_data_out(out);
 
 	return IRQ_HANDLED;
 }
 
-static cycles_t test_response(void)
+static u64 test_response(void)
 {
-	cycles_t now, end;
+	struct timespec start, end;
+	u64 startns, endns;
 	unsigned char in;
 	int timeout = 0;
 
 	local_irq_disable();
-	in = inb(0x379);
-	inb(0x378);
-	outb(0x08, 0x378);
-	now = get_cycles();
+
+	in = lpptest_stat_in();
+	lpptest_data_in();
+	lpptest_data_out(0x08);
+
+	getnstimeofday(&start);
 	while(1) {
 		if (inb(0x379) != in)
 			break;
 		if (timeout++ > 1000000) {
-			outb(0x00, 0x378);
+			lpptest_data_out(0x00);
 			local_irq_enable();
-
 			return 0;
 		}
 	}
-	end = get_cycles();
-	outb(0x00, 0x378);
+	getnstimeofday(&end);
+	lpptest_data_out(0x00);
 	local_irq_enable();
 
-	return end - now;
+	startns = (u64)start.tv_sec * 1000000000ULL;
+	startns += start.tv_nsec;
+	endns = (u64)end.tv_sec * 1000000000ULL;
+	endns += end.tv_nsec;
+
+	return endns - startns;
 }
 
 static int lpptest_open(struct inode *inode, struct file *file)
@@ -120,7 +171,7 @@ int lpptest_ioctl(struct inode *inode, s
 
 	case LPPTEST_TEST: {
 
-		cycles_t diff = test_response();
+		unsigned long long diff = test_response();
 		if (copy_to_user((void *)ioctl_param, (void*) &diff, sizeof(diff)))
 			goto errcpy;
 		break;
@@ -142,17 +193,26 @@ static struct file_operations lpptest_de
 
 static int __init lpptest_init (void)
 {
+	struct resource *res;
+	int ret = -EAGAIN;
+
+	res = request_region(LPPTEST_PORT_BASE, LPPTEST_PORT_SIZE, LPPTEST_DEVICE_NAME);
+	if (!res) {
+		printk(KERN_NOTICE "Can't allocate region %x for lpp.\n",
+		       LPPTEST_PORT_BASE);
+		goto out;
+	}
+
 	if (register_chrdev(LPPTEST_CHAR_MAJOR, LPPTEST_DEVICE_NAME, &lpptest_dev_fops))
 	{
 		printk(KERN_NOTICE "Can't allocate major number %d for lpptest.\n",
 		       LPPTEST_CHAR_MAJOR);
-		return -EAGAIN;
+		goto out1;
 	}
 
 	if (request_irq (LPPTEST_IRQ, lpptest_irq, 0, "lpptest", dev_id)) {
 		printk (KERN_WARNING "lpptest: irq %d in use. Unload parport module!\n", LPPTEST_IRQ);
-		unregister_chrdev(LPPTEST_CHAR_MAJOR, LPPTEST_DEVICE_NAME);
-		return -EAGAIN;
+		goto out2;
 	}
 	irq_desc[LPPTEST_IRQ].status |= IRQ_NODELAY;
 	irq_desc[LPPTEST_IRQ].action->flags |= IRQF_NODELAY | IRQF_DISABLED;
@@ -161,6 +221,13 @@ static int __init lpptest_init (void)
 	ENABLE_IRQ();
 
 	return 0;
+ out2:
+	unregister_chrdev(LPPTEST_CHAR_MAJOR, LPPTEST_DEVICE_NAME);
+ out1:
+	release_region(LPPTEST_PORT_BASE, LPPTEST_PORT_SIZE);
+ out:
+	return ret;
+
 }
 module_init (lpptest_init);
 
@@ -170,6 +237,7 @@ static void __exit lpptest_exit (void)
 
 	free_irq(LPPTEST_IRQ, dev_id);
 	unregister_chrdev(LPPTEST_CHAR_MAJOR, LPPTEST_DEVICE_NAME);
+	release_region(LPPTEST_PORT_BASE, LPPTEST_PORT_SIZE);
 }
 module_exit (lpptest_exit);
 
Index: linux-2.6.20-rt7/scripts/testlpp.c
===================================================================
--- linux-2.6.20-rt7.orig/scripts/testlpp.c	2007-02-16 10:46:56.000000000 -0500
+++ linux-2.6.20-rt7/scripts/testlpp.c	2007-02-16 14:02:57.000000000 -0500
@@ -4,6 +4,10 @@
  *
  *      Copyright (C) 2005 Thomas Gleixner
  *
+ * Resurrected by Steven Rostedt:
+ *   - Slight code clean up.
+ *   - Remove dependency on TSC (the driver returns nsecs).
+ *
  * licensed under the GPL
  */
 #include <unistd.h>
@@ -51,34 +55,12 @@ static void print_hist(void)
 	}
 }
 
-static inline unsigned long long int rdtsc(void)
-{
-	unsigned long long int x, y;
-	for (;;) {
-		__asm__ volatile ("rdtsc" : "=A" (x));
-		__asm__ volatile ("rdtsc" : "=A" (y));
-		if (y - x < 1000)
-			return y;
-	}
-}
-
-static unsigned long long calibrate_loop(void)
-{
-	unsigned long long mytime1, mytime2;
-
-	mytime1 = rdtsc();
-	usleep(500000);
-	mytime2 = rdtsc();
-
-	return (mytime2 - mytime1) * 2;
-}
-
-#define time_to_usecs(time) ((double)time*1000000.0/(double)cycles_per_sec)
+#define time_to_usecs(time) ((double)time/1000.0)
 
-#define time_to_usecs_l(time) (long)(time*1000000/cycles_per_sec)
+#define time_to_usecs_l(time) (long)(time/1000)
 
 int fd, total;
-unsigned long long tim, sum_tim, min_tim = -1ULL, max_tim, cycles_per_sec;
+unsigned long long tim, sum_tim, min_tim = -1ULL, max_tim;
 
 void cleanup(int sig)
 {
@@ -125,9 +107,6 @@ int main (int argc, char **argv)
 
 	ioctl (fd, LPPTEST_DISABLE, &tim);
 
-	fprintf(stderr, "calibrating cycles to usecs: ");
-	cycles_per_sec = calibrate_loop();
-	fprintf(stderr, "%lld cycles per usec\n", cycles_per_sec/1000000);
 	if (nr_requests)
 		fprintf(stderr, "[max # of requests: %u]\n", nr_requests);
 	fprintf(stderr, "starting %dHz test, hit Ctrl-C to stop:\n\n", HZ);
@@ -139,7 +118,7 @@ int main (int argc, char **argv)
 		else {
 			hist_hit(time_to_usecs_l(tim));
 			if (tim > max_tim) {
-				printf ("new max latency: %.2lf usecs (%Ld cycles)\n", time_to_usecs(tim), tim);
+				printf ("new max latency: %.2lf usecs (%Ld nsecs)\n", time_to_usecs(tim), tim);
 				max_tim = tim;
 			}
 			if (tim < min_tim)


