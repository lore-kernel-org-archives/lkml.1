Return-Path: <linux-kernel-owner+w=401wt.eu-S1759545AbZADUTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545AbZADUTa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 15:19:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752199AbZADUTQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 15:19:16 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:43559
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbZADUTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 15:19:15 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/3]: Replace kernel/timeconst.pl with kernel/timeconst.sh
Date: Sun, 4 Jan 2009 13:03:12 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>, Sam Ravnborg <sam@ravnborg.org>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <200901020207.30359.rob@landley.net> <200901031932.51873.rob@landley.net> <20090104120735.72840fdb@lxorguk.ukuu.org.uk>
In-Reply-To: <20090104120735.72840fdb@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901041303.12687.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 January 2009 06:07:35 Alan Cox wrote:
> > I note that sed and printf and such are all susv3.  I have an explicit
> > test for 32 bit math in the script that cares, and this worked in Red Hat
> > 9 circa 2003.
>
> If you are trying to do arbitary precision maths using standard posix
> tools just use dc. That way the standard is explicit about what you will
> get.

I looked at that, but:

A) the Open Group Base Specifications (which I normally go by, since they're 
roughly synonymous with SUSv3 and Posix and available free on the web; they 
just released version 7 a week or so back) don't list dc as one of their 
utilities.  (They mention bc, but not dc.)

B) The busybox implementation of dc is crap.  I got 'em to fix the bug where 
the output defaulted to binary instead of decimal, but the math is all done as 
floating point rather than arbitrary precision, and they don't implement the 
<< operator.

C) The only calculation which can overflow 64 bits (the ADJ32 one) turns out 
not to need arbitrary precision math, just 72 bits, and if it ever uses more 
than 32 then bottom 32 are all zero before the divide so you can do it in 
three lines.

Essentially, the ADJ32 calculation is "(($NUMBER-1)<<$SHIFT)/$NUMBER".

$SHIFT maxes out at 51 and the largest interesting $NUMBER is 1000000.  
(That's the pathological case of HZ=1, calculating the USEC_TO_HZ direction.  
A larger $HZ results in a smaller $SHIFT by the number of bits needed to store 
$HZ, by the way, so a $HZ of 17 would have a shift of 47.  So even a HZ bigger 
than a million should have a small enough $SHIFT not to cause trouble here, 
although that's probably an _insane_ input to this script.)

1 million needs 20 bits to store, so the above calculation has to cope with an 
intermediate value of 999999<<51 which takes a little over 70 bits to store, 
hence the potential to overflow 63 bits of signed math.

But this calculation has two special properties:

1) The number you start with before the shift is divided back out at the end 
(more or less), so the _result_ has to be less than 1<<$SHIFT and thus only 
takes $SHIFT bits to store.  With a maximum $SHIFT of 51 it has to fit in a 64 
bit result with about a dozen bits to spare.

2) The bottom $SHIFT many bits are all zero before the divide.

We can use these two properties to easily break the math into chunks that 
can't overflow by:

a) Chopping off the bottom X bits and dividing what's left by $NUMBER, keeping 
both the dividend and the remainder.  Choose any X that's big enough that this 
step won't overflow.  (I chose X=32, leaving at most 40-ish bits here).
b) Shift that dividend X bits to the left.  This can't overflow because of 
special property 1 above.
c) Shift the remainder X bits to the left.  The remainder can't be larger than 
the $NUMBER you started with, so if X+bits($NUMBER)<64 this has to fit too.  
With X=32 and bits=20 we again have a dozen bits to spare.
d) Add the results of (b) and (c) together.  Since the bottom X bits were all 
zero, this is equivalent to having done the full divide.  (Easy enough to mask 
those bottom bits off and add them to the remainder before the divide if they 
weren't, but we didn't need to do that because we know they were zero.)

So no arbitrary precision math is actually required here, and yes there's a 
comment in the source about this. :)

Rob
