Return-Path: <linux-kernel-owner+w=401wt.eu-S1758291AbYF0OQX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758291AbYF0OQX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 10:16:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754970AbYF0OQN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 10:16:13 -0400
Received: from gate.crashing.org ([63.228.1.57]:40437 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754836AbYF0OQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 10:16:11 -0400
Cc: joseph@codesourcery.com, linux-kernel@vger.kernel.org,
       libc-alpha@sourceware.org
Message-Id: <F02EB8BE-6780-4C75-ABB9-7F2397457374@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: David Miller <davem@davemloft.net>
In-Reply-To: <20080612.212457.01943346.davem@davemloft.net>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v924)
Subject: Re: math-emu issue with fp divide
Date: Fri, 27 Jun 2008 09:15:40 -0500
References: <Pine.LNX.4.64.0806042134020.32021@digraph.polyomino.org.uk> <20080604.144950.117343339.davem@davemloft.net> <Pine.LNX.4.64.0806050837230.24924@blarg.am.freescale.net> <20080612.212457.01943346.davem@davemloft.net>
X-Mailer: Apple Mail (2.924)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 12, 2008, at 11:24 PM, David Miller wrote:

> From: Kumar Gala <galak@kernel.crashing.org>
> Date: Thu, 5 Jun 2008 08:38:44 -0500 (CDT)
>
>> Now that I'm digging into this a bit I'm thinking my issue has to  
>> do with
>> the fix you put in place from back in Aug 2007 (commit
>> 405849610fd96b4f34cd1875c4c033228fea6c0f):
>>
>> [MATH-EMU]: Fix underflow exception reporting.
>>
>>    2) we ended up rounding back up to normal (this is the case where
>>       we set the exponent to 1 and set the fraction to zero), this
>>       should set inexact too
>> ...
>>
>>    Another example, "0x0.0000000000001p-1022 / 16.0", should signal  
>> both
>>    inexact and underflow.  The cpu implementations and ieee1754
>>    literature is very clear about this.  This is case #2 above.
>>
>> I'm not clear from your commit comment on what actual number
>> 0x0.0....01p-1022 is?
>
> I haven't been able to look closely at this yet but I think I
> happened to stumble over the test case that lead me to that
> changeset you are referencing here.
>
> The "actual number" is exactly as listed "0x0.0000000000001p-1022",
> I don't know what's so confusing about it :-)))
>
> I think this was distilled by Jakub Jelinek from some glibc test case.
>
> #include <float.h>
> #include <fenv.h>
> #include <stdio.h>
>
> volatile double d = DBL_MIN;
> volatile double e = 0x0.0000000000001p-1022;
> volatile double f = 16.0;
> int
> main (void)
> {
>  printf ("%x\n", fetestexcept (FE_UNDERFLOW));
>  d /= f;
>  printf ("%x\n", fetestexcept (FE_UNDERFLOW));
>  e /= f;
>  printf ("%x\n", fetestexcept (FE_UNDERFLOW));
>  return 0;
> }

I tested this on PPC HW fp and kern emu w/my patch and get the same  
results:

0
0
8000000

(8000000 is underflow in the PPC FP status register)

- k
