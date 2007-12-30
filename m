Return-Path: <linux-kernel-owner+w=401wt.eu-S1755195AbXL3SRF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbXL3SRF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Dec 2007 13:17:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751750AbXL3SQy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Dec 2007 13:16:54 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:23206 "EHLO
	pd3mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbXL3SQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Dec 2007 13:16:53 -0500
Date: Sun, 30 Dec 2007 12:16:44 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: SATA buffered read VERY slow (not raid,
 Promise TX300 card); 2.6.23.1(vanilla)
In-reply-to: <fa.6TIOCGhBpW0r4XW9rqR+Ad8P+Js@ifi.uio.no>
To: Linda Walsh <lkml@tlinx.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <4777E08C.4000603@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.6TIOCGhBpW0r4XW9rqR+Ad8P+Js@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linda Walsh wrote:
> I needed to get a new hard disk for one of my systems and thought that
> it was about time to start going with SATA.
> 
> I picked up a Promise 4-Port Sata300-TX4 to go with a 750G
> Seagate SATA -- I'd had good luck with a Promise ATA100 (P)ATA
> and lower capacity Seagates and thought it would be a good combo.
> 
> Unfortunately, the *buffered* read performance is *horrible*!
> 
> I timed the new disk against a 400GB PATA and old 80MB/s SCSI-based
> 18.3G hard disk.  While the raw speed numbers are faster as expected, 
> the linux-buffered read numbers are not good.
> 
> 
> sda=18.3G on 80MB/s SCSI
> sdb=the new 750GB on a 3Gb SATA w/NCQ.
> hdf=400GB PATA on an ATA100 Promise card
> 
> I used "dd" for my tests, reading 2GB on a quiescent machine
> that has 1GB of main memory.  Output was to dev null.  Input
> was from the device (not a partition or file), (/dev/sda, /dev/sdb
> and /dev/hdf).  BS=1M, Count=2k.  For the direct tests, I used
> the "iflag=direct" param.  No RAID or "volumes" are involved.
> 
> In each case, I took best run time out of 3 runs.
> 
> Direct read speeds (and cpu usage):
> dev   speed       cpu/real     %
> sda   60MB/s     0.51/35.84   1.44
> sdb   80MB/s     0.50/26.72   1.87
> hdf   69.4MB/s   0.51/30.92   1.68
> 
> 
> Buffered reads show the "bad news":
> dev   speed       cpu/real     %
> sda   59.9MB/s  20.80/35.86   58.03
> sdb   18.7MB/s  16.07/114.73  14.01  <-SATA extra badness
> hdf   69.8MB/s  17.37/30.76   56.48
> 
> I assume this isn't expected behavior.
> 
> Why would buffered reads be so much slower for SATA?  Shouldn't
> it be the same buffering system used by sda and hdf?  I can't
> see how it would be the hardware or the driver since both
> give "best" read performance with the new SATA disk being
> 15-20% faster.
> 
> But the buffered reads...are 60% *slower*.  I want to ask if this
> is even possible, even though the evidence seems to indicate it is.
> But what I mean to ask is: "are the SATA buffered read paths
> *so* different from SCSI and PATA that they could cause this?
> Isn't the block layer mostly "independent" above the device
> layer?  If it isn't evident, I'm using the newer SATA drivers (not
> the old ones included with the pata library and the pata disks
> are using the old ATA interface.

Have you tried using a different block size to see how that effects the 
results? There might be some funny interaction there.

> 
> I wanted to use the newer pata support in the SATA lib, but
> got frustrated "real fast" by the lack of disk-parameter support
> in the new pata library (hdparm is mostly broken; and the SCSI
> utils aren't really intended for ATA(or SATA?) disks using the
> SCSI interface.

It's somewhat intentional that some of the hdparm commands (like for 
settting transfer modes, enable/disable DMA, etc.) don't work with 
libata. Most of them aren't necessary at all as correct DMA settings, 
etc. should always be set automatically (if not, please report as a bug).

> 
> Is there some 'gotcha' I'm missing?  Google didn't seem to
> throw any answers at me that 'stood out'.
> 
> Also, as a side issue -- have the buffered commands always
> taken that much cpu vs. direct (machine has 2x1GHz-P-III's).
> Maybe it has and I just haven't noticed it -- but my main
> problem right now is with the horrible buffered SATA
> performance.
> 
> Since SATA's use ATA-7 (or at least the Seagate disk I
> acquired seems to), shouldn't most of the hdparm commands
> be functional on the SATA hardware as much as they would
> be on PATA?  Or...maybe said a different way, is there
> an "sdparm" that is to SATA what hdparm is to PATA?

It's the same libata code, so the same applies to some of the hdparm 
commands not being implemented, as above.

> 
> The Promise controllers involved (PATA and SATA) are:
> 00:0d.0 Mass storage controller: Promise Technology, Inc. PDC20268 
> (Ultra100 TX2) (rev 02)
> and
> 02:09.0 Mass storage controller: Promise Technology, Inc. PDC40718 (SATA 
> 300 TX4) (rev 02)
> 
> I'd ask about a newer driver, but the hardware seems pretty
> fast if I go around the Linux kernel.  Ideas?  What could
> slow down the linux-buffer layer when the driver is faster?
> Perversely, could it be the faster driver speed just tipping
> over some internal "flooding" limit which degrades buffered
> performance?
> Very Confused & TIA,
> Linda

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

