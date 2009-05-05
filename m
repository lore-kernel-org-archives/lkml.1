Return-Path: <linux-kernel-owner+w=401wt.eu-S1758726AbZEEVol@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758726AbZEEVol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 17:44:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753655AbZEEVob
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 17:44:31 -0400
Received: from [212.69.161.110] ([212.69.161.110]:34574 "EHLO
	mail09.linbit.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752917AbZEEVob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 17:44:31 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Subject: Re: [PATCH 00/16] DRBD: a block device for HA clusters
Date: Tue, 5 May 2009 23:45:19 +0200
User-Agent: KMail/1.11.0 (Linux/2.6.27-9-generic; KDE/4.2.0; i686; ; )
Cc: david@lang.hm, Willy Tarreau <w@1wt.eu>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Greg KH <gregkh@suse.de>,
       Neil Brown <neilb@suse.de>, Sam Ravnborg <sam@ravnborg.org>,
       Dave Jones <davej@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>,
       "Lars Marowsky-Bree" <lmb@suse.de>, Kyle Moffett <kyle@moffetthome.net>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com> <200905051756.29703.philipp.reisner@linbit.com> <1241543146.3312.57.camel@mulgrave.int.hansenpartnership.com>
In-Reply-To: <1241543146.3312.57.camel@mulgrave.int.hansenpartnership.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200905052345.20515.philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 05 Mai 2009 19:05:46 schrieb James Bottomley:
> On Tue, 2009-05-05 at 17:56 +0200, Philipp Reisner wrote:
> > On Tuesday 05 May 2009 16:09:45 James Bottomley wrote:
> > > On Tue, 2009-05-05 at 10:21 +0200, Philipp Reisner wrote:
> > > > > > When you do asynchronous replication, how do you ensure that
> > > > > > implicit write-after-write dependencies in the stream of writes
> > > > > > you get from the file system above, are not violated on the
> > > > > > secondary ?
> >
> > [...]
> >
> > > > > The way nbd does it (in the updated tools is to use DIRECT_IO and
> > > > > fsync).
> >
> > [...]
> >
> > > I think you'll find the dio/fsync method above actually does solve all
> > > of these issues (mainly because it enforces the semantics from top to
> > > bottom in the stack).  I agree one could use more elaborate semantics
> > > like you do for drbd, but since the simple ones worked efficiently for
> > > md/nbd, there didn't seem to be much point.
> >
> > Do I get it right, that you enforce the exact same write order on the
> > secondary node as the stream of writes was comming in on the primary?
>
> Um, yes ... that's the text book way of doing replication: write order
> preservation.
>
> > Using either DIRECT_IO or fsync() calls ?
>
> Yes.
>
> > Is DIRECT_IO/fsync() enabled by default ?
>
> I'd have to look at the tools (and, unfortunately, there are many
> variants) but it was certainly true in the variant I used.

[...]

My experience is that enforcing the exact same write order as on the primary
by using IO draining, kills performance. - Of course things are changing in 
a world where everybody uses a RAID controller with a gig of battery
backed RAM. But there are for sure some embedded users that run
the replication technology on top of plain hard disks.

What I want to work out is, that in DRBD we have that capability to allow
limited reordering on the secondary, to achieve the highest possible
performance, while maintaining these implicit write-after-write dependencies.

> I also think you're not quite looking at the important case: if you
> think about it, the real necessity for the ordered domain is the
> network, not so much the actual secondary server.  The reason is that
> it's very hard to find a failure case where the write order on the
> secondary from the network tap to disk actually matters (as long as the
> flight into the network tap was in order).  The standard failure is of
> the primary, not the secondary, so the network stream stops and so does
> the secondary writing: as long as we guarantee to stop at a consistent
> point in flight, everything works.  If the secondary fails while the
> primary is still up, that's just a standard replay to bring the
> secondary back into replication, so the issue doesn't arise there
> either.

A common power failure is possible. We aim for an HA system, we can
not ignore a possible failure scenario. No user will buy: Well in most
scenarios we do it correctly, in the unlikely case of a common power
failure, and you loose your former primary at the same time, you might
have a secondary with the last write but not that one write before!

Correctness before efficiency!

But I will now stop this discussion now. Proving that DRBD does some
details better than the md/nbd approch gets pointless, when we agreed
that DRBD can get merged as a driver. We will focus on the necessary
code cleanups.

-Phil

