Return-Path: <linux-kernel-owner+w=401wt.eu-S1759153AbXFVQVx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759153AbXFVQVx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 12:21:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758131AbXFVQVq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 12:21:46 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:31257 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758105AbXFVQVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 12:21:46 -0400
Date: Fri, 22 Jun 2007 18:21:42 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Subject: Re: SATA Harddisk speed drop of 100 MB/s
Message-ID: <20070622162142.GA603@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Arjan van de Ven <arjan@infradead.org>,
	Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
References: <20070620224847.GA5488@alinoe.com> <4679B2DE.9090903@garzik.org> <1182397012.2863.0.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1182397012.2863.0.camel@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 20, 2007 at 08:36:52PM -0700, Arjan van de Ven wrote:
> also do a 
> 
> echo 60 > /proc/sys/vm/dirty_ratio
> 
> first to see if that helps

That makes no difference.

It took a while before I replied - because I first want to do a bisect
to find a version closer to the problem.

So far I found out that it's RAID only.

I have four disks:

Three times a western digital Raptor 10k rpm:

ATA device, with non-removable media
        Model Number:       WDC WD740ADFD-00NLR1
        Firmware Revision:  20.07P20

And one Seagate Barracuda 7200 rpm:

ATA device, with non-removable media
        Model Number:       ST3320620AS
        Firmware Revision:  3.AAE

The Raptors are in RAID5.

hdparm -tT gives me always > 4 GB/s cached reads, for example:

 Timing cached reads:   8166 MB in  2.00 seconds = 4086.82 MB/sec

and the buffered disk reads do not significantly vary when
reading the devices directly (/dev/sda, /dev/sdb, /dev/sdc for
the Raptors and /dev/sdd for the Barracuda):

/dev/sda etc: Around 67 MB/sec
/dev/sdd    : Around 75 MB/sec   (so much for 10k rpm ...)

These numbers are weird in itself (the 67 should have been 75,
and the 75 should have been 54) - but at least they are constant.

What DOES *signficantly* change as function of kernel revision
is the buffered disk read with hdparm -tT /dev/md2

The normal speed I get is > 160, often 165 MB/sec. But with
kernel revisions over a certain version that drops to around
67 MB/sec - and at one point I even observed a drop in speed
every time I repeated the measurement until the speed was
around 30 MB/s !

At the moment I am (still) doing the bisect; I had some problems
compiling a pristine 2.6.18 and some problems with the config
(that differs significantly between 2.6.18 and 2.6.22) as well
as the problem that the kernel simply didn't compile for a large
range of revisions needed for the bisect (I needed to export
current_is_keventd with this patch:

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index c525731..012e11b 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -654,6 +654,7 @@ int current_is_keventd(void)
        return ret;

 }
+EXPORT_SYMBOL_GPL(current_is_keventd);

 /* Take the work from this (downed) CPU. */
 static void take_over_work(struct workqueue_struct *wq, unsigned int cpu)

)

I'll report back when I'm done with the bisect :)

-- 
Carlo Wood <carlo@alinoe.com>
