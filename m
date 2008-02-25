Return-Path: <linux-kernel-owner+w=401wt.eu-S1757583AbYBYUBD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583AbYBYUBD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 15:01:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756043AbYBYUAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 15:00:53 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:43016 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755900AbYBYUAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 15:00:52 -0500
Date: Mon, 25 Feb 2008 15:00:51 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       David Brownell <david-b@pacbell.net>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Bugs in MMC [was: [Bug 10030] Suspend doesn't work when SD card
 is inserted]
In-Reply-To: <20080225193134.104b386d@mjolnir.drzeus.cx>
Message-ID: <Pine.LNX.4.44L0.0802251451050.5536-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Feb 2008, Pierre Ossman wrote:

> > What do you think of the patch attached to comment #40 in the Bugzilla 
> > entry?
> > 
> 
> Looks ok. As long as those two synchronization points are guaranteed,
> then I'm happy.

Maybe a better approach would be to leave the workqueue unfreezable,
and keep cancel_delayed_work_sync() in mmc_suspend_host().  It would
then be necessary to add a test to verify, if there is a card attached,
that the card is indeed suspended.  After all, it's possible that the
cancel_delayed_work_sync() ended up waiting for a job already running
on the workqueue to register a new card!  (The same would be true even 
with flush_scheduled_work.)

Also, as a bit of defensive programming, it might be a good idea to add
a "suspended" flag to the mmc_host structure.  If mmc_rescan() sees
that the flag is set then it should return immediately.  This would
protect against host drivers that aren't careful to disable detect
IRQs before calling mmc_suspend_host().

Alan Stern

