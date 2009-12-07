Return-Path: <linux-kernel-owner+w=401wt.eu-S935401AbZLGQi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935401AbZLGQi2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Dec 2009 11:38:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935376AbZLGQi0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Dec 2009 11:38:26 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47544 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935321AbZLGQiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Dec 2009 11:38:25 -0500
Date: Mon, 7 Dec 2009 08:37:56 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Zhang Rui <rui.zhang@intel.com>, Alan Stern <stern@rowland.harvard.edu>,
       LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [GIT PULL] PM updates for 2.6.33
In-Reply-To: <200912071615.34788.rjw@sisk.pl>
Message-ID: <alpine.LFD.2.00.0912070832330.3560@localhost.localdomain>
References: <Pine.LNX.4.44L0.0912060953190.4442-100000@netrider.rowland.org> <1260158279.27069.181.camel@rzhang1-desktop> <alpine.LFD.2.00.0912062122460.3560@localhost.localdomain> <200912071615.34788.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 7 Dec 2009, Rafael J. Wysocki wrote:
> 
> > The advantage: untouched drivers don't change ANY SEMANTICS AT ALL.
> 
> This also was true for my patchset.

That's simply not trye.

You set async_suspend on every single PCI driver. I object very heavily to 
it.

You also introduce this whole big "callback when ready", and 
"non-topoligical PM dependency chain" thing. Which I also object to.

Notice how with the simpler "lock parent" model, you _can_ actually encode 
non-topological dependencies, but you do it by simply read-locking 
whatever other independent device you want. So if an architecture has some 
system devices that have odd rules, that architecture can simply encode 
those rules in its suspend() functions.

It doesn't need to expose it to the device layer - because the device 
layer won't even care. The code will just automatically "do the right 
thing" without even having that notion of PM dependencies at any other 
level than the driver that knows about it.

No registration, no callbacks, no nothing.

> In my patchset the drivers didn't need to do all that stuff.  The only thing
> they needed, if they wanted their suspend/resume to be executed
> asynchronously, was to set the async_suspend flag.

In my patchset, the drivers don't need to either.

The _only_ thing that would do this is something like the USB layer. We're 
talking ten lines of code or so. And you get rid of all the PM 
dependencies and all the infrastructure - because the model is so simple 
that it doesn't need any.

(Well, except for the infrastructure to run things asynchronously, but 
that was kind of my point from the very beginning: we can just re-use all 
that existing async infrastructure. We already have that).

		Linus
