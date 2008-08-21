Return-Path: <linux-kernel-owner+w=401wt.eu-S1754771AbYHUJd4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771AbYHUJd4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 05:33:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752019AbYHUJdp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 05:33:45 -0400
Received: from smtp106.mail.mud.yahoo.com ([209.191.85.216]:27812 "HELO
	smtp106.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751707AbYHUJdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 05:33:44 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=L+2l8b/wlHV3YsazCTWAwpImMHY5KUP2Z5dgWdDqW6H0MsLEgxNhwodOi+nEigDg/b7Pm0xvEOjAb8nqvBsz5nrZtWjs4KGaUgb0RdwHRICAJ2f2V03eikib7E2I5731fVtOq5ErpZj/Ur8AEKVgG6CZkYZIGeAeKrdiQg7HvxY=  ;
X-YMail-OSG: YSUfezAVM1nIYEVb080VtwO88mds1qzAt3muyAZmqnvhtTS8s16__hdUaIwEs4Uu6HP_vlFBjMaNmFBxjcnQcXt7OR.GQeoTDVbu.dZ3fJUTzKPq9C1z488X6Blp1SJd7kM-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS vs Elevators (was Re: [PATCH RFC] nilfs2: continuous snapshotting file system)
Date: Thu, 21 Aug 2008 19:33:34 +1000
User-Agent: KMail/1.9.5
Cc: gus3 <musicman529@yahoo.com>, Szabolcs Szakacsits <szaka@ntfs-3g.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
References: <20080821051508.GB5706@disturbed> <200808211700.39584.nickpiggin@yahoo.com.au> <20080821085332.GG5706@disturbed>
In-Reply-To: <20080821085332.GG5706@disturbed>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808211933.34565.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 August 2008 18:53, Dave Chinner wrote:
> On Thu, Aug 21, 2008 at 05:00:39PM +1000, Nick Piggin wrote:
> > On Thursday 21 August 2008 16:14, Dave Chinner wrote:
> > > I think that we need to issue explicit unplugs to get the log I/O
> > > dispatched the way we want on all elevators and stop trying to
> > > give elevators implicit hints by abusing the bio types and hoping
> > > they do the right thing....
> >
> > FWIW, my explicit plugging idea is still hanging around in one of
> > Jens' block trees (actually he refreshed it a couple of months ago).
> >
> > It provides an API for VM or filesystems to plug and unplug
> > requests coming out of the current process, and it can reduce the
> > need to idle the queue. Needs more performance analysis and tuning
> > though.
>
> We've already got plenty of explicit unplugs in XFS to get stuff
> moving quickly - I'll just have to add another....

That doesn't really help at the elevator, though.


> > But existing plugging is below the level of the elevators, and should
> > only kick in for at most tens of ms at queue idle events, so it sounds
> > like it may not be your problem. Elevators will need some hint to give
> > priority to specific requests -- either via the current threads's io
> > priority, or information attached to bios.
>
> It's getting too bloody complex, IMO. What is right for one elevator
> is wrong for another, so as a filesystem developer I have to pick
> one to target.

I don't really see it as too complex. If you know how you want the
request to be handled, then it should be possible to implement.


> With the way the elevators have been regressing, 
> improving and changing behaviour,

AFAIK deadline, AS, and noop haven't significantly changed for years.


> I am starting to think that I 
> should be picking the noop scheduler.
> Any 'advanced' scheduler that 
> is slower than the same test on the noop scheduler needs fixing...

I disagree. On devices with no seek penalty or their own queueing,
noop is often the best choice. Same for specialized apps that do
their own disk scheduling.
