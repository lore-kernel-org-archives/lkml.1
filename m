Return-Path: <linux-kernel-owner+w=401wt.eu-S1758186AbYDNMLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758186AbYDNMLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 08:11:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753617AbYDNMLJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 08:11:09 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41273 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753571AbYDNMLH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 08:11:07 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: benh@kernel.crashing.org
Subject: Re: [PATCH 1/3] PM: Introduce new top level suspend and hibernation callbacks (rev. 8)
Date: Mon, 14 Apr 2008 14:11:17 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Greg KH <greg@kroah.com>, pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Oliver Neukum <oliver@neukum.org>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200804040111.15255.rjw@sisk.pl> <200804140309.22057.rjw@sisk.pl> <1208143380.6958.105.camel@pasglop>
In-Reply-To: <1208143380.6958.105.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804141411.19385.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 14 of April 2008, Benjamin Herrenschmidt wrote:
> 
> > To avoid breaking things (from the functional point of view) unnecessarily.
> > 
> > In short, I don't really see the difference between moving ->prepare() before
> > the freezer and droppig the freezer, which I'm not going to do right now.
> 
> I believe the use of prepare for things like request_firmware etc... is
> worth the effort of fixing the known breakage of not having the freezer
> while preventing insertion of new devices (mostly USB). In fact, it
> won't be such a big issue as the core should/will return an error from
> attempting to add the device in that case.

Okay, this was a shortcut.  [If we're discussing things when there's 2 am here,
I'm at a big disadvantage. :-)]

I think we agree that finally there should be no freezer and the things should
go like this:

(1) notifiers
(2) platform ->begin()
(3) ->prepare()
(4) ->suspend()
(5) platform ->prepare()
(6) ->suspend_noirq()
(7) platform ->enter()
(8) (we are in the sleep state)
(9) ->resume_noirq()
(10) platform ->finish()
(11) ->resume()
(12) ->complete()
(13) platform ->end()
(14) notifiers

Now, the question arises how to reach that status from what we have at the
moment and IMO there are two ways to go.

The first one is what I've implemented in the $subject patch:
(1) make ->prepare() be executed after the freezer with the current semantics
    (ie. you can assume the user space do be there when ->prepare() is running
    and use a notifier for things depending on that assumption)
(2) after we've dropped the freezer, change the semantics of ->prepare() (now
    you can assume that the user space is there)
(3) move code from notifiers to ->prepare() - this is entirely optional from
    the functionality point of view, the code can stay in the notifiers.
The advantage of this is that it doesn't require nontrivial modifications of
the core suspend/hibernation code.

The second one is a bit more complicated:
(1) make ->prepare() be executed before the freezer with the semantics like
    "you can assume that the user space is there while ->prepare() is running,
    but you are supposed to prevent new children of the device from being
    registered from that point on _and_ you have to make sure that freezable
    tasks will be able to freeze after ->prepare() has run" (but why on Earth a
    driver writer is now required to know what's a freezable task etc.?)
(2) after we've dropped the freezer, change the semantics of ->prepare() (now
    there are no freezable tasks to care for)
(3) remove the code necessary to make the freezer happy from ->prepare()
    (if any) - this need not be totally optional, IMO
Also, to implement this we'd have to change the core code (ie. add two
additional routines, device_prepare() and device_complete() to be called by it,
rework the error paths, move the platform ->begin()/->end() invocations
before/after the freezer etc.).  In the end, we'll end up with a more
complicated core in this case (we can simplify it afterwards, but that means
one patchset more).

[See how the semantics of ->prepare() changes in both cases, BTW.  We can't
avoid changing it in the future, we can only choose _how_ to change it.]

I prefer the first one quite a lot.

Thanks,
Rafael
