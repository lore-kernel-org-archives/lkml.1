Return-Path: <linux-kernel-owner+w=401wt.eu-S946208AbXHMOna@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S946208AbXHMOna (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 10:43:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S943787AbXHMLpR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 07:45:17 -0400
Received: from dsl081-085-152.lax1.dsl.speakeasy.net ([64.81.85.152]:55171
	"EHLO moonbase.phunq.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S941297AbXHMLpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 07:45:09 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: Re: Distributed storage.
Date: Mon, 13 Aug 2007 04:45:06 -0700
User-Agent: KMail/1.9.5
Cc: Jens Axboe <jens.axboe@oracle.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       Peter Zijlstra <peterz@infradead.org>
References: <20070731171347.GA14267@2ka.mipt.ru> <200708130312.33903.phillips@phunq.net> <20070813110302.GA28360@2ka.mipt.ru>
In-Reply-To: <20070813110302.GA28360@2ka.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708130445.06643.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 August 2007 04:03, Evgeniy Polyakov wrote:
> On Mon, Aug 13, 2007 at 03:12:33AM -0700, Daniel Phillips 
(phillips@phunq.net) wrote:
> > > This is not a very good solution, since it requires all users of
> > > the bios to know how to free it.
> >
> > No, only the specific ->endio needs to know that, which is set by
> > the bio owner, so this knowledge lies in exactly the right place. 
> > A small handful of generic endios all with the same destructor are
> > used nearly everywhere.
>
> That is what I meant - there will be no way to just alloc a bio and
> put it, helpers for generic bio sets must be exported and each and
> every bi_end_io() must be changed to check reference counter and they
> must know how they were allocated.

There are fewer non-generic bio allocators than you think.

> Endio callback is of course quite rare and additional atomic
> reading will not kill the system, but why introduce another read?
> It is possible to provide a flag for endio callback that it is last,
> but it still requires to change every single callback - why do we
> want this?

We don't.  Struct bio does not need to be shrunk.  Jens wanted to talk 
about what fields could be eliminated if we wanted to shrink it.  It is 
about time to let that lie, don't you think?

> So, I'm a bit lost...
>
> You say it is too big 

Did not say that.

> and some parts can be removed or combined

True.

> and  then that size does not matter.

Also true, backed up by numbers on real systems.

> Last/not-last checks in the code is 
> not clear design, so I do not see why it is needed at all if not for
> size shrinking.

Not needed, indeed.  Accurate throttling is needed.  If the best way to 
throttle requires expanding struct bio a little then we should not let 
concerns about the cost  of an int or two stand in the way.  Like Jens, 
I am more concerned about the complexity cost, and that is minimized in 
my opinion by throttling in the generic code rather than with custom 
code in each specialized block driver.

Your patch does throttle in the generic code, great.  Next thing is to 
be sure that it completely closes the window for reserve leakage, which 
is not yet clear.

Regards,

Daniel
