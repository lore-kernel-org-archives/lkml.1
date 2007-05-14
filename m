Return-Path: <linux-kernel-owner+w=401wt.eu-S1758781AbXENDh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758781AbXENDh0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 23:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755324AbXENDhU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 23:37:20 -0400
Received: from wx-out-0506.google.com ([66.249.82.238]:54821 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbXENDhS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 23:37:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=l9tA8/u7OTetPEpB8z8PvOXmgm4wICp7nPRfhRgUV6QjLXh80BkJBcRN2x8pN0+ruKU5ACjRYDBQOVzEIsOV+WZFSabN4qNqFsmXoIBJAcOxAMJgpCBWZlFtTdVY/GBgCCDSGgettQ6Eg9H5+5rkFK5lLIsbeuTF4WSgjwC08Oc=
Message-ID: <a781481a0705132037v2229e675p1f51a9f18222b46b@mail.gmail.com>
Date: Mon, 14 May 2007 09:07:16 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: 7eggert@gmx.de
Subject: Re: [PATCH] "volatile considered harmful", take 3
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Jonathan Corbet" <corbet@lwn.net>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       "Johannes Stezenbach" <js@linuxtv.org>,
       "Jesper Juhl" <jesper.juhl@gmail.com>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Heikki Orsila" <shdl@zakalwe.fi>,
       "jimmy bahuleyan" <knight.camelot@gmail.com>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>
In-Reply-To: <E1Hn1VO-0001Gp-Ka@be1.lrz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <8jHg3-1T2-5@gated-at.bofh.it> <8jQt5-7As-3@gated-at.bofh.it>
	 <8jSuQ-28J-21@gated-at.bofh.it> <8jT7y-39x-9@gated-at.bofh.it>
	 <E1Hn1VO-0001Gp-Ka@be1.lrz>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bodo,

On 5/13/07, Bodo Eggert <7eggert@gmx.de> wrote:
> Satyam Sharma <satyam.sharma@gmail.com> wrote:
>
> > In fact you can't really say the same for
> > volatile. We already assume the compiler _actually_ took some
> > pains to stuff meaning into C's (lack of) definition of volatile and
> > implement it -- but in what sense, nobody knows (the C standard
>                                                    ^^^^^^^^^^^^^^
> > doesn't, so what are we).
>   ^^^^^^^
> It does:

I don't think so ... the ambiguity in 6.7.3:6 is why.

> ISO/IEC 9899:1999 (E)
>
> 5.1.2.3 Program execution
>
> 5 The least requirements on a conforming implementation are:
>  At sequence points, volatile objects are stable in the sense that previous
>  accesses are complete and subsequent accesses have not yet occurred.

Worthy goal, indeed, but you've yourself pointed out later in your mail
why this may not be possible for a compiler/assembler to guarantee safely
(in a sense that the programmer usually wants, anyway), even with the C
standard-blessed "volatile" type-qualifier, what with the *hardware*
optimizing memory accesses _independently_ at a granularity finer than
the "sequence points" understood by a compiler.

> 9 Alternatively, an implementation might perform various optimizations
>  within each translation unit, such that the actual semantics would agree
>  with the abstract semantics only when making function calls across
>  translation unit boundaries. In such an implementation, at the time of each
>  function entry and function return where the calling function and the
>  called function are in different translation units, the values of all
>  externally linked objects and of all objects accessible via pointers
>  therein would agree with the abstract semantics. Furthermore, at the time
>  of each such function entry the values of the parameters of the called
>  function and of all objects accessible via pointers therein would agree
>  with the abstract semantics. In this type of implementation, objects
>  referred to by interrupt service routines activated by the signal function
>  would require explicit specification of volatile storage, as well as other
>  implementation-defined restrictions.
>
>
> 6.7.3 Type qualifiers
>
> 6 An object that has volatile-qualified type may be modified in ways unknown
>  to the implementation or have other unknown side effects. Therefore any
>  expression referring to such an object shall be evaluated strictly according
>  to the rules of the abstract machine, as described in 5.1.2.3. Furthermore,
>  at every sequence point the value last stored in the object shall agree with
>  that prescribed by the abstract machine, except as modified by the unknown
>  factors mentioned previously.114) What constitutes an access to an object
>  that has volatile-qualified type is implementation-defined.

The way I read it, "What constitutes an access to an object that has
volatile-qualified type is implementation-defined" is the standard's way
of saying: "All bets are off." Actually I wonder how the various _compiler
implementations_ read this clause (and whether *all* of them read it
consistently and equally, which is what a portable codebase probably
wants), because _their_ interpretation of this clause is more important
than mine, after all. But I don't really see how generic C code that uses
"volatile" can also claim dialect-independence.

So, IMO, the trouble with the volatile type-qualifier is that it is (what
should have been defined as in the first place, and what is in effect)
a _compiler extension_ *masquerading* as a _language keyword_.

*Unfortunately* (the trouble with C itself, is that a *committee* has made
it into ... something ... that it should not have made it into) -- anyway,
unfortunately C took it upon itself to solve a problem that it did not
have (and does not even bring about) in the first place: and the
half-hearted (or vague, call it what you will) attempt _then_ ends up
being a problem -- by making people _feel_ as if they are doing things
right, when that is probably not the case.

[ And we've not even touched the issue of whether the _same_ compiler's
implementation of volatile across archs/platforms is consistent. ]

> It does not guarantee ordering or consistency beyond the scope of the
> assembler layer, especially the CPU or other hardware may be free to cache
> or reorder load/stores to these volatile objects (see e.g. MTRR), which is
> why you'll usurally want to use something completely different. If you know

Exactly. So this combined with the issue above, is the last nail in volatile's
coffin as far as I'm concerned.

> an object to not be modified from outside the scope of the C state machine
> and it does not have relevant side effects, you can however use volatile
> (likely on an atomic value).

Yes, but I'd prefer to stick to the straight-and-narrow (well-defined-and-
well-understood), and avoid volatile altogether. The kernel codebase does
contain APIs that allow one to avoid it and are also what one probably
wants for most situations.

> I think you should say something like:
>
> 1) Don't use volatile
> 2) Read memory-barriers.txt carefully!
> 3) If you still use volatile, explain
>   a) Why it's nescensary
>   b) Why it's enough (see (2))
>  to specify volatile on that object. Be sure to consider hardware cache and
>  reordering, as well as prohibited optimizations on volatile access and on
>  functions possibly doing volatile access.

Yeah, I agree with the wording above, also with Jimmy's summary that Jeff
and Peter agreed to already.

Satyam
