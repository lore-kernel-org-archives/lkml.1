Return-Path: <linux-kernel-owner+w=401wt.eu-S1753884AbXDLVXW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884AbXDLVXW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 17:23:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753898AbXDLVXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 17:23:22 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52845 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753884AbXDLVXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 17:23:21 -0400
Date: Thu, 12 Apr 2007 17:23:18 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: USB development list <linux-usb-devel@lists.sourceforge.net>
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: How should an exit routine wait for release() callbacks?
Message-ID: <Pine.LNX.4.44L0.0704121706040.2472-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a not-so-theoretical question.

I've got a module which registers a struct device.  (It represents a
virtual device, not a real one, but that doesn't matter.)  Obviously the
module's exit routine has to wait until the release() routine for that
device has been invoked -- if it returned too early then the release()
call would oops.

How should it wait?

The most straightforward approach is to use a struct completion, like 
this:

	static struct {
		struct device dev;
		...
	} my_dev;

	static DECLARE_COMPLETION(my_completion);

	static void my_release(struct device *dev)
	{
		complete(&my_completion);
	}

	static void __exit my_exit(void)
	{
		device_unregister(&my_dev.dev);
		wait_for_completion(&my_completion);
	}

The problem is that there is no guarantee a context switch won't take
place after my_release() has called complete() and before my_release()  
returns.  If that happens and my_exit() finishes running, then the module
will be unloaded and the next context switch back to finish off
my_release() will oops.

Other approaches have similar defects.  So how can this problem be solved?

Alan Stern

