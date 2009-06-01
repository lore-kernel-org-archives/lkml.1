Return-Path: <linux-kernel-owner+w=401wt.eu-S1755578AbZFAWmj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578AbZFAWmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 18:42:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752873AbZFAWmc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 18:42:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56700 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752207AbZFAWmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 18:42:31 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jan Scholz <scholz@fias.uni-frankfurt.de>
Subject: Re: [regression, bisected] adb trackpad disappears after suspend to ram
Date: Tue, 2 Jun 2009 00:42:36 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-rjw; KDE/4.2.3; x86_64; ; )
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Adrian Bunk <bunk@kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <878wkl6vce.fsf@scholz.fias.uni-frankfurt.de> <200906011836.15507.rjw@sisk.pl> <877hzv8txp.fsf@scholz.fias.uni-frankfurt.de>
In-Reply-To: <877hzv8txp.fsf@scholz.fias.uni-frankfurt.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906020042.37036.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 02 June 2009, Jan Scholz wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > On Monday 01 June 2009, Jan Scholz wrote:
> >> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> >> 
> >> > On Friday 29 May 2009, Jan Scholz wrote:
> >> >> Benjamin Herrenschmidt <benh@kernel.crashing.org> writes:
> >> >> 
> >> >> >> We are too late in the cycle to revert this commit and it really is needed to
> >> >> >> fix a more serious issue.  Nevertheless knowing that it caused the problem to
> >> >> >> appear on your system is also important.
> >> >> >> 
> >> >> >> Ben, do you have an idea what may be going on here?  Does __disable_irq() mask
> >> >> >> the interrupt on this platform?
> >> >> >
> >> >> > I suppose so :-) I'll have to check what's going on, it's not
> >> >> > immediately clear to me.
> >> >> >
> >> >> > Cheers,
> >> >> > Ben.
> >> >> >
> >> >> >> 
> >> >> >> I'd like to see a boot log, preferably containing a suspend-resume in which
> >> >> >> the problem was reproduced.
> >> >> 
> >> >> Here is a log from booting, through several suspend cycles, until the
> >> >> trackpad disappeared. The first few suspends were done while X was
> >> >> running but from the console. As you can tell from lines like
> >> >>    May 28 23:51:26 [kernel] adb devices: [2]: 2 c4 [3]: 3 1 [7]: 7 1f
> >> >> the trackpad was still present. The last suspend was done from within X,
> >> >> here the trackpad did not make it.
> >> >>    May 28 23:58:09 [kernel] adb devices: [2]: 2 c4 [7]: 7 1f
> >> >> However, there have been cases, although not in this log, were the
> >> >> trackpad has been alive even when suspending from within X.
> >> >
> >> > This means the problem is probably timing-related.
> >> >
> >> > Can you please try to comment out suspend_device_irqs() and
> >> > resume_device_irqs()  in drivers/base/power/main.c and see if that changes
> >> > anything?  It's not entirely safe (well, that's why the calls are there after
> >> > all), but hopefully the box won't hang during this test.
> >> >
> >> 
> >> Tried that against v2.6.30-rc7 and it seems to fix the issue. I did ~10
> >> suspend-resume cycles from the console (which worked just like before)
> >> and ~20 cycles from within X and the trackpad is still alive.
> >
> > So, it seems we lose and interrupt during resume and that confuses the
> > ADB controller driver or something like this.  Do you use the keyboard or
> > the trackpad as a wake-up device?
> 
> I do the wakeup by pressing keys on the keyboard. I'd try wakeup via the
> trackpad's button, but I have no idea how to activate that.
> 
> > Please additionally try to go back to the original code, put
> > 'sleepy_trackpad = 1' at the beginning of do_adb_reset_bus() in
> > drivers/macintosh/adb.c and see if the problem is reproducible with that.
> 
> Tried this, but it does not help.
> 
> What I haven't noticed before is, that even if the trackpad already
> disappeared, an additional suspend-resume cycle from the console brought
> it back to life every time. Sometimes this worked from within X as well,
> just not with such a high probability as from the console.
> However, this is independent from 'sleepy_trackpad = 1'. 

OK, thanks for testing.  I think I know what to do, but I need some time to
prepare a patch.

Best,
Rafael
