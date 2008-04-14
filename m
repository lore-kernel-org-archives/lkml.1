Return-Path: <linux-kernel-owner+w=401wt.eu-S1758062AbYDNAbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062AbYDNAbU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2008 20:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbYDNAbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Apr 2008 20:31:10 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:38255 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753401AbYDNAbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2008 20:31:08 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: benh@kernel.crashing.org
Subject: Re: [PATCH 1/3] PM: Introduce new top level suspend and hibernation callbacks (rev. 8)
Date: Mon, 14 Apr 2008 02:31:30 +0200
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
References: <200804040111.15255.rjw@sisk.pl> <200804140108.05447.rjw@sisk.pl> <1208130390.6958.71.camel@pasglop>
In-Reply-To: <1208130390.6958.71.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804140231.32245.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 14 of April 2008, Benjamin Herrenschmidt wrote:
> 
> On Mon, 2008-04-14 at 01:08 +0200, Rafael J. Wysocki wrote:
> > 
> > Well, if we put ->prepare() before the freezer, what can it actually do?
> > Certainly nothing that will block any (user space) task, because the freezer
> > won't work after that.  So, all of the significant suspend work, like blocking
> > tasks using the device etc., will have to be done by ->suspend().  Will that be
> > convenient?  I'm not sure.  I'm not even sure that would be _doable_ at all.
> 
> Most of the actual suspending of requests queues etc... has to be done
> in suspend. Nothing changed here. I don't see why it would change.
> prepare() is a way to preallocate things when needed, cache things when
> needed, etc... and possibly interact user space. At least that how I see
> it.
> 
> It -is- acceptable to stop servicing user space after prepare() in some
> well defined cases such as the DRM, as long as in-kernel users aren't
> affected. But that's not necessarily what I have in mind. In the case us
> userspace for example, the idea here is to perform the migration of all
> the dirty data in the VRAM (that will be lost during suspend) out to
> main memory (or AGP memory). That doesn't mean necessarily that the DRM
> will stop servicing anything from there, it can still perform things. It
> might mean that user space would have to disable some accelerations that
> rely on dirty data in VRAM though until complete() is called.
> 
> > The point of view depends on what you think ->prepare() should be used for
> > and I'm sure you have some specific cases in mind.  However, are they generic
> > enough?
> 
> request_firmware() & caching the resulting firmware so that the driver
> can resume & start operating right away is an example (think about NFS
> over wireless here for example, or iSCSI). the DRM example above. In
> general, any driver that needs to interact with user space, perform
> large allocations, muck around with the VM, etc...
> 
> prepare() isn't intended to stop operations, but to
> preload/cache/prepare and have userspace available for drivers where
> this is needed. In some case, that might need the driver will continue
> operating in some degraded mode (for example, a multiqueue driver can
> degrade to a single queue with one pre-allocated request to avoid
> relying on allocations).
> 
> I would expect most simple drivers not to need it of course.

Well, in our discussions with Alan Stern ->prepare() turned out to be necessary
for exactly one reason, preventing new children of the device from being
registered (by threads concurrent wrt the suspend thread).  For this reason,
it doesn't really seem a good idea to run it before the freezer (seemingly, it
would be difficult to avoid situations in which the freezer would fail as a
result of ->prepare()).

It looks like you'd like to have a third callback executed before the freezer,
but OTOH I don't see the reason not to use a notifier for such things.

I have imagined that while we have the freezer, the operations that need to
be carried out with the user space available will be done using notifiers
and the rest will be done by ->prepare() and ->suspend().  Next, when we
finally drop the freezer, it will be possible to move the code from the
notifiers into ->prepare() and drop the notifiers altogether.

Since, as you said, there aren't too many drivers that will need anything like
that, it seems perfectly doable to me.

Thanks,
Rafael


> 
> Cheers,
> Ben.
> 
> 
> 
> 
> 



-- 
"Premature optimization is the root of all evil." - Donald Knuth
