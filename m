Return-Path: <linux-kernel-owner+w=401wt.eu-S933774AbZJHVbs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933774AbZJHVbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 17:31:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933727AbZJHVbq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 17:31:46 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:44054 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932675AbZJHVbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 17:31:44 -0400
Date: Thu, 8 Oct 2009 17:31:07 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 4/5] usb_serial: Kill port mutex
In-Reply-To: <200910082240.36607.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0910081722340.2765-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 8 Oct 2009, Oliver Neukum wrote:

> Am Donnerstag, 8. Oktober 2009 22:06:10 schrieb Alan Stern:
> 
> >
> > On further thought, unthrottle should autoresume if the device is
> > open and autosuspended (but it shouldn't do anything if the device is
> > suspended).  After all, the reason for the autosuspend may have been
> > the lack of activity caused by the throttling.
> >
> > In practice this isn't likely to come up.  It would be surprising if
> > throttling lasted long enough to cause an autosuspend or if the core
> > decided to throttle while the device was autosuspended and hence idle.
> 
> So you say that throttle() should do an autopm_put?

The way you've coded the sierra and option drivers, it's not necessary.  
Those drivers do an autopm_get_async during submission and an
autopm_put_async after the completion of every output URB (and they
update the last_busy time in the completion of every input URB).  When
the driver is throttled no URBs will be submitted, so the usage count
will remain at 0 with no effort on the part of throttle().

For other drivers that use the simpler "autoresume on tty install,
autosuspend on tty cleanup" approach provided by usb-serial.c, the
throttle routines obviously don't need to worry about runtime PM.

Alan Stern

