Return-Path: <linux-kernel-owner+w=401wt.eu-S1753404AbZIAIu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404AbZIAIu0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 04:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbZIAIuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 04:50:24 -0400
Received: from mga14.intel.com ([143.182.124.37]:54449 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379AbZIAIuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 04:50:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="182702861"
Date: Tue, 1 Sep 2009 16:14:58 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Fernando Silveira <fsilveira@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: I/O and pdflush
Message-ID: <20090901081458.GD1446@localhost>
References: <6afc6d4a0907111027w76234c8fv11ab77864515fdb0@mail.gmail.com> <20090712080410.GA8512@localhost> <6afc6d4a0908281448s537aa315jcb79b27453cf4279@mail.gmail.com> <20090829101247.GA20786@localhost> <20090829102126.GA22409@localhost> <6afc6d4a0908310624j47f9d8c7h47d98ecd95811883@mail.gmail.com> <20090831140006.GA23668@localhost> <20090831140113.GA24005@localhost> <20090831140713.GA24185@localhost> <6afc6d4a0908310733l6426e21fu11d826f6ffa6a2af@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6afc6d4a0908310733l6426e21fu11d826f6ffa6a2af@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 10:33:43PM +0800, Fernando Silveira wrote:
> On Mon, Aug 31, 2009 at 11:07, Wu Fengguang<fengguang.wu@intel.com> wrote:
> > On Mon, Aug 31, 2009 at 10:01:13PM +0800, Wu Fengguang wrote:
> >> On Mon, Aug 31, 2009 at 10:00:06PM +0800, Wu Fengguang wrote:
> >> > Hi Fernando,
> >> >
> >> > What's your SSD's IO parameters? Ie. output of this command:
> >> >
> >> >         grep -r . /sys/block/sda/queue/
> >> >
> >> > Please replace 'sda' with your SSD device name.
> >>
> >> Oh I guess it's sdc:
> >>
> >>          grep -r . /sys/block/sdc/queue/
> 
> Here is it:
> 
> # grep -r . /sys/block/sdc/queue/
> /sys/block/sdc/queue/nr_requests:128
> /sys/block/sdc/queue/read_ahead_kb:128
> /sys/block/sdc/queue/max_hw_sectors_kb:128
> /sys/block/sdc/queue/max_sectors_kb:128
> /sys/block/sdc/queue/scheduler:noop anticipatory [deadline] cfq
> /sys/block/sdc/queue/hw_sector_size:512
> /sys/block/sdc/queue/rotational:0
> /sys/block/sdc/queue/nomerges:0
> /sys/block/sdc/queue/rq_affinity:0
> /sys/block/sdc/queue/iostats:1
> /sys/block/sdc/queue/iosched/read_expire:500
> /sys/block/sdc/queue/iosched/write_expire:5000
> /sys/block/sdc/queue/iosched/writes_starved:2
> /sys/block/sdc/queue/iosched/front_merges:1
> /sys/block/sdc/queue/iosched/fifo_batch:16
> #
> 
> These are probably default settings.
> 
> > BTW, would you run "iostat -x 1 5" (which will run 5 seconds) when
> > doing I/O in ideal throughput, and when in 25MB/s thoughput state?
> 
> Both files are attached (25mbps = 25MB/s, 80mbps = 80MB/s).

The iostat reported IO size is 64kb, which is half of max_sectors_kb=128.
It is strange why the optimal 128kb IO size is not reached in both cases:

        Device:         rrqm/s   wrqm/s     r/s     w/s    rsec/s   wsec/s  avgrq-sz avgqu-sz   await  svctm  %util
case 1: sdc               0.00 69088.00     0.00  552.00     0.00 70656.00    128.00   142.75  386.39   1.81 100.10
case 2: sdc               0.00 153504.00    0.00 1200.00     0.00 153600.00   128.00   138.35  115.76   0.83 100.10

Fernando, could you try increasing these deadline parameters by 10
times?

        echo 160   > /sys/block/sdc/queue/iosched/fifo_batch
        echo 50000 > /sys/block/sdc/queue/iosched/write_expire

And try cfq iosched if that still fails? The iostat outputs would be
enough during the tests.

Thanks,
Fengguang
