Return-Path: <linux-kernel-owner+w=401wt.eu-S1762314AbYBLNWi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762314AbYBLNWi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 08:22:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757460AbYBLNW3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 08:22:29 -0500
Received: from smtp.nokia.com ([192.100.122.230]:18039 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757160AbYBLNW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 08:22:28 -0500
Date: Tue, 12 Feb 2008 15:22:15 -0500
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext David Brownell <david-b@pacbell.net>
Cc: felipe.balbi@nokia.com, linux-kernel@vger.kernel.org,
       linux-usb@vger.kernel.org, me@felipebalbi.com
Subject: Re: [PATCH] USB: OTG: Fix weirdnesses on enumerating partial otg
	devices
Message-ID: <20080212202215.GY4769@gandalf.research.nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <1202835603-10663-1-git-send-email-felipe.balbi@nokia.com> <200802120228.54123.david-b@pacbell.net> <20080212174515.GU4769@gandalf.research.nokia.com> <200802120502.48019.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200802120502.48019.david-b@pacbell.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-OriginalArrivalTime: 12 Feb 2008 13:21:41.0554 (UTC) FILETIME=[3492E920:01C86D7A]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 12, 2008 at 05:02:47AM -0800, David Brownell wrote:
> On Tuesday 12 February 2008, Felipe Balbi wrote:
> > On Tue, Feb 12, 2008 at 02:28:53AM -0800, David Brownell wrote:
> > > On Tuesday 12 February 2008, Felipe Balbi wrote:
> > > > Some devices claim
> > > > to be b_host even though they have an a_connector attached to it.
> > > 
> > > Why not just fix that bug?  Remember that's Linux code.
> > 
> > The device claiming to be b_host is not linux based.
> 
> Wrong ... the meaning of that flag is:  *THIS* system is a
> Linux-USB OTG device which came up in B-peripheral role, and
> then through the magic of HNP morphed into the B-host role.

Don't be sarcastic I won't even fall into what Jean Delvare told you.

> Linux is acting as a host at that point.  So either it's
> being the A-host, or the B-host.  That flag says which.  If
> the other device has the A-connector, yet we're the B-host,
> then right now it is acting as an A-peripheral.  That's
> exactly what HNP is designed to do.

True, but allowing hnp nowing we're b_host doesn't sound correct. If
we're b_host it can get two scenarios we would get to fall into this
state:

	1. We asked to become host; or
	2. A_device allowed us become host because it can't handle us.

In both cases, HNP is quite useless happening again, don't you think?
We should at least try to enumerate a_peripheral, if it can't due to
our power capabilities i.e. 100mA, we'll fall into overcurrent
protection and we'll suspend the bus and disconnect, which would give
a_device another change to enumerate us.

This sound much better to me.

> > In any case this 
> > is_b_host check won't do nothing here as we should check is
> > SetFeature(b_hnp_enbable) has been succesfull.
> 
> Again wrong ... if the host side's b_hnp_enable flag is set,
> that means this is a Linux-USB OTG device which came up in
> A-host role and enumerated some vendor's OTG device, and
> then set the b_hnp_enable flag.  (So it could in the future
> use HNP to become an A-peripheral, despite having started
> as an A-host.)
> 
> 
> > A device in b_host state is not enough for allowing hnp to happen.
> 
> If the system is in b_host state, then HNP *ALREADY* happened.

True, but...

> So it can happen again, to go back into the b_peripheral state.
> (And of course, we can't set the b_hnp_enable flag in a device
> which is in the a_peripheral state...)

it shouldn't happen again at this point. If we're b_host, we should try to
enumerate a_peripheral. If it draws more than 100mA the session should
end, otherwise we'd fall into hnp loops until we start getting hub port
errors and linux decide to suspend roothub and end the session.

> Seems like the root cause of the problem here is that you
> have some correctly functioning code, but for some reason
> you're surprised by that correct functioning.  (Maybe this
> is a case where neither device is on the other's whitelist?)

True, neither is in other's whitelist, but the point is:

 1. Currently standard-a device supports hnp only on A states
 2. Currently standard-b device supports hnp on both roles
 3. A-device enumerates b-device, checks it's not tpl'ed and allow hnp
 4. B-device become b_host, checks a_peripheral is not on its tpl, even
 though it has support for that device class and it draws less than
 100mA.

According to otg tpl clarification, they should work in this scenario,
shouldn't they ? Or should they stay in an hnp loop until someone
decides to end the session ?

-- 
	- Balbi
