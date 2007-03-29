Return-Path: <linux-kernel-owner+w=401wt.eu-S934069AbXC2SlG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934069AbXC2SlG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 14:41:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934307AbXC2SlE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 14:41:04 -0400
Received: from science.horizon.com ([192.35.100.1]:19812 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934069AbXC2SlD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 14:41:03 -0400
Date: 29 Mar 2007 14:40:41 -0400
Message-ID: <20070329184041.13243.qmail@science.horizon.com>
From: linux@horizon.com
To: jeff@garzik.org, psusi@cfl.rr.com
Subject: Re: Why is NCQ enabled by default by libata? (2.6.20)
Cc: htejun@gmail.com, jpiszcz@lucidpixels.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux@horizon.com
In-Reply-To: <460BF73C.5070707@cfl.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> But when writing, what is the difference between queuing multiple tagged 
> writes, and sending down multiple untagged cached writes that complete 
> immediately and actually hit the disk later?  Either way the host keeps 
> sending writes to the disk until it's buffers are full, and the disk is 
> constantly trying to commit those buffers to the media in the most 
> optimal order.

Well, theoretically it allows more buffering, without hurting read
cacheing.

With NCQ, the drive gets the command, and then tells the host when it
wants the corresponding data.  It can ask for the data in any order
it likes, when it's decided which write will be serviced next.  So it
doesn's have to fill up its RAM with the write data.  This leaves more
RAM free for things like read-ahead.

Another trick, that I know SCSI can do and I expect NCQ can do, is that
the drive cam ask for the data for a single write in different orders.
This is particularly useful for reads, where a drive asked for blocks
100-199 can deliver blocks 150-199 first, then 100-149 when the drive
spins around.

This is, unfortunately, kind of theoretical.  I don't actually know
how hard drive cacheing algorithms work, but I assume it's mostly a
readahead cache.  The host has much more RAM than the drive, so any
block that it's read won't be requested again for a long time.  So the
drive doesn't want to keep that in cache.  But any sectors that the
drive happens to read nearby requested sectors are worth keeping.


I'm not sure it's a big deal, as 32 (tags) x 128K (largest LBA28 write
size) is 4M, only half of a typical drive's cache RAM.  But it's
possible that there's some difference.
