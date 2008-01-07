Return-Path: <linux-kernel-owner+w=401wt.eu-S1757643AbYAGQuP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757643AbYAGQuP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2008 11:50:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755633AbYAGQuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jan 2008 11:50:00 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37320 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755519AbYAGQt7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2008 11:49:59 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] PM: Acquire device locks on suspend
Date: Mon, 7 Jan 2008 17:51:59 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Johannes Berg <johannes@sipsolutions.net>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, Len Brown <lenb@kernel.org>,
       Ingo Molnar <mingo@elte.hu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0801071039330.4609-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0801071039330.4609-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801071752.00138.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 7 of January 2008, Alan Stern wrote:
> Let's try to summarize the main issues here:
> 
>      1. We want the PM core to lock all devices during suspend and
> 	hibernation.  This implies that registration and unregistration
> 	at such times can't work, because they need to lock the
> 	device sem in order to make probe and remove method calls.
> 
>      2. Registration calls can be failed, with an error message in the
> 	system log.  However unregistration calls cannot fail.  They
> 	_can_ block until the system resumes, but if the unregistration
> 	call was made from within a suspend or resume method it will
> 	deadlock.  This seems inescapable, but at least we should print
> 	an error in the log so the offending driver can be identified.
> 
>      3. In response to 2, the PM core should have a special routine for
> 	unregistering devices while a suspend is in progress.  Rafael
> 	proposed that the core should unlock the device to permit the
> 	call to go through.  This seems dangerous to me; I would prefer
> 	to leave the locks in place and defer the unregistration until
> 	after the system is back up and the locks have all been 
> 	dropped.  This would avoid all sorts of locking, deadlock, and 
> 	mutual exclusion problems.
> 
> (As a side note: destroy_suspended_device() has a rather limited
> interface anyway, since it can handle only devices that were created by
> create_device().)
> 
>      4. Rafael pointed out that unregistration can occur concurrently
> 	with system suspend.  When this happens we can end up trying to
> 	suspend a device which has already been through 
> 	bus_remove_device(), because it hasn't yet been removed from 
> 	the dpm_active list.  He proposes we make unregistration block
> 	system suspend, just as registration does.
> 
> I don't see 4 as a real problem.  Starting an unregistration before
> the suspend and finishing it afterward should be okay.  Once a device
> has gone through bus_remove_device() it hasn't got a suspend method any
> more, so trying to suspend it won't do anything at all -- the tests in
> suspend_device() will all fail.  Conversely, if bus_remove_device()  
> hasn't run yet then we would end up calling the driver's suspend method
> before the device_del() call returns.  As Johannes pointed out, this is
> a normal race that would exist anyway.
> 
> On the other hand, having unregistration block system suspend wouldn't 
> actually be wrong.  I simply don't think it is necessary.  But note 
> that making the two mutually exclusive would complicate Rafael's 
> synchronous approach for destroy_suspended_device().
> 
>      5. All the discussion about pm_sleep_rwsem and so on is 
> 	implementation details.  Once we have settled on the correct
> 	approach for 1-4, the implementation should be relatively easy.

Please see the patch at: http://lkml.org/lkml/2008/1/6/298 .  It represents my
current idea about how to do that.

Thanks,
Rafael
