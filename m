Return-Path: <linux-kernel-owner+w=401wt.eu-S1755877AbYLHL7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877AbYLHL7K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:59:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757267AbYLHLzo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:55:44 -0500
Received: from ozlabs.org ([203.10.76.45]:38053 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756226AbYLHLzn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:55:43 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 1/2] kvm: use modern cpumask primitives, no cpumask_t on stack
Date: Mon, 8 Dec 2008 22:25:38 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-9-generic; KDE/4.1.2; i686; ; )
Cc: "kvm-devel" <kvm@vger.kernel.org>, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>
References: <200812072125.14416.rusty@rustcorp.com.au> <200812081638.07526.rusty@rustcorp.com.au> <493CEDC5.1080004@redhat.com>
In-Reply-To: <493CEDC5.1080004@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812082225.39351.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 December 2008 20:19:57 Avi Kivity wrote:
> Rusty Russell wrote:
> >> Btw, for the general case, instead of forcing everyone to duplicate, how 
> >> about:
> >>
> >> cpumask_var_t cpus;
> >>
> >> with_cpumask(cpus) {
> >>    ... code to populate cpus
> >>    smp_call_function_some(...);
> >> } end_with_cpumask(cpus);
> >>
> >> Where with_cpumask() allocates cpus, and uses a mutex + static fallback 
> >> on failure.
> >>     
> >
> > I'd prefer not to hide deadlocks that way :(
> >
> > I'll re-battle with that code to neaten it.  There are only a few places
> > which have these kind of issues.
> >
> >   
> 
> cpuvar_get_maybe_mutex_lock(...);
> ...
> cpuvar_put_maybe_mutex_unlock(...);

My thought was something like:

/* This is an empty struct for !CONFIG_CPUMASK_OFFSTACK. */
static struct cpuvar_with_mutex_fallback fallback;

...
	cpumask_var_t tmp;

	cpuvar_alloc_fallback(&tmp, &fallback);
	...
	cpuvar_free_fallback(tmp, &fallback);

We may get there eventually, but so far I've managed to produce
less horrendous code in every case.

Cheers,
Rusty.
