Return-Path: <linux-kernel-owner+w=401wt.eu-S2992701AbXDTIyJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992701AbXDTIyJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 04:54:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992695AbXDTIyI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 04:54:08 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:35279 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S2992701AbXDTIyH (ORCPT
	<rfc822;@relay.sgi.com:linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 04:54:07 -0400
Date: Fri, 20 Apr 2007 18:53:54 +1000
From: David Chinner <dgc@sgi.com>
To: Jarek Poplawski <jarkao2@o2.pl>
Cc: David Chinner <dgc@sgi.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -mm] workqueue: debug possible endless loop in cancel_rearming_delayed_work
Message-ID: <20070420085354.GP32602149@melbourne.sgi.com>
References: <20070419065404.GB1782@ff.dom.local> <20070419144618.GG32602149@melbourne.sgi.com> <20070420081325.GB1695@ff.dom.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070420081325.GB1695@ff.dom.local>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 10:13:26AM +0200, Jarek Poplawski wrote:
> On Fri, Apr 20, 2007 at 12:46:18AM +1000, David Chinner wrote:
> > On Thu, Apr 19, 2007 at 08:54:04AM +0200, Jarek Poplawski wrote:
> > > Hi,
> > > 
> > > IMHO cancel_rearming_delayed_work is dangerous place:
> > 
> > Agreed - I spent a couple of hours today learning why it
> > can only be used on work functions that always rearm...
> > 
> > > - it assumes a work function always rearms (with no exception),
> > > which probably isn't explained enough now (but anyway should
> > > be checked in such loops);
> > >
> > > - probably possible (theoretical) scenario: a few work
> > > functions rearm themselves with very short, equal times;
> > > before flush_workqueue ends, their timers are already
> > > fired, so cancel_delayed_work has nothing to do.
> > 
> > Easier than that - have a work function that rearms only if there's
> > more work to do in the future. You only arm the timer when you
> > have work to do, and it only rearms if there's more work to
> > do in the future (e.g. rotating expiry lists).
> > 
> > i.e. while there's more work to do, you need to call
> > cancel_rearming_delayed_work() to stop it reliably, but if you race
> > with the work function not restarting itself, you hang.....
> 
> I'm not sure I correctly get your point, but according to
> this comment:
> 
> " * cancel_rearming_delayed_work - reliably kill off a delayed
> keventd work whose handler rearms the delayed work."
> 
> there is a question, whether a function that "rearms only if"
> - "rearms".

Right. Given that the bug I was initially trying to solve was a race
killing off a handler that was rearming itself, that comment says to
me "this is the right thing to do".

> It seems the author of this comment didn't think
> so and it was obvious to him/her cancel_rearming_delayed_work
> wasn't intended for this case. At first I thought it's only a
> language question - now, I see it's probably logical, too.

Yes, after spending another two hours working out why my fix was
then hanging in cancel_rearming_delayed_work() I was a little bit
annoyed at the now obviously misleading comment. Five minutes later
I'd fixed the bug properly. A better comment would have saved me two
hours of wasted time.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
