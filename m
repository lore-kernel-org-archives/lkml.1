Return-Path: <linux-kernel-owner+w=401wt.eu-S1751633AbXCJTTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbXCJTTp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2007 14:19:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751654AbXCJTTp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Mar 2007 14:19:45 -0500
Received: from pool-151-204-250-243.bstnma.east.verizon.net ([151.204.250.243]:50097
	"EHLO patience.localdomain" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751573AbXCJTTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2007 14:19:44 -0500
X-Greylist: delayed 991 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Mar 2007 14:19:43 EST
Date: Sat, 10 Mar 2007 14:19:29 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@patience.localdomain
To: Oliver Neukum <oneukum@suse.de>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Maneesh Soni <maneesh@in.ibm.com>, <gregkh@suse.de>,
       <linux-kernel@vger.kernel.org>
Subject: Re: refcounting drivers' data structures used in sysfs buffers
In-Reply-To: <200703092148.08910.oneukum@suse.de>
Message-ID: <Pine.LNX.4.44L0.0703101405330.7545-100000@patience.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Mar 2007, Oliver Neukum wrote:

> Am Freitag, 9. März 2007 21:08 schrieb Alan Stern:
> > After some more thought, I basically agree with what Oliver wrote
> > originally.  sysfs_dirent is indeed the logical place to store the kref
> > pointer.  However it needs to be used during open and release, not during
> 
> OK.
> 
> > read, write, and poll.  Another point, which Oliver didn't think of, is
> > that the kref pointer needs to be passed to the driver as an argument in
> > the show() and store() method calls.
> 
> Why? What's wrong with simply calling kref_get/put?

It's the same old problem: the race between unbind and sysfs I/O.  What
good does holding a reference to the private data structure do if the
show/store method gets called after the driver has been unbound from the
device?  dev_get_drvdata() will no longer provide a valid pointer to the
private data, so the method will have no way to access it.  Hence the
method needs another argument.

(BTW, the sysfs core would actually need more than a kref.  It would also 
need a pointer to a release routine -- the kref contains only the atomic 
counter.  The more you think about it, the more complicated this approach 
becomes.)

> > Finally, there's added complexity in each driver which wants to use the 
> > new facility.  The module_exit routine will need to be smart enough to 
> > block until all the private data structures have been released.  
> > usb-storage does something like that now; it's kind of ugly (although it 
> > could be improved if appropriate support were added to the core kernel).
> 
> If we up the module count for every bound device, all device attributes
> should be gone before we ever get that far.

Not quite right.  However, since every open sysfs file holds a module
reference, if the driver's module_exit has been called then there can be
no open sysfs files, hence no private data still pinned.  Thus this isn't
a problem at all.


But never mind all the above.  I'm going to post another message on this
thread in which I argue that Oliver's original approach was a good one and
should not have been reverted.  The specific problem identified by Hugh
Dickins can be fixed in the way Dmitry first suggested, by doing the real
operation from a workqueue routine.

Alan Stern

