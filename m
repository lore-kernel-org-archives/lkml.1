Return-Path: <linux-kernel-owner+w=401wt.eu-S1762483AbXE1RVy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762483AbXE1RVy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 13:21:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756988AbXE1RVr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 13:21:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60542 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751330AbXE1RVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 13:21:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH -mm 1/3] PM: Hibernation and suspend notifiers
Date: Mon, 28 May 2007 19:26:59 +0200
User-Agent: KMail/1.9.5
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Nigel Cunningham <nigel@nigel.suspend2.net>,
       Alan Stern <stern@rowland.harvard.edu>,
       Oliver Neukum <oliver@neukum.org>
References: <200705272229.21263.rjw@sisk.pl> <200705272230.04478.rjw@sisk.pl> <20070528131243.GP18807@elf.ucw.cz>
In-Reply-To: <20070528131243.GP18807@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705281927.00277.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 28 May 2007 15:12, Pavel Machek wrote:
> Hi!
> 
> > Make it possible to register hibernation and suspend notifiers, so that
> > subsystems can perform hibernation-related or suspend-related operations that
> > should not be carried out by device drivers' .suspend() and
> > .resume() routines.
> 
> I believe it adds _way_ too many notifiers.
> 
> > +PM_PRE_FREEZE		The system is going to hibernate or suspend, tasks will
> > +			be frozen immediately
> 
> 80 columns.

OK

> Anyway yes, this one is needed. 
> 
> > +PM_POST_THAW		Tasks have just been thawed after a resume or restore
> > +			from a hibernation image
> 
> Symetrical with the previous one, useful for freeing firmware images, ok.
> 
> > +PM_HIBERNATION_PREPARE	The system is preparing for hibernation.  Tasks have
> > +			been frozen, memory is going to be freed and devices
> > +			are going to be suspended.
> 
> What is this one good for?

Allocating memory before the hibernation, mainly.  Anything done after freezing
tasks.

> > +PM_SNAPSHOT_FAILED	The creation of hibernation image has failed.  Tasks
> > +			will be thawed immediately.
> 
> Does this one need to be different from POST_THAW?

Do you mean POST_RESTORE?  Well, maybe not.  Yesterday I thought it would be
for a specific reason, but now I can't recall what it was. :-(

> I do not see the need for the other chains. Notice that we do not
> _want_ to have too many of them, because changing anything in the
> hibernation will become impossible with 10 chains having intimate
> details of suspend sequence.

I think the two suspend-specific might be handy.

What about:

PM_PRE_FREEZE
PM_HIBERNATION_PREPARE
PM_POST_HIBERNATION (handling failed snapshots too)
PM_POST_THAW

plus PM_RESTORE_PREPARE for the restore and

PM_SUSPEND_PREPARE
PM_POST_SUSPEND (handling failed suspends too)

for the suspend code path?

Rafael
