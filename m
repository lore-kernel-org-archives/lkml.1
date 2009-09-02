Return-Path: <linux-kernel-owner+w=401wt.eu-S1755630AbZIBDFm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630AbZIBDFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 23:05:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755609AbZIBDFl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 23:05:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:25777 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755583AbZIBDFk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 23:05:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="183068047"
Date: Wed, 2 Sep 2009 11:05:34 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Fernando Silveira <fsilveira@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: I/O and pdflush
Message-ID: <20090902030534.GC6248@localhost>
References: <6afc6d4a0908281448s537aa315jcb79b27453cf4279@mail.gmail.com> <20090829101247.GA20786@localhost> <20090829102126.GA22409@localhost> <6afc6d4a0908310624j47f9d8c7h47d98ecd95811883@mail.gmail.com> <20090831140006.GA23668@localhost> <20090831140113.GA24005@localhost> <20090831140713.GA24185@localhost> <6afc6d4a0908310733l6426e21fu11d826f6ffa6a2af@mail.gmail.com> <20090901081458.GD1446@localhost> <6afc6d4a0909010710l2cf77fbbmb1ab192ed12a7efc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6afc6d4a0909010710l2cf77fbbmb1ab192ed12a7efc@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 01, 2009 at 10:10:53PM +0800, Fernando Silveira wrote:
> On Tue, Sep 1, 2009 at 05:14, Wu Fengguang<fengguang.wu@intel.com> wrote:
> > On Mon, Aug 31, 2009 at 10:33:43PM +0800, Fernando Silveira wrote:
> >> On Mon, Aug 31, 2009 at 11:07, Wu Fengguang<fengguang.wu@intel.com> wrote:
> >> > On Mon, Aug 31, 2009 at 10:01:13PM +0800, Wu Fengguang wrote:
> >> >> On Mon, Aug 31, 2009 at 10:00:06PM +0800, Wu Fengguang wrote:
> >> >> > Hi Fernando,
> >> >> >
> >> >> > What's your SSD's IO parameters? Ie. output of this command:
> >> >> >
> >> >> >         grep -r . /sys/block/sda/queue/
> >> >> >
> >> >> > Please replace 'sda' with your SSD device name.
> >> >>
> >> >> Oh I guess it's sdc:
> >> >>
> >> >>          grep -r . /sys/block/sdc/queue/
> >>
> >> Here is it:
> >>
> >> # grep -r . /sys/block/sdc/queue/
> >> /sys/block/sdc/queue/nr_requests:128
> >> /sys/block/sdc/queue/read_ahead_kb:128
> >> /sys/block/sdc/queue/max_hw_sectors_kb:128
> >> /sys/block/sdc/queue/max_sectors_kb:128
> >> /sys/block/sdc/queue/scheduler:noop anticipatory [deadline] cfq
> >> /sys/block/sdc/queue/hw_sector_size:512
> >> /sys/block/sdc/queue/rotational:0
> >> /sys/block/sdc/queue/nomerges:0
> >> /sys/block/sdc/queue/rq_affinity:0
> >> /sys/block/sdc/queue/iostats:1
> >> /sys/block/sdc/queue/iosched/read_expire:500
> >> /sys/block/sdc/queue/iosched/write_expire:5000
> >> /sys/block/sdc/queue/iosched/writes_starved:2
> >> /sys/block/sdc/queue/iosched/front_merges:1
> >> /sys/block/sdc/queue/iosched/fifo_batch:16
> >> #
> >>
> >> These are probably default settings.
> >>
> >> > BTW, would you run "iostat -x 1 5" (which will run 5 seconds) when
> >> > doing I/O in ideal throughput, and when in 25MB/s thoughput state?
> >>
> >> Both files are attached (25mbps = 25MB/s, 80mbps = 80MB/s).
> >
> > The iostat reported IO size is 64kb, which is half of max_sectors_kb=128.
> > It is strange why the optimal 128kb IO size is not reached in both cases:
> >
> >        Device:         rrqm/s   wrqm/s     r/s     w/s    rsec/s   wsec/s  avgrq-sz avgqu-sz   await  svctm  %util
> > case 1: sdc               0.00 69088.00     0.00  552.00     0.00 70656.00    128.00   142.75  386.39   1.81 100.10
> > case 2: sdc               0.00 153504.00    0.00 1200.00     0.00 153600.00   128.00   138.35  115.76   0.83 100.10
> >
> > Fernando, could you try increasing these deadline parameters by 10
> > times?
> >
> >        echo 160   > /sys/block/sdc/queue/iosched/fifo_batch
> >        echo 50000 > /sys/block/sdc/queue/iosched/write_expire
> 
> No changes. The iostat log is attached with the 20090901_1026 time tag
> in its name.
> 
> > And try cfq iosched if that still fails? The iostat outputs would be
> > enough during the tests.
> 
> I had already tried it before posting here, but not with iostat
> logging. The log is attached as 20090901_1037.
> 
> Please tell me if you need anything else.

