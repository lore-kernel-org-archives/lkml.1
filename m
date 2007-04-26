Return-Path: <linux-kernel-owner+w=401wt.eu-S1031278AbXDZP3y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031278AbXDZP3y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 11:29:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031283AbXDZP3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 11:29:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:46470 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1031278AbXDZP3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 11:29:53 -0400
Date: Thu, 26 Apr 2007 11:29:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Kernel development list <linux-kernel@vger.kernel.org>
Subject: Kthread question
Message-ID: <Pine.LNX.4.44L0.0704261114080.3552-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a question about how to use a kthread.

The usb-storage driver creates a new thread to do LUN scanning whenever a
newly-hotplugged device is detected.  This scanning involves waiting for
several seconds and then carrying out a potentially long-lasting series of
I/O operations.  So we don't want to use schedule_work(); instead we
create a new thread to do it.

Once the scanning thread's work is done, there's no reason for it to hang
around.  The driver's probe() method has long since exited, leaving nobody
to reap the thread.  Of course it could always just exit normally, without
checking kthread_should_stop(), but...

If the device is unplugged during that initial several-second-long delay 
period, we need to stop the scanning thread immediately.  The obvious 
answer is to use kthread_stop(), but that's not consistent with the 
thread's normal behavior of exiting without waiting for 
kthread_should_stop().

Another problem arises as well.  If the driver's remove() method doesn't
call kthread_stop() then it doesn't have any straightforward way to wait
for the thread to exit.  This leads to the possibility that the driver's
module could be unloaded while the scanning thread is still running.

Would the best approach be to set up a special-purpose struct completion?  
Then the thread could call complete_and_exit() and the remove() method
could wait for it safely.

Alan Stern

