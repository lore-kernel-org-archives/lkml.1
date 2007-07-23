Return-Path: <linux-kernel-owner+w=401wt.eu-S933374AbXGWBJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933374AbXGWBJa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 21:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759547AbXGWBJU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 21:09:20 -0400
Received: from mga09.intel.com ([134.134.136.24]:52368 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758580AbXGWBJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 21:09:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,569,1175497200"; 
   d="scan'208";a="108761944"
Subject: Re: [PATCH] Optimize struct task_delay_info
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: balbir@linux.vnet.ibm.com
Cc: Shailabh Nagar <nagar1234@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1184733015.4688.46.camel@ymzhang>
References: <1184138034.3068.51.camel@ymzhang>
	 <4694C30E.1030607@linux.vnet.ibm.com>  <1184733015.4688.46.camel@ymzhang>
Content-Type: text/plain; charset=utf-8
Date: Mon, 23 Jul 2007 09:08:34 +0800
Message-Id: <1185152914.4688.50.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-18 at 12:30 +0800, Zhang, Yanmin wrote:
> On Wed, 2007-07-11 at 17:16 +0530, Balbir Singh wrote:
> > Zhang, Yanmin wrote:
> > > struct task_delay_info is used by per process block I/O delay statistics
> > > feature which is useful in kernel. This struct is not optimized.
> > > 
> > > My patch against kernel 2.6.22 shrinks it a half.
> > > 
> > > 1) Delete blkio_start and blkio_end. As the collection happens in
> > > io_schedule and io_schedule_timeout, we use local variables to
> > > replace them;
> > > 2) Delete lock. The change to the protected data has no nested cases.
> > > In addition, the result is for performance data collection, so it’s
> > > unnecessary to add such lock. 
> > > 3) Delete flags. It just has one value. Use the most significant bit of
> > > blkio_delay (64 bits) to mark it..
> > > 
> > > 
> > > Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>
> > 
> > Hi, Yanmin,
> > 
> > Did you see any particular performance issues with the delay accounting
> > patches? Is the patch tested; could you please provide test results?
> It's hard to find an appropriate benchmark to test it. Anyway, I used sysbench
> to test it on my x86_64 machine. My machine has 16 logical cpu, dual-core+hyperThread.
> memory is 8GB and disk is one SATA.
> 
> I tested both sequence and rand.
> 1) seq read/write:use command line:
> echo "3">/proc/sys/vm/drop_caches; sysbench --test=fileio --file-test-mode=seqrewr
> --num-threads=32 --file-total-size=1500M --max-requests=150000 --max-time=3000 run;
> 
> Run the command for 20 times and get average result:
> Without patch: 49.7511Mb/sec
> With patch: 51.6557Mb/sec
> Improvement: 3.8%
> 
> 
> 2) Rand read/write:use command line:
> echo "3">/proc/sys/vm/drop_caches; sysbench --test=fileio --file-test-mode=rndrw
> --num-threads=32 --file-total-size=800M --max-requests=15000 --max-time=3000 run;
> 
> Run the command for 10 times and get average result:
> Without patch: 7.25657Mb/sec
> With patch: 7.35052Mb/sec
> Improvement: 1.3%
> 
> 
> I didn't use application to read the delay accounting info. If I did, I guess the improvement
> is better.
> 
> > 
> > Meanwhile, I'll review these patches and I am correcting Shailabh's id
> > to his new email id.
Man,

What's your comment about the patch?

Thanks,
Yanmin
