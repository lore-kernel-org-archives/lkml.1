Return-Path: <linux-kernel-owner+w=401wt.eu-S1753331AbXFXWHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbXFXWHf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 18:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751430AbXFXWH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 18:07:27 -0400
Received: from viefep18-int.chello.at ([213.46.255.22]:7057 "EHLO
	viefep14-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751081AbXFXWH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 18:07:26 -0400
Date: Mon, 25 Jun 2007 00:07:23 +0200
From: Carlo Wood <carlo@alinoe.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>,
       "Dr. David Alan Gilbert" <linux@treblig.org>,
       Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
       Manoj Kasichainula <manoj@io.com>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: SATA RAID5 speed drop of 100 MB/s
Message-ID: <20070624220723.GA21724@alinoe.com>
Mail-Followup-To: Carlo Wood <carlo@alinoe.com>,
	Justin Piszcz <jpiszcz@lucidpixels.com>,
	Michael Tokarev <mjt@tls.msk.ru>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>,
	Manoj Kasichainula <manoj@io.com>, linux-kernel@vger.kernel.org,
	IDE/ATA development list <linux-ide@vger.kernel.org>
References: <4679B2DE.9090903@garzik.org> <20070622214859.GC6970@alinoe.com> <467CC5C5.6040201@garzik.org> <20070623125316.GB26672@alinoe.com> <467DA1F5.2060306@garzik.org> <467E5C5E.6000706@msgid.tls.msk.ru> <20070624125957.GA28067@gallifrey> <Pine.LNX.4.64.0706241021030.12207@p34.internal.lan> <467E9356.1030200@msgid.tls.msk.ru> <Pine.LNX.4.64.0706241257190.12207@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0706241257190.12207@p34.internal.lan>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 24, 2007 at 12:59:10PM -0400, Justin Piszcz wrote:
> Concerning NCQ/no NCQ, without NCQ I get an additional 15-50MB/s in speed 
> per various bonnie++ tests.

There is more going on than a bad NCQ implementation of the drive imho.
I did a long test over night (and still only got two schedulers done,
will do the other two tomorrow), and the difference between a queue depth
of 1 and 2 is DRAMATIC.

See http://www.xs4all.nl/~carlo17/noop_queue_depth.png
and http://www.xs4all.nl/~carlo17/anticipatory_queue_depth.png

The bonnie++ tests are done in a directory on the /dev/md7 and
/dev/ssd2 partitions respectively. Each bonnie test is performed
four times.

The hdparm -t tests (that show no difference with a -tT test) are
each done five times, for /dev/sdd, /dev/md7 and /dev/sda (that is
one of the RAID5 drives used for /dev/md7).

Thus in total there are 2 * 4 + 3 * 5 = 23 data points per
queue depth value in each graph.

The following can be observed:

1) There is hardly any difference between the two schedulers (noop
   is a little faster for the bonny test).
2) An NCQ depth of 1 is WAY faster on RAID5 (bonnie; around 125 MB/s),
   the NCQ depth of 2 is by far the slowest for the RAID5 (bonnie;
   around 40 MB/s). NCQ depths of 3 and higher show no difference,
   but are also slow (bonnie; around 75 MB/s).
3) There is no significant influence of the NCQ depth for non-RAID,
   either the /dev/sda (hdparm -t) or /dev/sdd disk (hdparm -t and
   bonnie).
4) With a NCQ depth > 1, the hdparm -t measurement of /dev/md7 is
   VERY unstable. Sometimes it gives the maximum (around 150 MB/s),
   and sometimes as low as 30 MB/s, seemingly independent of the
   NCQ depth. Note that those measurement were done on an otherwise
   unloaded machine in single user mode; and the measurements were
   all done one after an other. The strong fluctuation of the hdparm
   results for the RAID device (while the underlaying devices do not
   show this behaviour) are unexplainable.

>From the above I conclude that something must be wrong with the
software RAID implementation - and not just with the harddisks, imho.
At least, that's what it looks like to me. I am not an expert though ;)

-- 
Carlo Wood <carlo@alinoe.com>

PS RAID5 (md7 = sda7 + sdb7 + sdc7): Three times a Western Digital
   Raptor 10k rpm (WDC WD740ADFD-00NLR1).
   non-RAID (sdd2): Seagate barracuda 7200 rpm (ST3320620AS).

   The reason that now I measure around 145 MB/s instead of 165 MB/s
   as reported in previous post (with hdparm -t /dev/md7) is because
   before I use hdparm -t /dev/md2, which is closer to the outside
   of the disk and therefore faster. /dev/md2 still is around 165 MB/s.

