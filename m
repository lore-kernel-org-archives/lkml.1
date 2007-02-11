Return-Path: <linux-kernel-owner+w=401wt.eu-S1750860AbXBKOix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750860AbXBKOix (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 09:38:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750849AbXBKOix
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 09:38:53 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37280 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698AbXBKOiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 09:38:52 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH] Re: NAK new drivers without proper power management?
Date: Sun, 11 Feb 2007 15:36:19 +0100
User-Agent: KMail/1.9.5
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
       Daniel Barkalow <barkalow@iabervon.org>, nigel@nigel.suspend2.net,
       Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>, Pavel Machek <pavel@ucw.cz>,
       pm list <linux-pm@lists.osdl.org>
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no> <200702111450.49736.rjw@sisk.pl> <20070211135708.GC1868@1wt.eu>
In-Reply-To: <20070211135708.GC1868@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702111536.20871.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 11 February 2007 14:57, Willy Tarreau wrote:
> On Sun, Feb 11, 2007 at 02:50:48PM +0100, Rafael J. Wysocki wrote:
> > On Sunday, 11 February 2007 14:37, Willy Tarreau wrote:
> > > On Sun, Feb 11, 2007 at 01:19:57PM +0000, Matthew Garrett wrote:
> > > > On Sun, Feb 11, 2007 at 02:09:43PM +0100, Willy Tarreau wrote:
> > > > 
> > > > > Then change the PCI layer to do the basic PM only for known compatible
> > > > > drivers, and modify only the known-compatible drivers to mark them
> > > > > explicitly compatible. IMHO, it generally is a bad idea to require that
> > > > > any driver explicitly states what it *does not* support. It's the reason
> > > > > why users encounter problem on new features with old drivers. For instance,
> > > > > do you know if the old ISA NE2000 driver breaks suspend ? I don't know,
> > > > > but I would at least expect it not to support it by default. It's best
> > > > > to announce what *is* supported and consider everything unimplemented
> > > > > otherwise explicitly stated.
> > > > 
> > > > This ignores the reality of the situation, which is that many drivers 
> > > > support suspend and resume despite the lack of any explicit 
> > > > implementation. Changing things so they're flagged as broken when 
> > > > they're not would be a regression.
> > > 
> > > Those which are identified as OK should be flagged OK. Only those for
> > > which we have no idea should be flagged broken.
> > 
> > I think we don't need to flag the drivers identified as OK.  Let's flag only
> > the suspicious ones.
> > 
> > Whatever we finally come up with, I'd like to avoid modifying drivers that are
> > known good.
> 
> I understand your concerns, but the problem is not *current* drivers, but
> what will happen to *new* drivers. If we make it implicit that a driver
> is compatible, then new drivers will be promoted as good even if nothing
> has been done for this.

The problem is it was made implicit long ago.  The design is "optimistic", so
to speak, and I think we have the following choices:

1) Change the design to make the kernel refuse to suspend if there are any
drivers not explicitly flagged as "suspend/resume-safe".  [This looks like a
lot of work to me, but it is generally doable provided that someone has enough
time to do it.  Unfortunately it has to be done in one shot for all of the
known good drivers to avoid user-observable regressions.]

2) Require the authors of new drivers to _either_ ensure that their drivers
will be suspend/resume-safe (and I mean both STR and STD here), _or_ explicitly
flag the drivers as "suspend/resume-unsafe", for example by impelenting
.suspend() routines returning -ENOSYS.  [The existing drivers can be modified
to follow this convention gradually.]

Now IMO 1) has some disadvantages:
- Potential for introducing some regressions (eg. if we omit a known-good
driver)
- Necessity to review a lot of drivers simultaneously
- Problem what to do with drivers that work for some people and don't work
for the others (ie. if we don't flag them as known good, we will break the
setups in which they work)

The advantage of 1), however, is that we can differentiate drivers that are
safe only with respect to the suspend to disk from those that are safe with
respect to the suspend to RAM too (there are some).

I'd prefer 2), because it's simpler to make happen.

Greetings,
Rafael
