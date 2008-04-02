Return-Path: <linux-kernel-owner+w=401wt.eu-S1756401AbYDBPNV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401AbYDBPNV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 11:13:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754973AbYDBPNN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 11:13:13 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50637 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754478AbYDBPNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 11:13:12 -0400
Date: Wed, 2 Apr 2008 11:13:11 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC][PATCH] PM: Introduce new top level suspend and hibernation
 callbacks (rev. 6)
In-Reply-To: <200804021622.04461.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0804021104190.6272-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Apr 2008, Oliver Neukum wrote:

> We need to do something about devices that don't want to be resumed.
> There's code like this:
> 
> 
> static int usb_resume(struct device *dev)
> {
> 	struct usb_device	*udev;
> 
> 	if (!is_usb_device(dev))	/* Ignore PM for interfaces */
> 		return 0;
> 	udev = to_usb_device(dev);
> 
> 	/* If udev->skip_sys_resume is set then udev was already suspended
> 	 * when the system suspend started, so we don't want to resume
> 	 * udev during this system wakeup.  However a reset-resume counts
> 	 * as a wakeup event, so allow a reset-resume to occur if remote
> 	 * wakeup is enabled. */
> 	if (udev->skip_sys_resume) {
> 		if (!(udev->reset_resume && udev->do_remote_wakeup))
> 			return -EHOSTUNREACH;
> 	}
> 	return usb_external_resume_device(udev);
> }
> 
> Do we want to keep this in the subsystems?

Basically yes.  Subsystems and drivers are allowed to keep devices
suspended if they were suspended before the system went to sleep.  
Remember, the purpose of the resume method is to let drivers know that
the system is now awake, not to force them to put their devices into a
high-power state.

But under these circumstances we don't want to return an error code,
since nothing really went wrong in the method.  So the -EHOSTUNREACH
should be changed to 0.

Alan Stern

