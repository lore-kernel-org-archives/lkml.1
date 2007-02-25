Return-Path: <linux-kernel-owner+w=401wt.eu-S1752366AbXBYQvt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366AbXBYQvt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Feb 2007 11:51:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752369AbXBYQvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Feb 2007 11:51:49 -0500
Received: from firewall.rowland.harvard.edu ([140.247.233.35]:53874 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1752366AbXBYQvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Feb 2007 11:51:47 -0500
Date: Sun, 25 Feb 2007 11:51:46 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Kernel development list <linux-kernel@vger.kernel.org>
cc: Sarah Bailey <saharabeara@gmail.com>, <usb-hacking@svcs.cs.pdx.edu>,
       USB development list <linux-usb-devel@lists.sourceforge.net>
Subject: [linux-usb-devel] usbfs2: Why asynchronous I/O?
Message-ID: <Pine.LNX.4.44L0.0702251147500.25265-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This deserves to be discussed on LKML.

Alan Stern

---------- Forwarded message ----------
Date: Sun, 25 Feb 2007 00:57:55 -0800
From: Sarah Bailey <saharabeara@gmail.com>
To: David Brownell <david-b@pacbell.net>, greg@kroah.com
Cc: usb-hacking@svcs.cs.pdx.edu, linux-usb-devel@lists.sourceforge.net
Subject: [linux-usb-devel] usbfs2: Why asynchronous I/O?

I've been doing some research into how asynchronous I/O is implemented,
and I'm beginning to doubt the usefulness of implementing aio_read
and aio_write in usbfs2.  More detail on what I've learned can be found
at http://wiki.cs.pdx.edu/usb/asyncdebate.html

It was a surprise to me that aio_read(3) and aio_write(3) don't actually
end up calling aio_read and aio_write file operations.  Instead, GNU
libc spawns threads that call the blocking read and write file
operations.

I haven't seen any evidence that the kernel-side aio is substantially
more efficient than the GNU libc implementation, so it seems like it
would be better to leave the complexity in userspace.  I also doubt that
most userspace application writers know they aren't getting kernel-side
aio when they use aio_read(3) and aio_write(3).  Why implement something
that isn't going to be used?

There are few examples in the kernel where the aio API is implemented in
a truly asynchronous manner, and that leads me to wonder if the aio
system has been thoroughly tested.  The majority of aio_read and
aio_write file operations simply block and wait for their transactions
to complete.

The only "proper" async examples I could find were gadgetfs, NFS, and
block devices.  NFS and block devices only use aio when the O_DIRECT
flag is set, so that code may not be well tested.  I just found a bug in
gadgetfs that has been there for six months that means the code wasn't
tested for when io_submit is called in readv mode.

So, why do I want a non-blocking aio_read and aio_write file operation?
It's useful to have read and readv implemented automatically from
aio_read, but I see no substantial benefit to implementing aio_read in a
non-blocking way.

Sarah Bailey

