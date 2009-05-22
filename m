Return-Path: <linux-kernel-owner+w=401wt.eu-S1757217AbZEVO23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757217AbZEVO23 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 10:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756246AbZEVO2W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 10:28:22 -0400
Received: from www.tglx.de ([62.245.132.106]:35397 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756223AbZEVO2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 10:28:21 -0400
Date: Fri, 22 May 2009 16:27:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Stanislaw Gruszka <sgruszka@redhat.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH resend4 2/3] itimers: fix periodic tics precision
In-Reply-To: <20090522154339.06d30f0a@dhcp-lab-109.englab.brq.redhat.com>
Message-ID: <alpine.LFD.2.00.0905221611380.3570@localhost.localdomain>
References: <20090522154339.06d30f0a@dhcp-lab-109.englab.brq.redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 May 2009, Stanislaw Gruszka wrote:
>  
> +#define CPUTIME_SUB_NS(ct, real_ns) ({ 		\
> +	struct timespec ts;			\
> +	s64 cpu_ns;				\
> +	cputime_to_timespec(ct, &ts); 		\
> +	cpu_ns = timespec_to_ns(&ts);		\
> +	cpu_ns - real_ns;	 		\
> +})
> +

  Please make this an inline function. Also this should have a sanity
  check for values < 0, which might happen due to rounding errors. In
  that case you set it simply to 0.

>  	if (cputime_ge(cur_time, it->expires)) {
> -		it->expires = it->incr;
> -		if (!cputime_eq(it->expires, cputime_zero))
> -			it->expires = cputime_add(it->expires, cur_time);
> +		if (!cputime_eq(it->incr, cputime_zero)) {
> +			it->expires = cputime_add(it->expires, it->incr);
> +			it->error += it->incr_error;
> +			if (it->error >= onecputick) {
> +				it->expires = cputime_sub(it->expires,
> +							jiffies_to_cputime(1));
> +				it->error -= onecputick;
> +			}

  Yep, that's a sane solution except for jiffies_to_cputime(), which
  can be precomputed as well.

Thanks,

	tglx
