Return-Path: <linux-kernel-owner+w=401wt.eu-S1759567AbYFMEZO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759567AbYFMEZO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 00:25:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbYFMEZA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 00:25:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:35440
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751964AbYFMEY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 00:24:57 -0400
Date: Thu, 12 Jun 2008 21:24:57 -0700 (PDT)
Message-Id: <20080612.212457.01943346.davem@davemloft.net>
To: galak@kernel.crashing.org
Cc: joseph@codesourcery.com, linux-kernel@vger.kernel.org,
       libc-alpha@sourceware.org
Subject: Re: math-emu issue with fp divide
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0806050837230.24924@blarg.am.freescale.net>
References: <Pine.LNX.4.64.0806042134020.32021@digraph.polyomino.org.uk>
	<20080604.144950.117343339.davem@davemloft.net>
	<Pine.LNX.4.64.0806050837230.24924@blarg.am.freescale.net>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kumar Gala <galak@kernel.crashing.org>
Date: Thu, 5 Jun 2008 08:38:44 -0500 (CDT)

> Now that I'm digging into this a bit I'm thinking my issue has to do with
> the fix you put in place from back in Aug 2007 (commit
> 405849610fd96b4f34cd1875c4c033228fea6c0f):
> 
> [MATH-EMU]: Fix underflow exception reporting.
> 
>     2) we ended up rounding back up to normal (this is the case where
>        we set the exponent to 1 and set the fraction to zero), this
>        should set inexact too
> ...
> 
>     Another example, "0x0.0000000000001p-1022 / 16.0", should signal both
>     inexact and underflow.  The cpu implementations and ieee1754
>     literature is very clear about this.  This is case #2 above.
> 
> I'm not clear from your commit comment on what actual number
> 0x0.0....01p-1022 is?

I haven't been able to look closely at this yet but I think I
happened to stumble over the test case that lead me to that
changeset you are referencing here.

The "actual number" is exactly as listed "0x0.0000000000001p-1022",
I don't know what's so confusing about it :-)))

I think this was distilled by Jakub Jelinek from some glibc test case.

#include <float.h>
#include <fenv.h>
#include <stdio.h>

volatile double d = DBL_MIN;
volatile double e = 0x0.0000000000001p-1022;
volatile double f = 16.0;
int
main (void)
{
  printf ("%x\n", fetestexcept (FE_UNDERFLOW));
  d /= f;
  printf ("%x\n", fetestexcept (FE_UNDERFLOW));
  e /= f;
  printf ("%x\n", fetestexcept (FE_UNDERFLOW));
  return 0;
}
