Return-Path: <linux-kernel-owner+w=401wt.eu-S932240AbZLDQ5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240AbZLDQ5x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 11:57:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932206AbZLDQ5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 11:57:51 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:43449 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932150AbZLDQ5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 11:57:50 -0500
Date: Fri, 4 Dec 2009 11:57:57 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Greg KH <gregkh@suse.de>, <stable@kernel.org>,
       Rickard Bellini <rickard.bellini@ericsson.com>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       Torgny Johansson <torgny.johansson@ericsson.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Driver core: fix race in dev_driver_string
In-Reply-To: <200912041716.19329.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.0912041148150.3070-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Dec 2009, Oliver Neukum wrote:

> Am Freitag, 4. Dezember 2009 17:06:57 schrieb Alan Stern:
> > Oliver:
> > 
> > We don't have to worry about the device structure being deallocated 
> > while the routine is running.  If that happens it's a bug in the 
> > caller: improper refcounting.
> 
> That raises two points
> 
> 1. am I supposed to get a reference just so that I can use dev_err?

You're supposed to hold a reference before using dev at all.  If the 
only use you make of dev is to call dev_err(), then yes.

That's how refcounting is meant to work.

> 2. what happens if this is a soft disconnect and the device is reconnected?
> It seems to me that you'd print the wrong driver's name.

You mean the device is unbound from driver A and then bound to driver 
B, after which a thread running in driver A calls dev_err()?  Then yes, 
the "wrong" name will be printed.

This is part of the idea behind dev_err() and friends.  They print the 
name of the currently bound driver, not the name of the calling source 
file.  That's why, for example, the name "usb-storage" shows up in a 
message printed from within usbcore rather than "hub.c".

Alan Stern

