Return-Path: <linux-kernel-owner+w=401wt.eu-S1756410AbZJ2GZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410AbZJ2GZ4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 02:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753076AbZJ2GZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 02:25:55 -0400
Received: from mga06.intel.com ([134.134.136.21]:27764 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751798AbZJ2GZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 02:25:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,644,1249282800"; 
   d="scan'208";a="462505229"
Subject: Re: hackbench regression with kernel 2.6.32-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1256795190.7048.63.camel@marge.simson.net>
References: <1255079943.25078.23.camel@ymzhang>
	 <1255084986.8802.46.camel@laptop>  <1255331120.3684.43.camel@ymzhang>
	 <1255357264.10420.15.camel@twins>  <1255403522.3684.57.camel@ymzhang>
	 <1255691192.7029.13.camel@marge.simson.net>
	 <1256630584.16282.13.camel@ymzhang>
	 <1256654547.17752.13.camel@marge.simson.net>
	 <1256722141.16282.20.camel@ymzhang>
	 <1256739779.7503.59.camel@marge.simson.net>
	 <1256777448.16282.21.camel@ymzhang>
	 <1256795190.7048.63.camel@marge.simson.net>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 29 Oct 2009 14:26:48 +0800
Message-Id: <1256797608.16282.28.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-29 at 06:46 +0100, Mike Galbraith wrote:
> On Thu, 2009-10-29 at 08:50 +0800, Zhang, Yanmin wrote:
> > On Wed, 2009-10-28 at 15:22 +0100, Mike Galbraith wrote:
> > > On Wed, 2009-10-28 at 17:29 +0800, Zhang, Yanmin wrote:
> > > > 	-Mike
> > > > I'm investigating 5% tbench regression on Nehalem machine. perf_counter shows
> > > > select_task_rq_fair consumes about 5% cpu time with 2.6.32-rc1 while it consumes
> > > > less than 0.5% with 2.6.31.
> > > > 
> > > > Patch c88d5910890 has comments to explain it, but I still can't understand why
> > > > to add complicated balance logic when selecting task rq.
> > > > 
> > > > I will check which section in function ﻿select_task_rq_fair consumes so much time.
> > > 
> > > Turn off SD_WAKE_BALANCE as it was called in rc1.  See commit 182a85f.
> > I run testing against 2.6.32-rc1 which already includes the patch.
> 
> Duh, I checked the wrong tree.
> 
> SD_PREFER_LOCAL is still on in rc1 though (double checks;), so you'll go
> through the power saving code until you reach a domain containing both
> waker's cpu and wakee's previous cpu even if that code already found
> that a higher domain wasn't overloaded.  Looks to me like that block
> wants a want_sd && qualifier. 
> 
> Even it you turn SD_PREFER_LOCAL off, you can still hit the overhead if
> SD_POWERSAVINGS_BALANCE is set, so I'd make sure both are off and see if
> that's the source (likely, since the rest is already off).
Yes. ﻿SD_POWERSAVINGS_BALANCE is disabled by default. I applied Peter's patch which
turning ﻿SD_PREFER_LOCAL off for MC and cpu domain and it doesn't help.
perf counter shows ﻿select_task_rq_fair still consumes about 5% cpu time. Eventually,
I found for_each_cpu in for_each_domain consumes the 5% cpu time, because Peter's
patch doesn't turn off ﻿SD_PREFER_LOCAL for node domain.
I turned it off for node domain against the latest tips tree and tbench regression
disappears on a Nehalem machine and becomes about 2% on another one.

Can we turn it off for node domain by default?


