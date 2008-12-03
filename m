Return-Path: <linux-kernel-owner+w=401wt.eu-S1755038AbYLCEH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038AbYLCEH0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 23:07:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbYLCEHL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 23:07:11 -0500
Received: from mail1.sea5.speakeasy.net ([69.17.117.3]:46737 "EHLO
	mail1.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbYLCEHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 23:07:10 -0500
Date: Tue, 2 Dec 2008 20:07:04 -0800 (PST)
From: Trent Piepho <xyzzy@speakeasy.org>
X-X-Sender: xyzzy@shell2.speakeasy.net
To: Alex Chiang <achiang@hp.com>
cc: "Darrick J. Wong" <djwong@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci <linux-pci@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>
Subject: Re: Problems with fakephp
In-Reply-To: <20081202031602.GG19000@ldl.fc.hp.com>
Message-ID: <Pine.LNX.4.58.0812021729560.2943@shell2.speakeasy.net>
References: <20081125212422.22631.69619.stgit@elm3a70.beaverton.ibm.com>
 <Pine.LNX.4.64.0811251919590.5161@t2.domain.actdsltmp> <20081126074808.GE6539@plum>
 <Pine.LNX.4.58.0811260131200.24816@shell4.speakeasy.net> <20081126181841.GF6539@plum>
 <Pine.LNX.4.58.0811261349120.24816@shell4.speakeasy.net>
 <20081126225535.GA27936@ldl.fc.hp.com> <Pine.LNX.4.58.0811261647410.24816@shell4.speakeasy.net>
 <20081128231820.GA23578@ldl.fc.hp.com> <Pine.LNX.4.58.0812010356410.2943@shell2.speakeasy.net>
 <20081202031602.GG19000@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Dec 2008, Alex Chiang wrote:
> I think there are now enough ideas in this thread that they're
> starting to get confusing.
>
> 	1) Function vs. device removal
> 	2) User interface
> 	3) Existing fakephp bugs
>
> For (1), do you need function level hotplug? Or will you be able
> to get away with device level?

While I have some hardware the can use function level hotplug (secondary
functions can be controlled by registers in the primary function), it's not
something *I* make use of.  But function level hotplug has been there for
years so it seems like a regression to remove that ability and break the
existing interface.

I guess my first though is should be there a new interface, as part of the
pci core rather than pci hotplug, for adding/removing devices from Linux's
view?  By devices I mean in the Linux "struct device" sense, so PCI
functions.

I think that seems reasonable.  fakephp isn't the best interface.  My patch
to add "remove" to pci-sysfs ended up being very simple, unless there's a
serious flaw in it I've overlooked.

So once we have that the question becomes how to keep some compatibility
with the old fakephp interface.  Either a new legacy compat module like
I've done or by fixing fakephp.

I'm more inclined to have the new legacy compat module:

- It's quite a bit simpler than fakephp so far.
- It already works better than fakephp ever did.  fakephp can't do
recursive bridge removal and won't co-exist well with a new pci core
remove/add interface.
- Fakephp's use of devices as "slots" appears to be fundamentally at odds
with the hotplug core.  It's just going to cause problems in the future.
The new compat module doesn't use hotplug at all, so it shouldn't get in
the way.

> > It looks like you weren't opposed to reverting the original
> > patch.  I think that should be done for 2.6.27 and 2.6.28, to
> > restore the existing interface.
>
> So we can't do a simple revert of fe99740c because:
>
> 	- fakephp registers with PCI hotplug core for device xxxx:yy.0
> 	- fakephp tries to register device xxxx:yy.1
> 	- PCI hotplug core returns -EBUSY because the _device_ is
> 	  already claimed

Hmm, I see what you mean.  I'd really like to fix 2.6.27 though.  I suppose
it would be if one left out sub-functions?  Partially broken being better
than entirely broken.

> You've convinced me that the 'fake%d' names are pretty useless. I
> was thinking of submitting my test patch that shows the
> domain:bus:slot.fn output above.

If fn must be 0, then maybe use domain:bus:slot?  That way there's no
conflict with the old fakephp interface.
