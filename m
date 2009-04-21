Return-Path: <linux-kernel-owner+w=401wt.eu-S1758979AbZDUTKd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758979AbZDUTKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 15:10:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757745AbZDUTJ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 15:09:56 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:59451 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756209AbZDUTJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 15:09:54 -0400
Date: Tue, 21 Apr 2009 15:09:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: David VomLehn <dvomlehn@cisco.com>
cc: Jamie Lokier <jamie@shareable.org>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Wait for console to become available, v3.2
In-Reply-To: <20090421165214.GB8251@cuplxvomd02.corp.sa.net>
Message-ID: <Pine.LNX.4.44L0.0904211457150.3986-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Apr 2009, David VomLehn wrote:

> > If somebody would like to suggest a programming interface (a waitqueue 
> > perhaps?) by which the USB hub driver could send a notification when it 
> > becomes idle, I could implement it.
> 
> I actually started the USB console stuff with exactly this approach, but
> switched to the approach that's out there. A minor drawback, which is
> probably obvious, is that you actually wait for some interval without
> getting anything to do before you think things are idle.

Sorry, I don't understand.  You've got a waitqueue, and you wake up to
try again every time a console device is registered.  So if the console
device does exist, you'll find it as quickly as possible.  There's a
problem only when no console device is ever registered.  In that case
you want to stop waiting when all the devices present at boot time have
been probed (as opposed to waiting for the user to plug in a USB serial
device, for example).

So then the problem becomes: How do you tell when all the USB devices 
present at boot time have been probed?  That's exactly what this new 
interface is supposed to tell you.

>  But a bigger
> drawback is that you lose the ability to chose appropriate intervals for
> different classes of devices.

Why do you need to choose any intervals at all?  Just keep waiting
until you know there's no point waiting any longer.  If you stop 
waiting before then, you run the risk of missing a device that could 
have worked.

> So far, there appear to be three possible USB boot devices: consoles, network
> devices, and boot devices.

Is that last supposed to be "disk drives containing root filesystems"?

> A system may not have all of these and so may not
> need to wait as long as a system with all of them. One of my goals is to
> preserve as much of the reduction in boot time as possible, even on systems
> that use USB devices that may or may not be plugged in.

Let's take console devices as an example.  If one is present then you
do want to wait until it is detected, instead of booting as quickly as
possible, right?  Which implies that if one isn't present, you want to 
wait until you _know_ that it's not present.  Which means waiting all 
all the devices present during boot have been probed.

This approach should work fine with USB consoles and network devices;
it's not so easy to implement for USB disk drives.  So let's not worry 
about them.

Now the only drawback I can see would crop up if some device takes a
very long time to probe (perhaps because of errors and retries).  If
there's no other console device, it could slow down the boot procedure
quite a lot.  But there doesn't appear to be any logical alternative,
given your goals as stated above.

Alan Stern

