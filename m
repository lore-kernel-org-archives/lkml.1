Return-Path: <linux-kernel-owner+w=401wt.eu-S1756258AbYFENjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756258AbYFENjj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 09:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754625AbYFENj3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 09:39:29 -0400
Received: from gate.crashing.org ([63.228.1.57]:54927 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbYFENj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 09:39:28 -0400
Date: Thu, 5 Jun 2008 08:38:44 -0500 (CDT)
From: Kumar Gala <galak@kernel.crashing.org>
X-X-Sender: galak@blarg.am.freescale.net
To: David Miller <davem@davemloft.net>
cc: joseph@codesourcery.com, linux-kernel@vger.kernel.org,
       libc-alpha@sourceware.org
Subject: Re: math-emu issue with fp divide
In-Reply-To: <20080604.144950.117343339.davem@davemloft.net>
Message-ID: <Pine.LNX.4.64.0806050837230.24924@blarg.am.freescale.net>
References: <9BECB10D-536E-4242-A2F5-6E1EF8CBDB40@kernel.crashing.org>
 <Pine.LNX.4.64.0806042134020.32021@digraph.polyomino.org.uk>
 <20080604.144950.117343339.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2008, David Miller wrote:

> From: "Joseph S. Myers" <joseph@codesourcery.com>
> Date: Wed, 4 Jun 2008 21:42:55 +0000 (UTC)
>
> > On Wed, 4 Jun 2008, Kumar Gala wrote:
> >
> > > I'm trying to move the powerpc math-emu
> > > code to use the include/math-emu bits.
> >
> > I'd like to remind people that the include/math-emu code is based on an
> > old, buggy version of the soft-fp code in glibc.  RTH previously noted
> > <http://sourceware.org/ml/libc-alpha/2006-02/msg00075.html> that the fixes
> > should go in the kernel, when approving a patch of mine fixing various
> > bugs and speeding up soft-fp, and several more bugs have been fixed since
> > then in the course of GCC work on soft-float for Power and __float128
> > support for x86_64.
> >
> > So it may be better than the old code you're replacing, but it might still
> > be a good idea to merge things with the current glibc code, as a matter of
> > both correctness and performance.  (And there may well still be bugs left
> > in the code.)
>
> Once the GCC folks started looking into using the soft-fp bits I knew
> this situation would develop.  The kernel side would have some set of
> fixes and the glibc/gcc side would have yet another set.
>
> To be honest this doesn't surprise me...
>

Now that I'm digging into this a bit I'm thinking my issue has to do with
the fix you put in place from back in Aug 2007 (commit
405849610fd96b4f34cd1875c4c033228fea6c0f):

[MATH-EMU]: Fix underflow exception reporting.

    2) we ended up rounding back up to normal (this is the case where
       we set the exponent to 1 and set the fraction to zero), this
       should set inexact too
...

    Another example, "0x0.0000000000001p-1022 / 16.0", should signal both
    inexact and underflow.  The cpu implementations and ieee1754
    literature is very clear about this.  This is case #2 above.

I'm not clear from your commit comment on what actual number
0x0.0....01p-1022 is?

It looks like the case I have we are exact before rounding, but think it
looks like the rounding case since it appears as if "overflow is set".

000.FFFFFFFFFFFFF / 3FE.FFFFFFFFFFFFE = 001.0000000000000

I think the following adds the check for my case and still works for the
issue your commit was trying to resolve.  Take a look any and all comments
are welcome since this code is pretty complicated:

- k

diff --git a/include/math-emu/op-common.h b/include/math-emu/op-common.h
index cc1ec39..bc50aa0 100644
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
