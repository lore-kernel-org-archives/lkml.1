Return-Path: <linux-kernel-owner+w=401wt.eu-S1754304Ab0A3S4O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab0A3S4O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jan 2010 13:56:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753864Ab0A3S4N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jan 2010 13:56:13 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:47098 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753815Ab0A3S4M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jan 2010 13:56:12 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Subject: Re: [Update][PATCH] MM / PM: Force GFP_NOIO during suspend/hibernation and resume
Date: Sat, 30 Jan 2010 19:56:41 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.33-rc6-rjw; KDE/4.3.5; x86_64; ; )
Cc: Maxim Levitsky <maximlevitsky@gmail.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-pm@lists.linux-foundation.org,
       LKML <linux-kernel@vger.kernel.org>, "linux-mm" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <201001212121.50272.rjw@sisk.pl> <201001252249.18690.rjw@sisk.pl> <4B5E1281.7090700@suse.de>
In-Reply-To: <4B5E1281.7090700@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201001301956.41372.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 January 2010, Alexey Starikovskiy wrote:
> Rafael J. Wysocki пишет:
> > On Saturday 23 January 2010, Maxim Levitsky wrote:
> >> On Fri, 2010-01-22 at 22:19 +0100, Rafael J. Wysocki wrote: 
> >>> On Friday 22 January 2010, Maxim Levitsky wrote:
> >>>> On Fri, 2010-01-22 at 10:42 +0900, KOSAKI Motohiro wrote: 
> >>>>>>>> Probably we have multiple option. but I don't think GFP_NOIO is good
> >>>>>>>> option. It assume the system have lots non-dirty cache memory and it isn't
> >>>>>>>> guranteed.
> >>>>>>> Basically nothing is guaranteed in this case.  However, does it actually make
> >>>>>>> things _worse_?  
> >>>>>> Hmm..
> >>>>>> Do you mean we don't need to prevent accidental suspend failure?
> >>>>>> Perhaps, I did misunderstand your intention. If you think your patch solve
> >>>>>> this this issue, I still disagree. but If you think your patch mitigate
> >>>>>> the pain of this issue, I agree it. I don't have any reason to oppose your
> >>>>>> first patch.
> >>>>> One question. Have anyone tested Rafael's $subject patch? 
> >>>>> Please post test result. if the issue disapper by the patch, we can
> >>>>> suppose the slowness is caused by i/o layer.
> >>>> I did.
> >>>>
> >>>> As far as I could see, patch does solve the problem I described.
> >>>>
> >>>> Does it affect speed of suspend? I can't say for sure. It seems to be
> >>>> the same.
> >>> Thanks for testing.
> >> I'll test that too, soon.
> >> Just to note that I left my hibernate loop run overnight, and now I am
> >> posting from my notebook after it did 590 hibernate cycles.
> > 
> > Did you have a chance to test it?
> > 
> >> Offtopic, but Note that to achieve that I had to stop using global acpi
> >> hardware lock. I tried all kinds of things, but for now it just hands
> >> from time to time.
> >> See http://bugzilla.kernel.org/show_bug.cgi?id=14668
> > 
> > I'm going to look at that later this week, although I'm not sure I can do more
> > than Alex about that.
> > 
> > Rafael
> Rafael,
> If you can point to where one may insert callback to be called just before handing control to resume kernel,
> it may help...

Generally speaking, I'd do that in a .suspend() callback of one of devices.

If that's inconvenient, you can also place it in the .pre_restore() platform
hibernate callback (drivers/acpi/sleep.c).  It only disables GPEs right now,
it might release the global lock as well.

The .pre_restore() callback is executed after all devices have been suspended,
so there's no danger any driver would re-acquire the global lock after that.

Rafael
