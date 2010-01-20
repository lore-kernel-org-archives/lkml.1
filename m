Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408Ab0ATAdR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab0ATAdR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 19:33:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752495Ab0ATAdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 19:33:17 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42069 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab0ATAdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 19:33:16 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC][PATCH] PM: Force GFP_NOIO during suspend/resume (was: Re: [linux-pm] Memory allocations in .suspend became very unreliable)
Cc: kosaki.motohiro@jp.fujitsu.com,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, "linux-mm" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <201001192147.58185.rjw@sisk.pl>
References: <1263871194.724.520.camel@pasglop> <201001192147.58185.rjw@sisk.pl>
Message-Id: <20100120085053.405A.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 20 Jan 2010 09:33:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tuesday 19 January 2010, Benjamin Herrenschmidt wrote:
> > On Tue, 2010-01-19 at 10:19 +0900, KOSAKI Motohiro wrote:
> > > I think the race happen itself is bad. memory and I/O subsystem can't solve such race
> > > elegantly. These doesn't know enough suspend state knowlege. I think the practical 
> > > solution is that higher level design prevent the race happen.
> > > 
> > > 
> > > > My patch attempts to avoid these two problems as well as the problem with
> > > > drivers using GFP_KERNEL allocations during suspend which I admit might be
> > > > solved by reworking the drivers.
> > > 
> > > Agreed. In this case, only drivers change can solve the issue. 
> > 
> > As I explained earlier, this is near to impossible since the allocations
> > are too often burried deep down the call stack or simply because the
> > driver doesn't know that we started suspending -another- driver...
> > 
> > I don't think trying to solve those problems at the driver level is
> > realistic to be honest. This is one of those things where we really just
> > need to make allocators 'just work' from a driver perspective.
> > 
> > It can't be perfect of course, as mentioned earlier, there will be a
> > problem if too little free memory is really available due to lots of
> > dirty pages around, but most of this can be somewhat alleviated in
> > practice, for example by pushing things out a bit at suspend time,
> > making some more memory free etc... But yeah, nothing replaces proper
> > error handling in drivers for allocation failures even with
> > GFP_KERNEL :-)
> 
> Agreed.
> 
> Moreover, I didn't try to do anything about that before, because memory
> allocation problems during suspend/resume just didn't happen.  We kind of knew
> they were possible, but since they didn't show up, it wasn't immediately
> necessary to address them.
> 
> Now, however, people started to see these problems in testing and I'm quite
> confident that this is a result of recent changes in the mm subsystem.  Namely,
> if you read the Maxim's report carefully, you'll notice that in his test case
> the mm subsystem apparently attempted to use I/O even though there was free
> memory available in the system.  This is the case I want to prevent from
> happening in the first place.

Hi Rafael,

Do you mean this is the unrelated issue of nVidia bug? Probably I haven't
catch your point. I don't find Maxim's original bug report. Can we share
the test-case and your analysis detail?



