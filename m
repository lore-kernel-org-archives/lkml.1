Return-Path: <linux-kernel-owner+w=401wt.eu-S1757300AbYFWQaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300AbYFWQaX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 12:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755522AbYFWQaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 12:30:13 -0400
Received: from ns.theshore.net ([67.18.92.50]:37660 "EHLO www.theshore.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755026AbYFWQaM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 12:30:12 -0400
X-Greylist: delayed 835 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Jun 2008 12:30:12 EDT
Message-ID: <485FCC25.7090401@theshore.net>
Date: Mon, 23 Jun 2008 12:15:33 -0400
From: "Christopher S. Aker" <caker@theshore.net>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: xen devel <xen-devel@lists.xensource.com>
Subject: ext3 directory corruption under Xen
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've been seeing a rash of ext3 directory corruption occurring under 
Xen.  All but one of the reports have been with filesystems formatted 
with 1024 blocksize.  We have one report, that's potentialy the same 
bug, occurring on a filesystem with 4096 blocksize (either way, it was 
some type of corruption in that case).  In all cases, the filesystems 
were mounted with ext3's default journaling mode.  No quotas or anything 
else other than the default ext3 mount options.

It's happened on a number of different hosts, all of the same hardware 
and software configuration (Xen 3.2 64bit, 32bit pae dom0, 32bit pae 
domUs.  LVM backend with 3ware hardware RAID-1).  Some of those hosts 
were previously running non-virtaulized Linux and UML, using the 
identical guest images, and under that configuration never experienced 
this problem.

This has occurred under both 2.6.18-xenbits and the more recent pv_ops 
based kernels (2.6.24, 2.6.25), which I presume are all using the same 
blkfront driver code.

The common workloads from the reports seems to be active maildirs and rsync.

The initial errors reported back are all from fs/ext3/dir.c, in 
ext3_check_dir_entry(). Most commonly hit is the "rec_len % 4 != 0" 
check.  We've seen other checks trigger, but my assumption is that those 
happen after more stuff gets whacked out.

Eventually the fs will go read-only.  In extreme cases, the fs is chewed 
through enough that data is lost.

It's tricky to track down the trigger because you can only detect the 
corruption after it's happened.  Our attempts to reproduce this using 
various filesystem thrashing scripts haven't yielded a reliable way to 
trigger it, however we have been successful in triggering it twice -- in 
two weeks :( .

My hope is that this triggers an "a-hah" from someone in LKML or Xen 
land who has experience with this code, or that this is a known issue 
and a fix already lives.

We're scared.  Please help.

Thanks,
-Chris

