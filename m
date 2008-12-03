Return-Path: <linux-kernel-owner+w=401wt.eu-S1754917AbYLCEsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbYLCEsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 23:48:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbYLCErv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 23:47:51 -0500
Received: from mga05.intel.com ([192.55.52.89]:62752 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752139AbYLCErv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 23:47:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,706,1220252400"; 
   d="scan'208";a="410907757"
Subject: Re: [RFC][PATCH] Catch xtime_nsec underflows and fix them
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Roman Zippel <zippel@linux-m68k.org>
Cc: john stultz <johnstul@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       alex.shi@intel.com, Thomas Gleixner <tglx@tglx.de>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0812030436590.24668@localhost.localdomain>
References: <1228185281.7176.37.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0812022118330.24668@localhost.localdomain>
	 <1228273295.2866.189.camel@ymzhang>
	 <Pine.LNX.4.64.0812030436590.24668@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 03 Dec 2008 12:45:32 +0800
Message-Id: <1228279532.2866.192.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 2008-12-03 at 04:48 +0100, Roman Zippel wrote:
> Hi,
> 
> On Wed, 3 Dec 2008, Zhang, Yanmin wrote:
> 
> > > This doesn't explain the problem entirely, I considered a negative 
> > > xtime_nsec before, but xtime_nsec+offset should still be positive
> > ﻿xtime_nsec underflows after ﻿clocksource_adjust. Before ﻿clocksource_adjust,
> > ﻿xtime_nsec is a small positive.
> > 
> > When ﻿﻿xtime_nsec underflows at the first time, xtime.tv_nsec becomes -1.
> > Later on when the second tick arrives, below statement in the while loop
> >  clock->xtime_nsec += clock->xtime_interval;
> > will cause ﻿clock->xtime_nsec becomes positive again. So the second tick
> > appears a going-backward time.
> 
> Yes, but only by 1nsec, so normally it wouldn't be noticable.
Not 1nsec. At the second tick, go back about 4294967296 nsec (2^32), about
4 seconds. That matches the output of testing process.

> 
> > >  and 
> > > produce the correct result, at least I can't find anything in 
> > > getnstimeofday().
> > The testing uses vsyscall to get call gettimeofday. vsyscall_gtod_data.wall_time_nsec
> > is a u32 while timespec->tv_nsec is a signed long.
> 
> Ok, I was missing this part, I looked at the 32bit version of 
> getnstimeofday() and there xtime.tv_nsec was correctly sign extended.
> To be safe for the future wall_time_nsec should also be a s32.

