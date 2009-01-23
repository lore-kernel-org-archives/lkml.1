Return-Path: <linux-kernel-owner+w=401wt.eu-S1760215AbZAWEDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760215AbZAWEDr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 23:03:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754643AbZAWEDj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 23:03:39 -0500
Received: from tomts40.bellnexxia.net ([209.226.175.97]:44427 "EHLO
	tomts40-srv.bellnexxia.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754547AbZAWEDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 23:03:38 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq8EAK/NeElMQWt2/2dsb2JhbACBbchHhXM
Date: Thu, 22 Jan 2009 23:03:20 -0500
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, ltt-dev@lists.casi.polymtl.ca,
       Jens Axboe <jens.axboe@oracle.com>, akpm@linux-foundation.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [ltt-dev] [RFC PATCH] block: Fix bio merge induced high I/O
	latency
Message-ID: <20090123040320.GA23838@Krystal>
References: <20090120122855.GF30821@kernel.dk> <20090120232748.GA10605@Krystal> <20090123220009.34DF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20090123220009.34DF.KOSAKI.MOTOHIRO@jp.fujitsu.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 22:59:31 up 22 days,  3:57,  3 users,  load average: 1.13, 0.92,
	0.73
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KOSAKI Motohiro (kosaki.motohiro@jp.fujitsu.com) wrote:
> > So, I ran the tests with my corrected patch, and the results are very
> > good !
> > 
> > "incoming ssh connexion" test
> > 
> > "config 2.6.28 cfq"
> > Linux 2.6.28
> > /sys/block/sd{a,b}/device/queue_depth = 31 (default)
> > /sys/block/sd{a,b}/queue/iosched/slice_async_rq = 2 (default)
> > /sys/block/sd{a,b}/queue/iosched/quantum = 4 (default)
> > 
> > "config 2.6.28.1-patch1"
> > Linux 2.6.28.1
> > Corrected cfq patch applied
> > echo 1 > /sys/block/sd{a,b}/device/queue_depth
> > echo 1 > /sys/block/sd{a,b}/queue/iosched/slice_async_rq
> > echo 1 > /sys/block/sd{a,b}/queue/iosched/quantum
> > 
> > On /dev/sda :
> > 
> > I/O scheduler        runt-min (msec)   runt-max (msec)
> > cfq (2.6.28 cfq)          523             6637
> > cfq (2.6.28.1-patch1)     579             2082
> > 
> > On raid1 :
> > 
> > I/O scheduler        runt-min (msec)   runt-max (msec)
> > cfq (2.6.28 cfq)           523            28216
> > cfq (2.6.28.1-patch1)      517             3086
> 
> Congraturation.
> In university machine room (at least, the university in japan), 
> parallel ssh workload freqently happend.
> 
> I like this patch :)
> 

Please see my today's posts with numbers taken after my Seagate firmware
upgrade.  The runt-max case is pretty hard to trigger "for sure" and I
had to do a few runs to trigger the problem. The latest tests are
better. E.g. the 3086msec is actually just because the problem has not
been hit.

But the 
echo 1 > /sys/block/sd{a,b}/device/queue_depth
echo 1 > /sys/block/sd{a,b}/queue/iosched/slice_async_rq
echo 1 > /sys/block/sd{a,b}/queue/iosched/quantum

Are definitely helping a lot, as my last numbers also show. The patch,
OTOH, degraded performances rather than making them better.

Mathieu

> 
> 
> > 
> > It looks like we are getting somewhere :) Are there any specific
> > queue_depth, slice_async_rq, quantum variations you would like to be
> > tested ?
> > 
> > For reference, I attach my ssh-like job file (again) to this mail.
> > 
> > Mathieu
> > 
> > 
> > [job1]
> > rw=write
> > size=10240m
> > direct=0
> > blocksize=1024k
> > 
> > [global]
> > rw=randread
> > size=2048k
> > filesize=30m
> > direct=0
> > bsrange=4k-44k
> > 
> > [file1]
> > startdelay=0
> > 
> > [file2]
> > startdelay=4
> > 
> > [file3]
> > startdelay=8
> > 
> > [file4]
> > startdelay=12
> > 
> > [file5]
> > startdelay=16
> > 
> > [file6]
> > startdelay=20
> > 
> > [file7]
> > startdelay=24
> > 
> > [file8]
> > startdelay=28
> > 
> > [file9]
> > startdelay=32
> > 
> > [file10]
> > startdelay=36
> > 
> > [file11]
> > startdelay=40
> > 
> > [file12]
> > startdelay=44
> > 
> > [file13]
> > startdelay=48
> > 
> > [file14]
> > startdelay=52
> > 
> > [file15]
> > startdelay=56
> > 
> > [file16]
> > startdelay=60
> > 
> > [file17]
> > startdelay=64
> > 
> > [file18]
> > startdelay=68
> > 
> > [file19]
> > startdelay=72
> > 
> > [file20]
> > startdelay=76
> > 
> > [file21]
> > startdelay=80
> > 
> > [file22]
> > startdelay=84
> > 
> > [file23]
> > startdelay=88
> > 
> > [file24]
> > startdelay=92
> > 
> > [file25]
> > startdelay=96
> > 
> > [file26]
> > startdelay=100
> > 
> > [file27]
> > startdelay=104
> > 
> > [file28]
> > startdelay=108
> > 
> > [file29]
> > startdelay=112
> > 
> > [file30]
> > startdelay=116
> > 
> > [file31]
> > startdelay=120
> > 
> > [file32]
> > startdelay=124
> > 
> > [file33]
> > startdelay=128
> > 
> > [file34]
> > startdelay=132
> > 
> > [file35]
> > startdelay=134
> > 
> > [file36]
> > startdelay=138
> > 
> > [file37]
> > startdelay=142
> > 
> > [file38]
> > startdelay=146
> > 
> > [file39]
> > startdelay=150
> > 
> > [file40]
> > startdelay=200
> > 
> > [file41]
> > startdelay=260
> > 
> > -- 
> > Mathieu Desnoyers
> > OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
> > 
> > _______________________________________________
> > ltt-dev mailing list
> > ltt-dev@lists.casi.polymtl.ca
> > http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> 
> 
> 
> 
> _______________________________________________
> ltt-dev mailing list
> ltt-dev@lists.casi.polymtl.ca
> http://lists.casi.polymtl.ca/cgi-bin/mailman/listinfo/ltt-dev
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
