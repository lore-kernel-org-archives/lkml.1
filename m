Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbXGLTio@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbXGLTio (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 15:38:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755454AbXGLTif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 15:38:35 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:56600 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753667AbXGLTie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 15:38:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: david@lang.hm
Subject: Re: [PATCH 0/2] Kexec jump: The first step to kexec base hibernation
Date: Thu, 12 Jul 2007 21:45:55 +0200
User-Agent: KMail/1.9.5
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Huang, Ying" <ying.huang@intel.com>, Pavel Machek <pavel@ucw.cz>,
       nigel@nigel.suspend2.net, Jeremy Maitin-Shepard <jbms@cmu.edu>,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <1184167831.12556.13.camel@caritas-dev.intel.com> <200707122120.19662.rjw@sisk.pl> <Pine.LNX.4.64.0707121210210.25614@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0707121210210.25614@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707122145.56567.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 12 July 2007 21:14, david@lang.hm wrote:
> On Thu, 12 Jul 2007, Rafael J. Wysocki wrote:
> 
> >>>> note that what devices get put to sleep could be configurable, potentially
> >>>> to the extreme of things like the OLPC (that have hardware designed for
> >>>> cheap sleeping) going into a light suspend-to-ram state between keystrokes
> >>>> if nothing else has a timer event scheduled before that.
> >>>>
> >>>> Suspend-do-disk (Hibernate) involves stopping the system, makeing a
> >>>> snapshot of ram, writing the snapshot to somewhere and powering off the
> >>>> box. on wakeup (power-on) a helper kernel boots, loads the snapshot into
> >>>> ram and jumps to the kernel in the snapshot to resume operation.
> >>>>
> >>>> as I understand the proposal the thought is to do the following
> >>>>
> >>>> 1. system kernel does suspend-to-ram to put the devices into a known safe
> >>>> state.
> >>>
> >>> Not necessarily suspend-to-RAM.  I'd much prefer it if devices were not put
> >>> into low power states but quiesced (ie. no DMA, no interrupts).
> >>
> >> as I asked in another message, is it really worth having two (or more)
> >> modes here?
> >
> > I think so.  The suspend-to-RAM mode is quite specific and on some platform
> > (ie. ACPI) it requires platform support.
> >
> > We've already reached the conclusion that it's better to separate suspend from
> > hibernation, as far as device drivers are concerned, and let's not repeat the
> > discussion.
> 
> Ok, I seem to have been miscommunicating here. the old combined 
> suspend/hibernate took everything to the hibernate state even if you only 
> needed to suspend.

No, quite the other way around.

For creating a hibernation image you don't have to suspend devices.
Furthermore, you don't want to suspend at least some of them, because you'll
be using them to save the image in a while.  Also, there's no need to worry
about what power state to put the device into, so that it can wake up the
system from the sleep state etc.

We've made hibernation use suspend-specific callbacks and that causes quite
a lot of problems to appear.

> I was still seeing two diffent states involved
> 
> for suspend go to low-power mode
> 
> for hibernate go to low-power mode,

No, that is not the way to go, IMO.  We can shut down devices before creating
the image, but not suspend them.

> kexec the new kernel, do your stuff, power off 

Here, instead of just powering off, we may want to make the system enter a
sleep state (S4 in ACPI systems), which is similar to suspend.

> note that this doesn't really matter as you have pointed out in other 
> messages that we don't really want to put things in low-power mode, and 
> Eric pointed out that kexec already handles disabling devices, so it 
> sounds like this may be a solved problem if he's right and an issue to be 
> solved differently if he's not.

Shutting down devices and reinitializing them is costly.  I wouldn't like to
do that.

Of course, in a proof-of-concept version this is viable, but IMO not in the
final one.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
