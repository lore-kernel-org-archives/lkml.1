Return-Path: <linux-kernel-owner+w=401wt.eu-S1763672AbXK2RHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763672AbXK2RHB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 12:07:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756542AbXK2RGw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 12:06:52 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:35403 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1762177AbXK2RGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 12:06:51 -0500
Date: Thu, 29 Nov 2007 12:06:50 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Cornelia Huck <cornelia.huck@de.ibm.com>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] kobject: make sure kobj->ktype is set before kobject_init
In-Reply-To: <1196352280.3118.11.camel@lov.site>
Message-ID: <Pine.LNX.4.44L0.0711291202570.4712-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007, Kay Sievers wrote:

> > In fact, if we were designing the kobject API from scratch, I'd suggest 
> > making the ktype value an argument to kobject_init() so that it 
> > _couldn't_ be omitted.
> 
> Sounds fine, maybe we should also pass the name along, so it will be
> obvious what happens here:
>   int kobject_init(struct kobject *kobj, struct kobj_type *type, const char *fmt, ...)

I don't know...  Normally *_init() routines can't fail, but this could.  
Then things like device_register() would run into trouble: The caller 
wouldn't know whether a failure occurred before or after the 
kobject_init() call, so it wouldn't know what sort of cleanup action 
was needed: kfree() or device_put().

> Oh, if you want to rewind on error and have an initialized but still
> unregistered kobject, and just want to free the allocated name by
> calling kobject_cleanup() or kobject_put() you might not expect, that
> your whole object that embeds the kobject will be gone. Just something
> we need to document ...

When that sort of thing happens, the unwinding should be done by the   
code responsible for whole object.  For example, if device_add() fails
then the caller should go on to call device_put() rather than
kfree(dev).

That's how you would expect things to work in most cases.  There aren't
many bare kobjects in the kernel.

I agree that documenting this behavior would be good.

Alan Stern

