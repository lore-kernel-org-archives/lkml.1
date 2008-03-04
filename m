Return-Path: <linux-kernel-owner+w=401wt.eu-S934307AbYCDXR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934307AbYCDXR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 18:17:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934608AbYCDXJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 18:09:42 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:44904 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934563AbYCDXJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 18:09:39 -0500
Date: Tue, 4 Mar 2008 16:09:37 -0700
From: Alex Chiang <achiang@hp.com>
To: Greg KH <gregkh@suse.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Matthew Wilcox <matthew@wil.cx>,
       Gary Hade <garyhade@us.ibm.com>, kaneshige.kenji@jp.fujitsu.com,
       warthog19@eaglescrag.net, kristen.c.accardi@intel.com,
       rick.jones2@hp.com, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 4/4] ACPI PCI slot detection driver
Message-ID: <20080304230937.GD3694@ldl.fc.hp.com>
Mail-Followup-To: Alex Chiang <achiang@hp.com>,
	Greg KH <gregkh@suse.de>, Jesse Barnes <jbarnes@virtuousgeek.org>,
	Matthew Wilcox <matthew@wil.cx>, Gary Hade <garyhade@us.ibm.com>,
	kaneshige.kenji@jp.fujitsu.com, warthog19@eaglescrag.net,
	kristen.c.accardi@intel.com, rick.jones2@hp.com,
	linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz,
	linux-acpi@vger.kernel.org
References: <20080229002341.GA21420@ldl.fc.hp.com> <20080301144307.GD24386@parisc-linux.org> <20080304054927.GA15566@suse.de> <200803041018.29035.jbarnes@virtuousgeek.org> <20080304193036.GB5534@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080304193036.GB5534@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH <gregkh@suse.de>:
> On Tue, Mar 04, 2008 at 10:18:28AM -0800, Jesse Barnes wrote:
> > On Monday, March 03, 2008 9:49 pm Greg KH wrote:
> > > On Sat, Mar 01, 2008 at 07:43:07AM -0700, Matthew Wilcox wrote:
> > > > On Fri, Feb 29, 2008 at 09:25:42PM -0800, Greg KH wrote:
> > > > > What is the guarantee that the names of these slots are correct and do
> > > > > not happen to be the same as the hotpluggable ones?
> > > >
> > > > That would be a bug -- and yes, bugs happen, and we have to deal with
> > > > them.
> > >
> > > My main concern is that BIOS vendors will not fix these bugs, as no
> > > other OS cares/does this kind of thing today.  The ammount of bad
> > > information out there might be quite large, and I think this was
> > > confirmed by some initial testing of IBM systems, right?
> > 
> > Yeah, but there's a flip side to this too:  if no one uses the data, no one 
> > will complain when it's wrong.  If Linux starts making it easy to see this 
> > stuff, there's a chance system vendors will start taking an extra 5 min. 
> > before shipment to make sure that the BIOS info is up to date...
> > 
> > OTOH, I'm not sure which is worse, bad data or no data.
> 
> bad data is worse.
> 
> And then there's the machines with duplicate slot names, how does this
> code handle PCI slots with that?  I think some of the IBM machines had
> non-hotplug slots named the same as the hotplug slots, right?

At one point, I had some code in there to stick the names of the
slots into a linked list and walk through it to try and detect
duplicate slot names, but after a few iterations, the cases I was
dealing with, it turned out to be easier to refcount them.

[my machines did not have colliding names between hp and non-hp
slots, it was more like seeing the same SxFy object appear
multiple times in the namespace and trying to create them
multiple times.]

It wasn't the IBM machine that was breaking; it was Fujitsu. They
were returning an error code (the numerical value 1023) when I
called the _SUN method on a slot object that existed in the ACPI
namespace but was not present (as reported by the _STA method).

By the time I got that error report, I'd already dropped the
duplicate name detection code, and was letting the kobject
infrastructure warn about duplicate names because for my test
cases, refcounting was a better solution.

[Kenji-san from Fujitsu seemed to be ok with the progress I'd
made at the time, he can speak up if he's changed his mind ;)]

But even that is not the error case you're describing, where
there is clear name collision of two physical slots in the
machine, one being hotplug, the other non-hotplug.

Maybe I would have to add some duplicate name detection code back
in there but...

> This stuff needs a _lot_ of testing on a lot of different
> machines, and a sane way to fall-back if there are errors to
> ensure that working machines don't break.
> 
> And then there's the issue with userspace programs only expecting
> hotplugable slots in the slots/ directory...

Yes -- totally agreed. And I'd like to see actual examples of
name collisions or userspace breakage to get a better idea of how
to handle real world problems rather than writing some crummy
code based on what my limited imagination can think of.

So how to get this test coverage? -mm? linux-next?

Thanks.

/ac

