Return-Path: <linux-kernel-owner+w=401wt.eu-S1754918AbXGJE0R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918AbXGJE0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 00:26:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751054AbXGJE0E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 00:26:04 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:48962 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848AbXGJE0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 00:26:03 -0400
Message-ID: <469309FA.6040501@torque.net>
Date: Tue, 10 Jul 2007 00:24:26 -0400
From: Douglas Gilbert <dougg@torque.net>
Reply-To: dougg@torque.net
User-Agent: Thunderbird 2.0.0.4 (X11/20070615)
MIME-Version: 1.0
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
CC: Bruce Allen <ballen@gravity.phys.uwm.edu>, Mark Lord <liml@rtr.ca>,
       David Greaves <david@dgreaves.com>, Tejun Heo <htejun@gmail.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Jeff Garzik <jeff@garzik.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jan Dvorak <fermentol@gmail.com>,
       Klaus Fuerstberger <kfuerstberger@arcor.de>,
       Bruce Allen <bruce.allen@aei.mpg.de>, Robert Hancock <hancockr@shaw.ca>
Subject: Re: SMART problems in 2.6.22
References: <Pine.LNX.4.63.0707081910050.21572@trinity.phys.uwm.edu> <Pine.LNX.4.64.0707092341280.4779@kai.makisara.local>
In-Reply-To: <Pine.LNX.4.64.0707092341280.4779@kai.makisara.local>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Kai Makisara wrote:
> On Sun, 8 Jul 2007, Bruce Allen wrote:
> 
>> Mark, David, Doug, Tejin, Alan, Jeff, LKML,
>>
>> I'm afraid that there may be some problem with SMART + libata in the 2.6.22
>> kernel.  An hour ago I discovered that I missed a month of correspondence
>> (some LKML, some private) about this problem which Alan, Tejun, Jeff, Mark and
>> others copied to me -- it was automatically shoved into one of my mailboxes by
>> my mail client.  Sorry about that.  So I am trying to catch up to see if there
>> is some real problem or not.
>>
>> Here is a typical bug report that worries me:
>> http://article.gmane.org/gmane.linux.utilities.smartmontools/4712
>>
>> Here is another similar report:
>> http://thread.gmane.org/gmane.linux.utilities.smartmontools/4713
>>
>> And another report:
>> http://www.mail-archive.com/debian-bugs-dist@lists.debian.org/msg358354.html
>>
>> >From some of the earlier threads that I missed (below) I have the impression
>> that the problem may be a very simple one, namely that starting with 2.6.22
>> one needs to run a command to enable SMART when a box is first booted -- the
>> kernel no longer does this as part of the init/setup of the disks. But that is
>> NOT consistent with the first two reports above, which show 'SMART ENABLED'.
>>
>> Here are some of the earlier threads that I completely missed:
>>
>> http://www.ussg.iu.edu/hypermail/linux/kernel/0706.1/0849.html
> 
> I have done some more debugging on this one. An easy way to reproduce the 
> problem is to use 'smartctl -H /dev/sdb'. If I enable debugging with '-r 
> ioctl,2', I find the following difference between outputs using 2.6.21.1 
> (works OK) and 2.6.22 (fails):
> 
> --- sm-2.6.21.1b.log    2007-07-09 23:47:28.000000000 +0300
> +++ sm-2.6.22.log       2007-07-09 23:39:56.000000000 +0300
> @@ -11,7 +11,7 @@
>    status=0x0
>   [ata pass-through(16): 85 08 0e 00 00 00 01 00 00 00 00 00 00 00 ec 00 ]
>    scsi_status=0x0, host_status=0x0, driver_status=0x0
> -  info=0x0  duration=0 milliseconds  resid=0
> +  info=0x0  duration=4 milliseconds  resid=0
>    Incoming data, len=512 [only first 256 bytes shown]:
>   00     5a 0c ff 3f 37 c8 10 00  00 00 00 00 3f 00 00 00                        
>   10     00 00 00 00 20 20 20 20  20 20 20 20 20 20 20 20                        
> @@ -97,11 +97,11 @@
>    scsi_status=0x2, host_status=0x0, driver_status=0x8
>    info=0x1  duration=48 milliseconds  resid=0
>    >>> Sense buffer, len=22:
> - 00     72 00 00 00 00 00 00 0e  09 0c 00 00 00 00 00 00                        
> - 10     00 4f 00 c2 00 50                                                       
> + 00     72 00 00 00 00 00 00 0e  09 0c 00 00 00 01 00 00                        
> + 10     00 00 00 00 00 50                                                       
>    status=2: [desc] sense_key=0 asc=0 ascq=0
>  Values from ATA status return descriptor are:
> - 00     09 0c 00 00 00 00 00 00  00 4f 00 c2 00 50                              
> + 00     09 0c 00 00 00 01 00 00  00 00 00 00 00 50                              
>  REPORT-IOCTL: DeviceFD=3 Command=SMART STATUS returned 0
>  
>  REPORT-IOCTL: DeviceFD=3 Command=SMART STATUS CHECK
> @@ -110,9 +110,13 @@
>    info=0x1  duration=40 milliseconds  resid=0
>    >>> Sense buffer, len=22:
>   00     72 00 00 00 00 00 00 0e  09 0c 00 00 00 00 00 00                        
> - 10     00 4f 00 c2 00 50                                                       
> + 10     00 00 00 00 00 50                                                       
>    status=2: [desc] sense_key=0 asc=0 ascq=0
>  Values from ATA status return descriptor are:
> - 00     09 0c 00 00 00 00 00 00  00 4f 00 c2 00 50                              
> -REPORT-IOCTL: DeviceFD=3 Command=SMART STATUS CHECK returned 0
> -
> + 00     09 0c 00 00 00 00 00 00  00 00 00 00 00 50                              
> +Error SMART Status command failed
> +Please get assistance from http://smartmontools.sourceforge.net/
> +Values from ATA status return descriptor are:
> + 00     09 0c 00 00 00 00 00 00  00 00 00 00 00 50                              
> +REPORT-IOCTL: DeviceFD=3 Command=SMART STATUS CHECK returned -1
> +A mandatory SMART command failed: exiting. To continue, add one or more 
> '-T permissive' options.
> 
> 
> The log shows that the sense data returned by the commands differ: with 
> 2.6.22 the bytes 4f and 2c (tf.lbam and tf.lbah) are not returned. Both of 
> the status commands fail to return these bytes but the tests in smartctl 
> are more strict for the second case. This is why the second status command 
> seems to be failing.
> 
> Next I added printks to the function ata_qc_complete() in libata-core.c. 
> The changed code from 2.6.22 at line 5222 looked like this:
> 
>                 /* read result TF if requested */
>                 if (qc->flags & ATA_QCFLAG_RESULT_TF) {
>                         if (qc->tf.feature == 0xda)
>                                 printk("ata_qc_complete before: %02x %02x %02x %02x\n",
>                                        qc->result_tf.feature,
>                                        qc->result_tf.lbam, qc->result_tf.lbah,
>                                        qc->result_tf.command);
>                         fill_result_tf(qc);
>                         if (qc->tf.feature == 0xda)
>                                 printk("ata_qc_complete %ld: %02x %02x %02x %02x\n",
>                                        qc->flags & ATA_QCFLAG_RESULT_TF,
>                                        qc->result_tf.feature,
>                                        qc->result_tf.lbam, qc->result_tf.lbah,
>                                        qc->result_tf.command);
>                 }
> 
> The output from 2.6.21.6 looks like this:
> 
> Jul  9 18:37:44 kai kernel: [  193.443874] ata_qc_complete before: 00 00 00 40
> Jul  9 18:37:44 kai kernel: [  193.443880] ata_qc_complete 16: 00 4f c2 50
> Jul  9 18:37:44 kai kernel: [  193.462802] ata_qc_complete before: 00 4f c2 40
> Jul  9 18:37:44 kai kernel: [  193.462807] ata_qc_complete 16: 00 4f c2 50
> 
> i.e., the bytes are returned.
> 
> The output from 2.6.22 is different:
> 
> Jul  9 18:44:35 kai kernel: [  147.765965] ata_qc_complete before: 00 00 00 40
> Jul  9 18:44:35 kai kernel: [  147.765970] ata_qc_complete 16: 00 00 00 50
> Jul  9 18:44:35 kai kernel: [  147.784890] ata_qc_complete before: 00 00 00 40
> Jul  9 18:44:35 kai kernel: [  147.784894] ata_qc_complete 16: 00 00 00 50
> 
> The lbam and lbah bytes are not returned but the command byte is.
> 
> fill_result_tf() basically calls the tf_read() method of the low-level  
> driver. sata_nc has been changed between 2.6.21 and 2.6.22-rc1 and this 
> particular smartctl problem may or may not be specific to CK804. Disabling 
> adma did not change the results.

Kai,
Thanks for the analysis.
Some background documents for those interested:
The SCSI to ATA Translation (SAT) draft:
   http://www.t10.org/ftp/t10/drafts/sat/sat-r09.pdf
in which the relevant section is 12.2.6 (page 110)
table 93.
A modern descriptor-based SCSI sense buffer is being used
to convey the "ATA (status) return descriptor" back from
the ATA device after the command has been completed.
My SAT code in smartmontools requests this descriptor
so it should be returned irrespective of whether the
ATA command succeeded or failed.

Now from the ATA side the command being executed is
"SMART RETURN STATUS  B0h/DAh, non-data". For
reference I use this draft from www.t13.org :
D1699r3f-ATA8-ACS.pdf . See that command's
_description_ section. That explains that 4f and c2
in the LBA field indicates the disk is healthy. "threshold
exceeded" is indicated by putting f4 and 2c in the same
positions. [Whoever specified that must have hated people
with dyslexia.] No ATA command error is indicated ("abort"
is the only one listed for that ATA command) in the reports
that I have seen.

So when smartmontools sees 0 and 0 in those positions it
pulls out the red card for that device. My guess is that
libata in lk 2.6.22 is corrupting those FIS device to
host register values.


Doug Gilbert


