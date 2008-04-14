Return-Path: <linux-kernel-owner+w=401wt.eu-S1755755AbYDNAsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755AbYDNAsq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 20:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbYDNAsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 20:48:37 -0400
Received: from gate.crashing.org ([63.228.1.57]:59352 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752918AbYDNAsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 20:48:36 -0400
Subject: Re: [PATCH 1/3] PM: Introduce new top level suspend and
	hibernation callbacks (rev. 8)
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
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
In-Reply-To: <200804140231.32245.rjw@sisk.pl>
References: <200804040111.15255.rjw@sisk.pl>
	 <200804140108.05447.rjw@sisk.pl> <1208130390.6958.71.camel@pasglop>
	 <200804140231.32245.rjw@sisk.pl>
Content-Type: text/plain
Date: Mon, 14 Apr 2008 10:46:57 +1000
Message-Id: <1208134017.6958.94.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Mon, 2008-04-14 at 02:31 +0200, Rafael J. Wysocki wrote:
> 
> Well, in our discussions with Alan Stern ->prepare() turned out to be necessary
> for exactly one reason, preventing new children of the device from being
> registered (by threads concurrent wrt the suspend thread).  For this reason,
> it doesn't really seem a good idea to run it before the freezer (seemingly, it
> would be difficult to avoid situations in which the freezer would fail as a
> result of ->prepare()).

I'm opposed to designing something around the freezer since we know it
will ultimately go away.

If things like USB have issues with userland doing nasty things after
prepare(), then those things need to be fixed. The freezer will only
hide bugs and not even always or properly and not on all archs.

> It looks like you'd like to have a third callback executed before the freezer,
> but OTOH I don't see the reason not to use a notifier for such things.

That's just gratuituous complication imho. We can add callbacks every
week and no driver will every find out what to use and when.

prepare() has quite well defined and nice semantics if you ignore your
freezer trickery. It matches well with the needs of things like
request_firmware or the DRM, and possibly a few others, in addition to
matching well the need to block bus discovery.

If some drivers have issue because of what userland might do after
prepare(), then those drivers need to be fixed. We all know the freezer
is not a proper solution. It just hides problems and not always
correctly.

> I have imagined that while we have the freezer, the operations that need to
> be carried out with the user space available will be done using notifiers
> and the rest will be done by ->prepare() and ->suspend().  Next, when we
> finally drop the freezer, it will be possible to move the code from the
> notifiers into ->prepare() and drop the notifiers altogether.

Why do this two steps ? What is the point ?

> Since, as you said, there aren't too many drivers that will need anything like
> that, it seems perfectly doable to me.

Ben.


