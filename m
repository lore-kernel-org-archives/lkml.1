Return-Path: <linux-kernel-owner+w=401wt.eu-S1751110AbXCWOFH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751110AbXCWOFH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2007 10:05:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbXCWOFH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Mar 2007 10:05:07 -0400
Received: from hosting4p.com ([81.0.235.160]:51659 "EHLO micron1.hosting4p.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751110AbXCWOFF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2007 10:05:05 -0400
Message-ID: <4603DE86.1090009@slax.org>
Date: Fri, 23 Mar 2007 15:04:54 +0100
From: Tomas M <tomas@slax.org>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [patch] [bugfix] loop.c
Content-Type: multipart/mixed;
 boundary="------------020902010905030705000707"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020902010905030705000707
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

I posted this yesterday but it seems people didn't understand the real 
goal of my patch. So I will explain once more again:

This is a bugfix for loop.c block driver, as it currently allocates more 
memory then it needs, without any further use.

If 'max_loop=255' parameter is given, the loop.c driver allocates this 
amount of memory:

   kmalloc(max_loop * sizeof(struct loop_device))

But in this case, (max_loop * sizeof) is greater than 65536, and thus 
kmalloc must allocate the next bigger size (which is 128KB of RAM).

Unfortunately the loop.c driver doesn't allow users to use bigger 
max_loop then 255 (for reasons which are completely obsolete) so the 
rest of memory is *unused*.

This patch doesn't fix unused memory in the case of max_loop=255, but 
rather it allows user to specify bigger max_loop (up to 455 on 386), so 
  the user can fully use all the memory, which would be allocated anyway.

Thank you for your consideration

Tomas M
slax.org

--------------020902010905030705000707
Content-Type: text/x-patch;
 name="loop.c.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="loop.c.diff"

--- linux/drivers/block/loop.c_old	2007-03-23 14:27:04.000000000 +0000
+++ linux/drivers/block/loop.c	2007-03-23 14:31:18.098458759 +0000
@@ -1358,7 +1358,7 @@
  * And now the modules code and kernel interface.
  */
 module_param(max_loop, int, 0);
-MODULE_PARM_DESC(max_loop, "Maximum number of loop devices (1-256)");
+MODULE_PARM_DESC(max_loop, "Maximum number of loop devices (455/355 on x86/x86_64)");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_BLOCKDEV_MAJOR(LOOP_MAJOR);
 
@@ -1402,9 +1402,9 @@
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
 
@@ -1465,7 +1465,7 @@
 	kfree(loop_dev);
 out_mem1:
 	unregister_blkdev(LOOP_MAJOR, "loop");
-	printk(KERN_ERR "loop: ran out of memory\n");
+	printk(KERN_ERR "loop: ran out of memory for max_loop=%d\n", max_loop);
 	return -ENOMEM;
 }
 

--------------020902010905030705000707--
