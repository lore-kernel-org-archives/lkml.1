Return-Path: <linux-kernel-owner+w=401wt.eu-S1756055AbZEERF5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbZEERF5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 13:05:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754147AbZEERFt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 13:05:49 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:53387 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754316AbZEERFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 13:05:48 -0400
Subject: Re: [PATCH 00/16] DRBD: a block device for HA clusters
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: david@lang.hm, Willy Tarreau <w@1wt.eu>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Greg KH <gregkh@suse.de>,
       Neil Brown <neilb@suse.de>, Sam Ravnborg <sam@ravnborg.org>,
       Dave Jones <davej@redhat.com>, Nikanth Karthikesan <knikanth@suse.de>,
       Lars Marowsky-Bree <lmb@suse.de>, Kyle Moffett <kyle@moffetthome.net>,
       Lars Ellenberg <lars.ellenberg@linbit.com>
In-Reply-To: <200905051756.29703.philipp.reisner@linbit.com>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com>
	 <200905051021.33461.philipp.reisner@linbit.com>
	 <1241532585.3312.13.camel@mulgrave.int.hansenpartnership.com>
	 <200905051756.29703.philipp.reisner@linbit.com>
Content-Type: text/plain
Date: Tue, 05 May 2009 17:05:46 +0000
Message-Id: <1241543146.3312.57.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-05 at 17:56 +0200, Philipp Reisner wrote:
> On Tuesday 05 May 2009 16:09:45 James Bottomley wrote:
> > On Tue, 2009-05-05 at 10:21 +0200, Philipp Reisner wrote:
> > > > > When you do asynchronous replication, how do you ensure that implicit
> > > > > write-after-write dependencies in the stream of writes you get from
> > > > > the file system above, are not violated on the secondary ?
> > > >
> [...]
> > > > The way nbd does it (in the updated tools is to use DIRECT_IO and
> > > > fsync).
> > >
> [...]
> > I think you'll find the dio/fsync method above actually does solve all
> > of these issues (mainly because it enforces the semantics from top to
> > bottom in the stack).  I agree one could use more elaborate semantics
> > like you do for drbd, but since the simple ones worked efficiently for
> > md/nbd, there didn't seem to be much point.
> >
> 
> Do I get it right, that you enforce the exact same write order on the 
> secondary node as the stream of writes was comming in on the primary?

Um, yes ... that's the text book way of doing replication: write order
preservation.

> Using either DIRECT_IO or fsync() calls ?

Yes.

> Is DIRECT_IO/fsync() enabled by default ?

I'd have to look at the tools (and, unfortunately, there are many
variants) but it was certainly true in the variant I used.  However, the
current main use case of md/nbd is a secondary transaction log to allow
rollback anyway, so the incoming network stream is stored on the device
in write order and the problem doesn't arise.

I also think you're not quite looking at the important case: if you
think about it, the real necessity for the ordered domain is the
network, not so much the actual secondary server.  The reason is that
it's very hard to find a failure case where the write order on the
secondary from the network tap to disk actually matters (as long as the
flight into the network tap was in order).  The standard failure is of
the primary, not the secondary, so the network stream stops and so does
the secondary writing: as long as we guarantee to stop at a consistent
point in flight, everything works.  If the secondary fails while the
primary is still up, that's just a standard replay to bring the
secondary back into replication, so the issue doesn't arise there
either.

The case where it does matter is failure of the primary followed by
instantaneous failure of the secondary before the actual network stream
completes, so guaranteeing that the secondary can be brought back up
consistently.  However, this is an incredibly rare failure scenario
given the tight race timings.

James


