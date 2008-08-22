Return-Path: <linux-kernel-owner+w=401wt.eu-S1761362AbYHVC33@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761362AbYHVC33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 22:29:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754442AbYHVC3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 22:29:20 -0400
Received: from smtp114.mail.mud.yahoo.com ([209.191.84.67]:28587 "HELO
	smtp114.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752462AbYHVC3S convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 22:29:18 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=B2OnnGYaNfscLIJ7+XI5bZMJUKF8QtpzB3zNqn0RNs9PawB+vmBbOCQhaYTIpDGZK+p7y9NrHu/Nyu2+EDBHtwCJ4JwBZbrUfRYvBHz76Uyqlo06HKaf0D1esz1sCIyQ9jxro+GRhIC7NMz/e/uzFUQFbzz6JQuVgT+ig1E/OqU=  ;
X-YMail-OSG: KScCNAQVM1noSjLBUDHXeEUI_KDT1I.lDLnIoY7dl8KNy6Swu2nfCIhCNmyOT98KewMStg3UPefN_NhOwPVxPQ43f7X00yC.4UKssUUJjSluwTf6sjuEOLx5FROzjlEKnq0-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Dave Chinner <david@fromorbit.com>
Subject: Re: XFS vs Elevators (was Re: [PATCH RFC] nilfs2: continuous snapshotting file system)
Date: Fri, 22 Aug 2008 12:29:10 +1000
User-Agent: KMail/1.9.5
Cc: gus3 <musicman529@yahoo.com>, Szabolcs Szakacsits <szaka@ntfs-3g.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       xfs@oss.sgi.com
References: <20080821051508.GB5706@disturbed> <200808211933.34565.nickpiggin@yahoo.com.au> <20080821170854.GJ5706@disturbed>
In-Reply-To: <20080821170854.GJ5706@disturbed>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200808221229.11069.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 22 August 2008 03:08, Dave Chinner wrote:
> On Thu, Aug 21, 2008 at 07:33:34PM +1000, Nick Piggin wrote:

> > I don't really see it as too complex. If you know how you want the
> > request to be handled, then it should be possible to implement.
>
> That is the problem in a nutshell. Nobody can keep up with all
> the shiny new stuff that is being implemented,let alone the
> subtle behavioural differences that accumulate through such
> change...

I'm not sure exactly what you mean.. I certainly have not been keeping
up with all the changes here as I'm spending most of my time on other
things lately...

But from what I see, you've got a fairly good handle on analysing the
elevator behaviour (if only the end result). So if you were to tell
Jens that "these blocks" need more priority, or not to contribute to
a process's usage quota, etc. then I'm sure improvements could be
made.

Or am I completely misunderstanding you? :)


> > > With the way the elevators have been regressing,
> > > improving and changing behaviour,
> >
> > AFAIK deadline, AS, and noop haven't significantly changed for years.
>
> Yet they've regularly shown performance regressions because other
> stuff has been changing around them, right?

Is this rhetorical? Because I don't see how *they* could be showing
regular performance regressions. Deadline literally had its last
behaviour change nearly a year ago, and before that was before
recorded (git) history.

AS hasn't changed much more frequently, although I will grant that it
and CFS add a lot more complexity. So I would always compare results
with deadline or noop.


> > > I am starting to think that I
> > > should be picking the noop scheduler.
> > > Any 'advanced' scheduler that
> > > is slower than the same test on the noop scheduler needs fixing...
> >
> > I disagree. On devices with no seek penalty or their own queueing,
> > noop is often the best choice. Same for specialized apps that do
> > their own disk scheduling.
>
> A filesystem is nothing but a complex disk scheduler that
> has to handle vastly larger queues than an elevator. Іf the
> filesystem doesn't get it's disk scheduling right, then the
> elevator is irrelevant because nothing will fix the I/O
> problems in the filesystem algorithms.....

I wouldn't say it is so black and white if you have multiple processes
submitting IO. You get more opportunities to sort and merge things in
the disk scheduler, and you can do things like fairness and anticipatory
scheduling. But if XFS does enough of what you need, then by all means
use noop. There is an in-kernel API to change it (although it's
designed more for block devices than filesystems so it might not work
exactly for you).
