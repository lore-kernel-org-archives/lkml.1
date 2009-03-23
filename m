Return-Path: <linux-kernel-owner+w=401wt.eu-S1758676AbZCWWZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758676AbZCWWZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 18:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756824AbZCWWZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 18:25:08 -0400
Received: from cpsmtpm-eml104.kpnxchange.com ([195.121.3.8]:58095 "EHLO
	CPSMTPM-EML104.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755528AbZCWWZH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 18:25:07 -0400
From: Frans Pop <elendil@planet.nl>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] usb: avoid PM error messages during resume if a device was disconnected
Date: Mon, 23 Mar 2009 23:25:02 +0100
User-Agent: KMail/1.9.9
Cc: linux-usb@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-pm@lists.linux-foundation.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <Pine.LNX.4.44L0.0903231738300.3610-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0903231738300.3610-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903232325.04181.elendil@planet.nl>
X-OriginalArrivalTime: 23 Mar 2009 22:25:05.0263 (UTC) FILETIME=[3732D7F0:01C9AC06]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 March 2009, Alan Stern wrote:
> > diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
> > index d0a21a5..97ea69b 100644
> > --- a/drivers/usb/core/driver.c
> > +++ b/drivers/usb/core/driver.c
> > @@ -1727,6 +1727,10 @@ int usb_external_resume_device(struct usb_device *udev, pm_message_t msg)
> >     status = usb_resume_both(udev, msg);
> >  	udev->last_busy = jiffies;
> >  	usb_pm_unlock(udev);
> > +
> > +	if (status == -ENODEV)
> > +		return 0;
> > +
> >  	if (status == 0)
> >  		do_unbind_rebind(udev, DO_REBIND);
>
> Please include a short comment explaining the reason for this test
> (i.e., that there's no advantage in producing an error message since
> the regular disconnect messages will be generated shortly).

Will do if there are no other comments.

> Or do you think maybe it would be better to move this test up into the
> PM core?  After all, other subsystems will face the same issue.  I
> think that would be the best approach.  Yes?

I did look at that option, but implementing it in the USB subsystem seemed
more logical to me, for example as other subsystems possibly would want to
display an info message.

And is -ENODEV safe to ignore in all cases? Would there be other errors that
should be ignored too?

if Rafael would be happy with a generic test for -ENODEV, it could be done.
If not, maybe some other special error code would need to be used but then
you'd still need to test in the subsystem to set that error.
Disadvantage is also that it would make resume_device() and related PM
driver core functions quite a bit less clean than they currently are.

Implementing the test in USB was quite a bit simpler (for me at least ;-)

Thanks,
FJP
