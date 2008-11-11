Return-Path: <linux-kernel-owner+w=401wt.eu-S1755428AbYKKDVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755428AbYKKDVe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 22:21:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754194AbYKKDVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 22:21:25 -0500
Received: from gate.crashing.org ([63.228.1.57]:45177 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754126AbYKKDVX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 22:21:23 -0500
Subject: Re: [Bug #11875] radeonfb lockup in .28-rc (bisected)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andreas Schwab <schwab@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>,
       James Cloos <cloos@jhcloos.com>,
       Paul Collins <paul@burly.ondioline.org>
In-Reply-To: <alpine.LFD.2.00.0811101822350.3468@nehalem.linux-foundation.org>
References: <YrUCLn0F-xH.A.fhE.E4zFJB@chimera>
	 <wnN9HICUAgP.A._d.f5zFJB@chimera> <1226295985.7731.7.camel@pasglop>
	 <jetzafiad4.fsf@sykes.suse.de> <1226353979.7530.8.camel@pasglop>
	 <jefxlzi2x0.fsf@sykes.suse.de> <1226360094.7530.18.camel@pasglop>
	 <je1vxji1br.fsf@sykes.suse.de> <1226368174.7530.47.camel@pasglop>
	 <alpine.LFD.2.00.0811101822350.3468@nehalem.linux-foundation.org>
Content-Type: text/plain
Date: Tue, 11 Nov 2008 14:21:02 +1100
Message-Id: <1226373662.7530.76.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-10 at 18:47 -0800, Linus Torvalds wrote:
> 
> On Tue, 11 Nov 2008, Benjamin Herrenschmidt wrote:
> > 
> > In any case, I doesn't seem to be directly related to those radeonfb
> > changes, though a clash with X like that is indeed more likely to
> > actually happen if radeonfb relies more heavily on acceleration.
> 
> Just a silly question, without actually looking at the code - since you 
> now do acceleration in radeonfb, do you wait for everything to drain 
> before you switch consoles? 

radeonfb has been doing acceleration for some time :-) Just not color
expansion, only blits and solid fills (so basically scrolling). That is
a lot less common though and thus it's possible that existing races
didn't show up until now.

It does drain the engine in various cases, typically mode change,
blanking, sync callback. fbcon core should at least sync if not blank
when switching to KD_GRAPHICS (or at least used to, I need to double
check). I have additional guards also that disable use of the engine
when sleeping.

> There could be races that depend on timing, where perhaps X is unhappy 
> about being entered with the acceleration engine busy, or conversely the 
> radeonfb code is unhappy about perhaps some still-in-progress X thing that 
> hasn't been synchronously waited for..

Yes. From what's been reported, the more likely thing would be a race
when switching away from X.

> Before, radeonfb_imageblit() would always end up doing a 
> "radeon_engine_idle()", so in practice, I think just about any fbcon 
> access ended up idling the engine. Now, we can probably do a lot more 
> without syncronizing - maybe there's insufficient synchronization at the 
> switch-over from X to text-mode or vice versa?

Switch over from X should restore KD_TEXT which should turn to a call to
set_par() that idles the engine before anything gets written to the
screen, but those code path are intricated between the VT code and fbcon
and things may well be subtely broken. I'll dig later today after I'm
done with some other emergency.

At one point, I fixed a crapload of VT bugs where things were done
without any locking, nowadays, everything should pretty much be covered
by the console semaphore, but maybe there's still a problem there.
Another area to look at is X itself. I've had problems with X (or the
DRM) still whacking the card after handing back the console to the
kernel in the past, so it wouldn't surprise me if there was something
bogus there too.

I also had problems with fbcon trying to draw before it re-initialized
the card (ie, it -should- call set_par before any new draw operation
when switching back from KD_GRAPHICS, if not, we don't properly get to
reconfigure the engine before we try to use it, which can be fatal), but
those were fixed last time I looked.

Anyway, I'll dig and let you know what I find.

Cheers,
Ben.

