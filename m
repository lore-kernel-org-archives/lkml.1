Return-Path: <linux-kernel-owner+w=401wt.eu-S1757420AbYEKOF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420AbYEKOF0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2008 10:05:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754766AbYEKOFQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 May 2008 10:05:16 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:54198 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751938AbYEKOFO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2008 10:05:14 -0400
Subject: Re: performance "regression" in cfq compared to anticipatory,
	deadline and noop
From: Kasper Sandberg <lkml@metanurb.dk>
To: Daniel J Blueman <daniel.blueman@gmail.com>
Cc: axboe@kernel.dk, Linux Kernel <linux-kernel@vger.kernel.org>,
       Matthew <jackdachef@gmail.com>
In-Reply-To: <6278d2220805110614i7160a8a5o36d55acb732c1b59@mail.gmail.com>
References: <6278d2220805110614i7160a8a5o36d55acb732c1b59@mail.gmail.com>
Content-Type: text/plain
Date: Sun, 11 May 2008 16:02:47 +0200
Message-Id: <1210514567.7827.62.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.4.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-05-11 at 14:14 +0100, Daniel J Blueman wrote:
> I've been experiencing this for a while also; an almost 50% regression
> is seen for single-process reads (ie sync) if slice_idle is 1ms or
> more (eg default of 8) [1], which seems phenomenal.
> 
> Jens, is this the expected price to pay for optimal busy-spindle
> scheduling, a design issue, bug or am I missing something totally?
> 
> Thanks,
>   Daniel
> 
> --- [1]
> 
> # cat /sys/block/sda/queue/iosched/slice_idle
> 8
> # echo 1 >/proc/sys/vm/drop_caches
> # dd if=/dev/sda of=/dev/null bs=64k count=5000
> 5000+0 records in
> 5000+0 records out
> 327680000 bytes (328 MB) copied, 4.92922 s, 66.5 MB/s
> 
> # echo 0 >/sys/block/sda/queue/iosched/slice_idle
> # echo 1 >/proc/sys/vm/drop_caches
> # dd if=/dev/sda of=/dev/null bs=64k count=5000
> 5000+0 records in
> 5000+0 records out
> 327680000 bytes (328 MB) copied, 2.74098 s, 120 MB/s
> 
> # hdparm -Tt /dev/sda
> 
> /dev/sda:
>  Timing cached reads:   15464 MB in  2.00 seconds = 7741.05 MB/sec
>  Timing buffered disk reads:  342 MB in  3.01 seconds = 113.70 MB/sec
> 
> [120MB/s is known platter-rate for this disc, so expected]

This appears to be what i get aswell..

root@quadstation # dd if=/dev/sda of=/dev/null bs=64k count=5000
5000+0 records in
5000+0 records out
327680000 bytes (328 MB) copied, 5.48209 s, 59.8 MB/s
root@quadstation # echo 0 >/sys/block/sda/queue/iosched/slice_idle
root@quadstation # echo 1 >/proc/sys/vm/drop_caches
root@quadstation # dd if=/dev/sda of=/dev/null bs=64k count=5000
5000+0 records in
5000+0 records out
327680000 bytes (328 MB) copied, 2.93932 s, 111 MB/s
root@quadstation # hdparm -Tt /dev/sda
 Timing cached reads:   7264 MB in  2.00 seconds = 3633.82 MB/sec
 Timing buffered disk reads:  322 MB in  3.01 seconds = 107.00 MB/se
root@quadstation # echo 0 >/sys/block/sda/queue/iosched/slice_idle
root@quadstation # echo 1 >/proc/sys/vm/drop_caches
root@quadstation # hdparm -Tt /dev/sda
 Timing cached reads:   15268 MB in  2.00 seconds = 7643.54 MB/sec
 Timing buffered disk reads:  328 MB in  3.01 seconds = 108.85 MB/sec


To be sure, i did it all again:
noop:
root@quadstation # echo 1 >/proc/sys/vm/drop_caches
root@quadstation # dd if=/dev/sda of=/dev/null bs=64k count=5000
5000+0 records in
5000+0 records out
327680000 bytes (328 MB) copied, 2.85503 s, 115 MB/s
root@quadstation # echo 1 >/proc/sys/vm/drop_caches
root@quadstation # hdparm -tT /dev/sda
 Timing cached reads:   14076 MB in  2.00 seconds = 7045.78 MB/sec
 Timing buffered disk reads:  328 MB in  3.01 seconds = 109.12 MB/sec

anticipatory:
root@quadstation # echo 1 >/proc/sys/vm/drop_caches
root@quadstation # dd if=/dev/sda of=/dev/null bs=64k count=5000
5000+0 records in
5000+0 records out
327680000 bytes (328 MB) copied, 2.96948 s, 110 MB/s
root@quadstation # echo 1 >/proc/sys/vm/drop_caches
root@quadstation # hdparm -tT /dev/sda
 Timing cached reads:   13424 MB in  2.00 seconds = 6719.29 MB/sec
 Timing buffered disk reads:  328 MB in  3.01 seconds = 109.13 MB/sec

cfq:
root@quadstation # echo 1 >/proc/sys/vm/drop_caches
root@quadstation # dd if=/dev/sda of=/dev/null bs=64k count=5000
5000+0 records in
5000+0 records out
327680000 bytes (328 MB) copied, 5.25252 s, 62.4 MB/s
root@quadstation # echo 1 >/proc/sys/vm/drop_caches
root@quadstation # hdparm -tT /dev/sda
 Timing cached reads:   13434 MB in  2.00 seconds = 6723.59 MB/sec
 Timing buffered disk reads:  188 MB in  3.00 seconds =  62.57 MB/sec

Thisd would appear to be quite a considerable performance difference.

