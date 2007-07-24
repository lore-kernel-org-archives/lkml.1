Return-Path: <linux-kernel-owner+w=401wt.eu-S1756338AbXGXQHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756338AbXGXQHA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2007 12:07:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751287AbXGXQGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jul 2007 12:06:52 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59230 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750925AbXGXQGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2007 12:06:52 -0400
Date: Tue, 24 Jul 2007 12:06:50 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Oliver Neukum <oliver@neukum.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
Subject: Re: Towards eliminating the freezer
In-Reply-To: <200707241724.50330.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0707241155420.14025-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Jul 2007, Rafael J. Wysocki wrote:

> > As with Oliver's suggestion, this would create a locking order 
> > violation.  Drivers registering children (and thus acquiring 
> > dpm_list_mtx) will often already hold the parent's sem.  But 
> > device_suspend() needs to acquire device sems while holding 
> > dpm_list_mtx.
> 
> Hmm, but this is done already (ie. device_suspend() acquires device sems
> while holding dpm_list_mtx in the current code).
> 
> What I'm suggesting is not to let device_suspend() release dpm_list_mtx
> when it's finished.  The appended patch illustrates that I mean.

Oh, okay, I see what you mean.

I should have explained earlier that my proposal was meant to be in the 
context of a previous discussion, where I suggested that 
device_suspend() should go through a preliminary step of acquiring all 
the device semaphores.  This would have the beneficial effect of 
blocking all attempts at driver binding or unbinding while a suspend is 
underway.

Still, this isn't a bad approach.  Maybe the following algorithm could 
be used:

 get_more:
	For each device on dpm_list
		Acquire dev->sem
		Move dev from dpm_list to a temporary list
	Lock dpm_list_mutex
	If (!list_empty(dpm_list)) {
		Unlock dpm_list_mutex
		Goto get_more
	}

(The "For each" loop would have to be written carefully to allow for 
device removal.)

The total number of iterations should never be large.  At the end the 
PM core would own all the device semaphores and no more devices could 
be added.  Then it would be safe to call each device's suspend() 
method.

This will remove one of the barriers to eliminating the freezer.

Alan Stern

