Return-Path: <linux-kernel-owner+w=401wt.eu-S1757564AbZC3V0a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564AbZC3V0a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 17:26:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757658AbZC3V0T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 17:26:19 -0400
Received: from mail.windriver.com ([147.11.1.11]:38434 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754889AbZC3V0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 17:26:18 -0400
Date: Mon, 30 Mar 2009 17:23:57 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>, clemens@ladisch.de,
       linux-kernel@vger.kernel.org, robert.picco@hp.com,
       venkatesh.pallipadi@intel.com, vojtech@suse.cz, mingo@redhat.com
Subject: Re: [Patch] Fix the possibility of insane return value of
	hpet_calibrate() against SMI. (take 2)
Message-ID: <20090330212357.GA386@windriver.com>
References: <49BFA1D7.8020302@windriver.com> <20090318094346.7BA9.E1E9C6FF@jp.fujitsu.com> <20090318113948.7BAD.E1E9C6FF@jp.fujitsu.com> <20090330140659.66ccbfe9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090330140659.66ccbfe9.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 30 Mar 2009 21:24:22.0240 (UTC) FILETIME=[E4ADE600:01C9B17D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Re: [Patch] Fix the possibility of insane return value of hpet_calibrate() against SMI. (take 2)] On 30/03/2009 (Mon 14:06) Andrew Morton wrote:

> On Wed, 18 Mar 2009 11:47:04 +0900
> Yasunori Goto <y-goto@jp.fujitsu.com> wrote:
> 
> > hpet_calibrate() has a possibility of miss-calibration due to SMI.
> > If SMI interrupts in the while loop of calibration, then return value
> > will be big. This change calibrates until stabilizing by the return
> > value with a small value.
> > 
> > 
> > Signed-off-by: Yasunori Goto <y-goto@jp.fujitsu.com>
> > 
> > 
> > ---
> >  drivers/char/hpet.c |   21 ++++++++++++++++++++-
> >  1 file changed, 20 insertions(+), 1 deletion(-)
> > 
> > Index: hpet_test/drivers/char/hpet.c
> > ===================================================================
> > --- hpet_test.orig/drivers/char/hpet.c	2009-03-12 15:47:45.000000000 +0900
> > +++ hpet_test/drivers/char/hpet.c	2009-03-18 11:12:42.000000000 +0900
> > @@ -713,7 +713,7 @@
> >   */
> >  #define	TICK_CALIBRATE	(1000UL)
> >  
> > -static unsigned long hpet_calibrate(struct hpets *hpetp)
> > +static unsigned long __hpet_calibrate(struct hpets *hpetp)
> >  {
> >  	struct hpet_timer __iomem *timer = NULL;
> >  	unsigned long t, m, count, i, flags, start;
> > @@ -750,6 +750,25 @@
> >  	return (m - start) / i;
> >  }
> >  
> > +static unsigned long hpet_calibrate(struct hpets *hpetp)
> > +{
> > +	unsigned long ret = ~0UL, tmp;
> > +
> > +	/*
> > +	 * Try to calibrate until return value becomes stable small value.
> > +	 * If SMI interruption occurs in calibration loop, the return value
> > +	 * will be big. This avoids its impact.
> > +	 */
> > +	do {
> > +		tmp = __hpet_calibrate(hpetp);
> > +		if (ret <= tmp)
> > +			break;
> > +		ret = tmp;
> > +	} while (1);
> > +
> > +	return ret;
> > +}
> 
> Call me paranoid, but I'd like to see a maximum retry count here and an
> error message-and-continue if it is exceeded.  To prevent mysterious
> boot-time lockups from misbehaving hpets, perhaps?

I'd mentioned that here:

http://lkml.org/lkml/2009/3/18/180

but the general consensus was that it was impossible and I was just
being paranoid.  :-)

Acked-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Paul.

> 
> Also, style nit - I find
> 
> 	for ( ; ; ) {
> 		...
> 	}
> 
> to be more readable than
> 
> 	do {
> 		...
> 	} while (1);
> 
> and I believe the former is more common.
> 
> 
> And
> 
> 	unsigned long ret = -1;
> 
> has the same effect as
> 
> 	unsigned long ret = ~0UL;
> 
> but is more maintainable - it doesn't subtly break if someone changes
> the type of `ret'.  (This is a bit of an ugly C trick).
> 
> 
> 
