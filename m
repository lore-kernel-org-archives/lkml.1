Return-Path: <linux-kernel-owner+w=401wt.eu-S1758913AbZEEVyQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913AbZEEVyQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 17:54:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753559AbZEEVx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 17:53:59 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41039 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753382AbZEEVx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 17:53:59 -0400
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
In-Reply-To: <200905052345.20515.philipp.reisner@linbit.com>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com>
	 <200905051756.29703.philipp.reisner@linbit.com>
	 <1241543146.3312.57.camel@mulgrave.int.hansenpartnership.com>
	 <200905052345.20515.philipp.reisner@linbit.com>
Content-Type: text/plain
Date: Tue, 05 May 2009 21:53:57 +0000
Message-Id: <1241560437.3312.159.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-05-05 at 23:45 +0200, Philipp Reisner wrote:
> > I also think you're not quite looking at the important case: if you
> > think about it, the real necessity for the ordered domain is the
> > network, not so much the actual secondary server.  The reason is that
> > it's very hard to find a failure case where the write order on the
> > secondary from the network tap to disk actually matters (as long as the
> > flight into the network tap was in order).  The standard failure is of
> > the primary, not the secondary, so the network stream stops and so does
> > the secondary writing: as long as we guarantee to stop at a consistent
> > point in flight, everything works.  If the secondary fails while the
> > primary is still up, that's just a standard replay to bring the
> > secondary back into replication, so the issue doesn't arise there
> > either.
> 
> A common power failure is possible. We aim for an HA system, we can
> not ignore a possible failure scenario. No user will buy: Well in most
> scenarios we do it correctly, in the unlikely case of a common power
> failure, and you loose your former primary at the same time, you might
> have a secondary with the last write but not that one write before!
> 
> Correctness before efficiency!

Well, you have to agree that during a resync from the activity log,
which plays up the primary disk from one end to another, the secondary
is completely corrupt if a primary failure occurs before the resync
completes.  That's something that's triggered by a network outage, and
so is a far more common event than cascading dual failures.  It's all
really a question of where you focus your effort to eliminate the corner
cases.

> But I will now stop this discussion now. Proving that DRBD does some
> details better than the md/nbd approch gets pointless, when we agreed
> that DRBD can get merged as a driver. We will focus on the necessary
> code cleanups.

I agree.  Also HA is full of corner cases like this and opinion is
endlessly divided over which corner cases are more important than which
others.

James


