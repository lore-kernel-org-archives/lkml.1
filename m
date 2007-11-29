Return-Path: <linux-kernel-owner+w=401wt.eu-S1763541AbXK2TGX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763541AbXK2TGX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 14:06:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763206AbXK2TFe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 14:05:34 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:37556 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1762972AbXK2TFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 14:05:32 -0500
Date: Thu, 29 Nov 2007 14:05:29 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Kay Sievers <kay.sievers@vrfy.org>
cc: Cornelia Huck <cornelia.huck@de.ibm.com>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Jonathan Corbet <corbet@lwn.net>,
       Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] kobject: make sure kobj->ktype is set before kobject_init
In-Reply-To: <1196361226.7903.6.camel@lov.site>
Message-ID: <Pine.LNX.4.44L0.0711291358200.4712-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2007, Kay Sievers wrote:

> Your error scenario confirmed my initial concern about suggesting
> kobject_put() to clean up an initialized kobject.
> 
> We should probably make kobject_cleanup() free only the resources taken
> by kobject_init(), and use kobject_cleanup() instead of kobject_put()?

My conclusion is different.  We should make kobject_init() not consume
any resources at all; just initialize various fields.  That way it
would be okay to call either kfree() or kobject_put() on an initialized
kobject.  And then when something like device_register() fails, the
caller would know the proper thing to do would be to call the put()  
routine, always.

Of course, once the name has been assigned, only kobject_put() should
be used.

There's another good reason for not assigning the name in
kobject_init(): Code that uses kobjects (like the driver core) doesn't
set the name until later.

Alan Stern

