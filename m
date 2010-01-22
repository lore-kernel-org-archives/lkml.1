Return-Path: <linux-kernel-owner+w=401wt.eu-S1753684Ab0AVPkK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab0AVPkK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jan 2010 10:40:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752363Ab0AVPkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jan 2010 10:40:09 -0500
Received: from relay3.sgi.com ([192.48.152.1]:35599 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752106Ab0AVPkI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jan 2010 10:40:08 -0500
Date: Fri, 22 Jan 2010 09:40:06 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Jack Steiner <steiner@sgi.com>,
       "H. Peter Anvin" <hpa@zytor.com>, tglx@linutronix.de
Subject: Re: [PATCH] x86, UV: Fix RTC latency bug by reading replicated
	cachelines
Message-ID: <20100122154006.GA4975@sgi.com>
References: <20100112210904.GA24546@sgi.com> <20100113092433.GB6739@elte.hu> <20100114183422.GA12152@sgi.com> <20100119144137.GB22276@sgi.com> <20100120081020.GG20621@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100120081020.GG20621@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 09:10:20AM +0100, Ingo Molnar wrote:
> 
> * Dimitri Sivanich <sivanich@sgi.com> wrote:
> 
> > +++ linux/drivers/char/uv_mmtimer.c	2010-01-14 11:56:57.000000000 -0600
> > @@ -89,12 +89,19 @@ static long uv_mmtimer_ioctl(struct file
> >  	switch (cmd) {
> >  	case MMTIMER_GETOFFSET:	/* offset of the counter */
> >  		/*
> > -		 * UV RTC register is on its own page
> > +		 * Starting with HUB rev 2.0, the UV RTC register is
> > +		 * replicated across all cachelines of it's own page.
> > +		 * This allows faster simultaneous reads from a given socket.
> > +		 *
> > +		 * The offset returned is in 64 bit units.
> >  		 */
> > -		if (PAGE_SIZE <= (1 << 16))
> > -			ret = ((UV_LOCAL_MMR_BASE | UVH_RTC) & (PAGE_SIZE-1))
> > -				/ 8;
> > -		else
> > +		if (PAGE_SIZE <= (1 << 16)) {
> > +			if (uv_get_min_hub_revision_id() == 1)
> > +				ret = 0;
> > +			else
> > +				ret = ((uv_blade_processor_id() *
> > +					L1_CACHE_BYTES) % PAGE_SIZE) / 8;
> > +		} else
> 
> That 64K PAGE_SIZE check in the ioctl looks rather weird. What is the purpose 
> of it?

Checking for > 64k pages is really a holdover from similar code on ia64.  I've taken it out with a modified version of this patch that I'll send shortly.
