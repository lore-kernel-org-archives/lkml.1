Return-Path: <linux-kernel-owner+w=401wt.eu-S1761940AbYDBVJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761940AbYDBVJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 17:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760340AbYDBVJB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 17:09:01 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:43779 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756255AbYDBVJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 17:09:00 -0400
Date: Wed, 2 Apr 2008 17:08:59 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David Brownell <david-b@pacbell.net>
cc: Mark Lord <lkml@rtr.ca>, <pavel@suse.cz>, <oliver@neukum.org>,
       <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
       <jikos@suse.cz>, <gregkh@suse.de>, <akpm@linux-foundation.org>
Subject: Re: [PATCH] usb ehci_iaa_watchdog fix
In-Reply-To: <200804021342.33102.david-b@pacbell.net>
Message-ID: <Pine.LNX.4.44L0.0804021658170.2107-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2008, David Brownell wrote:

> > It fixes the cause rather than the symptom.
> 
> I'm not sure I'd agree with that.

Really?  The logic seemed clear enough to me.

     1. Evidently the ehci_iaa_watchdog routine was getting called at a 
	time when the host controller wasn't running -- which had to
	have been after it was suspended.

     2. But ehci_bus_suspend() calls end_unlink_async(), which turns
	off the IAA watchdog timer.

     3. Hence the timer must have been restarted later on while 
	ehci_bus_suspend() was still running.  The call to ehci_work() 
	appeared to be the only place that could have happened.

     4. Thus moving the end_unlink_async() call to after ehci_work()
	(or just to be doubly safe, after ehci_halt() and the change
	to HC_STATE_SUSPENDED) should take care of all pending QH
	unlinks and leave none of them unfinished.

Strictly speaking, it would be best to move the del_timer_sync() calls
to after ehci_lock is released.  But it doesn't really matter if the
timer routines get invoked after the controller is suspended.

Alan Stern

