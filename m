Return-Path: <linux-kernel-owner+w=401wt.eu-S1756204AbZJ2Fq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756204AbZJ2Fq3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 01:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750707AbZJ2Fq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 01:46:29 -0400
Received: from mail.gmx.net ([213.165.64.20]:34693 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755323AbZJ2Fq2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 01:46:28 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18zmaskws4z8S1zQSn/+DFhL1mRBpZ0Ou4ttq+2hD
	DDomKdz399F+Z/
Subject: Re: hackbench regression with kernel 2.6.32-rc1
From: Mike Galbraith <efault@gmx.de>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1256777448.16282.21.camel@ymzhang>
References: <1255079943.25078.23.camel@ymzhang>
	 <1255084986.8802.46.camel@laptop>  <1255331120.3684.43.camel@ymzhang>
	 <1255357264.10420.15.camel@twins>  <1255403522.3684.57.camel@ymzhang>
	 <1255691192.7029.13.camel@marge.simson.net>
	 <1256630584.16282.13.camel@ymzhang>
	 <1256654547.17752.13.camel@marge.simson.net>
	 <1256722141.16282.20.camel@ymzhang>
	 <1256739779.7503.59.camel@marge.simson.net>
	 <1256777448.16282.21.camel@ymzhang>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 29 Oct 2009 06:46:30 +0100
Message-Id: <1256795190.7048.63.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-29 at 08:50 +0800, Zhang, Yanmin wrote:
> On Wed, 2009-10-28 at 15:22 +0100, Mike Galbraith wrote:
> > On Wed, 2009-10-28 at 17:29 +0800, Zhang, Yanmin wrote:
> > > 	-Mike
> > > I'm investigating 5% tbench regression on Nehalem machine. perf_counter shows
> > > select_task_rq_fair consumes about 5% cpu time with 2.6.32-rc1 while it consumes
> > > less than 0.5% with 2.6.31.
> > > 
> > > Patch c88d5910890 has comments to explain it, but I still can't understand why
> > > to add complicated balance logic when selecting task rq.
> > > 
> > > I will check which section in function ﻿select_task_rq_fair consumes so much time.
> > 
> > Turn off SD_WAKE_BALANCE as it was called in rc1.  See commit 182a85f.
> I run testing against 2.6.32-rc1 which already includes the patch.

Duh, I checked the wrong tree.

SD_PREFER_LOCAL is still on in rc1 though (double checks;), so you'll go
through the power saving code until you reach a domain containing both
waker's cpu and wakee's previous cpu even if that code already found
that a higher domain wasn't overloaded.  Looks to me like that block
wants a want_sd && qualifier. 

Even it you turn SD_PREFER_LOCAL off, you can still hit the overhead if
SD_POWERSAVINGS_BALANCE is set, so I'd make sure both are off and see if
that's the source (likely, since the rest is already off).

	-Mike

