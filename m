Return-Path: <linux-kernel-owner+w=401wt.eu-S937518AbYCSVcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937518AbYCSVcp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 17:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763033AbYCSUFM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 16:05:12 -0400
Received: from gate.crashing.org ([63.228.1.57]:57726 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763010AbYCSUFJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 16:05:09 -0400
Subject: Re: [RFC][PATCH 1/3] PM: Introduce new top level suspend and
	hibernation callbacks
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>
In-Reply-To: <Pine.LNX.4.44L0.0803182233370.10154-100000@netrider.rowland.org>
References: <Pine.LNX.4.44L0.0803182233370.10154-100000@netrider.rowland.org>
Content-Type: text/plain
Date: Wed, 19 Mar 2008 14:49:02 +1100
Message-Id: <1205898542.26869.268.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan !

On Tue, 2008-03-18 at 22:44 -0400, Alan Stern wrote:

> In order to make this work, you would have to prevent new children from
> being registered starting from the time just after prepare() returns,
> rather than from the time just before suspend() is called.  Nothing is
> wrong with that, but it requires a redesign of the new flags.  (It's 
> worth mentioning that drivers will want to have a flag that gets set 
> just _before_ prepare() -- just _after_ is too late.)

I think that's the most logical semantic to expose to drivers. We've
been needing prepare() for a lot of things in the past.

The main one is that you know user space is still up & running (not only
it's not been frozen, but even in the absence of a freezer, you know
storage hasn't been stopped yet, etc...). So if your driver has tight
interaction with userspace that requires clean handling of suspend, it
can be done at that point (X with DRI is an example that could make good
use of that).

The whole GFP_KERNEL allocation is another, though we could make
GFP_KERNEL become silently GFP_NOIO when entering the suspend loop, it's
still useful for the driver to know that we are -about- to start a
suspend operation, if any significant storage is needed (for backup for
example, or if it needs to cache a firmware to ensure proper resume),
it's the right time to do it.

Now, about the issue vs. device insertion, I believe it's solvable
unless I missed something:

So it's the responsibility of bus drivers such as khubd to stop
inserting new devices in the tree from prepare(). There we agree. The
problem is about -enforcing- it in the core right ? That is, making
device addition actually fail if a bogus bus driver tries to insert a
device at the wrong time.

This does indeed have an issue of when precisely do we stick that flag
(that tells the core to fail) since before calling the bus driver
prepare() is too early and after is potentially too late.

Now, I think this is not really a problem if prepare() calls the drivers
from top to bottom: In that case, we would set the flag after the bus
driver returns from prepare(). That means that there is a small window
where a bogus bus driver can still insert a new child, but I think that
isn't an issue, specifically because we walk from parent to child:

If the sequence is:

	1- prepare() returns
	2- we set the "no new addition" flag
	3- we start walking children

You see that the only place the where the "bad" bus driver can still
attempt to insert without failing is between 1 and 2. However, that
happens before we start prepare()'ing the children. So that means that
anything that has successfully been added -will- have it's prepare()
called, and thus becomes a normal part of the suspend/resume process.
Any attempt at adding after 2 would fail, thus we are sure the children
list is sane here (won't get new things right in between. Removal might
still happen I suppose, we'll have to look into this closely).

> In the other direction, it ought to be okay to allow new children to 
> be registered during resume().  There's no need to wait for complete().

There are pros and cons here. A lot of drivers may rely on
request_firmware() and such, and will possibly deadlock or timeout if
called during resume before storage is available (i've seen that
happening with today scheme). It might be better to be safe here, but I
agree, it's generally less of a concern.

> > Next, he wants the number of noirq callbacks to be reduced.
> 
> I agree.  For example, there isn't much point in having prepare() and
> complete() entries for noirq.

Exactly. I think we really only need noirq variants of suspend and
resume, and possibly freeze and thaw (I'm not 100% of the later as I
haven't studied the problem of hibernate closely, but I can see a usage
scenario that might make sense).

> > Both of the above things make sense, so I'll rework the patch (or maybe even
> > all three patches) to implement them and we'll see how they will look like.

Cheers,
Ben.


