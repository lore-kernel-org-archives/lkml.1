Return-Path: <linux-kernel-owner+w=401wt.eu-S1753112AbZLAAso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112AbZLAAso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 19:48:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751793AbZLAAsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 19:48:42 -0500
Received: from 207-172-212-176.c3-0.smr-ubr2.sbo-smr.ma.static.cable.rcn.com ([207.172.212.176]:51329
	"EHLO torpor.static.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503AbZLAAsl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 19:48:41 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Apple Message framework v1077)
Subject: Re: writev data loss bug in (at least) 2.6.31 and 2.6.32pre8 x86-64
From: James Y Knight <foom@fuhm.net>
In-Reply-To: <1F5364AE-321E-44E9-8B0D-B8E17597A0DA@fuhm.net>
Date: Mon, 30 Nov 2009 19:48:39 -0500
Content-Transfer-Encoding: 8BIT
Message-Id: <907888CC-F4B2-448F-8F48-B96A566D323B@fuhm.net>
References: <1F5364AE-321E-44E9-8B0D-B8E17597A0DA@fuhm.net>
To: linux-kernel@vger.kernel.org
X-Mailer: Apple Mail (2.1077)
X-Spam-Score: -10.0
X-Spam-Report: ALL_TRUSTED=-10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 30, 2009, at 3:55 PM, James Y Knight wrote:

> This test case fails in 2.6.23-2.6.25, because of the bug fixed in 864f24395c72b6a6c48d13f409f986dc71a5cf4a, and now again in at least 2.6.31 and 2.6.32pre8 because of a *different* bug. This test *does not* fail 2.6.26. I have not tested anything between 2.6.26 and 2.6.31.
> 
> The bug in 2.6.31 is definitely not the same bug as 2.6.23's. This time, the zero'd area of the file doesn't show up immediately upon writing the file. Instead, the kernel waits to mangle the file until it has to flush the buffer to disk. *THEN* it zeros out parts of the file.
> 
> So, after writing out the new file with writev, and checking the md5sum (which is correct), this test case asks the kernel to flush the cache for that file, and then checks the md5sum again. ONLY THEN is the file corrupted. That is, I won't hesitate to say *incredibly evil* behavior: it took me quite some time to figure out WTH was going wrong with my program before determining it was a kernel bug.
> 
> This test case is distilled from an actual application which doesn't even intentionally use writev: it just uses C++'s ofstream class to write data to a file. Unfortunately, that class smart and uses writev under the covers. Unfortunately, I guess nobody ever tests linux writev behavior, since it's broken _so_much_of_the_time_. I really am quite astounded to see such a bad track record for such a fundamental core system call....
> 
> My /tmp is an ext3 filesystem, in case that matters.

Further testing shows that the filesystem type *does* matter. The bug does not exhibit when the test is run on ext2, ext4, vfat, btrfs, jfs, or xfs (and probably all the others too). Only, so far as I can determine, on ext3.

Thanks,
James