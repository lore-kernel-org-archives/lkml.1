Return-Path: <linux-kernel-owner+w=401wt.eu-S1753568AbYF0Bw5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbYF0Bw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 21:52:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751282AbYF0Bwp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 21:52:45 -0400
Received: from ipmail04.adl2.internode.on.net ([203.16.214.57]:45051 "EHLO
	ipmail04.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751128AbYF0Bwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 21:52:44 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEANexXkh5LFnm/2dsb2JhbACuPg
X-IronPort-AV: E=Sophos;i="4.27,712,1204464600"; 
   d="scan'208";a="143990837"
Date: Fri, 27 Jun 2008 11:52:41 +1000
From: Dave Chinner <david@fromorbit.com>
To: Daniel Walker <dwalker@mvista.com>
Cc: xfs@oss.sgi.com, matthew@wil.cx, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] Extend completions to provide XFS object flush
	requirements
Message-ID: <20080627015241.GX29319@disturbed>
Mail-Followup-To: Daniel Walker <dwalker@mvista.com>, xfs@oss.sgi.com,
	matthew@wil.cx, linux-kernel@vger.kernel.org
References: <1214455277-6387-1-git-send-email-david@fromorbit.com> <1214455277-6387-2-git-send-email-david@fromorbit.com> <1214512405.21035.110.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214512405.21035.110.camel@localhost.localdomain>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 26, 2008 at 01:33:25PM -0700, Daniel Walker wrote:
> 
> On Thu, 2008-06-26 at 14:41 +1000, Dave Chinner wrote:
> > XFS object flushing doesn't quite match existing completion semantics.  It
> > mixed exclusive access with completion. That is, we need to mark an object as
> > being flushed before flushing it to disk, and then block any other attempt to
> > flush it until the completion occurs.
> > 
> > To do this we introduce:
> > 
> > void init_completion_flush(struct completion *x)
> > 	which initialises x->done = 1
> > 
> > void completion_flush_start(struct completion *x)
> > 	which blocks if done == 0, otherwise decrements done to zero and
> > 	allows the caller to continue.
> > 
> > bool completion_flush_start_nowait(struct completion *x)
> > 	returns a failure status if done == 0, otherwise decrements done
> > 	to zero and returns a "flush started" status. This is provided
> > 	to allow flushing to begin safely while holding object locks in
> > 	inverted order.
> > 
> > This replaces the use of semaphores for providing this exclusion
> > and completion mechanism.
> 
> I think there is some basis to make the changes that you have here.
> Specifically this email and thread,
> 
> http://lkml.org/lkml/2008/4/15/232
> 
> However, I don't like how your implementing this as specifically a
> "flush" mechanism for XFS, and the count is limited to just 1 .. There
> are several other places that do this kind of counting with semaphores,
> and have counts above 1..

Agreed - but the extension has to start somewhere. So, do I simply
add a "init_completion_count()" that passes a count value for the
completion (i.e. replaces init_completion_flush())?

> > +
> > +static inline void completion_flush_start(struct completion *x)
> > +{
> > +	wait_for_completion(x);
> > +}
> 
> Above seems completely pointless.. I would just call
> wait_for_completion(), and make the rest of the interface generic.

Except then wait_for_completion_nowait() makes absolutely no sense ;)
If i use wait_for_completion() for this, then perhaps the
non-blocking version becomes "try_wait_for_completion()". Would
this be acceptible?

i.e. the extra functions in the completion API would be:

	void init_completion_count(struct completion *x, int count);
	int try_wait_for_completion(struct completion *x);
	int completion_in_progress(struct completion *x);

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
