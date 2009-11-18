Return-Path: <linux-kernel-owner+w=401wt.eu-S1758224AbZKRST6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224AbZKRST6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Nov 2009 13:19:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758203AbZKRST5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Nov 2009 13:19:57 -0500
Received: from kroah.org ([198.145.64.141]:56607 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758195AbZKRST4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Nov 2009 13:19:56 -0500
Date: Wed, 18 Nov 2009 10:16:37 -0800
From: Greg KH <greg@kroah.com>
To: Russ Dill <russ.dill@gmail.com>
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
       Jiri Kosina <jkosina@suse.cz>, linux-usb@vger.kernel.org
Subject: Re: [PATCH] Close usb_find_interface race
Message-ID: <20091118181637.GA2330@kroah.com>
References: <20091118153947.GA32440@kroah.com>
 <1258567334-14846-1-git-send-email-Russ.Dill@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1258567334-14846-1-git-send-email-Russ.Dill@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 18, 2009 at 11:02:13AM -0700, Russ Dill wrote:
> USB drivers that create character devices call usb_register_dev in their
> probe function. This associates the usb_interface device with that minor
> number and creates the character device and announces it to the world.
> However, the driver's probe function is called before the new
> usb_interface is added to the driver's klist_devices.
> 
> This is a problem because userspace will respond to the character device
> creation announcement by opening the character device. The driver's open
> function will the call usb_find_interface to find the usb_interface
> associated with that minor number. usb_find_interface will walk the
> driver's list of devices and find the usb_interface with the matching
> minor number.
> 
> Because the announcement happens before the usb_interface is added to the
> driver's klist_devices, a race condition exists. A straightforward fix
> is to walk the list of devices on usb_bus_type instead since the device
> is added to that list before the announcement occurs.
> 
> bus_find_device calls get_device to bump the reference count on the found
> device. It is arguable that the reference count should be dropped by the
> caller of usb_find_interface instead of usb_find_interface, however,
> the current users of usb_find_interface do not expect this.
> 
> Signed-off-by: Russ Dill <Russ.Dill@gmail.com>
> ---
>  drivers/usb/core/usb.c |   30 +++++++++++-------------------
>  1 files changed, 11 insertions(+), 19 deletions(-)

Looks good, thanks for finding and fixing this.  I'll queue it up.

greg k-h
