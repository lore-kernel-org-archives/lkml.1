Return-Path: <linux-kernel-owner+w=401wt.eu-S1030915AbXDPTiz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030915AbXDPTiz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 15:38:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030916AbXDPTiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 15:38:55 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56478 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030915AbXDPTiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 15:38:54 -0400
Date: Mon, 16 Apr 2007 15:38:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, Greg K-H <greg@kroah.com>,
       Tejun Heo <htejun@gmail.com>, Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [Patch -mm 0/3] RFC: module unloading vs. release function
In-Reply-To: <d120d5000704161130j7ae89a1eyef89e015f0a3e97f@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.0704161530160.2685-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Apr 2007, Dmitry Torokhov wrote:

> On 4/16/07, Cornelia Huck <cornelia.huck@de.ibm.com> wrote:
> > Hi,
> >
> > based on the discussion in "How should an exit routine wait for
> > release() callbacks?", I've cooked up some patches that make module
> > unload wait until the last reference for a kobject has been dropped.
> > This should plug the "release function in already deleted module" race;
> > however, if the last kobject_put() from the module containing the
> > release function is not in the module's exit function, there's still a
> > small window (not sure if and how to plug this).
> 
> Unfortunately all this "wait for refcount in module's exit" schemas
> lead to the following deadlock:
> 
>         rmmod my_module < /path/to/some/file/incrementing/my/refcount

(Note that this problem will be a lot harder to provoke once Tejun's
changes to sysfs are in place.  But it will still be possible, unless we 
make similar changes to all the other filesystems as well.)

There are three possible approaches to this problem:

     1. Ignore it, as we do now.  If someone actually tries running your
	example above, an oops will result when the kobject's release
	method is called after my_module has been unloaded from memory.

     2. Do what Cornelia suggested, and allow the example to deadlock.

     3. Change the module code so that rmmod can return _before_ the
	module is actually unloaded from memory (but after the module's
	exit routine has completed).  This will lead to more problems.
	For example, what if someone tries to modprobe my_module back
	again before it has finished unloading?

My feeling is that either a deadlock or more complications with modprobe 
would be preferable to an oops.  Your opinion may differ.

(Also, doing this might be a good way to expose a lot of hidden 
refcounting bugs.  They will become very obvious when rmmod hangs.)

Alan Stern

