Return-Path: <linux-kernel-owner+w=401wt.eu-S1757787AbZEVOlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757787AbZEVOlv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 10:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756279AbZEVOlo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 10:41:44 -0400
Received: from mx2.redhat.com ([66.187.237.31]:51717 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753051AbZEVOlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 10:41:44 -0400
Date: Fri, 22 May 2009 16:34:38 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH resend4 2/3] itimers: fix periodic tics precision
Message-ID: <20090522163438.71f895d1@dhcp-lab-109.englab.brq.redhat.com>
In-Reply-To: <alpine.LFD.2.00.0905221611380.3570@localhost.localdomain>
References: <20090522154339.06d30f0a@dhcp-lab-109.englab.brq.redhat.com>
	<alpine.LFD.2.00.0905221611380.3570@localhost.localdomain>
Organization: RedHat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 May 2009 16:27:40 +0200 (CEST)
Thomas Gleixner <tglx@linutronix.de> wrote:

> On Fri, 22 May 2009, Stanislaw Gruszka wrote:
> >  
> > +#define CPUTIME_SUB_NS(ct, real_ns) ({ 		\
> > +	struct timespec ts;			\
> > +	s64 cpu_ns;				\
> > +	cputime_to_timespec(ct, &ts); 		\
> > +	cpu_ns = timespec_to_ns(&ts);		\
> > +	cpu_ns - real_ns;	 		\
> > +})
> > +
> 
>   Please make this an inline function. Also this should have a sanity
>   check for values < 0, which might happen due to rounding errors. In
>   that case you set it simply to 0.

Ok.

 
> >  	if (cputime_ge(cur_time, it->expires)) {
> > -		it->expires = it->incr;
> > -		if (!cputime_eq(it->expires, cputime_zero))
> > -			it->expires = cputime_add(it->expires, cur_time);
> > +		if (!cputime_eq(it->incr, cputime_zero)) {
> > +			it->expires = cputime_add(it->expires, it->incr);
> > +			it->error += it->incr_error;
> > +			if (it->error >= onecputick) {
> > +				it->expires = cputime_sub(it->expires,
> > +							jiffies_to_cputime(1));
> > +				it->error -= onecputick;
> > +			}
> 
>   Yep, that's a sane solution except for jiffies_to_cputime(), which
>   can be precomputed as well.

Ok, I forgot PPC exist.

Thanks
Stanislaw
