Return-Path: <linux-kernel-owner+w=401wt.eu-S1755129AbYBDVtY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755129AbYBDVtY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 16:49:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753855AbYBDVtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 16:49:17 -0500
Received: from mga11.intel.com ([192.55.52.93]:47675 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753359AbYBDVtQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 16:49:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,304,1199692800"; 
   d="scan'208";a="295738307"
Date: Mon, 4 Feb 2008 13:47:57 -0800
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: Nick Piggin <npiggin@suse.de>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       linux-kernel@vger.kernel.org, arjan@linux.intel.com, mingo@elte.hu,
       ak@suse.de, jens.axboe@oracle.com, James.Bottomley@SteelEye.com,
       andrea@suse.de, clameter@sgi.com, akpm@linux-foundation.org,
       andrew.vasquez@qlogic.com, willy@linux.intel.com,
       Zach Brown <zach.brown@oracle.com>
Subject: Re: [rfc] direct IO submission and completion scalability issues
Message-ID: <20080204214757.GA19592@linux-os.sc.intel.com>
References: <20070728012128.GB10033@linux-os.sc.intel.com> <20080203095252.GA11043@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080203095252.GA11043@wotan.suse.de>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2008 at 10:52:52AM +0100, Nick Piggin wrote:
> Hi guys,
> 
> Just had another way we might do this. Migrate the completions out to
> the submitting CPUs rather than migrate submission into the completing
> CPU.

Hi Nick, This was the first experiment I tried on a quad core four
package SMP platform. And it didn't show much improvement in my
prototype(my protoype was migrating the softirq to the kblockd context
of the submitting CPU).

In the OLTP workload, quite a bit of activity happens below the block layer
and by the time we come to softirq, some damage is done in
slab, scsi cmds, timers etc. Last year OLS paper
(http://ols.108.redhat.com/2007/Reprints/gough-Reprint.pdf)
shows different cache lines that are contended in the kernel for the
OLTP workload.

Softirq migration should atleast reduce the cacheline contention that
happens in sched and AIO layers. I didn't spend much time why my softirq
migration patch didn't help much (as I was behind bigger birds of migrating
IO submission to completion CPU at that time). If this solution has
less side-effects and easily acceptable, then we can analyze the softirq
migration patch further and findout the potential.

While there is some potential with the softirq migration, full potential
can be exploited by making the IO submission and completion on the same CPU.

thanks,
suresh
