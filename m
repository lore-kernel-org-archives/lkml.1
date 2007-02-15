Return-Path: <linux-kernel-owner+w=401wt.eu-S1161356AbXBOVXE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161356AbXBOVXE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 16:23:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161357AbXBOVXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 16:23:04 -0500
Received: from tomts43-srv.bellnexxia.net ([209.226.175.110]:35236 "EHLO
	tomts43-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161356AbXBOVXD convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 16:23:03 -0500
Date: Thu, 15 Feb 2007 16:23:00 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Kumar Gala <galak@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] local_t : powerpc extension - use long for powerpc32
Message-ID: <20070215212259.GA3466@Krystal>
References: <117122149548-git-send-email-mathieu.desnoyers@polymtl.ca> <11712214961955-git-send-email-mathieu.desnoyers@polymtl.ca> <20070214225653.345aad29.akpm@linux-foundation.org> <20070215072024.GA9137@Krystal> <27EC3349-5FD8-47BD-B909-E1180B86AF40@kernel.crashing.org> <20070215200245.GF31359@Krystal> <906FD21B-59B6-4A30-90F0-914E0CD3CFBF@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <906FD21B-59B6-4A30-90F0-914E0CD3CFBF@kernel.crashing.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.4.34-grsec (i686)
X-Uptime: 16:20:59 up 13 days, 11:29,  5 users,  load average: 1.79, 2.20, 1.66
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Kumar Gala (galak@kernel.crashing.org) wrote:
> 
> On Feb 15, 2007, at 2:02 PM, Mathieu Desnoyers wrote:
> 
> >* Kumar Gala (galak@kernel.crashing.org) wrote:
> >>is there a reason this isn't local_add_return(long a, local_t *l) on
> >>ppc32?
> >>
> >>(same comment for other functions)
> >>
> >>- k
> >
> >no, except that we use the code is taken from atomic.h and used an
> >int parameter. However, due to the semantics of local_t, we should
> >manipulate longs instead of ints, even if they are the same size on a
> >given architecture (ppc32 and mips32 are affectec by this).
> >
> >Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> 
> Right, this means we can simply for ppc version down to:
> 
> +static __inline__ int local_add_return(int a, local_t *l)
> +{
> +	int t;
> +
> +	__asm__ __volatile__(
> +"1:	PPC_LLARX	%0,0,%2		# local_add_return\n\
> +	add	%0,%1,%0\n"
> +	PPC405_ERR77(0,%2)
> +"	PPC_STLCX	%0,0,%2 \n\
what about the dot after stwcx ? (stwcx.) ? Is it no longer required ?

> +	bne-	1b"
> +	: "=&r" (t)
> +	: "r" (a), "r" (&(l->a.counter))
> +	: "cc", "memory");
> +
> +	return t;
> +}
> 
> and that should work for both ppc32 & ppc64 and removes the  
> duplication between the two.
> 
> - k
> 

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Candidate, École Polytechnique de Montréal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
