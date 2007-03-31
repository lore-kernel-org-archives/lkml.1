Return-Path: <linux-kernel-owner+w=401wt.eu-S933587AbXCaGwY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933587AbXCaGwY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 02:52:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933599AbXCaGwY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 02:52:24 -0400
Received: from brick.kernel.dk ([62.242.22.158]:27434 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933587AbXCaGwX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 02:52:23 -0400
Date: Sat, 31 Mar 2007 08:47:13 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Rene Herman <rene.herman@gmail.com>
Cc: Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: mcdx -- do_request(): non-read command to cd!!
Message-ID: <20070331064711.GF6246@kernel.dk>
References: <460D7F70.3090702@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <460D7F70.3090702@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 30 2007, Rene Herman wrote:
> Hi Al.
> 
> GIT doesn't remember, it's been too long, but IIRC you were the last one 
> to do some work on mcdx (the old proprietary mitsumi cd-rom driver). The 
> thing builds without warnings on 2.6.20.4, unlike most other proprietary 
> CD-ROM drivers, so someone did...
> 
> In any case, I just bet you're positively thrilled receiving bug-reports 
> for the thing right? Mmm?
> 
> I dug up a 1-speed Mitsumi CRMC-LU005S today. Brilliant drive! You push 
> on the front, after which it comes loose and you then yank the entire 
> drive, mechanism and all, out of its casing over some kind of magnetic 
> resistance it seems and then open a _second_ top-loading door, put in 
> the CD and follow the procedure backwards again. I've done that at least 
> 20 times now and I'm not by any means done yet. Brilliant.
> 
> The drive works fine under DOS (*), with both IRQ-less and IRQ-enabled 
> controllers. The linux driver does not work though:
> 
> root@5va2:~# modprobe mcdx
> 
> root@5va2:~# dmesg | tail -4
> mcdx Version 2.14(hs)
> mcdx $Id: mcdx.c,v 1.21 1997/01/26 07:12:59 davem Exp $
> Uniform CD-ROM driver Revision: 3.20
>  mcdx: Mitsumi CD-ROM installed at 0x300, irq 15. (Firmware version M 4)
> 
> root@5va2:~# mount /dev/mcdx0 /mnt/cdrom
> mount: block device /dev/mcdx0 is write-protected, mounting read-only
> mount: /dev/mcdx0: can't read superblock
> 
> root@5va2:~# dmesg | tail -4
>  mcdx: Mitsumi CD-ROM installed at 0x300, irq 15. (Firmware version M 4)
> mcdx do_request(): non-read command to cd!!
> end_request: I/O error, dev mcdx0, sector 0
> FAT: unable to read boot sector
> root@5va2:~#
> 
> This same 300/15 pair works under DOS in the same machine and IRQ15 is 
> firing. The error sounds very block-ish. Would you happen to know?
> 
> I'll happily test patches :-)

Try this.

diff --git a/drivers/cdrom/mcdx.c b/drivers/cdrom/mcdx.c
index f574962..7086313 100644
--- a/drivers/cdrom/mcdx.c
+++ b/drivers/cdrom/mcdx.c
@@ -577,6 +577,11 @@ static void do_mcdx_request(request_queue_t * q)
 	if (!req)
 		return;
 
+	if (!blk_fs_request(req)) {
+		end_request(req, 0);
+		goto again;
+	}
+
 	stuffp = req->rq_disk->private_data;
 
 	if (!stuffp->present) {
@@ -596,7 +601,7 @@ static void do_mcdx_request(request_queue_t * q)
 	xtrace(REQUEST, "do_request() (%lu + %lu)\n",
 	       req->sector, req->nr_sectors);
 
-	if (req->cmd != READ) {
+	if (rq_data_dir(req) != READ) {
 		xwarn("do_request(): non-read command to cd!!\n");
 		xtrace(REQUEST, "end_request(0): write\n");
 		end_request(req, 0);

-- 
Jens Axboe

