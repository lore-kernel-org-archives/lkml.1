Return-Path: <linux-kernel-owner+w=401wt.eu-S1752522AbZADG3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbZADG3T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 01:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750761AbZADG3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 01:29:10 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:46488
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbZADG3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 01:29:08 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: PATCH [0/3]: Simplify the kernel build by removing perl.
Date: Sun, 4 Jan 2009 00:29:02 -0600
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; x86_64; ; )
Cc: Leon Woestenberg <leon.woestenberg@gmail.com>,
       Embedded Linux mailing list <linux-embedded@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
References: <200901020207.30359.rob@landley.net> <200901032006.47652.rob@landley.net> <49601B94.3060408@zytor.com>
In-Reply-To: <49601B94.3060408@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901040029.03396.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 03 January 2009 20:14:44 H. Peter Anvin wrote:
> Rob Landley wrote:
> >> The new patches have *more* environmental
> >> dependencies than that ever did.
> >
> > Could you please be a little more specific?
>
> In this case, you're assuming that every version of every shell this is
> going to get involved with is going to do math correctly with the
> requisite precision, which is nowhere guaranteed, I'm pretty sure.

Well, SUSv3 requires that the shell support signed long arithmetic:
http://www.opengroup.org/onlinepubs/9699919799/utilities/V3_chap02.html#tag_18_06_04

And the LP64 standard says that on 64 bit systems, long must be 64 bit:
http://www.unix.org/whitepapers/64bit.html

Now the potential weakness there is that on 32 bit systems, shells might only 
support 32 bit math instead of 64 bit math.  (You'll notice I have a test for 
that.)  However, bash has supported 64 bit math on 32 bit systems since at 
least 2003.  (I keep a Red Hat 9 test image around because it had 50% market 
share when it shipped, so the majority of "old" Linux systems still in use 
_are_ RH9 or similar.  It also has the oldest gcc version the kernel still 
claims to build under.)  Busybox ash can also support 64 bit math on 32 bit 
hosts, and I just confirmed that the dash in the 32 bit xubuntu 8.10 supports 
64 bit math as well.

(It would also be possible to do a similar overflow avoiding trick to do the 
lot entirely in 32 bit math, but given that the three main shells in use on 
Linux _do_ support 64 bit math on 32 bit hosts and are _required_ to support 
it on 64 bit hosts according to SUSv3, the extra complexity really doesn't 
seem worth it.)

> >> Third, if someone actually cares to do it right, I have a smallish
> >> bignum library at http://git.zytor.com/?p=lib/pbn.git;a=summary that
> >> might be a starting point.
> >
> > This doesn't _need_ bignum support.  It maxes out around 72 bits and the
> > _result_ can't use more than about $SHIFT bits because you're dividing by
> > the amount you shifted, so just chop off the bottom 32 bits, do a normal
> > 64 bit division on the top (it has to fit), and then do the same division
> > on the appropriate shifted remainder, and combine the results.  This is
> > easy because when the shift _is_ 32 bits or more, the bottom 32 bits all
> > have to be zeroes so you don't even have to mask and add, just shift the
> > remainder left 32 bits so you can continue the divide.
> >
> > Pulling out perl isn't always a good alternative to thinking about the
> > problem.
>
> Neither is open-coding a bignum operation instead of relying on an
> existing, validated implementation.

Implementing something by hand isn't _always_ a good alternative, sure.  That 
would be the "thinking about the problem" part.  In this instance, avoiding 
overflow is trivial.  (If 1<<-1 didn't wrap around, it wouldn't even need the 
if statement.)

I'm curious, would the "existing, validated implementation" in this instance 
be the perl implementation, or the library you wrote and pointed me to above 
as a potential replacement for it?

I suppose there's a certain amount of style in accusing me of reinventing the 
wheel while pointing me at your reinvention of the wheel.  (Are you aiming to 
replace Gnu's gmplib.org, the perhaps the BSD licensed one in openssh?  
Dropbear uses Libtommath.  A quick google for C open source big number 
libraries also found Libimath, MPI, NTL, BigDigits, decNumber, and MPI.  The 
last time I personally wrote my own arbitrary precision math package from 
scratch was in 1998, and that was in Java, so I'm a little rusty...)  But I 
don't personally consider avoiding the need for an arbitrary precision math 
library to be the same as reimplementing one.

> 	-hpa

Rob
