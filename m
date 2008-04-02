Return-Path: <linux-kernel-owner+w=401wt.eu-S1757034AbYDBOWW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757034AbYDBOWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2008 10:22:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754677AbYDBOWO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Apr 2008 10:22:14 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:52324 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753812AbYDBOWN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2008 10:22:13 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: Novell
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC][PATCH] PM: Introduce new top level suspend and hibernation callbacks (rev. 6)
Date: Wed, 2 Apr 2008 16:22:03 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Nigel Cunningham <ncunningham@crca.org.au>,
       pm list <linux-pm@lists.linux-foundation.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Greg KH <greg@kroah.com>, Len Brown <lenb@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       David Brownell <david-b@pacbell.net>, Pavel Machek <pavel@ucw.cz>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
References: <Pine.LNX.4.44L0.0804021007060.14858-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0804021007060.14858-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200804021622.04461.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 2. April 2008 16:11:14 schrieb Alan Stern:
> > However, I'd like to add a recommendation that the _new_ "resume" callbacks
> > should only return errors in critical situations as the indication to the PM
> > core that something went _really_ wrong and the device in question is quite
> > surely unusable.
> 
> Agreed.  The most important aspect is that drivers should _not_ return
> an error if the device is working correctly.  We should fix the drivers 
> which make this mistake.

We need to do something about devices that don't want to be resumed.
There's code like this:


static int usb_resume(struct device *dev)
{
	struct usb_device	*udev;

	if (!is_usb_device(dev))	/* Ignore PM for interfaces */
		return 0;
	udev = to_usb_device(dev);

	/* If udev->skip_sys_resume is set then udev was already suspended
	 * when the system suspend started, so we don't want to resume
	 * udev during this system wakeup.  However a reset-resume counts
	 * as a wakeup event, so allow a reset-resume to occur if remote
	 * wakeup is enabled. */
	if (udev->skip_sys_resume) {
		if (!(udev->reset_resume && udev->do_remote_wakeup))
			return -EHOSTUNREACH;
	}
	return usb_external_resume_device(udev);
}

Do we want to keep this in the subsystems?

	Regards
		Oliver
