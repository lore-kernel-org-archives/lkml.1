Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbZGMH1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbZGMH1t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 03:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbZGMH1o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 03:27:44 -0400
Received: from mga14.intel.com ([143.182.124.37]:54336 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889AbZGMH1n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 03:27:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,389,1243839600"; 
   d="scan'208";a="164276713"
Date: Mon, 13 Jul 2009 15:27:01 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
Subject: Re: [Bug #13726] fio sync read 4k block size 35% regression
Message-ID: <20090713072701.GA11630@localhost>
References: <35kKlbXMqWN.A.RXD.D0oUKB@chimera> <dWkuWjWDsSB.A.lME.S0oUKB@chimera> <1246946802.2560.532.camel@ymzhang> <20090710063730.GA23814@localhost> <1247211714.2560.546.camel@ymzhang> <20090710081736.GA27471@localhost> <1247453490.2560.574.camel@ymzhang>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1247453490.2560.574.camel@ymzhang>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 13, 2009 at 10:51:30AM +0800, Zhang, Yanmin wrote:
> On Fri, 2009-07-10 at 16:17 +0800, Wu Fengguang wrote:
> > On Fri, Jul 10, 2009 at 03:41:54PM +0800, Zhang, Yanmin wrote:
> > > On Fri, 2009-07-10 at 14:37 +0800, Wu Fengguang wrote:
> > > > On Tue, Jul 07, 2009 at 02:06:42PM +0800, Zhang, Yanmin wrote:
> > > > > On Tue, 2009-07-07 at 02:01 +0200, Rafael J. Wysocki wrote:
> > > > > > This message has been generated automatically as a part of a report
> > > > > > of recent regressions.
> > > > > > 
> > > > > > The following bug entry is on the current list of known regressions
> > > > > > from 2.6.30.  Please verify if it still should be listed and let me know
> > > > > > (either way).
> > > > > > 
> > > > > > 
> > > > > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13726
> > > > > > Subject		: fio sync read 4k block size 35% regression
> > > > > > Submitter	: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> > > > > > Date		: 2009-07-01 11:25 (6 days old)
> > > > > > First-Bad-Commit: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=51daa88ebd8e0d437289f589af29d4b39379ea76
> > > > > > References	: http://lkml.org/lkml/2009/6/30/679
> > > > > > Handled-By	: Wu Fengguang <fengguang.wu@intel.com>
> > > > > Fengguang,
> > > > > 
> > > > > I'm still working on it now. The new testing against 2.6.31-rc2 is ongoing.
> > > > > fio sync/mmap read has new behavior. I did collect some data. But suddenly
> > > > > with new created data, the fio_sync_read_4k regression disappeared, while
> > > > 
> > > > Do you mean the fio_sync_read_4k regression disappeared because we are
> > > > collecting data with lots of printks?
> > > No. I recreated the data and the regression disappeared.
> > 
> > OK. It's because you recreated the files, instead of upgrading to -rc2?
> Yes.
> 
> > 
> > > > 
> > > > > fio_mmap_read is still there. Originally, the testing and bisect were stable.
> > > > > Let me check what happens firstly.
> > > > 
> > > > Thanks! What's your fio_mmap_read job file and the readahead traces?
> > > I dumped trace data of fio and found the sync read isn't really sequential. I
> > > create many processes and every process could read a group of files. The trace
> > > shows fio reads a record of a file, then switch to another file to read. My
> > > original assumption is a process reads the complete file sequentially and then
> > > read the 2nd file. Now I upgrade fio the latest version and add parameter
> > > file_service_type=random:4000000 to rerun all testing.
> > 
> > However you organize the workload, it is a regression. If you mean
> > "this workload is expected to create regressions", then let's improve
> > the algorithm to cover that workload?
> Thanks Fengguang. You work carefully and be ready to resolve any regression.
> 
> When creating the workloads, I try to simulate _RealUsageModels_. For example,
> fio_mmap_sync_read and fio_sync_read are to simulate ftp/web server and media
> player to ﻿download big files. Such workloads mostly read files sequentially, not
> interspersally among many files. I also have other workloads, such like

Yes, file servers mostly read files sequentially.  But they do not
necessarily spawn one thread/process for each client (eg. lighttpd).
So you are testing some real workloads :)

> fio_mmap_rand_read/write simulating small/medium databases, which need IO
> interspersally among a coulpe of files.

Hmm, it seems that both regressions have something to do with
"one process accessing several files".

> As for this report, my original testing reads files ﻿interspersally. It's hard to
> find the usage models. In other hand, sometimes a method to improve one workload
> might hurt other workloads. So let's focus on good workloads.
> 
> With the latest version of fio and new parameters, I found some other regressions.
> I will check them and report if necessary.
> 
> > 
> > In your previous workload, what's the exact read pattern for any
> > single file over time?
> Sequential read, but read a block (4k64k/128k), then switch to next file to read
> another block. As for single file, read sequentially.
> If there are 3 files:
> 1) read 1st block of f1; then read 1st block of f2; then f3;
> 2) read 2nd block of f1;﻿ then read 2nd block of f2; then f3;
> 3) ...

In this case,
- one process process may issue IO for several files
  aka. random seeking
- several processes may issue IO for the same file
  aka. cooperative processes
The above IO patterns may well confuse the underlying CFQ io scheduler.

Would you please try rerun the test with

for param in /sys/block/sd?/queue/iosched/slice_idle
do
        echo 0 > $param
done

> Such read scenario isn't good. I created it incorrectly because I misunderstood
> some parameters of fio.
> 
> Pls. close the report.

No, you created a very good test scheme!  Let's fix this regression :)

Thanks,
Fengguang
