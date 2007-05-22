Return-Path: <linux-kernel-owner+w=401wt.eu-S934528AbXEVPNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934528AbXEVPNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 11:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757026AbXEVPNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 11:13:05 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:35594 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289AbXEVPNC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 11:13:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=L6jDclZU+qnWs03lOgIiKb4wY6Y0iVRRVRl2DlUOc/bwcf+V7xsjM6f2KUlc2SDokk22uHi7kOsx/YMbNCzoCTydO7aBNAidEggjPyo74KeelP+z5ZNsEuHbPVsMRsgeVy11t5CPbPriUkbHB5h1jKr0qis2H8bm1KgC5Yx9JFY=
Message-ID: <a781481a0705220813m7844dbabk387fc3a52d67cee7@mail.gmail.com>
Date: Tue, 22 May 2007 20:43:00 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Trent Piepho" <xyzzy@speakeasy.org>
Subject: Re: RFC: kconfig select warnings bogus?
Cc: "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Adrian Bunk" <bunk@stusta.de>, "Sam Ravnborg" <sam@ravnborg.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Roman Zippel" <zippel@linux-m68k.org>
In-Reply-To: <Pine.LNX.4.58.0705201316350.1671@shell4.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070519151523.GA26724@uranus.ravnborg.org>
	 <20070519230940.GJ6291@stusta.de>
	 <a781481a0705191719u5234b248v8d36af6a368a5119@mail.gmail.com>
	 <Pine.LNX.4.58.0705200228360.1671@shell4.speakeasy.net>
	 <465029F1.6090301@s5r6.in-berlin.de>
	 <Pine.LNX.4.58.0705200416370.1671@shell4.speakeasy.net>
	 <465034AA.6030904@s5r6.in-berlin.de>
	 <Pine.LNX.4.58.0705201243500.1671@shell4.speakeasy.net>
	 <4650AB9B.9060800@s5r6.in-berlin.de>
	 <Pine.LNX.4.58.0705201316350.1671@shell4.speakeasy.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Trent,

On 5/21/07, Trent Piepho <xyzzy@speakeasy.org> wrote:
> On Sun, 20 May 2007, Stefan Richter wrote:
> > Trent Piepho wrote:
> > > config A
> > >     bool "A"
> > >
> > > config B
> > >     bool "B"
> > >     depends on A
> > >
> > > config C
> > >     bool "C"
> > >     select B
> > >
> > > In this case, it's possible to turn C on and A off.  B will be on, even
> > > though it depends on A and A is off.
> > >
> > > The kconfig docs say that "B..  depends on A" sets the maximum value of B
> > > to be that of A.  Since A=0, the max value of B is 0.
> > >
> > > The kconfig docs also say that "C..  select B" sets the minimum value of B
> > > to be that of C.  Since C=2, the minimum value of B is 2.
> > >
> > > So we have B>=2 and B<=0, which is obviously impossible.  Yet *config has
> > > no problem with this, and will set B=2 even the 'depends' means B must be
> > > 0.  It seems like "select" will override any other dependencies.
> >
> > If that's so, then we have /a/ an incomplete definition of the Kconfig
> > language (what is supposed to happen if "select" attempts to set an
> > impossible value?) and /b/ a bug in the make xyzconfig programs (they
> > generate invalid configs).
>
> This came up when I was working on the v4l-dvb tree's out of kernel build
> system.  It uses the same Kconfig files, but I've created a config system in
> perl to parse and evaluate them.  It will disable options that the kernel
> config programs allow, and it is because I'm treating this situation
> differently:  Since "B" is disabled because "A" is off, "C" must also be
> disabled.

Yeah, this is the classic "select" trap.

> Another way of dealing with this would be to have 'select' follow the
> dependency chain back up.  Turning on C selects B, B depends on A, so A is
> also selected.

You're right ... we'd discussed this earlier in:
http://lkml.org/lkml/2007/5/16/257
and http://lkml.org/lkml/2007/5/16/237

Also, because dependencies are of two types, those that _can_ be
meaningfully selected and those that can't, so we could select _all_
grand-parent dependencies A's of C when user picks C if they are all
selectable, but just refuse to proceed to even pick C itself if _any_
grand-parent dependency A of C is not a "select"able dependency.

i.e., a mix of the two solutions you mentioned above.

> One problem with this is that "depends on" can take complex expressions.
> Finding the solution is NP complete, which likely isn't a problem for the
> sizes of realistic Kconfig files.  But there could easily be multiple
> solutions, so which one is the right one?

Yes, the real problem is when a "depends on" somewhere along the
dependency tree has a || somewhere in it -- so we don't exactly know which
branch to follow from that point when creating the dependency tree. But I
suspect this shouldn't really be such a show-stopper ... I'll see if I can look
into scripts/kconfig/*.c to try and implement something of this sort.

Cheers,
Satyam
