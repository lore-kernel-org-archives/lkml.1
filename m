Return-Path: <linux-kernel-owner+w=401wt.eu-S1759273AbZFJWBU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759273AbZFJWBU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 18:01:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756668AbZFJWBH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 18:01:07 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50183 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756302AbZFJWBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 18:01:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Oliver Neukum <oliver@neukum.org>
Subject: Re: [patch update] Re: [linux-pm] Run-time PM idea (was: Re: [RFC][PATCH 0/2] PM: Rearrange core suspend code)
Date: Thu, 11 Jun 2009 00:01:20 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc8-rjw; KDE/4.2.4; x86_64; ; )
Cc: Alan Stern <stern@rowland.harvard.edu>,
       linux-pm@lists.linux-foundation.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0906082233490.19072-100000@netrider.rowland.org> <200906102127.57136.rjw@sisk.pl> <200906102338.35183.oliver@neukum.org>
In-Reply-To: <200906102338.35183.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906110001.20718.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 10 June 2009, Oliver Neukum wrote:
> Am Mittwoch, 10. Juni 2009 21:27:56 schrieb Rafael J. Wysocki:
> > > What happens if the parent's parent is also suspended? It seems to me
> > > that you must code this recursively.
> >
> > Hmm, I thought I did.
> >
> > [Looks]
> >
> > pm_request_resume(dev) will call pm_request_resume(dev->parent), if
> > necessary, and that will call pm_request_resume(dev->parent->parent) and so
> > on.  Each of them will queue a work item and the one for the topmost parent
> > will be queued first.  So, the resume requests for all parents will be
> > executed before the one for the device, due to the fact that the workqueue
> > is singlethread.
> 
> Sneaky, I overlooked that.
> 
> > Well, there is a bug related to it, namely pm_autosuspend() may change the
> > status to RPM_SUSPENDED after pm_request_resume() has changed it to
> > RPM_WAKE, that needs fixing.
> 
> Ok, maybe this is related. You recurse if the parent isn't in RPM_ACTIVE.
> But that is not enough. You must ensure that all the nodes higher up stay
> in RPM_ACTIVE. It seems to me that you must go up until you find an
> active node (or the root) and put it a blocked state.

If you're referring to pm_autoresume(), then this again is tricky.

We have queued up resume requests for the device's parent, its parent etc.,
the topmost one goes first.  The workqueue is singlethread, so pm_autoresume()
is going to be run for all parents before the device itself, so if that were the
only resume mechanism, it would be enough to check if the parent is RPM_ACTIVE.
*However*, there also is pm_resume_sync(), which can take the device directly
from RPM_SUSPENDED to RPM_RESUMING and that may be done in parallel with our
pm_autoresume().  That's why I put the wait_for_completion() in there.

Best,
Rafael
