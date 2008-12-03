Return-Path: <linux-kernel-owner+w=401wt.eu-S1755251AbYLCDtd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbYLCDtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 22:49:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751753AbYLCDtZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 22:49:25 -0500
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:4353 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbYLCDtZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 22:49:25 -0500
Date: Wed, 3 Dec 2008 04:48:16 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@localhost.localdomain
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
cc: john stultz <johnstul@us.ibm.com>, lkml <linux-kernel@vger.kernel.org>,
       alex.shi@intel.com, Thomas Gleixner <tglx@tglx.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH] Catch xtime_nsec underflows and fix them
In-Reply-To: <1228273295.2866.189.camel@ymzhang>
Message-ID: <Pine.LNX.4.64.0812030436590.24668@localhost.localdomain>
References: <1228185281.7176.37.camel@localhost.localdomain> 
 <Pine.LNX.4.64.0812022118330.24668@localhost.localdomain>
 <1228273295.2866.189.camel@ymzhang>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-132831531-1228276096=:24668"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-132831531-1228276096=:24668
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

Hi,

On Wed, 3 Dec 2008, Zhang, Yanmin wrote:

> > This doesn't explain the problem entirely, I considered a negative 
> > xtime_nsec before, but xtime_nsec+offset should still be positive
> ﻿xtime_nsec underflows after ﻿clocksource_adjust. Before ﻿clocksource_adjust,
> ﻿xtime_nsec is a small positive.
> 
> When ﻿﻿xtime_nsec underflows at the first time, xtime.tv_nsec becomes -1.
> Later on when the second tick arrives, below statement in the while loop
>  clock->xtime_nsec += clock->xtime_interval;
> will cause ﻿clock->xtime_nsec becomes positive again. So the second tick
> appears a going-backward time.

Yes, but only by 1nsec, so normally it wouldn't be noticable.

> >  and 
> > produce the correct result, at least I can't find anything in 
> > getnstimeofday().
> The testing uses vsyscall to get call gettimeofday. vsyscall_gtod_data.wall_time_nsec
> is a u32 while timespec->tv_nsec is a signed long.

Ok, I was missing this part, I looked at the 32bit version of 
getnstimeofday() and there xtime.tv_nsec was correctly sign extended.
To be safe for the future wall_time_nsec should also be a s32.

bye, Roman
--8323328-132831531-1228276096=:24668--
