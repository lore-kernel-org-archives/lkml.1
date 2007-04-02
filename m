Return-Path: <linux-kernel-owner+w=401wt.eu-S1751220AbXDBAJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751220AbXDBAJF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 20:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751404AbXDBAJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 20:09:05 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:57419 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220AbXDBAJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 20:09:03 -0400
Message-ID: <46104954.50608@gmail.com>
Date: Mon, 02 Apr 2007 02:07:48 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Jens Axboe <jens.axboe@oracle.com>, Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: mcdx -- do_request(): non-read command to cd!!
References: <460D7F70.3090702@gmail.com> <20070331064711.GF6246@kernel.dk>	 <460EA727.8070306@gmail.com> <84144f020704010306q600f58ddge1d42753362cf4e2@mail.gmail.com> <4610481D.8000102@gmail.com>
In-Reply-To: <4610481D.8000102@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------090204060209020406000206"
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090204060209020406000206
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 04/02/2007 02:02 AM, Rene Herman wrote:

> On 04/01/2007 12:06 PM, Pekka Enberg wrote:
> 
>> Looks like mcdx_xfer is sleeping while holding q->queue_lock. The 
>> attached (untested) patch should fix it.
> 
> This (including your followup) does indeed avoid the traces in the 
> kernel log, but unfortunately, the driver seems to need a bit more.
> 
> This may be expected, I'm not sure:
> 
> root@5va2:~# dd if=/dev/mcdx0 of=/dev/null bs=2048
> 0+0 records in
> 0+0 records out
> 0 bytes (0 B) copied, 0.000221955 seconds, 0.0 kB/s
> root@5va2:~#
> 
> This I know isn't:
> 
> root@5va2:~# readcd dev=/dev/mcdx0 f=/dev/null
> Segmentation fault
> root@5va2:~#
> 
> (leaves a "note: readcd[1174] exited with preempt_count 1" in the log)
> 
> and after a "mount -t iso9660 /dev/mcdx0 /mnt/cdrom",  a:
> 
> root@5va2:~# tar cv /mnt/cdrom >/dev/null
> 
> has upto now done all of:
> 
> 1) segfault
> 2) make the kernel oops
> 3) reset the machine
> 
> This thing is just so badly broken... ;-(
> 
> I've attached the current patches from Jens and yourself (against 
> 2.6.20.4) as a double check, but the driver's still totally unuseable 
> even with them...

No, I didn't.

> I own two other legacy drives; a Panasonic CR562 (sbpcd.c) and a Sony 
> CDU33A (cdu31a.c) which together with this Mitsumi LU005S (mcdx.c) make 
> up also all but one of the controllers I have; a few standalone, but 
> most on old ISA soundcards. When I last tested, cdu31a somewhat worked 
> and sbpcd didn't. Had high hopes for mcdx.c upon seeing it compile 
> without warnings, but alas.
> 
> Last time Al Viro suggested ripping them out, I slightly objected:
> 
> http://lkml.org/lkml/2004/5/2/123
> 
> but well, although I like playing with this stuff, I still don't know 
> the first thing about the block layer and given the shape these things 
> are in...
> 
> Many thanks for looking though!

Rene.

--------------090204060209020406000206
Content-Type: text/plain;
 name="mcdx.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="mcdx.diff"

--- drivers/cdrom/mcdx.c.orig	2007-04-02 00:25:09.000000000 +0200
+++ drivers/cdrom/mcdx.c	2007-04-02 00:37:53.000000000 +0200
@@ -577,11 +577,20 @@
 	if (!req)
 		return;
 
+	if (!blk_fs_request(req)) {
+		spin_lock_irq(q->queue_lock);
+		end_request(req, 0);
+		goto again;
+	}
+
+	spin_unlock_irq(q->queue_lock);
+
 	stuffp = req->rq_disk->private_data;
 
 	if (!stuffp->present) {
 		xwarn("do_request(): bad device: %s\n",req->rq_disk->disk_name);
 		xtrace(REQUEST, "end_request(0): bad device\n");
+		spin_lock_irq(q->queue_lock);
 		end_request(req, 0);
 		return;
 	}
@@ -589,6 +598,7 @@
 	if (stuffp->audio) {
 		xwarn("do_request() attempt to read from audio cd\n");
 		xtrace(REQUEST, "end_request(0): read from audio\n");
+		spin_lock_irq(q->queue_lock);
 		end_request(req, 0);
 		return;
 	}
@@ -596,9 +606,10 @@
 	xtrace(REQUEST, "do_request() (%lu + %lu)\n",
 	       req->sector, req->nr_sectors);
 
-	if (req->cmd != READ) {
+	if (rq_data_dir(req) != READ) {
 		xwarn("do_request(): non-read command to cd!!\n");
 		xtrace(REQUEST, "end_request(0): write\n");
+		spin_lock_irq(q->queue_lock);
 		end_request(req, 0);
 		return;
 	}
@@ -613,6 +624,7 @@
 					  req->nr_sectors);
 
 			if (i == -1) {
+				spin_lock_irq(q->queue_lock);
 				end_request(req, 0);
 				goto again;
 			}
@@ -620,10 +632,12 @@
 			req->nr_sectors -= i;
 			req->buffer += (i * 512);
 		}
+		spin_lock_irq(q->queue_lock);
 		end_request(req, 1);
 		goto again;
 
 		xtrace(REQUEST, "end_request(1)\n");
+		spin_lock_irq(q->queue_lock);
 		end_request(req, 1);
 	}
 

--------------090204060209020406000206--
