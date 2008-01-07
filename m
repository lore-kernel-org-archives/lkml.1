Return-Path: <linux-kernel-owner+w=401wt.eu-S1756773AbYAGQQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773AbYAGQQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 11:16:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754708AbYAGQQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 11:16:34 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:55863 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753789AbYAGQQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 11:16:33 -0500
Date: Mon, 7 Jan 2008 11:16:32 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Johannes Berg <johannes@sipsolutions.net>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH] PM: Acquire device locks on suspend
In-Reply-To: <200801062347.49935.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.44L0.0801071039330.4609-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's try to summarize the main issues here:

     1. We want the PM core to lock all devices during suspend and
	hibernation.  This implies that registration and unregistration
	at such times can't work, because they need to lock the
	device sem in order to make probe and remove method calls.

     2. Registration calls can be failed, with an error message in the
	system log.  However unregistration calls cannot fail.  They
	_can_ block until the system resumes, but if the unregistration
	call was made from within a suspend or resume method it will
	deadlock.  This seems inescapable, but at least we should print
	an error in the log so the offending driver can be identified.

     3. In response to 2, the PM core should have a special routine for
	unregistering devices while a suspend is in progress.  Rafael
	proposed that the core should unlock the device to permit the
	call to go through.  This seems dangerous to me; I would prefer
	to leave the locks in place and defer the unregistration until
	after the system is back up and the locks have all been 
	dropped.  This would avoid all sorts of locking, deadlock, and 
	mutual exclusion problems.

(As a side note: destroy_suspended_device() has a rather limited
interface anyway, since it can handle only devices that were created by
create_device().)

     4. Rafael pointed out that unregistration can occur concurrently
	with system suspend.  When this happens we can end up trying to
	suspend a device which has already been through 
	bus_remove_device(), because it hasn't yet been removed from 
	the dpm_active list.  He proposes we make unregistration block
	system suspend, just as registration does.

I don't see 4 as a real problem.  Starting an unregistration before
the suspend and finishing it afterward should be okay.  Once a device
has gone through bus_remove_device() it hasn't got a suspend method any
more, so trying to suspend it won't do anything at all -- the tests in
suspend_device() will all fail.  Conversely, if bus_remove_device()  
hasn't run yet then we would end up calling the driver's suspend method
before the device_del() call returns.  As Johannes pointed out, this is
a normal race that would exist anyway.

On the other hand, having unregistration block system suspend wouldn't 
actually be wrong.  I simply don't think it is necessary.  But note 
that making the two mutually exclusive would complicate Rafael's 
synchronous approach for destroy_suspended_device().

     5. All the discussion about pm_sleep_rwsem and so on is 
	implementation details.  Once we have settled on the correct
	approach for 1-4, the implementation should be relatively easy.

Alan Stern

