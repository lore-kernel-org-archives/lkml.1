Return-Path: <linux-kernel-owner+w=401wt.eu-S1755866AbYLCEiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755866AbYLCEiY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 23:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754445AbYLCEiJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 23:38:09 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:15200 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753767AbYLCEiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 23:38:07 -0500
Date: Tue, 2 Dec 2008 21:38:04 -0700
From: Alex Chiang <achiang@hp.com>
To: Trent Piepho <xyzzy@speakeasy.org>
Cc: "Darrick J. Wong" <djwong@us.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       linux-pci <linux-pci@vger.kernel.org>, Matthew Wilcox <matthew@wil.cx>,
       eike-kernel@sf-tec.de, gregkh@suse.de
Subject: Re: Problems with fakephp
Message-ID: <20081203043804.GA26130@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Trent Piepho <xyzzy@speakeasy.org>,
	"Darrick J. Wong" <djwong@us.ibm.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	linux-pci <linux-pci@vger.kernel.org>,
	Matthew Wilcox <matthew@wil.cx>, eike-kernel@sf-tec.de,
	gregkh@suse.de
References: <20081126074808.GE6539@plum> <Pine.LNX.4.58.0811260131200.24816@shell4.speakeasy.net> <20081126181841.GF6539@plum> <Pine.LNX.4.58.0811261349120.24816@shell4.speakeasy.net> <20081126225535.GA27936@ldl.fc.hp.com> <Pine.LNX.4.58.0811261647410.24816@shell4.speakeasy.net> <20081128231820.GA23578@ldl.fc.hp.com> <Pine.LNX.4.58.0812010356410.2943@shell2.speakeasy.net> <20081202031602.GG19000@ldl.fc.hp.com> <Pine.LNX.4.58.0812021729560.2943@shell2.speakeasy.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0812021729560.2943@shell2.speakeasy.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Trent Piepho <xyzzy@speakeasy.org>:
> On Mon, 1 Dec 2008, Alex Chiang wrote:
> > I think there are now enough ideas in this thread that they're
> > starting to get confusing.
> >
> > 	1) Function vs. device removal
> > 	2) User interface
> > 	3) Existing fakephp bugs
> >
> > For (1), do you need function level hotplug? Or will you be able
> > to get away with device level?
> 
> While I have some hardware the can use function level hotplug (secondary
> functions can be controlled by registers in the primary function), it's not
> something *I* make use of.  But function level hotplug has been there for
> years so it seems like a regression to remove that ability and break the
> existing interface.

That seems reasonable.

> I guess my first though is should be there a new interface, as part of the
> pci core rather than pci hotplug, for adding/removing devices from Linux's
> view?  By devices I mean in the Linux "struct device" sense, so PCI
> functions.
> 
> I think that seems reasonable.  fakephp isn't the best interface.  My patch
> to add "remove" to pci-sysfs ended up being very simple, unless there's a
> serious flaw in it I've overlooked.

I think we should definitely merge your 'remove' attribute patch
for PCI functions. That should be independent of the rest of our
discussion.

It will probably help the SR-IOV folks too.

> So once we have that the question becomes how to keep some compatibility
> with the old fakephp interface.  Either a new legacy compat module like
> I've done or by fixing fakephp.
> 
> I'm more inclined to have the new legacy compat module:
> 
> - It's quite a bit simpler than fakephp so far.
> - It already works better than fakephp ever did.  fakephp can't do
> recursive bridge removal and won't co-exist well with a new pci core
> remove/add interface.
> - Fakephp's use of devices as "slots" appears to be fundamentally at odds
> with the hotplug core.  It's just going to cause problems in the future.
> The new compat module doesn't use hotplug at all, so it shouldn't get in
> the way.

Maybe we should just replace fakephp wholesale with your new
driver?

Or coming at it from another angle, I don't see what benefit
we'll have from keeping both fakephp and your driver. And if
fakephp is as broken as you describe, then it will only cause
more confusion if a user loads both fakephp and legacy_fakephp.

If the user removes a bridge via the correct legacy_fakephp
interface, fakephp won't notice, and we'll just have a broken
mess on our hands.

It would be better to have just one, correctly working fakephp,
even if the implementation is 100% different and truly not even a
"real" hotplug driver.

I think the way forward is:

	- merge in the function level hotplug patch
	- wholesale replacement of fakephp with new fakephp
	- schedule new fakephp for deprecation
	- encourage anyone who wants function level hotplug to
	  use the 'remove' attribute

Thoughts? Jesse, Willy, Eike, Greg?

Thanks.

/ac

