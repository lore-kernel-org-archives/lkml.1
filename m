Return-Path: <linux-kernel-owner+w=401wt.eu-S1757582AbZDOFTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582AbZDOFTw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 01:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753188AbZDOFTJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 01:19:09 -0400
Received: from kroah.org ([198.145.64.141]:48734 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752594AbZDOFTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 01:19:07 -0400
Date: Tue, 14 Apr 2009 22:15:48 -0700
From: Greg KH <greg@kroah.com>
To: David Vrabel <david.vrabel@csr.com>
Cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: device_for_each_child() before device_add() doesn't work
Message-ID: <20090415051548.GC3462@kroah.com>
References: <49E4BFD0.2020302@csr.com> <20090414165905.GA25645@kroah.com> <49E4D2FF.8090906@csr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E4D2FF.8090906@csr.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 07:16:31PM +0100, David Vrabel wrote:
> Greg KH wrote:
> > On Tue, Apr 14, 2009 at 05:54:40PM +0100, David Vrabel wrote:
> >> Calling device_for_each_child() on a device that has yet to be added
> >> (with device_add()) used to work.  UWB subsystem currently tries to do this.
> >>
> >> Since "driver core: move klist_children into private structure"[1] this
> >> no longer works (an oops occurs in device_for_each_chid()).  Is it
> >> something that ought to work? Or should the UWB subsystem be changed to
> >> not do this?
> > 
> > Why would you call device_for_each_child() if you have never added it to
> > the bus?  How would you expect that to work, as there will never be any
> > children for it?
> 
> The children of a UWB radio controller (RC) are it's neighbors.  When 
> assigning a random DevAddr to an RC we need to check that the address is 
>   unique within the beacon group.  We use device_for_each_child() here 
> to check that the generated DevAddr is not used by any of its neighbors.

So the problem is for the first device being added, right?  Can't you
just have a flag for this?

> This address must be assigned during initialization and during normal 
> operation and in the past we didn't need to special case the address 
> assignment during initialization.

Does the patch below fix the problem for you?

thanks,

greg k-h

---------------

 drivers/base/core.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -1142,6 +1142,9 @@ int device_for_each_child(struct device 
 	struct device *child;
 	int error = 0;
 
+	if (!parent->p)
+		return 0;
+
 	klist_iter_init(&parent->p->klist_children, &i);
 	while ((child = next_device(&i)) && !error)
 		error = fn(child, data);
