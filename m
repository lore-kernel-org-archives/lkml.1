Return-Path: <linux-kernel-owner+w=401wt.eu-S1754543AbYIHSK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543AbYIHSK7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 14:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbYIHSKv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 14:10:51 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:54774 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751628AbYIHSKu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 14:10:50 -0400
Date: Mon, 8 Sep 2008 20:10:47 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: "Alan D. Brunelle" <Alan.Brunelle@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Benchmarking results: DSS elapsed time values w/ rq_affinity=0/1  - Jens' for-2.6.28 tree
Message-ID: <20080908181046.GM20055@kernel.dk>
References: <48C15C02.7060504@hp.com> <48C31095.6020206@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48C31095.6020206@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 06 2008, Alan D. Brunelle wrote:
> Here are some results obtained during runs where we varied the number of
>  readers & the multi-block read counts. 5 runs per rq_affinity setting
> were done, and the averages are plotted at:
> 
> http://free.linux.hp.com/~adb/jens/08-09-05/by_mbr.jpeg
> 
> In all cases we are seeing a noticeable improvement in reduction of
> elapsed time to perform the tasks, and again we are seeing much tighter
> deviations with rq_affinity set to 1:
> 
>                           Min   Avg   Max   Std Dev
>                          ----- ----- -----  --------
> mbrs= 32 nrdrs= 64 rq=0: 30.57 31.50 34.06  1.456108
> mbrs= 32 nrdrs= 64 rq=1: 29.27 29.59 29.96  0.325469   6.05% improvement
> 
> mbrs= 32 nrdrs=128 rq=0: 28.14 28.48 29.32  0.480208
> mbrs= 32 nrdrs=128 rq=1: 27.54 27.88 28.48  0.359194   2.11% improvement
> 
> mbrs= 32 nrdrs=256 rq=0: 33.05 33.70 34.30  0.548151
> mbrs= 32 nrdrs=256 rq=1: 33.10 33.36 33.74  0.257158   1.01% improvement
> 
> mbrs= 64 nrdrs= 64 rq=0: 30.53 30.74 31.10  0.255441
> mbrs= 64 nrdrs= 64 rq=1: 29.40 29.65 29.91  0.187216   3.55% improvement
> 
> mbrs= 64 nrdrs=128 rq=0: 28.09 28.79 29.23  0.484149
> mbrs= 64 nrdrs=128 rq=1: 27.73 27.96 28.33  0.226429   2.89% improvement
> 
> mbrs= 64 nrdrs=256 rq=0: 33.35 34.04 34.76  0.518816
> mbrs= 64 nrdrs=256 rq=1: 33.02 33.13 33.25  0.088034   2.67% improvement
> 
> mbrs=128 nrdrs= 64 rq=0: 30.37 30.75 31.23  0.329439
> mbrs=128 nrdrs= 64 rq=1: 29.20 29.49 29.82  0.221179   4.08% improvement
> 
> mbrs=128 nrdrs=128 rq=0: 28.04 28.54 29.00  0.392785
> mbrs=128 nrdrs=128 rq=1: 27.76 28.08 28.26  0.190840   1.63% improvement
> 
> mbrs=128 nrdrs=256 rq=0: 33.37 33.89 34.30  0.448297
> mbrs=128 nrdrs=256 rq=1: 33.04 33.30 33.56  0.203175   1.76% improvement
> 
> mbrs=256 nrdrs= 64 rq=0: 30.55 30.80 30.94  0.167392
> mbrs=256 nrdrs= 64 rq=1: 29.23 29.57 29.91  0.305156   3.99% improvement
> 
> mbrs=256 nrdrs=128 rq=0: 28.38 28.82 29.20  0.305172
> mbrs=256 nrdrs=128 rq=1: 27.78 27.92 28.11  0.142583   3.12% improvement
> 
> mbrs=256 nrdrs=256 rq=0: 33.25 34.21 34.88  0.598398
> mbrs=256 nrdrs=256 rq=1: 33.11 33.23 33.48  0.154499   2.88% improvement

Thanks a lot for these numbers Alan, it definitely looks like a clear
win (and a pretty big one) for all of the above and the previous mail.
It would be interesting to see sys and usr times seperately, as well as
trying to compare profiles of two runs. On the testing that I did with a
4-way ppc box, lock contention and bouncing was way down with XFS and
btrfs. I didn't test other file systems yet. I saw mean acquisition and
hold time reductions in the 20-30% range and waittime reductions of over
40% in just simple meta data intensive fs testing.

For the casual reader, let me try and explan what the rq_affinity
toggles does in the 2.6.28 block tree. On the process side, the
scheduler will move processes around between cores in the system as it
deems it most beneficial. Or you can tie down a process to one or more
CPUs explicitly. On the IRQ side things are a little more rigid. You can
set IRQ affinity statically for a device (controller, typically) and
that's about it. With the new IO CPU affinity feature in the block
layer, you have full control over where you get your hardware completion
even. When you set rq_affinity=1, the block layer will route the
completion of a request to the CPU that submitted it. It does that by
utilizing the new generic SMP IPI code that was included in 2.6.26.

There's also the option of letting the submitter specify a CPU. I
haven't played much with that yet, but the intention is having the file
system pass down such a hint for keeping lock contention down. So when
the file system knows that it will update file system structures (and
thus grab a lock or more) on IO completion, it can ask for completion on
a limited range of CPUs instead of having that lock bounced around
between all cores. Right now it just supports a single CPU just like the
rq_affinity switch, but it can easily be extended to support a mask of
cores instead. It actually used to include that for the cases where you
would statically set a range of completion CPUs, but I removed that
since the option made little sense.

-- 
Jens Axboe

