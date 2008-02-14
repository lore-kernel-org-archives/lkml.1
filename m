Return-Path: <linux-kernel-owner+w=401wt.eu-S933502AbYBNM1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933502AbYBNM1b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 07:27:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759200AbYBNM1X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 07:27:23 -0500
Received: from relay2.sgi.com ([192.48.171.30]:38004 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757548AbYBNM1W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 07:27:22 -0500
Date: Thu, 14 Feb 2008 06:27:16 -0600
From: Paul Jackson <pj@sgi.com>
To: David Rientjes <rientjes@google.com>
Cc: Lee.Schermerhorn@hp.com, akpm@linux-foundation.org, clameter@sgi.com,
       ak@suse.de, linux-kernel@vger.kernel.org, mel@csn.ul.ie
Subject: Re: [patch 3/4] mempolicy: add MPOL_F_STATIC_NODES flag
Message-Id: <20080214062716.aa36d25a.pj@sgi.com>
In-Reply-To: <alpine.DEB.1.00.0802131314210.5914@chino.kir.corp.google.com>
References: <alpine.DEB.1.00.0802101506130.11145@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802101507210.11145@chino.kir.corp.google.com>
	<alpine.DEB.1.00.0802101507400.11145@chino.kir.corp.google.com>
	<1202862136.4974.41.camel@localhost>
	<20080212215242.0342fa25.pj@sgi.com>
	<alpine.DEB.1.00.0802121955040.11889@chino.kir.corp.google.com>
	<20080212221354.a33799f2.pj@sgi.com>
	<alpine.DEB.1.00.0802122018550.11889@chino.kir.corp.google.com>
	<20080213020344.45c9d924.pj@sgi.com>
	<alpine.DEB.1.00.0802130113020.3936@chino.kir.corp.google.com>
	<20080213110426.15179378.pj@sgi.com>
	<alpine.DEB.1.00.0802131050240.9186@chino.kir.corp.google.com>
	<20080213142956.5ba52101.pj@sgi.com>
	<alpine.DEB.1.00.0802131314210.5914@chino.kir.corp.google.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I had taken a vow of silence on this one, but couldn't resist one more
round.

David wrote:
> My preference (both mode and flags stored in the same member of struct 
> mempolicy):
> 
>    Advantages:
> 
> 	- completely consistent with the userspace API of passing modes
> 	  and flags together in a pointer to an int, and

True -- the necessary overloaded ugliness of the kernel-user system
call API is propogated throughout mempolicy.c.  However, I wouldn't
necessarily call that an advantage.

> 	- does not require additional formals to be added to several
> 	  functions, including functions outside mm/mempolicy.c.

... but does require the use of the new mpol_flags() and mpol_mode()
macros by code in mmshmem.c, outside of mm/mempolicy.c

>    Disadvantage:
> 
> 	- use of mpol_mode() throughout mm/mempolicy.c code to mask
> 	  off optional mode flags for conditionals or switch statements.

This will cause a bug in the future, that escapes into the wild, when
someone forgets one of these.  I'll bet on that.  It's fragile, because
(1) such errors are easy to make, and (2) hard to catch.

> Your preference (separate mode and flags members in struct mempolicy):
> 
>    Advantages:
> 
> 	- clearer implementation when dealing with modes: all existing
> 	  statements involving pol->policy can remain unchanged.

Clear, robust code - that's the biggie.

>    Disadvantages:
> 
> 	- requires additional formals to be added to several functions,
> 	  including functions outside mm/mempolicy.c, and

True -- though by this argument, we'd routinely aggregate multiple flags
and small words into single integer parameters, just to minimize the
parameter count.  Putting two flags in one parameter is a false
simplification, unless required by circumstance, such as communicating
with deep space probes or across the system call boundary with existing
API's.

Across the system call boundary, we have little choice, for compatibility
reasons.  But kernel internal interfaces are not so constrained, and the
ugliness at the system call boundary can be quarantined from most of the
mempolicy.c code.

> 	- takes additional space in struct mempolicy (two bytes) which
> 	  could eventually be used for something else.

To be clear to others, as you know, we're not talking here about
growing the sizeof(struct mempolicy) at present, but rather about using
some currently unused bytes in the struct.

More often than not, when someone adds complexity that is not needed at
present, because it might be needed in the future, they are making it
harder to maintain the code, not easier.

The single most important thing we can do to improve future
maintainability of code is to make it more readable.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
