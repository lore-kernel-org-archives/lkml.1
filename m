Return-Path: <linux-kernel-owner+w=401wt.eu-S1755830AbZFKNs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755830AbZFKNs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 09:48:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751177AbZFKNsU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 09:48:20 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52831 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013AbZFKNsU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 09:48:20 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [patch update] Re: [linux-pm] Run-time PM idea (was: Re: [RFC][PATCH 0/2] PM: Rearrange core suspend code)
Date: Thu, 11 Jun 2009 15:48:33 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: Oliver Neukum <oliver@neukum.org>, linux-pm@lists.linux-foundation.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0906101942280.29717-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0906101942280.29717-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906111548.33751.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 June 2009, Alan Stern wrote:
> On Thu, 11 Jun 2009, Oliver Neukum wrote:
> 
> > Am Donnerstag, 11. Juni 2009 00:01:20 schrieb Rafael J. Wysocki:
> > > We have queued up resume requests for the device's parent, its parent etc.,
> > > the topmost one goes first.  The workqueue is singlethread, so
> > > pm_autoresume() is going to be run for all parents before the device
> > > itself, so if that were the only resume mechanism, it would be enough to
> > > check if the parent is RPM_ACTIVE.
> > 
> >             A (IDLE)
> >     /                                \
> > B (SUSPENDED)         C (SUSPENDED)
> > 
> > Suppose C is to be resumed. This means first in case of A the request
> > to suspend would be cancelled. Here you drop the locks:
> > 
> > +           && (dev->parent->power.runtime_status == RPM_IDLE
> > +             || dev->parent->power.runtime_status == RPM_SUSPENDING
> > +             || dev->parent->power.runtime_status == RPM_SUSPENDED)) {
> > +               spin_unlock_irqrestore(&dev->power.lock, flags);
> > +               spin_unlock_irqrestore(&dev->parent->power.lock, parent_flags);
> > +
> > +               /* We have to resume the parent first. */
> > +               pm_request_resume(dev->parent);
> > 
> > But after pm_request_resume() returns there's no means to make sure
> > nothing alters it back to RPM_SUSPENDED. The workqueue doesn't help
> > you because you've scheduled nothing by that time. The suspension will
> > work because C is still in RPM_SUSPENDED.
> 
> This is an example where usage counters come in handy.

Do you mean we can count suspend/resume requests for a device?

Rafael
