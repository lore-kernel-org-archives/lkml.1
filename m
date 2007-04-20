Return-Path: <linux-kernel-owner+w=401wt.eu-S1423028AbXDTIHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423028AbXDTIHt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 04:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423032AbXDTIHt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 04:07:49 -0400
Received: from mx10.go2.pl ([193.17.41.74]:52011 "EHLO poczta.o2.pl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423028AbXDTIHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 04:07:48 -0400
Date: Fri, 20 Apr 2007 10:13:26 +0200
From: Jarek Poplawski <jarkao2@o2.pl>
To: David Chinner <dgc@sgi.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -mm] workqueue: debug possible endless loop in cancel_rearming_delayed_work
Message-ID: <20070420081325.GB1695@ff.dom.local>
References: <20070419065404.GB1782@ff.dom.local> <20070419144618.GG32602149@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070419144618.GG32602149@melbourne.sgi.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2007 at 12:46:18AM +1000, David Chinner wrote:
> On Thu, Apr 19, 2007 at 08:54:04AM +0200, Jarek Poplawski wrote:
> > Hi,
> > 
> > IMHO cancel_rearming_delayed_work is dangerous place:
> 
> Agreed - I spent a couple of hours today learning why it
> can only be used on work functions that always rearm...
> 
> > - it assumes a work function always rearms (with no exception),
> > which probably isn't explained enough now (but anyway should
> > be checked in such loops);
> >
> > - probably possible (theoretical) scenario: a few work
> > functions rearm themselves with very short, equal times;
> > before flush_workqueue ends, their timers are already
> > fired, so cancel_delayed_work has nothing to do.
> 
> Easier than that - have a work function that rearms only if there's
> more work to do in the future. You only arm the timer when you
> have work to do, and it only rearms if there's more work to
> do in the future (e.g. rotating expiry lists).
> 
> i.e. while there's more work to do, you need to call
> cancel_rearming_delayed_work() to stop it reliably, but if you race
> with the work function not restarting itself, you hang.....

I'm not sure I correctly get your point, but according to
this comment:

" * cancel_rearming_delayed_work - reliably kill off a delayed
keventd work whose handler rearms the delayed work."

there is a question, whether a function that "rearms only if"
- "rearms". It seems the author of this comment didn't think
so and it was obvious to him/her cancel_rearming_delayed_work
wasn't intended for this case. At first I thought it's only a
language question - now, I see it's probably logical, too.

Cheers,
Jarek P.
