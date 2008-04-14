Return-Path: <linux-kernel-owner+w=401wt.eu-S1759208AbYDNBJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208AbYDNBJF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 21:09:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754595AbYDNBIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 21:08:53 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38420 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754557AbYDNBIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 21:08:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: benh@kernel.crashing.org
Subject: Re: [PATCH 1/3] PM: Introduce new top level suspend and hibernation callbacks (rev. 8)
Date: Mon, 14 Apr 2008 03:09:20 +0200
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
References: <200804040111.15255.rjw@sisk.pl> <200804140231.32245.rjw@sisk.pl> <1208134017.6958.94.camel@pasglop>
In-Reply-To: <1208134017.6958.94.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804140309.22057.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 14 of April 2008, Benjamin Herrenschmidt wrote:
> 
> On Mon, 2008-04-14 at 02:31 +0200, Rafael J. Wysocki wrote:
> > 
> > Well, in our discussions with Alan Stern ->prepare() turned out to be necessary
> > for exactly one reason, preventing new children of the device from being
> > registered (by threads concurrent wrt the suspend thread).  For this reason,
> > it doesn't really seem a good idea to run it before the freezer (seemingly, it
> > would be difficult to avoid situations in which the freezer would fail as a
> > result of ->prepare()).
> 
> I'm opposed to designing something around the freezer since we know it
> will ultimately go away.

Well, I think the freezer is not anything we can remove overnight.  It's there
and does something our users rely on, whether we like it or not.  That means
we have to provide the users with other things to rely on and _then_
remove the freezer, not the other way around.  Hence, we need to design
around it, otherwise the users will suffer.
 
> If things like USB have issues with userland doing nasty things after
> prepare(), then those things need to be fixed. The freezer will only
> hide bugs and not even always or properly and not on all archs.
> 
> > It looks like you'd like to have a third callback executed before the freezer,
> > but OTOH I don't see the reason not to use a notifier for such things.
> 
> That's just gratuituous complication imho. We can add callbacks every
> week and no driver will every find out what to use and when.
> 
> prepare() has quite well defined and nice semantics if you ignore your
> freezer trickery. It matches well with the needs of things like
> request_firmware or the DRM, and possibly a few others, in addition to
> matching well the need to block bus discovery.
> 
> If some drivers have issue because of what userland might do after
> prepare(), then those drivers need to be fixed. We all know the freezer
> is not a proper solution. It just hides problems and not always
> correctly.
> 
> > I have imagined that while we have the freezer, the operations that need to
> > be carried out with the user space available will be done using notifiers
> > and the rest will be done by ->prepare() and ->suspend().  Next, when we
> > finally drop the freezer, it will be possible to move the code from the
> > notifiers into ->prepare() and drop the notifiers altogether.
> 
> Why do this two steps ? What is the point ?

To avoid breaking things (from the functional point of view) unnecessarily.

In short, I don't really see the difference between moving ->prepare() before
the freezer and droppig the freezer, which I'm not going to do right now.

Thanks,
Rafael
