Return-Path: <linux-kernel-owner+w=401wt.eu-S1756371AbXFWMx1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371AbXFWMx1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2007 08:53:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752543AbXFWMxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jun 2007 08:53:18 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:3820 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752188AbXFWMxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2007 08:53:16 -0400
Date: Sat, 23 Jun 2007 14:53:16 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: Tejun Heo <htejun@gmail.com>, Manoj Kasichainula <manoj@io.com>,
       linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: SATA RAID5 speed drop of 100 MB/s
Message-ID: <20070623125316.GB26672@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
	Manoj Kasichainula <manoj@io.com>, linux-kernel@vger.kernel.org,
	IDE/ATA development list <linux-ide@vger.kernel.org>
References: <20070620224847.GA5488@alinoe.com> <4679B2DE.9090903@garzik.org> <20070622214859.GC6970@alinoe.com> <467CC5C5.6040201@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <467CC5C5.6040201@garzik.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 23, 2007 at 03:03:33AM -0400, Jeff Garzik wrote:
> Your disk configurations are quite radically different between the two 
> kernels (see attached diff for key highlights).
> 
> The new behavior of the more recent kernel (551c012d7...) is that it now 
> fully drives your hardware :)  The reset problems go away, NCQ is 
> enabled, and if you had 3.0Gbps drives (you don't) they would be driven 
> at a faster speed.
> 
> Given that some drives might be better tuned for benchmarks in 
> non-queued mode, and that a major behavior difference is that your 
> drives are now NCQ-enabled, the first thing I would suggest you try is 
> disabling NCQ:
> 	http://linux-ata.org/faq.html#ncq

Thanks! That is indeed the difference that causes the drop of
"hdparm -tT" that I observed.
After setting /sys/block/sdX/device/queue_depth of all three drives
to 1, I get again

/dev/md2:
 Timing cached reads:   8252 MB in  2.00 seconds = 4130.59 MB/sec
 Timing buffered disk reads:  496 MB in  3.01 seconds = 164.88 MB/sec

on 2.6.22-rc5.

> Other indicators are the other changes in the "ahci 0000:00:1f.2: 
> flags:" line, which do affect other behaviors, though none so important 
> to RAID5 performance as NCQ, I would think.
> 
> Turning on NCQ also potentially affects barrier behavior in RAID, though 
> I'm guessing that is not a factor here.

Of course, I am not really interested in what "hdparm -tT" gives, but
rather in a high performance during real-life use of the disks.

Is it possible that the measurement with "hdparm -tT" returns a higher
value for some setting, but that the over-all real-life performance
drops?

Also, the effect of this setting is nil for the individual drives.
hdparm -tT /dev/sda  gives me still around 65 MB/s.  I don't understand
why this setting has such a HUGE effect on RAID5 while the underlaying
drives themselves don't seem affected.

PS I'd like to do extensive testing with Bonnie++ to tune everything
there is to tune. But bonnie likes to write/read files TWICE the amount
of RAM I have. It therefore takes a LOT of time to run one test. Do you
happen to know how I can limit the amount of RAM that the linux kernel
sees to, say 500 MB? That should be enough to run in Single User mode
but allow me to run the tests MUCH faster. (I have dual channel, four
DIMM's of 1 GB each -- 2 GB per Core 2 die. Hopefully the fact that
I have dual channel isn't going to be a problem when limiting the ram
that the kernel sees.)

-- 
Carlo Wood <carlo@alinoe.com>
