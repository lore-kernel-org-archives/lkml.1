Return-Path: <linux-kernel-owner+w=401wt.eu-S1754808AbXGREbS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808AbXGREbS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 00:31:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751349AbXGREbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 00:31:04 -0400
Received: from mga05.intel.com ([192.55.52.89]:29782 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751210AbXGREbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 00:31:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.16,548,1175497200"; 
   d="scan'208";a="269674522"
Subject: Re: [PATCH] Optimize struct task_delay_info
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: balbir@linux.vnet.ibm.com
Cc: Shailabh Nagar <nagar1234@in.ibm.com>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4694C30E.1030607@linux.vnet.ibm.com>
References: <1184138034.3068.51.camel@ymzhang>
	 <4694C30E.1030607@linux.vnet.ibm.com>
Content-Type: text/plain; charset=utf-8
Date: Wed, 18 Jul 2007 12:30:15 +0800
Message-Id: <1184733015.4688.46.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-07-11 at 17:16 +0530, Balbir Singh wrote:
> Zhang, Yanmin wrote:
> > struct task_delay_info is used by per process block I/O delay statistics
> > feature which is useful in kernel. This struct is not optimized.
> > 
> > My patch against kernel 2.6.22 shrinks it a half.
> > 
> > 1) Delete blkio_start and blkio_end. As the collection happens in
> > io_schedule and io_schedule_timeout, we use local variables to
> > replace them;
> > 2) Delete lock. The change to the protected data has no nested cases.
> > In addition, the result is for performance data collection, so it’s
> > unnecessary to add such lock. 
> > 3) Delete flags. It just has one value. Use the most significant bit of
> > blkio_delay (64 bits) to mark it..
> > 
> > 
> > Signed-off-by: Zhang Yanmin <yanmin.zhang@intel.com>
> 
> Hi, Yanmin,
> 
> Did you see any particular performance issues with the delay accounting
> patches? Is the patch tested; could you please provide test results?
It's hard to find an appropriate benchmark to test it. Anyway, I used sysbench
to test it on my x86_64 machine. My machine has 16 logical cpu, dual-core+hyperThread.
memory is 8GB and disk is one SATA.

I tested both sequence and rand.
1) seq read/write:use command line:
echo "3">/proc/sys/vm/drop_caches; sysbench --test=fileio --file-test-mode=seqrewr
--num-threads=32 --file-total-size=1500M --max-requests=150000 --max-time=3000 run;

Run the command for 20 times and get average result:
Without patch: 49.7511Mb/sec
With patch: 51.6557Mb/sec
Improvement: 3.8%


2) Rand read/write:use command line:
echo "3">/proc/sys/vm/drop_caches; sysbench --test=fileio --file-test-mode=rndrw
--num-threads=32 --file-total-size=800M --max-requests=15000 --max-time=3000 run;

Run the command for 10 times and get average result:
Without patch: 7.25657Mb/sec
With patch: 7.35052Mb/sec
Improvement: 1.3%


I didn't use application to read the delay accounting info. If I did, I guess the improvement
is better.

> 
> Meanwhile, I'll review these patches and I am correcting Shailabh's id
> to his new email id.
Thanks.

Yanmin
