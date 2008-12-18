Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbYLRWOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbYLRWOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 17:14:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbYLRWOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 17:14:46 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:36608 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752218AbYLRWOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 17:14:45 -0500
Date: Thu, 18 Dec 2008 17:14:44 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jens Axboe <axboe@kernel.dk>
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Checking a USB drive's capacity
Message-ID: <Pine.LNX.4.44L0.0812181641540.2217-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens:

As you may know, there are plenty of USB mass-storage devices that
respond incorrectly to READ CAPACITY: They report the total number of
blocks instead of the highest block number.  As a result, the kernel 
thinks the drive has one more sector than it really does.

So far we have dealt with this problem by means of a blacklist, but
this gets more and more unsatisfactory all the time.  We haven't been
able to find any other way to cope, since a few devices are so badly
behaved that they crash hard when you try to access the nonexistent
"last" sector, requiring a replug or power cycle.

My new idea is to keep in the blacklist only those devices which do
crash -- a relatively small number.  Everything else we should be able
to detect safely at runtime, by testing if it's possible to read the
last sector.

The question is, how and where?  The logical place for testing the
capacity is near the end of sd_read_capacity().  However this code runs
before any media accesses have occurred; the drive might not even be
spun up yet.  Not to mention that it seems strange to read the last
sector before reading the first!

It would make more sense to carry out this test after the first sector
has been read.  That's done by the partition management code in the
gendisk layer.  Would near the end of check_partition() be an
appropriate place to make the test?  And could I essentially copy the
code in scsi_ioctl.c:__blk_send_generic()?

Alan Stern

