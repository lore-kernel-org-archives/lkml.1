Return-Path: <linux-kernel-owner+w=401wt.eu-S1761668AbXIJXos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761668AbXIJXos (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2007 19:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751566AbXIJXoh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Sep 2007 19:44:37 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:39134 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbXIJXog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2007 19:44:36 -0400
Date: Mon, 10 Sep 2007 16:44:31 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Chris Snook <csnook@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Kyle Moffett <mrmacman_g4@mac.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Nick Piggin <piggin@cyberone.com.au>,
       Satyam Sharma <satyam@infradead.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Paul Mackerras <paulus@samba.org>, Christoph Lameter <clameter@sgi.com>,
       Ilpo Jarvinen <ilpo.jarvinen@helsinki.fi>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, Netdev <netdev@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, ak@suse.de,
       heiko.carstens@de.ibm.com, David Miller <davem@davemloft.net>,
       schwidefsky@de.ibm.com, wensong@linux-vs.org, horms@verge.net.au,
       wjiang@resilience.com, cfriesen@nortel.com, zlynx@acm.org,
       rpjday@mindspring.com, jesper.juhl@gmail.com,
       segher@kernel.crashing.org
Subject: Re: [PATCH] Document non-semantics of atomic_read() and atomic_set()
Message-ID: <20070910234431.GN11801@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <18115.52863.638655.658466@cargo.ozlabs.ibm.com> <6370BBDF-0C79-41EB-BD2A-02AA0D216924@mac.com> <200709101438.36710.vda.linux@googlemail.com> <200709101516.03234.vda.linux@googlemail.com> <alpine.LFD.0.999.0709100807260.16478@woody.linux-foundation.org> <20070910231944.GA3484@shell.boston.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070910231944.GA3484@shell.boston.redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2007 at 07:19:44PM -0400, Chris Snook wrote:
> From: Chris Snook <csnook@redhat.com>
> 
> Unambiguously document the fact that atomic_read() and atomic_set()
> do not imply any ordering or memory access, and that callers are
> obligated to explicitly invoke barriers as needed to ensure that
> changes to atomic variables are visible in all contexts that need
> to see them.

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Chris Snook <csnook@redhat.com>
> 
> --- a/Documentation/atomic_ops.txt	2007-07-08 19:32:17.000000000 -0400
> +++ b/Documentation/atomic_ops.txt	2007-09-10 19:02:50.000000000 -0400
> @@ -12,7 +12,11 @@
>  C integer type will fail.  Something like the following should
>  suffice:
> 
> -	typedef struct { volatile int counter; } atomic_t;
> +	typedef struct { int counter; } atomic_t;
> +
> +	Historically, counter has been declared volatile.  This is now
> +discouraged.  See Documentation/volatile-considered-harmful.txt for the
> +complete rationale.
> 
>  	The first operations to implement for atomic_t's are the
>  initializers and plain reads.
> @@ -42,6 +46,22 @@
> 
>  which simply reads the current value of the counter.
> 
> +*** WARNING: atomic_read() and atomic_set() DO NOT IMPLY BARRIERS! ***
> +
> +Some architectures may choose to use the volatile keyword, barriers, or
> +inline assembly to guarantee some degree of immediacy for atomic_read()
> +and atomic_set().  This is not uniformly guaranteed, and may change in
> +the future, so all users of atomic_t should treat atomic_read() and
> +atomic_set() as simple C assignment statements that may be reordered or
> +optimized away entirely by the compiler or processor, and explicitly
> +invoke the appropriate compiler and/or memory barrier for each use case.
> +Failure to do so will result in code that may suddenly break when used with
> +different architectures or compiler optimizations, or even changes in
> +unrelated code which changes how the compiler optimizes the section
> +accessing atomic_t variables.
> +
> +*** YOU HAVE BEEN WARNED! ***
> +
>  Now, we move onto the actual atomic operation interfaces.
> 
>  	void atomic_add(int i, atomic_t *v);
