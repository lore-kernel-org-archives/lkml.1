Return-Path: <linux-kernel-owner+w=401wt.eu-S1757549AbYFUCHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549AbYFUCHU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 22:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753267AbYFUCHJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 22:07:09 -0400
Received: from [194.117.236.238] ([194.117.236.238]:36618 "EHLO
	heracles.linux360.ro" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbYFUCHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 22:07:07 -0400
Date: Sat, 21 Jun 2008 05:06:32 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Tom Zanussi <tzanussi@gmail.com>
Cc: penberg@cs.helsinki.fi, akpm@linux-foundation.org,
       compudj@krystal.dyndns.org, linux-kernel@vger.kernel.org,
       righi.andrea@gmail.com
Subject: Re: [PATCH 1/3] relay: Fix 4 off-by-one errors occuring when
 writing to a CPU buffer.
Message-ID: <20080621050632.4a7a6c16@linux360.ro>
In-Reply-To: <1213593748.7744.34.camel@charm-linux>
References: <20080613040947.7465b9a5@linux360.ro>
	<1213418437.8237.51.camel@charm-linux>
	<20080614175223.4d3c6084@linux360.ro>
	<1213593748.7744.34.camel@charm-linux>
X-Mailer: Claws Mail 3.3.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jun 2008 00:22:27 -0500
Tom Zanussi <tzanussi@gmail.com> wrote:

> So apparently what you're seeing is zeroes being read when there's a
> buffer-full condition?  If so, we need to figure out exactly why
> that's happening to see whether your fix is really what's needed; I
> haven't seen problems in the buffer-full case before and I think your
> fix would break it even if it fixed your read problem.  So it would
> be good to be able to reproduce it first.
> 
> Tom  

Hi,

Sorry for being so late, there were some exams I had to cope with.

Although I couldn't reproduce zeros, I've come up with something I'd
say is equally good. This has been done on a vanilla 2.6.26-rc6.

Please look at the testcase below and tell me what you think.

And yes, the changes in relay_write() and __relay_write() are inappropriate.

	
	Cheers,
	Eduard

---
diff --git a/kernel/Makefile b/kernel/Makefile
index 1c9938a..5e1a32b 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -9,7 +9,7 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o profile.o \
 	    rcupdate.o extable.o params.o posix-timers.o \
 	    kthread.o wait.o kfifo.o sys_ni.o posix-cpu-timers.o mutex.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
-	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o
+	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o relay_test.o
 
 obj-$(CONFIG_SYSCTL_SYSCALL_CHECK) += sysctl_check.o
 obj-$(CONFIG_STACKTRACE) += stacktrace.o
diff --git a/kernel/relay_test.c b/kernel/relay_test.c
new file mode 100644
index 0000000..38c2755
--- /dev/null
+++ b/kernel/relay_test.c
@@ -0,0 +1,92 @@
+#include <linux/debugfs.h>
+#include <linux/relay.h>
+
+static struct rchan *relay_test_chan;
+
+static void relay_test_do_test_writes(int test)
+{
+	u32 poison32 = 0x32323232;
+	u16 poison16 = 0x1616;
+
+	switch (test) {
+		case 0: /* Half full subbuf. */
+			relay_write(relay_test_chan, &poison16, 2);
+			break;
+		case 1: /* Full subbuf. */
+			relay_write(relay_test_chan, &poison32, 4);
+			break;
+		case 2: /* Crossing subbuf boundaries. */
+			relay_write(relay_test_chan, &poison16, 2);
+			relay_write(relay_test_chan, &poison32, 4);
+			break;
+		case 3: /* Full buffer. */
+			relay_write(relay_test_chan, &poison32, 4);
+			relay_write(relay_test_chan, &poison32, 4);
+			break;
+		default:
+			printk(KERN_INFO "relay_test: No such test!\n");
+	}
+}
+
+static ssize_t relay_test_trigger_write(struct file *filp,
+					const char __user *userdata,
+					size_t count, loff_t *ppos)
+{
+	char data[5];
+	unsigned long test, err, bytes = min(count, (size_t) 4);
+
+	err = copy_from_user(&data, userdata, bytes);
+	if (err) {
+		printk(KERN_ERR "relay_test: Error reading from user!\n");
+		return -1;
+	}
+	data[4] = '\0';
+	test = simple_strtoul(data, NULL, 10);
+	
+	printk(KERN_INFO "relay_test: Doing test %lu on CPU %lu.\n",
+	       test, get_cpu());
+	put_cpu();
+	relay_test_do_test_writes(test);
+
+	return bytes;
+}
+
+static struct file_operations trigger_fops = {
+	.open = nonseekable_open,
+	.write = relay_test_trigger_write,
+};
+
+static struct dentry *
+relay_test_create_buf_file(const char *filename, struct dentry *parent,
+			   int mode, struct rchan_buf *buf, int *is_global)
+{
+	return debugfs_create_file(filename, mode, parent,
+				   buf, &relay_file_operations);
+}
+
+static struct rchan_callbacks relay_test_callbacks = {
+	.create_buf_file = relay_test_create_buf_file,
+};
+
+static int relay_test_init(void)
+{
+	struct dentry *trigger;
+
+	trigger = debugfs_create_file("relay_test_trigger", 0600, NULL,
+				      NULL, &trigger_fops);
+	if (!trigger) {
+		printk(KERN_ERR "relay_test: could not create trigger debugfs file!\n");
+		return 1;
+	}
+
+	relay_test_chan = relay_open("relay_test_cpu", NULL,
+				     4, 2, &relay_test_callbacks, NULL);
+	if (!relay_test_chan) {
+		printk(KERN_ERR "relay_test: could not open channel!\n");
+		return 1;
+	}
+		
+	return 0;
+}
+
+late_initcall(relay_test_init);
---

Results, first run:

Test 0:
0000000 1616                                   
0000002
---
Test 1:
0000000 3232 3232                              
0000004
---
Test 2:
0000000 1616                                   
0000002
---
Test 3:
0000000 3232 3232 3232 3232                    
0000008
---
Test 0, 0:
---
Test 0, 0, 0, 0:
0000000 1616 1616 1616 1616                    
0000008
---
What the kernel said:
relay_test: Doing test 0 on CPU 1.
relay_test: Doing test 1 on CPU 1.
relay_test: Doing test 2 on CPU 1.
relay_test: Doing test 3 on CPU 0.
relay_test: Doing test 0 on CPU 0.
relay_test: Doing test 0 on CPU 0.
relay_test: Doing test 0 on CPU 0.
relay_test: Doing test 0 on CPU 0.
relay_test: Doing test 0 on CPU 0.
relay_test: Doing test 0 on CPU 0.

Results, second run, without rebooting in between:

Test 0:
0000000 1616                                   
0000002
---
Test 1:
0000000 3232 3232                              
0000004
---
Test 2:
0000000 1616                                   
0000002
---
Test 3:
---
Test 0, 0:
0000000 3232 3232 3232 3232                    
0000008
---
Test 0, 0, 0, 0:
---
What the kernel said:
relay_test: Doing test 0 on CPU 0.
relay_test: Doing test 1 on CPU 1.
relay_test: Doing test 2 on CPU 1.
relay_test: Doing test 3 on CPU 1.
relay_test: Doing test 0 on CPU 1.
relay_test: Doing test 0 on CPU 1.
relay_test: Doing test 0 on CPU 1.
relay_test: Doing test 0 on CPU 1.
relay_test: Doing test 0 on CPU 1.
relay_test: Doing test 0 on CPU 1.

The ugly script used to do this (on the second run I edited the file to
remove previous dmesg stuff):

#!/bin/bash
echo "Test 0:" > /output.vanilla
echo "0" > /debug/relay_test_trigger
sleep 1
hexdump /debug/relay_test_cpu* >> /output.vanilla
sleep 1
echo "---" >> /output.vanilla

echo "Test 1:" >> /output.vanilla
echo "1" > /debug/relay_test_trigger
sleep 1
hexdump /debug/relay_test_cpu* >> /output.vanilla
sleep 1
echo "---" >> /output.vanilla

echo "Test 2:" >> /output.vanilla
echo "2" > /debug/relay_test_trigger
sleep 1
hexdump /debug/relay_test_cpu* >> /output.vanilla
sleep 1
echo "---" >> /output.vanilla

echo "Test 3:" >> /output.vanilla
echo "3" > /debug/relay_test_trigger
sleep 1
hexdump /debug/relay_test_cpu* >> /output.vanilla
sleep 1
echo "---" >> /output.vanilla

echo "Test 0, 0:" >> /output.vanilla
echo "0" > /debug/relay_test_trigger
echo "0" > /debug/relay_test_trigger
sleep 1
hexdump /debug/relay_test_cpu* >> /output.vanilla
sleep 1
echo "---" >> /output.vanilla

echo "Test 0, 0, 0, 0:" >> /output.vanilla
echo "0" > /debug/relay_test_trigger
echo "0" > /debug/relay_test_trigger
echo "0" > /debug/relay_test_trigger
echo "0" > /debug/relay_test_trigger
sleep 1
hexdump /debug/relay_test_cpu* >> /output.vanilla
sleep 1
echo "---" >> /output.vanilla

echo "What the kernel said:" >> /output.vanilla
dmesg | grep relay_test >> /output.vanilla
