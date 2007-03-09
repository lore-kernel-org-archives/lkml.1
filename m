Return-Path: <linux-kernel-owner+w=401wt.eu-S1767470AbXCIUIe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767470AbXCIUIe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2007 15:08:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767471AbXCIUIe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Mar 2007 15:08:34 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:44597 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1767470AbXCIUId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2007 15:08:33 -0500
Date: Fri, 9 Mar 2007 15:08:32 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Oliver Neukum <oneukum@suse.de>, Maneesh Soni <maneesh@in.ibm.com>,
       <gregkh@suse.de>, <linux-kernel@vger.kernel.org>
Subject: Re: refcounting drivers' data structures used in sysfs buffers
In-Reply-To: <d120d5000703090934r45c39f74l2a51eda986b1f07b@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0703091451140.5094-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2007, Alan Stern wrote:

> Oliver, your idea won't work either.  Think about what would happen if 
> someone did
> 
> 	rmmod driver_module </sys/devices/.../attribute_file
> 
> The rmmod process would never actually read the attribute, so until it 
> exited the private data structure would have a positive refcount.  But 
> rmmod can't exit until the driver has been unloaded from memory, and it 
> can't be unloaded while its data structure is still allocated.  Thus we 
> would end up with deadlock; rmmod would hang forever.

I take this back.  Redirecting stdin to the attribute file would increase 
the module's refcount and cause rmmod to exit immediately with an error.

After some more thought, I basically agree with what Oliver wrote
originally.  sysfs_dirent is indeed the logical place to store the kref
pointer.  However it needs to be used during open and release, not during
read, write, and poll.  Another point, which Oliver didn't think of, is
that the kref pointer needs to be passed to the driver as an argument in
the show() and store() method calls.

Implementing this will be difficult.  One possibility is to change the 
definition of sysfs_ops, adding the new struct kref * argument to the 
prototypes.  This will involve changing _lots_ of source files, adding an 
unused argument to many functions, which isn't attractive.

The other possibility is to test at runtime whether the kref pointer is 
NULL, and if it is, don't pass it.  This would work, but it isn't 
type-safe.

Finally, there's added complexity in each driver which wants to use the 
new facility.  The module_exit routine will need to be smart enough to 
block until all the private data structures have been released.  
usb-storage does something like that now; it's kind of ugly (although it 
could be improved if appropriate support were added to the core kernel).

Alan Stern

