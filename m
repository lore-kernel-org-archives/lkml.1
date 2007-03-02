Return-Path: <linux-kernel-owner+w=401wt.eu-S2992537AbXCBPyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992537AbXCBPyw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 10:54:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992541AbXCBPyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 10:54:52 -0500
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:49634 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992537AbXCBPyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 10:54:51 -0500
Subject: [PATCH 0/9] swap on flash support
From: Richard Purdie <rpurdie@openedhand.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-mtd@lists.infradead.org, dwmw2@infradead.org
Content-Type: text/plain
Date: Fri, 02 Mar 2007 15:54:30 +0000
Message-Id: <1172850870.11149.117.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch series adds a device driver which allows an mtd
flash device to be used as a swap device. Since flash needs wear
levelling, a normal block device can't be used directly.

In order to work efficiently, some changes to other parts of Linux are
needed. Most of these changes are hopefully useful in their own right.

The better handling of swap write failure patches have been seen before.
There were no real problems identified last time these were posted and
they haven't changed since then, I'm just posting them in context now.
The resulting patches are not particularly invasive and I hopefully
these could be considered for merging.

The most controversial part of the series is probably the mark unused
ioctl. Whilst frowned upon, I used an ioctl as it seemed the only way to
get a message from the swap layer to the block driver. I'm open to
suggestions for a better way to do this. Knowing which blocks it can
reuse is extremely useful to the swaponflash driver and makes it much
more efficient.

Its possible to think of races where a block is marked as used but a
write is still in the bio queue and ends up containing data when it
could really be empty. The false positive of a block being marked empty
when its not shouldn't (and mustn't) happen though. The ioctl should be
thought of as a hint to the block device rather than an absolute.

The swaponflash driver itself has several features to try and extend the
lifetime of any flash chip being used as swap. There is some detail at
the top of the file but in summary, it creates a block device (mtdswapX)
which already contains the swap header and can then be directly used by
swapon. Devices appearing as swap must be explicitly referenced on the
commandline or as a module parameter.

A simple map is then used to keep track of blocks in use by the kernel
and the placement of these blocks on flash is determined by the driver.
These blocks can be moved around for wear levelling as needed,
transparent to the kernel's swap layer. If we run out of space (too many
bad blocks), we return a write error to the kernel which is why bad swap
handling needs improvement. I've tested the pathological case where all
swap goes bad and the swap device size tends to zero and the kernel
survives!

One simplification it takes advantage of is that no state need be stored
over a reboot and it assumes it can start wear levelling from scratch
since it would have tried to keep wear level before in any previous
runs.

Richard


