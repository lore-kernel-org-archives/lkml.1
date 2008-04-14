Return-Path: <linux-kernel-owner+w=401wt.eu-S1758978AbYDNBgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758978AbYDNBgk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 21:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753318AbYDNBga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 21:36:30 -0400
Received: from mail.crca.org.au ([67.207.131.56]:38990 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907AbYDNBg3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 21:36:29 -0400
X-Bogosity: Ham, spamicity=0.000000
Subject: Re: [PATCH 1/3] PM: Introduce new top level suspend and
	hibernation callbacks (rev. 8)
From: Nigel Cunningham <ncunningham@crca.org.au>
To: benh@kernel.crashing.org
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Greg KH <greg@kroah.com>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Alan Stern <stern@rowland.harvard.edu>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Oliver Neukum <oliver@neukum.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <1208134017.6958.94.camel@pasglop>
References: <200804040111.15255.rjw@sisk.pl>
	 <200804140108.05447.rjw@sisk.pl> <1208130390.6958.71.camel@pasglop>
	 <200804140231.32245.rjw@sisk.pl>  <1208134017.6958.94.camel@pasglop>
Content-Type: text/plain
Organization: Christian Reformed Churches of Australia
Date: Mon, 14 Apr 2008 11:37:14 +1000
Message-Id: <1208137034.29577.41.camel@nigel-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Mon, 2008-04-14 at 10:46 +1000, Benjamin Herrenschmidt wrote:
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

I don't think we should be assuming that the freezer will ultimately go
away. Aiming for that is one thing, assuming that we know what will
happen in the future is another. Frankly, I hope it doesn't go away,
because right now it's the only way I can see that we can capture as
close as possible to a complete image of memory for hibernation. I know
that some people don't care about that option, but others of us find it
extremely useful.

> If things like USB have issues with userland doing nasty things after
> prepare(), then those things need to be fixed. The freezer will only
> hide bugs and not even always or properly and not on all archs.

Having said the above, I also agree with this. I want to see things
being done properly too. I believe the freezer still has a place when it
comes to providing the environment in which we can capture a consistent
image for hibernation, but that shouldn't get in the way of kernel
drivers (or even well designed userspace drivers) doing their thing,
including reloading firmware post-atomic restore or post-suspend-to-ram.

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

Not a proper/complete solution to every problem.

> > I have imagined that while we have the freezer, the operations that need to
> > be carried out with the user space available will be done using notifiers
> > and the rest will be done by ->prepare() and ->suspend().  Next, when we
> > finally drop the freezer, it will be possible to move the code from the
> > notifiers into ->prepare() and drop the notifiers altogether.
> 
> Why do this two steps ? What is the point ?

1 step for pre-freezing prepare (load firmware you might want to restore
later, allocate memory) and 1 step for post-freezing prepare (stop
driver discovery)? I'm not sure that this is what Rafael has in mind,
though.

Nigel

