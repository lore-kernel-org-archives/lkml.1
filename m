Return-Path: <linux-kernel-owner+w=401wt.eu-S938576AbXHMXyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938576AbXHMXyq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 19:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762171AbXHMXyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 19:54:32 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35518 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756530AbXHMXya (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 19:54:30 -0400
Date: Mon, 13 Aug 2007 16:54:23 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Chris Snook <csnook@redhat.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       akpm@linux-foundation.org,
       Segher Boessenkool <segher@kernel.crashing.org>,
       "Luck, Tony" <tony.luck@intel.com>, Chris Friesen <cfriesen@nortel.com>,
       "Robert P. J. Day" <rpjday@mindspring.com>
Subject: Re: [PATCH 1/23] document preferred use of volatile with atomic_t
Message-ID: <20070813235423.GO13410@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <46C03885.7000109@redhat.com> <20070813110415.GA24018@shell.boston.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070813110415.GA24018@shell.boston.redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2007 at 07:04:15AM -0400, Chris Snook wrote:
> From: Chris Snook <csnook@redhat.com>
> 
> Document proper use of volatile for atomic_t operations.

Looks good, as did a once-over on the arch-specific files.  Good stuff!!!

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Chris Snook <csnook@redhat.com>
> 
> --- linux-2.6.23-rc3-orig/Documentation/atomic_ops.txt	2007-07-08 19:32:17.000000000 -0400
> +++ linux-2.6.23-rc3/Documentation/atomic_ops.txt	2007-08-13 03:36:43.000000000 -0400
> @@ -12,13 +12,20 @@
>  C integer type will fail.  Something like the following should
>  suffice:
> 
> -	typedef struct { volatile int counter; } atomic_t;
> +	typedef struct { int counter; } atomic_t;
> +
> +	Historically, counter has been declared as a volatile int.  This
> +is now discouraged in favor of explicitly casting it as volatile where
> +volatile behavior is required.  Most architectures will only require such
> +a cast in atomic_read() and atomic_set(), as well as their 64-bit versions
> +if applicable, since the more complex atomic operations directly or
> +indirectly use assembly that results in volatile behavior.
> 
>  	The first operations to implement for atomic_t's are the
>  initializers and plain reads.
> 
>  	#define ATOMIC_INIT(i)		{ (i) }
> -	#define atomic_set(v, i)	((v)->counter = (i))
> +	#define atomic_set(v, i)	(*(volatile int *)&(v)->counter = (i))
> 
>  The first macro is used in definitions, such as:
> 
> @@ -38,7 +45,7 @@
> 
>  Next, we have:
> 
> -	#define atomic_read(v)	((v)->counter)
> +	#define atomic_read(v)	(*(volatile int *)&(v)->counter)
> 
>  which simply reads the current value of the counter.
> 
