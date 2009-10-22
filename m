Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbZJVW4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbZJVW4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 18:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753949AbZJVW4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 18:56:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56309 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750991AbZJVW4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 18:56:18 -0400
Date: Thu, 22 Oct 2009 15:55:30 -0700
From: Greg KH <gregkh@suse.de>
To: Haiyang Zhang <haiyangz@microsoft.com>
Cc: Hank Janssen <hjanssen@microsoft.com>,
       "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix null pointer error after vmbus loading
Message-ID: <20091022225530.GA11244@suse.de>
References: <1FB5E1D5CA062146B38059374562DF72180B39CA@TK5EX14MBXC126.redmond.corp.microsoft.com> <20091021224337.GA8550@suse.de> <1FB5E1D5CA062146B38059374562DF72180B3D51@TK5EX14MBXC126.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1FB5E1D5CA062146B38059374562DF72180B3D51@TK5EX14MBXC126.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 22, 2009 at 03:39:05PM +0000, Haiyang Zhang wrote:
> > >         /* Make sure we are not registered already */
> > > -       if (strlen(dev_name(&child_device_ctx->device)) != 0) {
> > > +       if (dev_name(&child_device_ctx->device) != NULL &&
> > > +           strlen(dev_name(&child_device_ctx->device)) != 0) {
> > 
> > Why would the device name ever be NULL?  Why would you need to check it
> > here?
> 
> In recently kernel versions, char bus_id[BUS_ID_SIZE] in struct device
> has been replaced by char* type kobj.name, which is NULL if name is
> not yet set.

Yes, but you should never care about this being NULL.

> The function vmbus_child_device_create() alloc the memory for struct
> device_context, which includes struct device as a member. All data are
> initialized to zero, so the device name ptr, aka kobj.name, is NULL at
> the beginning:
> 	child_device_ctx = kzalloc(sizeof(struct device_context), GFP_KERNEL);
> So, a NULL pointer checking is added to avoid null pointer dereference
> error if strlen() is called on the NULL name pointer. After we confirm
> the device isn't registered yet, we will set the name and register the
> device.

But this is not how you check to see if your device is registered at
all, you can not rely on the driver core to have the name set or not to
reflect the status of the device.  Devices have many stages in their
lifecycle, and the name reliably shows none of them.

Actually, why do you need to know this?  Shouldn't you always know the
state of your device, how can you get passed an unregistered device?

That is the real fix that needs to be done here.

thanks,

greg k-h
