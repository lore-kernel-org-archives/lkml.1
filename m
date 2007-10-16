Return-Path: <linux-kernel-owner+w=401wt.eu-S1750962AbXJPSFq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750962AbXJPSFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 14:05:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964832AbXJPSEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 14:04:49 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51718 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754484AbXJPSEp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 14:04:45 -0400
Date: Tue, 16 Oct 2007 14:04:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Matthew Dharm <mdharm-kernel@one-eyed-alien.net>
cc: Greg KH <greg@kroah.com>, Dave Young <hidave.darkstar@gmail.com>,
       <bbpetkov@yahoo.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: Re: [linux-usb-devel] usb+sysfs: duplicate filename 'bInterfaceNumber'
In-Reply-To: <20071016163348.GB24082@one-eyed-alien.net>
Message-ID: <Pine.LNX.4.44L0.0710161355150.9662-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Oct 2007, Matthew Dharm wrote:

> I haven't looked at this code at all, but neither approach feels right to
> me.
> 
> How does this work at all?  Even if you load a driver later, wouldn't it
> call usb_set_interface(), which would call usb_create_sysfs_intf_files()
> and hit the same issue?

usb_set_interface() is smart enough to remove the old interface files
before creating new ones, since it expects them to exist already.  
Hence there's no problem in that scenario.

But usb_set_configuration doesn't expect there to be any pre-existing
interface files, because there isn't even an interface until the
registration is performed.

> Heck, why do both call usb_create_sysfs_intf_file()?  I would guess if
> you're *changing* the active configuration you would need to do that, but
> why in usb_set_interface() at all?

For a couple of reasons.  The "interface" attribute file contains the
iInterface string descriptor, and that file is present only if such a
descriptor exists.  Since different altsettings might not agree on
whether or not iInterface exists, the attribute has to be created anew
for each altsetting.  (Yes, we could let the file always be present and
just be blank if there is no descriptor.)

The most important reason has to do with the endpoint pseudo-devices.  
Different altsettings can have different endpoints, so those have to be
removed and re-created whenever the altsetting changes.

Alan Stern

