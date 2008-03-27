Return-Path: <linux-kernel-owner+w=401wt.eu-S1756474AbYC0Jw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756474AbYC0Jw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2008 05:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755276AbYC0JwS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Mar 2008 05:52:18 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:2779 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534AbYC0JwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2008 05:52:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=JH2A7g/qwFi0mC9ls5EfEwb+fytcOVRVqeQ8A2jtIp3AwYuMQLNPkr5AI82YrpVe/6kRhciK1jaL3NZAJJy76+kmLHnrIRFTMe/B1S6asii3E0/30SeYBsjf4YllJ/Iqexqk4UIjRmkV0jPBPDmQ2dv+lSXEfwmNd0MrazJpyVI=
Message-ID: <bc64b4640803270252q7199b3c8g62b7483c310dba6a@mail.gmail.com>
Date: Thu, 27 Mar 2008 12:52:15 +0300
From: Dmitry <dbaryshkov@gmail.com>
To: "Paul Mundt" <lethal@linux-sh.org>, Dmitry <dbaryshkov@gmail.com>,
       "Haavard Skinnemoen" <haavard.skinnemoen@atmel.com>,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       hskinnemoen@atmel.com, domen.puncer@telargo.com, tony@atomide.com,
       rmk+kernel@arm.linux.org.uk, paul@pwsan.com
Subject: Re: [PATCH 1/3] Clocklib: add generic framework for managing clocks.
In-Reply-To: <20080326174433.GA13104@linux-sh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080326161456.GA12490@linux-sh.org>
	 <20080326154913.GA15326@doriath.ww600.siemens.net>
	 <20080326155203.GA15405@doriath.ww600.siemens.net>
	 <20080326170441.795fb928@hskinnemo-gx620.norway.atmel.com>
	 <bc64b4640803261004t3ac4910bq43a889a6fab350b@mail.gmail.com>
	 <bc64b4640803260952s58ad0645ve11766fdfa45e785@mail.gmail.com>
	 <20080326174433.GA13104@linux-sh.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2008/3/26, Paul Mundt <lethal@linux-sh.org>:
> On Wed, Mar 26, 2008 at 07:52:34PM +0300, Dmitry wrote:
>  > 2008/3/26, Haavard Skinnemoen <haavard.skinnemoen@atmel.com>:
>
> > > Hmm...this is exactly twice as big as the struct I'm currently using,
>  > >  it doesn't contain all the fields I need, and it's undocumented.
>  >
>  > I've added a more sofisticated arch convertion patch (the clocklib for
>  > ARM PXA chips).
>  >
>
> What you've converted is still pretty tame in comparison to what this
>  sort of framework has to handle. Something like the OMAP struct clk is
>  more like a worst-case and is representative of how large this structure
>  will get for everyone if it is to be shared without dropping
>  functionality.

No, I don't want to add any more fields to generic struct clk. All
fancy fields should
go intro arch (or even clock-type) specific "priv" struct.

>
>
>  > >  I have quite a few clocks, so the increased memory consumption is quite
>  > >  significant. What are the advantages of this?
>  >
>  > At maximum 55, IIUC. I counted 32 or so additional bytes in the struct
>  > (over avr32-specific one). That would count up to 1.5 K overhead. Is
>  > that really too much for current kernels?
>  >
>
> Your idea of maximum and my hardware's idea of maximum have very little
>  in common. Most of these platforms are dealing with hundreds of different
>  clocks, though they are not necessarily all interfaced in software
>  control (mostly because a lot of them auto-gate, and because writing up
>  struct clk definitions for 200+ clocks for 30 different CPUs isn't
>  exactly my idea of a good time). This does not mean that more clocks will
>  not be hooked up as the need arises.

I have an idea of extendability and not "maximisation". And btw if
those clocks can be controlled  from the kernel, one will write a
patch to control them to get better power
management, ease driver interfaces, etc.

>  On Wed, Mar 26, 2008 at 08:04:41PM +0300, Dmitry wrote:
>  > 2008/3/26, Paul Mundt <lethal@linux-sh.org>:
>
> > > Conversely it also has fields that I don't need. If struct clk could have
>  > >  been done generically without growing to insane sizes, it would have been
>  > >  done so in linux/clk.h a long time ago. The main thing there is API
>  > >  consistency for drivers, leaving the details up to the architecture.
>  >
>  > In reality, as noted David Brownell on LAKML, there is no API consistency.
>  > The driver has no way to know whether clk API is implemented at all or whether
>  > the "optional" functions do exist.
>  >
>
> There is certainly API consistency. If there were not, we wouldn't have
>  linux/clk.h. The fact that many platforms add on top of this does not
>  detract from the fact that we have a common API that is currently shared.

I don't mean "additions". I meant optional "rate-controlling"
functions that some platforms
event don't try to implement.

>
>  There is indeed no way to know what optional functionality exists, but
>  your proposed structure and interface largely works around that problem
>  by ignoring all of the optional functionality. This works great for an
>  idealized set of platforms and clock configurations, but quickly runs in
>  to the same issue that linux/clk.h has today. It's not clear how your
>  proposed interface helps any of this other than providing a struct clk
>  that can be used more generically.

In the current situation if the "rate" or "parent" functionality
doesn't exist and the driver tries to use it, one would either get
compilation errors, or some non-standard -ENOsmth error.

With my patchset if the CLOCK_LIB is selected, the driver can assume
that it can safely call all linux/clk.h functions and if requested
feature isn't supported it'll get -EINVAL.

>  > Moreover clocks aren't limited only to platform-specific code. As an
>  > example of the in-tree driver that will benefit from clocklib you can
>  > check drivers/mfd/sm501.c which  contains  it's own set of functions
>  > to manage clocks.
>  >
>
> That's certainly true, it's definitely worthwhile to try and unify as
>  much of the interface as possible. Perhaps it makes more sense to try and
>  have a common struct clk with the bare essentials and then allow the
>  platforms to extend that functionality based on their own capabilities.
>  This could be done through the private data I suppose.

Yup! Or  as Haavard suggested, via clock extention. I took the first
way, because
I didn't want to conflict too much with OMAP clocks (plat-omap/clock.c
uses clocks
extension for self purposes. Probably this can be merged).

>  > That's one of the initial reasons of this patchserie: I have a device
>  > that can be installed on several platforms. And I want for this device
>  > to provide clocks to some other devices.
>  >
>
> I don't disagree with your intentions, or that something like this would
>  be a good idea. What needs to happen first is having a look at all of the
>  different versions of the clock framework that are out there and coming
>  up with a consolidated struct clk, then seeing if the resulting size is
>  practical enough to actually use for any significant number of clocks.

That sound constructive. Good!

>
>  Your current definition doesn't meet the requirements of all of the
>  struct clk users in the kernel, and it's already getting quite big
>  compared to what people (avr32, sh, some ARM platforms, etc.) are using
>  today. This is a good indicator of why a common definition wasn't a good
>  fit in the first place.
>

IMHO It wasn't good when the linux/clk.h first arrived. Now we already
have a few implmentations of it, so we can really judge what is common
and can be moved
to generic code, what is platform-specific.

-- 
With best wishes
Dmitry
