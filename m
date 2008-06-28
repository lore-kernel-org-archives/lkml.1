Return-Path: <linux-kernel-owner+w=401wt.eu-S1757268AbYF1Mmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268AbYF1Mmg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2008 08:42:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752717AbYF1Mm3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Jun 2008 08:42:29 -0400
Received: from chrocht.moloch.sk ([62.176.169.44]:48232 "EHLO mail.moloch.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501AbYF1Mm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2008 08:42:28 -0400
X-Greylist: delayed 1849 seconds by postgrey-1.27 at vger.kernel.org; Sat, 28 Jun 2008 08:42:27 EDT
Date: Sat, 28 Jun 2008 14:11:32 +0200
From: Martin Lucina <mato@kotelna.sk>
To: linux-kernel@vger.kernel.org
Cc: Martin Sustrik <sustrik@fastmq.com>
Subject: Higher than expected disk write(2) latency
Message-ID: <20080628121131.GA14181@nodbug.moloch.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

we're getting some rather high figures for write(2) latency when testing
synchronous writing to disk.  The test I'm running writes 2000 blocks of
contiguous data to a raw device, using O_DIRECT and various block sizes
down to a minimum of 512 bytes.  

The disk is a Seagate ST380817AS SATA connected to an Intel ICH7
using ata_piix.  Write caching has been explicitly disabled on the
drive, and there is no other activity that should affect the test
results (all system filesystems are on a separate drive).  The system is
running Debian etch, with a 2.6.24 kernel.

Observed results:

size=1024, N=2000, took=4.450788 s, thput=3 mb/s seekc=1
write: avg=8.388851 max=24.998846 min=8.335624 ms
8 ms: 1992 cases
9 ms: 2 cases
10 ms: 1 cases
14 ms: 1 cases
16 ms: 3 cases
24 ms: 1 cases

size=512, N=2000, took=4.401289 s, thput=1 mb/s seekc=1
write: avg=8.364283 max=16.692206 min=2.010072 ms
2 ms: 1 cases
7 ms: 1 cases
8 ms: 1995 cases
16 ms: 3 cases

Measurement of the write(2) time is performed using the TSC, so any
latency there is negligible.

The datasheet for the drive being used gives the following figures:

Average latency (msec): 4.16
Track-to-track seek time (msec typical): <1.2 (write)
Average seek, write (msec typical): 9.5

If these figures are to be believed, then why are we seeing latencies of
8.3 msec?  Is this normal?  Or are we just being overly optimistic in
our performance expectations?

What we find suspicious is that the latency we see is so close to the
Average seek latency specified for the drive, almost as if the drive was
performing a seek on every write.

For comparison, here are the results of the same test with the disk
write cache *enabled*:

size=1024, N=2000, took=0.296284 s, thput=55 mb/s seekc=1
write: avg=0.147745 max=0.606990 min=0.117246 ms
0 ms: 2000 cases

size=512, N=2000, took=0.304614 s, thput=26 mb/s seekc=1
write: avg=0.152089 max=0.533234 min=0.125370 ms
0 ms: 2000 cases

We also ran the same test on a different system with recent SAS disks
connected via a HP/Compaq CCISS controller.  I don't have the exact
details of the drives used, since I don't know how to get them out of
the cciss driver, but the latencies we got were around 4 msec.  Whilst
this is better than the "commodity" hardware used in the tests above, it
still seems excessive.

Any advice would be appreciated.

Thanks,

-mato
