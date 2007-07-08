Return-Path: <linux-kernel-owner+w=401wt.eu-S1755206AbXGHOba@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755206AbXGHOba (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2007 10:31:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752677AbXGHObX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jul 2007 10:31:23 -0400
Received: from netrider.rowland.org ([192.131.102.5]:2931 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752666AbXGHObW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2007 10:31:22 -0400
Date: Sun, 8 Jul 2007 10:31:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Tejun Heo <htejun@gmail.com>
cc: Cornelia Huck <cornelia.huck@de.ibm.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Sysfs and suicidal attributes
Message-ID: <Pine.LNX.4.44L0.0707081015430.5323-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun:

You remember the problem we faced with "suicidal" sysfs attributes and 
the device_schedule_callback() routine that fixes it?

Well, it turns out that this approach may confict with suspend/resume
processing.  In brief, it's not a good idea to unregister devices while
a suspend is in progress, but on the other hand it's not a good idea to
block keventd waiting until the suspend is over.

There are some ways around this such as using a different workqueue, 
one that could safely be blocked during the suspend.  But I had another 
thought.

I haven't paid much attention to your sysfs updates.  Is it still true
that calls to show/store methods are mutually exclusive with attribute
unregistration?  Assuming the answer is Yes, would it be possible to
bypass that mutual exclusion in certain explicit cases?  Here's what I
have in mind:

	The user writes to an attribute file.

	The sysfs core calls the attribute's store method.

	The method tells the sysfs core to pretend that the call
	temporarily doesn't exist, or has completed, or something
	like that.

	The method safely unregisters the attribute file, with no
	mutual exclusion problems and no deadlock.  Of course, the
	unregistration will still block until all _other_ method
	calls for this attribute are complete.

	The method tells the sysfs core to stop pretending and
	go back to its normal state.

	The method returns, and the sysfs core takes whatever actions
	are needed to fully release the attribute file.

The idea is that there could be a way to allow unregistration while a 
method is still running, if the method specifically requests it.  If we 
could do this then device_schedule_callback() would be unnecessary.

What do you think?

Alan Stern

