Return-Path: <linux-kernel-owner+w=401wt.eu-S1758501AbYKDXoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758501AbYKDXoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757181AbYKDXin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:38:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51965 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757015AbYKDXim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:38:42 -0500
Date: Tue, 4 Nov 2008 15:31:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: [patch 19/57] math-emu: Fix signalling of underflow and inexact
	while packing result.
Message-ID: <20081104233137.GT659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0002-math-emu-Fix-signalling-of-underflow-and-inexact-wh.patch"
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Kumar Gala <galak@kernel.crashing.org>

[ Upstream commit 930cc144a043ff95e56b6888fa51c618b33f89e7 ]

I'm trying to move the powerpc math-emu code to use the include/math-emu bits.

In doing so I've been using TestFloat to see how good or bad we are
doing.  For the most part the current math-emu code that PPC uses has
a number of issues that the code in include/math-emu seems to solve
(plus bugs we've had for ever that no one every realized).

Anyways, I've come across a case that we are flagging underflow and
inexact because we think we have a denormalized result from a double
precision divide:

000.FFFFFFFFFFFFF / 3FE.FFFFFFFFFFFFE
	soft: 001.0000000000000 .....  syst: 001.0000000000000 ...ux

What it looks like is the results out of FP_DIV_D are:

D:
sign:	  0
mantissa: 01000000 00000000
exp:	 -1023 (0)

The problem seems like we aren't normalizing the result and bumping the exp.

Now that I'm digging into this a bit I'm thinking my issue has to do with
the fix DaveM put in place from back in Aug 2007 (commit
405849610fd96b4f34cd1875c4c033228fea6c0f):

[MATH-EMU]: Fix underflow exception reporting.

    2) we ended up rounding back up to normal (this is the case where
       we set the exponent to 1 and set the fraction to zero), this
       should set inexact too
...

    Another example, "0x0.0000000000001p-1022 / 16.0", should signal both
    inexact and underflow.  The cpu implementations and ieee1754
    literature is very clear about this.  This is case #2 above.

Here is the distilled glibc test case from Jakub Jelinek which prompted that
commit:

--------------------
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
--------------------

It looks like the case I have we are exact before rounding, but think it
looks like the rounding case since it appears as if "overflow is set".

000.FFFFFFFFFFFFF / 3FE.FFFFFFFFFFFFE = 001.0000000000000

I think the following adds the check for my case and still works for the
issue your commit was trying to resolve.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/math-emu/op-common.h |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/include/math-emu/op-common.h
+++ b/include/math-emu/op-common.h
@@ -139,18 +139,27 @@ do {								\
 	if (X##_e <= _FP_WFRACBITS_##fs)			\
 	  {							\
 	    _FP_FRAC_SRS_##wc(X, X##_e, _FP_WFRACBITS_##fs);	\
-	    _FP_ROUND(wc, X);					\
 	    if (_FP_FRAC_HIGH_##fs(X)				\
 		& (_FP_OVERFLOW_##fs >> 1))			\
 	      {							\
 	        X##_e = 1;					\
 	        _FP_FRAC_SET_##wc(X, _FP_ZEROFRAC_##wc);	\
-	        FP_SET_EXCEPTION(FP_EX_INEXACT);		\
 	      }							\
 	    else						\
 	      {							\
-		X##_e = 0;					\
-		_FP_FRAC_SRL_##wc(X, _FP_WORKBITS);		\
+		_FP_ROUND(wc, X);				\
+		if (_FP_FRAC_HIGH_##fs(X)			\
+		   & (_FP_OVERFLOW_##fs >> 1))			\
+		  {						\
+		    X##_e = 1;					\
+		    _FP_FRAC_SET_##wc(X, _FP_ZEROFRAC_##wc);	\
+		    FP_SET_EXCEPTION(FP_EX_INEXACT);		\
+		  }						\
+		else						\
+		  {						\
+		    X##_e = 0;					\
+		    _FP_FRAC_SRL_##wc(X, _FP_WORKBITS);		\
+		  }						\
 	      }							\
 	    if ((FP_CUR_EXCEPTIONS & FP_EX_INEXACT) ||		\
 		(FP_TRAPPING_EXCEPTIONS & FP_EX_UNDERFLOW))	\

-- 
