Return-Path: <linux-kernel-owner+w=401wt.eu-S1754040AbYJCM2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754040AbYJCM2R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 08:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbYJCM2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 08:28:03 -0400
Received: from smtp119.mail.mud.yahoo.com ([209.191.84.76]:31368 "HELO
	smtp119.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753199AbYJCM2B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 08:28:01 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=xwWeD9euQZ2xEv/F1ntOIRQuZ7T0viV9ka4UB5FjPAKCgtZnbq5Uk3lVwi5zK4xSgjlRrOXThTtHx9qoTwMN3yrVTcxQFE8mYBTyA1bwnxG3OQYuo++LxoTjBR59UFulrOUO2Fmdfn7uG5trz58huoZPwWviVEpkuXY78hWmWVk=  ;
X-YMail-OSG: PHjtyjUVM1mRqX.fv0K7QSKC6y3oc9lJxyoat_o0EAOSFOW5YbHJJhrSpmhe6uEEeEQ9Gb_UCC_cOg1MB9GnqEusAGQ6QBMFaP94K5z4FQBFCvqWWd3hwP4tzl_7EMxFbIe4wsmfRNYIW6OvD68kWiynDYQi0H4nCvFCHRI80_qrVT6v92w-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Mikulas Patocka <mpatocka@redhat.com>
Subject: Re: [PATCH] Memory management livelock
Date: Fri, 3 Oct 2008 22:27:50 +1000
User-Agent: KMail/1.9.5
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       agk@redhat.com, mbroz@redhat.com, chris@arachsys.com
References: <20080911101616.GA24064@agk.fab.redhat.com> <20081002205604.47910d6d.akpm@linux-foundation.org> <Pine.LNX.4.64.0810030729290.4875@hs20-bc2-1.build.redhat.com>
In-Reply-To: <Pine.LNX.4.64.0810030729290.4875@hs20-bc2-1.build.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200810032227.50892.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 October 2008 21:43, Mikulas Patocka wrote:
> On Thu, 2 Oct 2008, Andrew Morton wrote:
> > On Fri, 3 Oct 2008 13:47:21 +1000 Nick Piggin <nickpiggin@yahoo.com.au> 
wrote:
> > > > I expect there's no solution which avoids blocking the writers at
> > > > some stage.
> > >
> > > See my other email. Something roughly like this would do the trick
> > > (hey, it actually boots and runs and does fix the problem too).
> >
> > It needs exclusion to protect all those temp tags.  Is do_fsync()'s
> > i_mutex sufficient?  It's qute unobvious (and unmaintainable?) that all
> > the callers of this stuff are running under that lock.
>
> That filemap_fdatawrite and filemap_fdatawait in fsync() aren't really
> called under i_mutex (see do_fsync).
>
> So the possible solutions are:
>
> 1. Add jiffies when the page was diried and wroteback to struct page
> + no impact on locking and concurrency
> - increases the structure by 8 bytes

This one is not practical.


> 2. Stop the writers when the starvation happens (what I did)
> + doesn't do any locking if the livelock doesn't happen
> - locks writers when the livelock happens (I think it's not really serious
> --- because very few people complained about the livelock, very few people
> will see performance degradation from blocking the writers).

Maybe it is because not much actually does sequential writes to a massive
file or block device while trying to fsync it as well? I don't know. You
could still have cases where fsync takes much longer than expected but it
is still not long enough for a user to report it as a "livelock" bug.


> 3. Add another bit to radix tree (what Nick did)
> + doesn't ever block writers
> - unconditionally takes the lock on fsync path and serializates concurrent
> syncs/fsyncs. Probably low overhead too ... or I don't know, is there any
> possible situation when more processes execute sync() in parallel and user
> would see degradations if those syncs were serialized?

