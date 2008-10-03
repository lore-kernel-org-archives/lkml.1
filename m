Return-Path: <linux-kernel-owner+w=401wt.eu-S1753712AbYJCUzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753712AbYJCUzY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2008 16:55:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbYJCUzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Oct 2008 16:55:09 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59597 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751939AbYJCUzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2008 16:55:08 -0400
Date: Fri, 3 Oct 2008 16:55:06 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Dave Hansen <dave@sr71.net>, Thomas Gleixner <tglx@linutronix.de>
cc: gregkh <gregkh@suse.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>
Subject: Re: USB disconnects every 30 seconds (2.6.27-rc8)
In-Reply-To: <1223060886.7944.55.camel@nimitz>
Message-ID: <Pine.LNX.4.44L0.0810031608000.6462-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Oct 2008, Dave Hansen wrote:

> Yeah, it's a "7-port hub".  I assume that means that it's a pair of
> 4-porters plugged together somehow.  

It turns out that's exactly right.

> Unfortunately, the disconnects don't happen unless both my 7-port hub
> and the mouse are connected.  So, I've disconnected everything but those
> two things.  I also plugged the mouse into the single port on the right
> side of the T61 instead of the dock.
> 
> usbmon output: http://sr71.net/~dave/linux/1.mon.out

The usbmon trace answers a few questions.  And it raises one other.

> I've also attached appended the corresponding dmesg with annotations of
> what I did when.
> 
> plug in mouse:
> Oct  3 11:53:51 nimitz kernel: [ 8253.306987] usb 2-1: new low speed USB device using uhci_hcd and address 4
> Oct  3 11:53:51 nimitz kernel: [ 8253.420284] usb 2-1: configuration #1 chosen from 1 choice
> Oct  3 11:53:52 nimitz kernel: [ 8253.476663] input: Logitech USB Receiver as /devices/pci0000:00/0000:00:1a.1/usb2/2-1/2-1:1.0/input/input13
> Oct  3 11:53:52 nimitz kernel: [ 8253.493970] input: USB HID v1.10 Mouse [Logitech USB Receiver] on usb-0000:00:1a.1-1

That was more or less normal.

> plug in '7 port' hub:
> Oct  3 11:54:26 nimitz kernel: [ 8288.132987] usb 3-4.3: new high speed USB device using ehci_hcd and address 47
> Oct  3 11:54:26 nimitz kernel: [ 8288.188960] usb 3-4.3: configuration #1 chosen from 1 choice
> Oct  3 11:54:26 nimitz kernel: [ 8288.189371] hub 3-4.3:1.0: USB hub found
> Oct  3 11:54:26 nimitz kernel: [ 8288.189669] hub 3-4.3:1.0: 4 ports detected
> Oct  3 11:54:26 nimitz kernel: [ 8288.339300] usb 3-4.3.4: new high speed USB device using ehci_hcd and address 48
> Oct  3 11:54:26 nimitz kernel: [ 8288.395323] usb 3-4.3.4: configuration #1 chosen from 1 choice
> Oct  3 11:54:26 nimitz kernel: [ 8288.395611] hub 3-4.3.4:1.0: USB hub found
> Oct  3 11:54:26 nimitz kernel: [ 8288.395928] hub 3-4.3.4:1.0: 4 ports detected

As you can see, it is really two 4-port hubs: 3-4.3 and 3-4.3.4 
(which is connected to port 4 of 4.3).

> 'hub disconnects:' (I didn't do anything physically here)
> Oct  3 11:54:52 nimitz kernel: [ 8313.567487] usb 3-4.3: USB disconnect, address 47
> Oct  3 11:54:52 nimitz kernel: [ 8313.567492] usb 3-4.3.4: USB disconnect, address 48

Okay.  You didn't do anything, but _something_ did.  Probably a program
running on your computer that checks out all the usb devices every 30
seconds.  The usbmon trace clearly shows every suspended hub (which is
all but the one the mouse is plugged into) being woken up at 30-second
intervals.

Suspiciously enough, at the same time a vendor-specific request is sent 
to the mouse.  This, together with the fact that the disconnects occur 
only when the mouse is plugged in, strongly suggests that some program 
is trying to use the mouse and is doing something bad every 30 seconds.

Below is a patch you can apply; it may indicate which program is 
responsible.  In order to use it you'll have to do:

	echo 1 >/sys/module/usbcore/parameters/usbfs_snoop

before plugging in the mouse.

The next question is why the disconnects?  This is harder to explain.  
It's evident in the trace that there's something wrong with the timing 
code in your computer.  This shows up in several places, most clearly 
when the 7-port hub is resumed.

A resume works as follows: The computer sends a Clear-Port-Suspend
request to the hub's parent and then waits at least 25 milliseconds for 
the suspend to end.  In your trace, that delay lasts only 16 ms, which
wasn't long enough.  The suspend was still in progress, so the kernel 
decided something was wrong and disconnected the 7-port hub.  You can 
see it here (the second field on each line is a timestamp in 
microseconds):

f6194900 1490306395 S Co:3:002:0 s 23 01 0002 0003 0000 0
f6194900 1490306515 C Co:3:002:0 0 0
f6194900 1490322567 S Ci:3:002:0 s a3 00 0000 0003 0004 4 <
f6194900 1490322614 C Ci:3:002:0 0 4 = 07050000
f6194900 1490330540 S Co:3:002:0 s 23 01 0001 0003 0000 0
f6194900 1490330614 C Co:3:002:0 0 0

The first two lines show the Clear-Port-Suspend request being sent and
completing normally.  The third and fourth lines show a Get-Port-Status
request; the difference in times between the second and third lines is
1490322567 - 1490306515 = 16052 us, or about 16 ms.  But the source
code for that delay says:

	msleep(25);

so something is badly wrong.  And sure enough, the status value
07050000 indicates that the Suspend feature is still turned on.  The
last two lines show the hub being logically disconnected.

There are a number of other places in the trace where delays are
shorter than they should be.  This is out of my area of expertise, so 
I'm CC'ing Thomas Gleixner.  With luck he'll be able to help.

Thomas, the background for this problem is available here:

	http://marc.info/?l=linux-kernel&m=122305738430115&w=2

Alan Stern



Index: usb-2.6/drivers/usb/core/devio.c
===================================================================
--- usb-2.6.orig/drivers/usb/core/devio.c
+++ usb-2.6/drivers/usb/core/devio.c
@@ -625,6 +625,8 @@ static int usbdev_open(struct inode *ino
 	smp_wmb();
 	list_add_tail(&ps->list, &dev->filelist);
 	file->private_data = ps;
+	snoop(&dev->dev, "opened by process %d: %s\n", task_pid_nr(current),
+			current->comm);
  out:
 	if (ret) {
 		kfree(ps);

