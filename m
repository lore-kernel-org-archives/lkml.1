Return-Path: <linux-kernel-owner+w=401wt.eu-S1757442AbXGIVLk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442AbXGIVLk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 17:11:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754589AbXGIVLb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 17:11:31 -0400
Received: from emh05.mail.saunalahti.fi ([62.142.5.111]:42116 "EHLO
	emh05.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753565AbXGIVLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 17:11:30 -0400
Date: Tue, 10 Jul 2007 00:11:16 +0300 (EEST)
From: Kai Makisara <Kai.Makisara@kolumbus.fi>
X-X-Sender: makisara@kai.makisara.local
To: Bruce Allen <ballen@gravity.phys.uwm.edu>
cc: Mark Lord <liml@rtr.ca>, David Greaves <david@dgreaves.com>,
       Douglas Gilbert <dougg@torque.net>, Tejun Heo <htejun@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Dvorak <fermentol@gmail.com>,
       Klaus Fuerstberger <kfuerstberger@arcor.de>,
       Bruce Allen <bruce.allen@aei.mpg.de>, Robert Hancock <hancockr@shaw.ca>
Subject: Re: SMART problems in 2.6.22
In-Reply-To: <Pine.LNX.4.63.0707081910050.21572@trinity.phys.uwm.edu>
Message-ID: <Pine.LNX.4.64.0707092341280.4779@kai.makisara.local>
References: <Pine.LNX.4.63.0707081910050.21572@trinity.phys.uwm.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Antivirus: VAMS
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jul 2007, Bruce Allen wrote:

> Mark, David, Doug, Tejin, Alan, Jeff, LKML,
> 
> I'm afraid that there may be some problem with SMART + libata in the 2.6.22
> kernel.  An hour ago I discovered that I missed a month of correspondence
> (some LKML, some private) about this problem which Alan, Tejun, Jeff, Mark and
> others copied to me -- it was automatically shoved into one of my mailboxes by
> my mail client.  Sorry about that.  So I am trying to catch up to see if there
> is some real problem or not.
> 
> Here is a typical bug report that worries me:
> http://article.gmane.org/gmane.linux.utilities.smartmontools/4712
> 
> Here is another similar report:
> http://thread.gmane.org/gmane.linux.utilities.smartmontools/4713
> 
> And another report:
> http://www.mail-archive.com/debian-bugs-dist@lists.debian.org/msg358354.html
> 
> >From some of the earlier threads that I missed (below) I have the impression
> that the problem may be a very simple one, namely that starting with 2.6.22
> one needs to run a command to enable SMART when a box is first booted -- the
> kernel no longer does this as part of the init/setup of the disks. But that is
> NOT consistent with the first two reports above, which show 'SMART ENABLED'.
> 
> Here are some of the earlier threads that I completely missed:
> 
> http://www.ussg.iu.edu/hypermail/linux/kernel/0706.1/0849.html

I have done some more debugging on this one. An easy way to reproduce the 
problem is to use 'smartctl -H /dev/sdb'. If I enable debugging with '-r 
ioctl,2', I find the following difference between outputs using 2.6.21.1 
(works OK) and 2.6.22 (fails):

--- sm-2.6.21.1b.log    2007-07-09 23:47:28.000000000 +0300
+++ sm-2.6.22.log       2007-07-09 23:39:56.000000000 +0300
@@ -11,7 +11,7 @@
   status=0x0
  [ata pass-through(16): 85 08 0e 00 00 00 01 00 00 00 00 00 00 00 ec 00 ]
   scsi_status=0x0, host_status=0x0, driver_status=0x0
-  info=0x0  duration=0 milliseconds  resid=0
+  info=0x0  duration=4 milliseconds  resid=0
   Incoming data, len=512 [only first 256 bytes shown]:
  00     5a 0c ff 3f 37 c8 10 00  00 00 00 00 3f 00 00 00                        
  10     00 00 00 00 20 20 20 20  20 20 20 20 20 20 20 20                        
@@ -97,11 +97,11 @@
   scsi_status=0x2, host_status=0x0, driver_status=0x8
   info=0x1  duration=48 milliseconds  resid=0
   >>> Sense buffer, len=22:
- 00     72 00 00 00 00 00 00 0e  09 0c 00 00 00 00 00 00                        
- 10     00 4f 00 c2 00 50                                                       
+ 00     72 00 00 00 00 00 00 0e  09 0c 00 00 00 01 00 00                        
+ 10     00 00 00 00 00 50                                                       
   status=2: [desc] sense_key=0 asc=0 ascq=0
 Values from ATA status return descriptor are:
- 00     09 0c 00 00 00 00 00 00  00 4f 00 c2 00 50                              
+ 00     09 0c 00 00 00 01 00 00  00 00 00 00 00 50                              
 REPORT-IOCTL: DeviceFD=3 Command=SMART STATUS returned 0
 
 REPORT-IOCTL: DeviceFD=3 Command=SMART STATUS CHECK
@@ -110,9 +110,13 @@
   info=0x1  duration=40 milliseconds  resid=0
   >>> Sense buffer, len=22:
  00     72 00 00 00 00 00 00 0e  09 0c 00 00 00 00 00 00                        
- 10     00 4f 00 c2 00 50                                                       
+ 10     00 00 00 00 00 50                                                       
   status=2: [desc] sense_key=0 asc=0 ascq=0
 Values from ATA status return descriptor are:
- 00     09 0c 00 00 00 00 00 00  00 4f 00 c2 00 50                              
-REPORT-IOCTL: DeviceFD=3 Command=SMART STATUS CHECK returned 0
-
+ 00     09 0c 00 00 00 00 00 00  00 00 00 00 00 50                              
+Error SMART Status command failed
+Please get assistance from http://smartmontools.sourceforge.net/
+Values from ATA status return descriptor are:
+ 00     09 0c 00 00 00 00 00 00  00 00 00 00 00 50                              
+REPORT-IOCTL: DeviceFD=3 Command=SMART STATUS CHECK returned -1
+A mandatory SMART command failed: exiting. To continue, add one or more 
'-T permissive' options.


The log shows that the sense data returned by the commands differ: with 
2.6.22 the bytes 4f and 2c (tf.lbam and tf.lbah) are not returned. Both of 
the status commands fail to return these bytes but the tests in smartctl 
are more strict for the second case. This is why the second status command 
seems to be failing.

Next I added printks to the function ata_qc_complete() in libata-core.c. 
The changed code from 2.6.22 at line 5222 looked like this:

                /* read result TF if requested */
                if (qc->flags & ATA_QCFLAG_RESULT_TF) {
                        if (qc->tf.feature == 0xda)
                                printk("ata_qc_complete before: %02x %02x %02x %02x\n",
                                       qc->result_tf.feature,
                                       qc->result_tf.lbam, qc->result_tf.lbah,
                                       qc->result_tf.command);
                        fill_result_tf(qc);
                        if (qc->tf.feature == 0xda)
                                printk("ata_qc_complete %ld: %02x %02x %02x %02x\n",
                                       qc->flags & ATA_QCFLAG_RESULT_TF,
                                       qc->result_tf.feature,
                                       qc->result_tf.lbam, qc->result_tf.lbah,
                                       qc->result_tf.command);
                }

The output from 2.6.21.6 looks like this:

Jul  9 18:37:44 kai kernel: [  193.443874] ata_qc_complete before: 00 00 00 40
Jul  9 18:37:44 kai kernel: [  193.443880] ata_qc_complete 16: 00 4f c2 50
Jul  9 18:37:44 kai kernel: [  193.462802] ata_qc_complete before: 00 4f c2 40
Jul  9 18:37:44 kai kernel: [  193.462807] ata_qc_complete 16: 00 4f c2 50

i.e., the bytes are returned.

The output from 2.6.22 is different:

Jul  9 18:44:35 kai kernel: [  147.765965] ata_qc_complete before: 00 00 00 40
Jul  9 18:44:35 kai kernel: [  147.765970] ata_qc_complete 16: 00 00 00 50
Jul  9 18:44:35 kai kernel: [  147.784890] ata_qc_complete before: 00 00 00 40
Jul  9 18:44:35 kai kernel: [  147.784894] ata_qc_complete 16: 00 00 00 50

The lbam and lbah bytes are not returned but the command byte is.

fill_result_tf() basically calls the tf_read() method of the low-level  
driver. sata_nc has been changed between 2.6.21 and 2.6.22-rc1 and this 
particular smartctl problem may or may not be specific to CK804. Disabling 
adma did not change the results.

-- 
Kai

