Return-Path: <linux-kernel-owner+w=401wt.eu-S1758830AbYB1WA7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830AbYB1WA7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 17:00:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759551AbYB1WAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 17:00:37 -0500
Received: from www.tglx.de ([62.245.132.106]:40648 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759140AbYB1WAg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 17:00:36 -0500
Date: Thu, 28 Feb 2008 22:58:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Segher Boessenkool <segher@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH] Prevent the loop in timespec_add_ns() to be optimised
 away
In-Reply-To: <20080227154341.824efe3c.akpm@linux-foundation.org>
Message-ID: <alpine.LFD.1.00.0802282257490.3111@apollo.tec.linutronix.de>
References: <6a95d77ad55b29ff2d856c9e1f7dd79682370300.1203715782.git.segher@kernel.crashing.org> <20080227154341.824efe3c.akpm@linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Feb 2008, Andrew Morton wrote:

> On Fri, 22 Feb 2008 22:40:45 +0100
> Segher Boessenkool <segher@kernel.crashing.org> wrote:
> 
> > ...since some architectures don't support __udivdi3() (and
> > we don't want to use that, anyway).
> > 
> > Signed-off-by: Segher Boessenkool <segher@kernel.crashing.org>
> > ---
> >  include/linux/time.h |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/linux/time.h b/include/linux/time.h
> > index 2091a19..d32ef0a 100644
> > --- a/include/linux/time.h
> > +++ b/include/linux/time.h
> > @@ -174,6 +174,10 @@ static inline void timespec_add_ns(struct timespec *a, u64 ns)
> >  {
> >  	ns += a->tv_nsec;
> >  	while(unlikely(ns >= NSEC_PER_SEC)) {
> > +		/* The following asm() prevents the compiler from
> > +		 * optimising this loop into a modulo operation.  */
> > +		asm("" : "+r"(ns));
> > +
> >  		ns -= NSEC_PER_SEC;
> >  		a->tv_sec++;
> >  	}
> 
> It's pretty sad that we need to turn this into a loop just because of the
> __udivdi3() thing.
> 
> otoh, it's rarely occurring, and it could be that the number of times it
> loops is usually 1 (if it wasn't zero), so perhaps a loop is faster than a
> divide anyway.
> 
> This code is probably too large to be inlined.
> 
> I queued this patch as needed-in-2.6.25, to-be-merged-via-Thomas.

Are you going to send it or should I grab it from the mailing list
myself ?

Thanks,
	tglx
