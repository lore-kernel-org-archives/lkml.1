Return-Path: <linux-kernel-owner+w=401wt.eu-S1758095AbXGVQRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758095AbXGVQRW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 12:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754517AbXGVQRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 12:17:14 -0400
Received: from nz-out-0506.google.com ([64.233.162.239]:13437 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754301AbXGVQRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 12:17:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PPHZmYEicexiZGMuGz9E/c0BEuNFHzLP6F1OPgH3LBCwfWgamhWRecEkTCUkIFxA1dMoFc0McTS3gdReI9sLuVdHxsH5FntB9BTdryk/l7O1IAeIx0AFtt4TdpzXM2PMPQWme7vasd5mAn+0Mxob4gqPnGcUJLFlKVtm8lQ3qfI=
Message-ID: <a781481a0707220917m710f2df3x1a27bdbb523099d7@mail.gmail.com>
Date: Sun, 22 Jul 2007 21:47:06 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Andi Kleen" <ak@suse.de>
Subject: Re: [PATCH 1/1] i386: Geode's TSC is not neccessary to mark tu unstable
Cc: "Andres Salomon" <dilinger@queued.net>,
       "Juergen Beisert" <juergen127@kreuzholzen.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "TAKADA Yoshihito" <takada@mbf.nifty.com>, linux-kernel@vger.kernel.org,
       "Jordan Crouse" <jordan.crouse@amd.com>,
       "Andres Salomon" <dilinger@debian.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <200707191022.44572.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070715.210036.157242351.takada@mbf.nifty.com>
	 <200707190849.05983.juergen127@kreuzholzen.de>
	 <20070719031712.bda40333.dilinger@queued.net>
	 <200707191022.44572.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > > On Sun, 15 Jul 2007 21:06:27 +0200
> > > Juergen Beisert <juergen127@kreuzholzen.de> wrote:
> > > > Replace NSC/Cyrix specific chipset access macros by inlined functions.
> > > > With the macros a line like this fails (and does nothing):
> > > >   setCx86(CX86_CCR2, getCx86(CX86_CCR2) | 0x88);
> > > > With inlined functions this line will work as expected.


> > On Thursday 19 July 2007 03:02, Andrew Morton wrote:
> > >
> > > I don't get it.  Why would the macros behave differently from inlined
> > > functions?


> On Thu, 19 Jul 2007 08:49:05 +0200
> Juergen Beisert <juergen127@kreuzholzen.de> wrote:
> >
> > X86 magic. The access order is important. The first access must always be the
> > offset at 0x22. This access enables the next access to 0x23 (data). If you do
> > it in wrong order, it fails. With the macros you get something like 0x22,
> > 0x22, 0x23, 0x23. With the inline functions 0x22,0x23,0x22,0x23.


On 7/19/07, Andres Salomon <dilinger@queued.net> wrote:
>
> Wow, that's a really cool bug; nice work!  Don't forget to update
> arch/i386/kernel/cpu/mtrr/state.c, though; it uses setCx86() as well.  It needs
> to include processor-cyrix.h.


On 7/19/07, Andi Kleen <ak@suse.de> wrote:
>
> It also needs some big fat comments


Ok, I was discussing macros-in-C on some other thread and got
reminded about this one. Anyway, I don't really think there was
anything weird / surprising about this case at all -- it's just another
manifestation of the same age-old time-tested advise all our respective
grandmothers have always given us:

        Never pass arguments that have side-effects to macros.

Of course, ideally the user shouldn't even know that the API call he's
using is a macro or a function -- which puts the onus upon the person
who *wrote* that API to ensure that he doesn't write macros for what
could, and should, easily be functions. Macros are generally evil and
always horrible, all IMHO, of course.

Satyam
