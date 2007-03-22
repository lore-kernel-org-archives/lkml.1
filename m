Return-Path: <linux-kernel-owner+w=401wt.eu-S965864AbXCVIpq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965864AbXCVIpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 04:45:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965869AbXCVIpp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 04:45:45 -0400
Received: from hosting4p.com ([81.0.235.160]:42973 "EHLO micron1.hosting4p.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965864AbXCVIpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 04:45:44 -0400
X-Greylist: delayed 2930 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Mar 2007 04:45:44 EDT
Message-ID: <460236CE.1030303@slax.org>
Date: Thu, 22 Mar 2007 08:57:02 +0100
From: Tomas M <tomas@slax.org>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: max_loop limit
Content-Type: multipart/mixed;
 boundary="------------060801080908060703070002"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060801080908060703070002
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hello,

this is my first code submitted to kernel, I hope you won't hate it.

This 4-lines-change patch adds support for nearly two-times more loop
devices. Explanation follows:

The maximum amount of loop devices has been 255 for many years, while
there is a lot of space for more. The maximum depends on max memory
available from kmalloc(), which is usually 128KB, but can be increased
in some cases.

It would be better to support thousands of loop devices of course, but
the change could be more complicated (perhaps replace kmalloc by
vmalloc). This four lines change is just simple and sufficient, without
any need for kmalloc replacement.

I only removed the test if (max_loop > 255), so now we support much more
loop devices then before, without ANY OTHER CHANGE to the code.

Information: The maximum max_loop is 455 if kmalloc can allocate 128KB,
so the amount is nearly doubled without any significant change to kernel
code. The maximum could be even bigger I guess, it probably depends on:
NR_CPUS, MAX_NUMNODES, CONFIG_MMU and CONFIG_LARGE_ALLOCS.

If kmalloc can't allocate enough RAM, loop is simply unloaded.


Thank you for your consideration.

I hope you will like it and you will include it in kernel.
Or, if not, maybe this patch will start some debate regarding
the current insufficient limit of 255 loop devices.


Tomas M
slax.org



--------------060801080908060703070002
Content-Type: text/x-patch;
 name="loop.c.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="loop.c.diff"

--- linux/drivers/block/loop_old.c	2007-02-04 18:44:54.000000000 +0000
+++ linux/drivers/block/loop.c	2007-03-22 08:31:55.000000000 +0000
@@ -44,6 +44,16 @@
  * backing filesystem.
  * Anton Altaparmakov, 16 Feb 2005
  *
+ * The maximum amount of loop devices has been 255 for many years, while there
+ * is a lot of space for more. The maximum depends on max memory available 
+ * from kmalloc, which is usually 128KB, but can be even more.
+ * I removed the test if (max_loop > 255), so now we support much more loop 
+ * devices then before; it probably depends on:
+ *    NR_CPUS, MAX_NUMNODES, CONFIG_MMU and CONFIG_LARGE_ALLOCS.
+ * Information: The maximum max_loop is 455 if kmalloc handles only 128KB.
+ * If kmalloc can't allocate enough RAM, loop is simply unloaded.
+ * Author: Tomas Matejicek, www.slax.org, 21 Mar 2007
+ *
  * Still To Fix:
  * - Advisory locking is ignored here.
  * - Should use an own CAP_* category instead of CAP_SYS_ADMIN
@@ -1358,7 +1368,7 @@
  * And now the modules code and kernel interface.
  */
 module_param(max_loop, int, 0);
-MODULE_PARM_DESC(max_loop, "Maximum number of loop devices (1-256)");
+MODULE_PARM_DESC(max_loop, "Maximum number of loop devices (1-455 on i386)");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_BLOCKDEV_MAJOR(LOOP_MAJOR);
 
@@ -1402,9 +1412,9 @@
 {
 	int	i;
 
-	if (max_loop < 1 || max_loop > 256) {
-		printk(KERN_WARNING "loop: invalid max_loop (must be between"
-				    " 1 and 256), using default (8)\n");
+	if (max_loop < 1) {
+		printk(KERN_WARNING "loop: invalid max_loop (must be at least 1"
+				    ", using default (8)\n");
 		max_loop = 8;
 	}
 
@@ -1465,7 +1475,7 @@
 	kfree(loop_dev);
 out_mem1:
 	unregister_blkdev(LOOP_MAJOR, "loop");
-	printk(KERN_ERR "loop: ran out of memory\n");
+	printk(KERN_ERR "loop: ran out of memory for max_loop=%d\n", max_loop);
 	return -ENOMEM;
 }
 

--------------060801080908060703070002--
