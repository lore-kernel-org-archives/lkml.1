Return-Path: <linux-kernel-owner+w=401wt.eu-S1756243AbYAGMZk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbYAGMZk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 07:25:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754735AbYAGMZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 07:25:33 -0500
Received: from smtp.seznam.cz ([77.75.72.43]:42358 "HELO smtp.seznam.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754593AbYAGMZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 07:25:33 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 07 Jan 2008 07:25:32 EST
From: "Frantisek Rysanek" <Frantisek.Rysanek@post.cz>
To: linux-kernel@vger.kernel.org
Date: Mon, 07 Jan 2008 13:25:09 +0100
MIME-Version: 1.0
Subject: [noob q. on block layer] block IO read-ahead during sequential *write*?
Message-ID: <47822835.4182.1ADF8AE7@localhost>
X-mailer: Pegasus Mail for Windows (4.21c)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Smtpd: 1.0.26@12465M
X-Seznam-User: frantisek.rysanek@post.cz
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Everyone,

let me start with a simple example. The following commands:

 cp /dev/zero /dev/hda
 dd if=/dev/zero of=/dev/hda [bs=512]

both have one common side-effect: apart from the disk being properly 
overwritten with zeroes, the kernel seems to keep reading sectors 
ahead of the current seek position of the sequential write.

This is kernel 2.6.22.6 and around that - previously 2.6.16.* and 
2.6.18.* . I believe Linux 2.4 kernels didn't do that.

I observe that behavior using `iostat 1` (from the Sysstat package). 
After I spotted the behavior, I first upgraded to Sysstat 8.0.3 
(latest at the time) to avoid any possible misinterpretation of 
/proc/diskstats or what the relevant /proc node is. The upgrade 
brought no difference.

I'm using commands along those lines to erase hard drives, to check 
their sequential write speed, and as an additional test when checking 
for bad sectors / flawed behavior that goes unreported by SMART.
The read-ahead skews my view of sequential write performance :-)

Note that if I specify count=<some fixed number> to 'dd', 
the read-ahead doesn't kick in.

Makes me wonder if perhaps "cp" and "dd without count=" perform their 
writes un-aligned to sector boundaries, so that the Linux block layer 
feels obliged to prefetch the trailing sector that gets only 
partially written within a given transaction. It's weird though.
At least bs=512 should be aligned to sector boundaries, even if 
uncounted. And, it doesn't seem like every N'th sector - the read and 
write rates are about equal.

I've already discovered "hdparm -a", and some follow-ups called 
ioctl(BLKRASET) and 'bdi->ra_pages' in $KERNEL_SRC/block/* .
That's where I got stuck - trying to understand the whole read-ahead 
logic from the source code would take me too long to be worth it.
That's when I resorted to posting this to the LKML...

Is "hdparm -a" my only chance? Is there any kernel command line 
argument or /proc entry or ioctl() to modify this behavior 
selectively for writes? Should I write my own test prog, 
that will take care to strictly walk the sector boundaries?

Any ideas are welcome :-)

Frank Rysanek


