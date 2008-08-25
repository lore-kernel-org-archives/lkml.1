Return-Path: <linux-kernel-owner+w=401wt.eu-S1755782AbYHYSj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782AbYHYSj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 14:39:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751144AbYHYSjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 14:39:21 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37073 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751173AbYHYSjU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 14:39:20 -0400
Date: Mon, 25 Aug 2008 14:39:19 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oneukum@suse.de>
cc: Pavel Machek <pavel@suse.cz>, <linux-pm@lists.linux-foundation.org>,
       <James.Bottomley@hansenpartnership.com>,
       Linux-pm mailing list <linux-pm@lists.osdl.org>,
       kernel list <linux-kernel@vger.kernel.org>, <teheo@novell.com>
Subject: Re: [linux-pm] Power management for SCSI
In-Reply-To: <200808251934.03569.oneukum@suse.de>
Message-ID: <Pine.LNX.4.44L0.0808251411420.6639-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Aug 2008, Oliver Neukum wrote:

> > possible then the link would probably want to have remote wakeup 
> > enabled before autosuspending, even if none of the devices currently 
> > attached actually wants to use it.
> 
> That supposes it doesn't matter in terms of power use. Is that true?

I don't know -- it would depend on the particular transport.  In any 
case, it's a decision the transport class can make.

> > So sd.c might, in theory, want to respond in two different ways to an 
> > autosuspend request:
> > 
> > 	(A) Drain the cache,
> > 
> > 	(B) Drain the cache and spin down the drive.
> 
> (C) Do nothing

Possibly.

> (D) Refuse (i.e. the user has opened a block device and used a vendor
> specific command)

Also possible, although I don't think your example is a good one since 
sd.c wouldn't be aware of vendor-specific commands.

> > How does it know which to do?  Ask the transport class for help 
> > choosing?
> 
> I see no other way.
> 
> > (A) would leave us in an awkward "half-suspended" state.  Is the device
> > suspended or not?  It is, in the sense that now the link can safely be
> > suspended.  But it isn't, in the sense that a system sleep would still
> > require the drive to be spun down.
> > 
> > It's kind of like the state we have following a PMSG_FREEZE --
> > quiescent but not suspended.  Somehow this extra state needs to be
> > incorporated into the autosuspend framework.
> 
> Why? Unless the device can be skipped for purposes of autosuspend and
> system sleep, isn't it active?

To my mind, if the driver has to do something special to prepare for
the link going down (such as draining the cache), then afterward the
device is in a special state -- not the same as the active state.  The
difference between the two states is that in one the link may be
autosuspended and in the other it mustn't.

I see the driver making the transition between these states in response 
to autosuspend and autoresume calls.

This means a driver such as sd.c has to respond in different sorts of
ways to various autosuspend scenarios, either doing a real power-down
or merely preparing for the link to go down.  The implication is that
we might want to send the driver two different autosuspend calls: One
to prepare for the link to go down (after, say, a couple of seconds of
idleness) and another to power-down the device (after, say, 15 minutes
of idleness).

Thus, there would be two "autosuspended" states: a shallow autosuspend
(cache is drained) and a deep autosuspend (disk is spun down).  Such an
approach could be made to work, even though it seems slightly
artificial.

Alan Stern

