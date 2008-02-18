Return-Path: <linux-kernel-owner+w=401wt.eu-S1759318AbYBRNYj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759318AbYBRNYj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 08:24:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751751AbYBRNYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 08:24:31 -0500
Received: from hobbit.corpit.ru ([81.13.94.6]:23490 "EHLO hobbit.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563AbYBRNY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 08:24:29 -0500
Message-ID: <47B9870B.8060005@msgid.tls.msk.ru>
Date: Mon, 18 Feb 2008 16:24:27 +0300
From: Michael Tokarev <mjt@tls.msk.ru>
User-Agent: Icedove 1.5.0.12 (X11/20070607)
MIME-Version: 1.0
To: Ric Wheeler <ric@emc.com>
CC: device-mapper development <dm-devel@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [dm-devel] Re: [PATCH] Implement barrier support for single device
 DM devices
References: <20080215120821.GA8267@basil.nowhere.org> <20080215122002.GM29914@agk.fab.redhat.com> <47B58EAA.8040405@msgid.tls.msk.ru> <20080215142010.GA29552@one.firstfloor.org> <20080215141229.GB1788@agk.fab.redhat.com> <47B97E87.6040209@emc.com>
In-Reply-To: <47B97E87.6040209@emc.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ric Wheeler wrote:
> Alasdair G Kergon wrote:
>> On Fri, Feb 15, 2008 at 03:20:10PM +0100, Andi Kleen wrote:
>>> On Fri, Feb 15, 2008 at 04:07:54PM +0300, Michael Tokarev wrote:
>>>> I wonder if it's worth the effort to try to implement this.
>>
>> My personal view (which seems to be in the minority) is that it's a
>> waste of our development time *except* in the (rare?) cases similar to
>> the ones Andi is talking about.
> 
> Using working barriers is important for normal users when you really
> care about data loss and have normal drives in a box. We do power fail
> testing on boxes (with reiserfs and ext3) and can definitely see a lot
> of file system corruption eliminated over power failures when barriers
> are enabled properly.
> 
> It is not unreasonable for some machines to disable barriers to get a
> performance boost, but I would not do that when you are storing things
> you really need back.

The talk here is about something different - about supporting barriers
on md/dm devices, i.e., on pseudo-devices which uses multiple real devices
as components (software RAIDs etc).  In this "world" it's nearly impossible
to support barriers if there are more than one underlying component device,
barriers only works if there's only one component.  And the talk is about
supporting barriers only in "minority" of cases - mostly for simplest
device-mapper case only, NOT covering any raid1 or other "fancy" configurations.

> Of course, you don't need barriers when you either disable the write
> cache on the drives or use a battery backed RAID array which gives you a
> write cache that will survive power outages...

Two things here.

First, I still don't understand why in God's sake barriers are "working"
while regular cache flushes are not.  Almost no consumer-grade hard drive
supports write barriers, but they all support regular cache flushes, and
the latter should be enough (while not the most speed-optimal) to ensure
data safety.  Why to require write cache disable (like in XFS FAQ) instead
of going the flush-cache-when-appropriate (as opposed to write-barrier-
when-appropriate) way?

And second, "surprisingly", battery-backed RAID write caches tends to fail
too, sometimes... ;)  Usually, such a battery is enough to keep the data
in memory for several hours only (sine many RAID controllers uses regular
RAM for memory caches, which requires some power to keep its state), --
I come across this issue the hard way, and realized that only very few
persons around me who manages raid systems even knows about this problem -
that the battery-backed cache is only for some time...  For example,
power failed at evening, and by tomorrow morning, batteries are empty
already.  Or, with better batteries, think about a weekend... ;)
(I've seen some vendors now uses flash-based backing store for caches
instead, which should ensure far better results here).

/mjt
