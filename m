Return-Path: <linux-kernel-owner+w=401wt.eu-S1755759AbYIDC5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759AbYIDC5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 22:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753417AbYIDC5Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 22:57:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58065 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753397AbYIDC5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 22:57:23 -0400
Date: Wed, 3 Sep 2008 19:56:10 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alok Kataria <akataria@vmware.com>
cc: Thomas Gleixner <tglx@linutronix.de>,
       Larry Finger <Larry.Finger@lwfinger.net>,
       LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Michael Buesch <mb@bu3sch.de>, Dan Hecht <dhecht@vmware.com>
Subject: Re: [PATCH] Fix TSC calibration issues
In-Reply-To: <1220490884.22734.83.camel@alok-dev1>
Message-ID: <alpine.LFD.1.10.0809031817430.3515@nehalem.linux-foundation.org>
References: <48BB2116.1060904@lwfinger.net>  <alpine.LFD.1.10.0809011311210.3243@apollo.tec.linutronix.de>  <48BC2A03.9000104@lwfinger.net>  <alpine.LFD.1.10.0809012018000.3243@apollo.tec.linutronix.de>  <alpine.LFD.1.10.0809011142520.12958@nehalem.linux-foundation.org>
  <alpine.LFD.1.10.0809012114050.3243@apollo.tec.linutronix.de>  <alpine.LFD.1.10.0809011504200.12958@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0809020033450.3243@apollo.tec.linutronix.de>  <alpine.LFD.1.10.0809012015160.12958@nehalem.linux-foundation.org>
  <alpine.LFD.1.10.0809012033280.3210@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0809020835150.3243@apollo.tec.linutronix.de>  <alpine.LFD.1.10.0809020759480.3210@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0809021918450.3243@apollo.tec.linutronix.de>
  <alpine.LFD.1.10.0809021120120.3210@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0809022358370.3243@apollo.tec.linutronix.de>  <alpine.LFD.1.10.0809021906250.3259@nehalem.linux-foundation.org>  <alpine.LFD.1.10.0809031103090.3243@apollo.tec.linutronix.de>
 <1220490884.22734.83.camel@alok-dev1>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Sep 2008, Alok Kataria wrote:
> 
> As Linus suggested, we should be moving the tsc_read_refs outside of the
> loop, this gives us more accurate TSC calibration when calibrating against
> hpet/pmtimer, since we are now calibrating over a period of 250ms.

Side note: I'd like to change that.

250ms is a _loong_ time. It's a really really long time. It's 
human-noticeable. A quarter of a second at boot is just too long.

We have a couple of options:

 - make the PIT calibration shorter

   I suspect we could easily make the PIT calibration be just 5ms rather
   than 50ms. Yes, yes, it will be less precise, but the PIT counts at
   1.1MHz or something, so we're still talking about 5000+ ticks of the 
   clock.

   So we'll get within a fraction of a percent. We could then decide that 
   _if_ the HPET/PMTIMER matches the PIT, we'll decide to use that as the 
   reference time, because it would possibly have higher accuracy.

 - do other things while calibrating.

   Especially for HPET/PM_TIMER, we could actually do some other stuff 
   while it is calibrating, since those calibrations only depend on the 
   end/beginning being "close enough". This seems like it would be pretty 
   hard to actually do sanely, though (there's still the issue of the 
   HPET/PM_TIMER overflowing, although with 24 bits that should be on the 
   order of several seconds, I dunno)

Anyway, 250ms really is too long.

		Linus
