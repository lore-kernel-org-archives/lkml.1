Return-Path: <linux-kernel-owner+w=401wt.eu-S1754028Ab0ARCQl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab0ARCQl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jan 2010 21:16:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753844Ab0ARCQk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jan 2010 21:16:40 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:55445 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab0ARCQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jan 2010 21:16:39 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC][PATCH] PM: Force GFP_NOIO during suspend/resume (was: Re: [linux-pm] Memory allocations in .suspend became very unreliable)
Cc: kosaki.motohiro@jp.fujitsu.com, Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, "linux-mm" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <201001170138.37283.rjw@sisk.pl>
References: <201001162317.39940.rjw@sisk.pl> <201001170138.37283.rjw@sisk.pl>
Message-Id: <20100118110324.AE30.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Mon, 18 Jan 2010 11:16:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi,
> 
> I thing the snippet below is a good summary of what this is about.
> 
> On Saturday 16 January 2010, Rafael J. Wysocki wrote:
> > On Saturday 16 January 2010, Maxim Levitsky wrote:
> > > On Sat, 2010-01-16 at 01:57 +0100, Rafael J. Wysocki wrote: 
> > > > On Saturday 16 January 2010, Maxim Levitsky wrote:
> > > > > On Fri, 2010-01-15 at 23:03 +0100, Rafael J. Wysocki wrote: 
> > > > > > On Friday 15 January 2010, Maxim Levitsky wrote:
> > > > > > > Hi,
> > > > > > 
> > > > > > Hi,
> > > > > > 
> > > > > > > I know that this is very controversial, because here I want to describe
> > > > > > > a problem in a proprietary driver that happens now in 2.6.33-rc3
> > > > > > > I am taking about nvidia driver.
> > > > > > > 
> > > > > > > Some time ago I did very long hibernate test and found no errors after
> > > > > > > more that 200 cycles.
> > > > > > > 
> > > > > > > Now I update to 2.6.33 and notice that system will hand when nvidia
> > > > > > > driver allocates memory is their .suspend functions. 
> > > > > > 
> > > > > > They shouldn't do that, there's no guarantee that's going to work at all.
> > > > > > 
> > > > > > > This could fail in 2.6.32 if I would run many memory hungry
> > > > > > > applications, but now this happens with most of memory free.
> > > > > > 
> > > > > > This sounds a little strange.  What's the requested size of the image?
> > > > > Don't know, but system has to be very tight on memory.
> > > > 
> > > > Can you send full dmesg, please?
> > > 
> > > I deleted it, but for this case I think that hang was somewhere else.
> > > This task was hand on doing forking, which probably happened even before
> > > the freezer.
> > > 
> > > Anyway, the problem is clear. Now __get_free_pages blocks more often,
> > > and can block in .suspend even if there is plenty of memory free.
> 
> This is suspicious, but I leave it to the MM people for consideration.
> 
> > > I now patched nvidia to use GFP_ATOMIC _always_, and problem disappear.
> > > It isn't such great solution when memory is tight though....
> > > 
> > > This is going to hit hard all nvidia users...
> > 
> > Well, generally speaking, no driver should ever allocate memory using
> > GFP_KERNEL in its .suspend() routine, because that's not going to work, as you
> > can readily see.  So this is a NVidia bug, hands down.
> > 
> > Now having said that, we've been considering a change that will turn all
> > GFP_KERNEL allocations into GFP_NOIO during suspend/resume, so perhaps I'll
> > prepare a patch to do that and let's see what people think.
> 
> If I didn't confuse anything (which is likely, because it's a bit late here
> now), the patch below should do the trick.  I have only checked that it doesn't
> break compilation, so please take it with a grain of salt.
> 
> Comments welcome.

Hmm..
I don't think this is good idea.

GFP_NOIO mean "Please don't reclaim if the page is dirty". It mean the system
have lots dirty pages, this patch might makes hung up.

If suspend need lots memory, we need to make free memory before starting IO
suspending, I think.



