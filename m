Return-Path: <linux-kernel-owner+w=401wt.eu-S932699AbXFEPU1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699AbXFEPU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 11:20:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763597AbXFEPUN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 11:20:13 -0400
Received: from hammerhead.shentel.net ([204.111.1.228]:55103 "EHLO
	hammerhead.shentel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764685AbXFEPUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 11:20:11 -0400
Date: Tue, 5 Jun 2007 11:20:04 -0400 (EDT)
From: "John Anthony Kazos Jr." <jakj@j-a-k-j.com>
To: Richard Purdie <richard@openedhand.com>
cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Problems (a bug?) with UINT_MAX from kernel.h
In-Reply-To: <1181054562.6180.77.camel@localhost.localdomain>
Message-ID: <alpine.DEB.0.99.0706051111310.543@sigma.j-a-k-j.com>
References: <1181054562.6180.77.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> The kernel uses UINT_MAX defined from kernel.h in a variety of places.
> 
> While looking at the behaviour of the LZO code, I noticed it seemed to
> think an int was 8 bytes large on my 32 bit i386 machine. It isn't but
> why did it think that?
> 
> kernel.h says:
> 
> #define INT_MAX		((int)(~0U>>1))
> #define INT_MIN		(-INT_MAX - 1)
> #define UINT_MAX	(~0U)
> #define LONG_MAX	((long)(~0UL>>1))
> #define LONG_MIN	(-LONG_MAX - 1)
> #define ULONG_MAX	(~0UL)
> #define LLONG_MAX	((long long)(~0ULL>>1))
> #define LLONG_MIN	(-LLONG_MAX - 1)
> #define ULLONG_MAX	(~0ULL)
> 
> If I try to compile the code fragment below, I see the error:
> 
> #define UINT_MAX	(~0U)
> #if (0xffffffffffffffff == UINT_MAX)
>   #error argh
> #endif
> 
> I've tested this on several systems with a variety of gcc versions with
> the same result. I've tried various other ways of testing this all with
> the same conclusion, UINT_MAX is wrong.
> 
> The *LONG* definitions above should work as gcc is forced to a certain
> type. Where just 0U is specified, I don't think it will work as intended
> as gcc seems to automatically increase the type to fit the value and
> avoid truncation ending up with a long long.
> 
> If I change the above to:
> 
> /* Handle GCC = 3.2 */
> #if !defined(__INT_MAX__)
> #define INT_MAX		0x7fffffff
> #else
> #define INT_MAX		(__INT_MAX__)
> #endif
> #define INT_MIN		(-INT_MAX - 1)
> #define UINT_MAX	((INT_MAX<<1)+1)

For one thing, the C standard specifies that literals fit into signed 
before unsigned if they're not specified as unsigned in the first place. 
Shifting signed values (INT_MAX<<1) is wrong on some architectures and 
foolish on all. You would have to do "(unsigned int)INT_MAX << 1".

> I get the expected result of an int being 4 bytes long. Is there a
> better solution? Its probably better that whats there now but could
> break a machine using gcc 3.2 that doesn't have int size = 4 bytes...
> 
> (gcc <= 3.2 doesn't define __INT_MAX__)

The C standard specifies that a numeric literal constant ending with "U" 
may be interpreted as unsigned int, unsigned long int, or unsigned long 
long int, in that order, choosing the first in which it will fit. So "~0U" 
is correct. If it's not working, I suggest you file a compiler bug/defect 
report.
