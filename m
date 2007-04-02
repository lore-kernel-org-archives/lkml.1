Return-Path: <linux-kernel-owner+w=401wt.eu-S1751033AbXDBADx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751033AbXDBADx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 20:03:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbXDBADx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 20:03:53 -0400
Received: from smtpq1.groni1.gr.home.nl ([213.51.130.200]:37826 "EHLO
	smtpq1.groni1.gr.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbXDBADx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 20:03:53 -0400
Message-ID: <4610481D.8000102@gmail.com>
Date: Mon, 02 Apr 2007 02:02:37 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Jens Axboe <jens.axboe@oracle.com>, Al Viro <viro@ftp.linux.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: mcdx -- do_request(): non-read command to cd!!
References: <460D7F70.3090702@gmail.com> <20070331064711.GF6246@kernel.dk>	 <460EA727.8070306@gmail.com> <84144f020704010306q600f58ddge1d42753362cf4e2@mail.gmail.com>
In-Reply-To: <84144f020704010306q600f58ddge1d42753362cf4e2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2007 12:06 PM, Pekka Enberg wrote:

> Looks like mcdx_xfer is sleeping while holding q->queue_lock. The 
> attached (untested) patch should fix it.

This (including your followup) does indeed avoid the traces in the 
kernel log, but unfortunately, the driver seems to need a bit more.

This may be expected, I'm not sure:

root@5va2:~# dd if=/dev/mcdx0 of=/dev/null bs=2048
0+0 records in
0+0 records out
0 bytes (0 B) copied, 0.000221955 seconds, 0.0 kB/s
root@5va2:~#

This I know isn't:

root@5va2:~# readcd dev=/dev/mcdx0 f=/dev/null
Segmentation fault
root@5va2:~#

(leaves a "note: readcd[1174] exited with preempt_count 1" in the log)

and after a "mount -t iso9660 /dev/mcdx0 /mnt/cdrom",  a:

root@5va2:~# tar cv /mnt/cdrom >/dev/null

has upto now done all of:

1) segfault
2) make the kernel oops
3) reset the machine

This thing is just so badly broken... ;-(

I've attached the current patches from Jens and yourself (against 
2.6.20.4) as a double check, but the driver's still totally unuseable 
even with them...

I own two other legacy drives; a Panasonic CR562 (sbpcd.c) and a Sony 
CDU33A (cdu31a.c) which together with this Mitsumi LU005S (mcdx.c) make 
up also all but one of the controllers I have; a few standalone, but 
most on old ISA soundcards. When I last tested, cdu31a somewhat worked 
and sbpcd didn't. Had high hopes for mcdx.c upon seeing it compile 
without warnings, but alas.

Last time Al Viro suggested ripping them out, I slightly objected:

http://lkml.org/lkml/2004/5/2/123

but well, although I like playing with this stuff, I still don't know 
the first thing about the block layer and given the shape these things 
are in...

Many thanks for looking though!

Rene.