OK, these traces show how performance suddenly drops:

Device:         rrqm/s   wrqm/s     r/s     w/s   rsec/s   wsec/s avgrq-sz avgqu-sz   await  svctm  %util
sdc               0.00 138176.00    0.00 1098.00     0.00 140544.00   128.00   141.85  129.43   0.91 100.00
sdc               0.00 142240.00    0.00 1105.00     0.00 141440.00   128.00   141.78  128.57   0.90 100.00
sdc               0.00 140335.00    0.00 1105.00     0.00 141440.00   128.00   139.97  127.12   0.90 100.00
sdc               0.00 134858.42    0.00 1085.15     0.00 138899.01   128.00   138.91  127.34   0.91  99.01
sdc               0.00 142050.00    0.00 1099.00     0.00 140672.00   128.00   141.93  129.04   0.91 100.00
sdc               0.00 138176.00    0.00 1099.00     0.00 140672.00   128.00   141.92  129.35   0.91 100.00
sdc               0.00 109728.00    0.00  851.00     0.00 108928.00   128.00   143.74  168.61   1.18 100.00
sdc               0.00 138176.00    0.00 1101.00     0.00 140928.00   128.00   141.92  129.05   0.91 100.00
sdc               0.00 138176.00    0.00 1091.00     0.00 139776.00   128.12   141.87  129.93   0.92 100.00
sdc               0.00 142240.00    0.00 1105.00     0.00 141312.00   127.88   141.90  128.30   0.90 100.00
sdc               0.00 138176.00    0.00 1106.00     0.00 141568.00   128.00   141.78  128.49   0.90 100.00
sdc               0.00 142240.00    0.00 1100.00     0.00 140800.00   128.00   141.88  129.01   0.91 100.00
sdc               0.00 136807.92    0.00 1094.06     0.00 140039.60   128.00   140.49  128.64   0.90  99.01
sdc               0.00 129935.00    0.00 1073.00     0.00 137224.00   127.89   122.86  118.75   0.93 100.00
sdc               0.00 79368.00    0.00  581.00     0.00 74368.00   128.00   114.97  175.83   1.72 100.00
sdc               0.00 73152.00    0.00  575.00     0.00 73600.00   128.00   142.58  246.75   1.74 100.00
sdc               0.00 73152.00    0.00  575.00     0.00 73600.00   128.00   142.60  248.41   1.74 100.00
sdc               0.00 73937.00    0.00  580.00     0.00 74240.00   128.00   142.47  246.14   1.72 100.00
sdc               0.00 76431.00    0.00  578.00     0.00 73984.00   128.00   142.55  246.02   1.73 100.00
sdc               0.00 48768.00    0.00  408.00     0.00 52224.00   128.00   139.84  246.35   2.45 100.00
sdc               0.00 48285.15    0.00  377.23     0.00 48285.15   128.00   138.09  468.92   2.62  99.01
sdc               0.00 65024.00    0.00  515.00     0.00 65920.00   128.00   141.67  251.21   1.94 100.00
sdc               0.00 36456.00    0.00  264.00     0.00 33792.00   128.00   137.37  567.71   3.79 100.00
sdc               0.00 63627.00    0.00  572.00     0.00 73216.00   128.00   138.69  249.88   1.75 100.00
sdc               0.00 33267.00    0.00  216.00     0.00 27648.00   128.00   134.71  259.25   4.63 100.00
sdc               0.00 76334.00    0.00  578.00     0.00 74112.00   128.22   142.35  375.04   1.73 100.00
sdc               0.00 52952.00    0.00  418.00     0.00 53376.00   127.69   145.37  249.30   2.39 100.00
sdc               0.00 44584.00    0.00  356.00     0.00 45568.00   128.00   146.73  524.89   2.81 100.10
sdc               0.00 52952.00    0.00  412.00     0.00 52736.00   128.00   145.21  251.41   2.42  99.90
sdc               0.00 44142.57    0.00  352.48     0.00 45116.83   128.00   145.05  531.77   2.81  99.01
sdc               0.00 52952.00    0.00  412.00     0.00 52736.00   128.00   145.43  248.08   2.43 100.00
sdc               0.00 40640.00    0.00  336.00     0.00 43008.00   128.00   146.81  564.42   2.98 100.00
sdc               0.00 56896.00    0.00  432.00     0.00 55296.00   128.00   144.92  251.52   2.31 100.00
sdc               0.00 36636.00    0.00  314.00     0.00 40192.00   128.00   147.12  583.40   3.18 100.00
sdc               0.00 60900.00    0.00  454.00     0.00 58112.00   128.00   144.48  257.85   2.20 100.00
sdc               0.00 32512.00    0.00  277.00     0.00 35456.00   128.00   147.73  631.81   3.61 100.00

Is it tightly related to two interleaved write streams (the performance drop
starts and stops with the second write stream)?  If so, it sounds like a SSD
hardware/firmware problem.

Thanks,
Fengguang
