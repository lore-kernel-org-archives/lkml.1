Return-Path: <linux-kernel-owner+w=401wt.eu-S1760957AbZCaA21@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760957AbZCaA21 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 20:28:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756677AbZCaA2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 20:28:17 -0400
Received: from mga14.intel.com ([143.182.124.37]:36915 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756587AbZCaA2R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 20:28:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,449,1233561600"; 
   d="scan'208";a="125885338"
Date: Mon, 30 Mar 2009 17:28:15 -0700
From: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
To: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Cc: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: 2.6.29 git master and PAT problems
Message-ID: <20090331002815.GB10490@linux-os.sc.intel.com>
References: <200903302317.04515.a.miskiewicz@gmail.com> <200903302331.10995.a.miskiewicz@gmail.com> <1238449555.4529.1095.camel@localhost.localdomain> <200903310031.10335.a.miskiewicz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903310031.10335.a.miskiewicz@gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 30, 2009 at 03:31:09PM -0700, Arkadiusz Miskiewicz wrote:
> On Monday 30 of March 2009, Pallipadi, Venkatesh wrote:
> 
> More info follows. Now I've switched to
> e1c502482853f84606928f5a2f2eb6da1993cda1 which contains latest drm fixes and
> now I get much lower numbers of PAT errors but still.
> 
> > On Mon, 2009-03-30 at 14:31 -0700, Arkadiusz Miskiewicz wrote:
> > > On Monday 30 of March 2009, Pallipadi, Venkatesh wrote:
> > > > Patch here should get rid of these errors.
> > > >
> > > > http://marc.info/?l=linux-kernel&m=123788806506230&w=2
> > > >
> > > > The patch is in tip and on its way to upstream.
> > >
> > > The problem is that kernel I'm running already contains this patch (it's
> > > merged already). Other ideas?
> > >
> > > ratelimiting that error is good IMO anyway.
> >
> > Rate limiting will just work around the problem here. Ideally we should
> > never see these errors. So, it will be better if we can narrow down on
> > the bug resulting in these error messages.
> 
> Of course it's better. I'm saying that when these messages "fire" then it's
> hard to do anything else on the system for a while until these stop.
> 
> > Can you please send me the output of
> > # cat /debug/x86/pat_memtype_list
> > with debugfs mounted.
> > and
> > # cat /proc/mtrr
> 
> Two complets of logs below (second part done after reboot).
> 
> # cat /debug/x86/pat_memtype_list
> PAT memtype list:
> uncached-minus @ 0xbd6d1000-0xbd6d2000
> uncached-minus @ 0xbd6d2000-0xbd6d3000
> uncached-minus @ 0xbd6d3000-0xbd6d4000
> uncached-minus @ 0xbd706000-0xbd707000
> uncached-minus @ 0xbd707000-0xbd708000
> uncached-minus @ 0xbd96a000-0xbd96b000
> uncached-minus @ 0xbd96a000-0xbd96b000
> uncached-minus @ 0xbd96a000-0xbd97a000
> uncached-minus @ 0xbd979000-0xbd97a000
> uncached-minus @ 0xbd979000-0xbd97a000
> uncached-minus @ 0xbd979000-0xbd97a000
> uncached-minus @ 0xbd979000-0xbd97a000
> uncached-minus @ 0xbd979000-0xbd97a000
> uncached-minus @ 0xbd979000-0xbd97a000
> uncached-minus @ 0xbd979000-0xbd97a000
> uncached-minus @ 0xbd97b000-0xbd97c000
> uncached-minus @ 0xbd98b000-0xbd98e000
> uncached-minus @ 0xbd98b000-0xbd98d000
> uncached-minus @ 0xbd98d000-0xbd98e000
> uncached-minus @ 0xbd98e000-0xbd98f000
> uncached-minus @ 0xbd98e000-0xbd98f000
> uncached-minus @ 0xc2000000-0xc2001000
> write-combining @ 0xd0000000-0xe0000000
> write-combining @ 0xd2000000-0xd2020000
> write-combining @ 0xd2020000-0xd2512000
> write-combining @ 0xd2522000-0xd2523000
> write-combining @ 0xd26b7000-0xd26b8000
> write-combining @ 0xd26b8000-0xd26b9000
> write-combining @ 0xd26b9000-0xd26ba000
> write-combining @ 0xd26ba000-0xd26bb000
> write-combining @ 0xd26bb000-0xd26bc000
> write-combining @ 0xd26bc000-0xd26bd000
> write-combining @ 0xd26bd000-0xd26be000
> write-combining @ 0xd26be000-0xd26bf000


There seems to be two different problems here.
- We should not have that many single page ranges reserved. That will cause a
performance problem with drm even without the "freeing invalid type" error.
- "freeing invalid type" error itself. Seems to be caused due to some
unbalanced free along the drm path. We tried to find anything obvious in the
code that may be causing problem here. But, haven't found anything so far.
Will try to reproduce the problem internally and debug it further.

Thanks,
Venki
