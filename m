Return-Path: <linux-kernel-owner+w=401wt.eu-S1760106AbXLNGuL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760106AbXLNGuL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 01:50:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753464AbXLNGt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 01:49:59 -0500
Received: from mga10.intel.com ([192.55.52.92]:30749 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753326AbXLNGt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 01:49:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.24,164,1196668800"; 
   d="scan'208";a="438219081"
Subject: Re: Reducing the bdi proporion calculation period to speed up disk
	write
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: zhejiang <zhe.jiang@intel.com>, linux-kernel@vger.kernel.org
In-Reply-To: <1197367861.6985.14.camel@twins>
References: <1197354339.668.62.camel@localhost.localdomain>
	 <1197367861.6985.14.camel@twins>
Content-Type: text/plain; charset=utf-8
Date: Fri, 14 Dec 2007 14:45:26 +0800
Message-Id: <1197614726.6362.137.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.9.2 (2.9.2-2.fc7) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-12-11 at 11:11 +0100, Peter Zijlstra wrote:
> On Tue, 2007-12-11 at 14:25 +0800, zhejiang wrote:
> > The patch 04fbfdc14e5f48463820d6b9807daa5e9c92c51f implemented bdi per
> > device dirty threshold. It works well.
> > However, the period for proportion calculation may be too large.
> > For 8G memory, the calc_period_shift() will return 19 as the shift.
> > 
> > When we switch writing operation between different disks, there may be
> > potential performance issue.
> > 
> > For example, we first write to disk A, then write to disk B.
> > The proportion for disk B will increase slowly because the denominator
> > is too large (It's 2^18 + (global_count & counter_mask)).
> > The disk B will get small dirty page quota for a long time,
> > it will get blocked frequently though the total dirty page is under the
> > dirty page limit.
> > 
> > Peter provided a patch to avoid this issue, this patch allow violation
> > of bdi limits if there is a lot of room on the system.
> > It looks like:
> > 
> > +if (nr_reclaimable + nr_writeback < (background_thresh +
> > dirty_thresh) / 2)
> > +                     break; 
> > 
> > This patch really help to avoid congestion, but if the dirty pages
> > exceed about 3/4 of the dirty_thresh, congestion still happens if we
> > write to another disk. 
> > 
> > I think that we can reduce the period to speed up the proportion
> > adjustment. 
> > 
> > diff -Nur a/page-writeback.c b/page-writeback.c
> > --- a/page-writeback.c  2007-12-11 13:46:30.000000000 +0800
> > +++ b/page-writeback.c  2007-12-11 13:47:11.000000000 +0800
> > @@ -128,10 +128,7 @@
> >   */
> >  static int calc_period_shift(void)
> >  {
> > -       unsigned long dirty_total;
> > -
> > -       dirty_total = (vm_dirty_ratio * determine_dirtyable_memory()) /
> > 100;
> > -       return 2 + ilog2(dirty_total - 1);
> > +       return 12;
> >  }
> 
> Its a heuristic, it might need some tuning, but a static value is wrong.
> I think its generally true that the larger the machine memory size, the
> faster the storage subsystem. And the more likely it has more disks.
> 
> One of the reasons this value isn't static is that with your fixed 12 it
> becomes very hard to balance over more than 4096 active devices. Of
> course, it takes quite a special set-up to get into that situation.
I strongly agree with you that a static value is not a good idea.

> 
> As it is, it now takes about 2 * dirty limit to switch over, you could
> start by making that just a single, or maybe even half a, dirty limit.
We will do more testing to choose a better formular based on dirty_ratio
and total memory.

> 
> 
> Also, I'm not quite convinced your benchmark is all that useful. Do you
> really think it matches an actual frequently occurring usage pattern?
We used iozone to test 1.2GB sequential write/rewrite. It's hard to match
exactly an actual usage pattern, but I have an example. Administrator
might backup big files to other free disks periodically although he/she might
not need it fast.

-yanmin


