Return-Path: <linux-kernel-owner+w=401wt.eu-S1759475AbXHUM0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759475AbXHUM0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2007 08:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751368AbXHUM0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Aug 2007 08:26:45 -0400
Received: from fk-out-0910.google.com ([209.85.128.189]:17408 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197AbXHUM0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2007 08:26:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=E2R/eIZIXdBZxo2vfPttSewL5kXiKb6a3k0uwQcu1LoxcBq+R4kW5we09NLP9P0dFwe6LQsqLLgD3LWC/Upsn1OyNYCZSuMNY1Ql+n4JRFLJBrKrQ0Z1VNPwhpB5LrUe+sv4D9gSmNsE03AkWigzJZOi1VN9eI5sJ1Is0s3aguQ=
Message-ID: <5d6222a80708210526o5910f7f3j6f2ef30b3d035d0b@mail.gmail.com>
Date: Tue, 21 Aug 2007 09:26:41 -0300
From: "Glauber de Oliveira Costa" <glommer@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH] [5/12] x86_64: Make patching more robust, fix paravirt issue
Cc: "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Chris Wright" <chrisw@sous-sol.org>,
       "Rusty Russell" <rusty@rustcorp.com.au>, patches@x86-64.org,
       linux-kernel@vger.kernel.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Steven Rostedt" <rostedt@goodmis.org>
In-Reply-To: <20070821112330.GD32640@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070809241.425881000@suse.de>
	 <20070809124132.C794A14F3B@wotan.suse.de> <46C637B7.30200@goop.org>
	 <1187574628.19435.29.camel@localhost.localdomain>
	 <20070820020732.GA3672@sequoia.sous-sol.org>
	 <46C9317C.2080509@goop.org>
	 <5d6222a80708210030w26294b0dq4bd1977fcb3bc6f4@mail.gmail.com>
	 <20070821112330.GD32640@bingen.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/21/07, Andi Kleen <ak@suse.de> wrote:
> On Tue, Aug 21, 2007 at 04:30:10AM -0300, Glauber de Oliveira Costa wrote:
> > On 8/20/07, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> > > Chris Wright wrote:
> > > > That did get backed out (at least the part that broke paravirt patching)
> > > > in 602033ed5907a59ce86f709082a35be047743a86.  Linus' tree should be
> > > > working fine right now with d34fda4a84c18402640a1a2342d6e6d9829e6db7
> > > > committed, and can be further refined with the patch below that's just
> > > > waiting on some further testing.
> > > >
> > >
> > > I don't think this is necessary.  It isn't worth complicating the
> > > interface to avoid the memcpy.
> > >
> > >     J
> > Damn,
> >
> > I can't believe I've just lost a night tracking the issue, without
> > seeing the discussion here ;-)
> > I came out to this very same conclusion, and was about to send a patch
> > that fixes it, by doing a memcpy before starting the instruction
> > replacement.
> >
> > (I wouldn't say anything, as this is solved, but my night have to get
> > some value, after all! ;-)
> >
> > So I'm with Jeremy. We don't lose too much by putting a memcpy there,
> > this code is not exactly critical. It also seems cleaner, and less
> > error prone. I have a patch ready here, but I think by this time, you
> > guys have too ;-)
>
> x86-64 also has a __inline_memcpy that is guaranteed inlined. It was
> originally for such cases when memcpy didn't work. Could be added to i386
> too if there is need
>
Andi,

this is not the case that memcpy did not work. (I got the same issue
for paravirt_ops x86_64, and btw, that's why I have not yet sent a new
patch).

The thing is that if that the paravirt replacement function returns,
it will return with the temporary buffer empty, will write the buffer
with text_poke(), and thus, put crap into the code.

So adding a memcpy to the buffer guarantees that in the worst case, it
will contain the original instruction. The normal memcpy works neatly.

-- 
Glauber de Oliveira Costa.
"Free as in Freedom"
http://glommer.net

"The less confident you are, the more serious you have to act."
