Return-Path: <linux-kernel-owner+w=401wt.eu-S1759277AbYAFWb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759277AbYAFWb5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 17:31:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755523AbYAFWbr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 17:31:47 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:33835 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758913AbYAFWbq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 17:31:46 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] PM: Acquire device locks on suspend
Date: Sun, 6 Jan 2008 23:34:05 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       Len Brown <lenb@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0801061712480.19222-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0801061712480.19222-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801062334.05982.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 6 of January 2008, Alan Stern wrote:
> On Sun, 6 Jan 2008, Rafael J. Wysocki wrote:
> 
> > > Still, shouldn't we fail the removal of the device apart from giving the
> > > warning?
> > 
> > Actually, having thought about it a bit more, I don't see the point in
> > preventing the removal of the device from the list in device_pm_remove() if
> > we allow all of the operations in device_del() preceding it to be performed.
> 
> That's not the issue.  We _don't_ allow all of the operations in 
> device_del() preceding the call to device_pm_remove().  In particular, 
> the call to the device's driver's remove method will deadlock because 
> device_release_driver() always has to acquire dev->sem.
> 
> > Shouldn't we just take pm_sleep_rwsem in device_del() upfront and block on that
> > if locked?
> 
> No -- the whole idea here is to print an error message in the system
> log if a driver's resume method tries to call device_del().  Deadlock 
> is unavoidable in this case, but at least we'll know which driver is 
> guilty.

Still, if we do that, we won't need to acquire dev->sem in device_pm_remove()
any more.  Apart from this, by acqiring pm_sleep_rwsem for reading in
device_del() we can prevent a suspend from starting while the device is being
removed.

Consider, for example, the scenario possible with the $subject patch:
- device_del() starts and notices pm_sleep_rwsem unlocked, so the warning is
  not printed
- it proceeds and everything before device_pm_remove() succeeds
- now, device_suspend() is called and locks dev->sem
- device_del() calls device_pm_remove() and blocks on that with the device
  partialy removed
I think we should prevent this from happening.

Rafael
