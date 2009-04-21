Return-Path: <linux-kernel-owner+w=401wt.eu-S1755175AbZDUOgm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175AbZDUOgm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 10:36:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752553AbZDUOga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 10:36:30 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58949 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751542AbZDUOg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 10:36:29 -0400
Date: Tue, 21 Apr 2009 10:36:28 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jamie Lokier <jamie@shareable.org>
cc: Ingo Molnar <mingo@elte.hu>, Arjan van de Ven <arjan@infradead.org>,
       David VomLehn <dvomlehn@cisco.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Wait for console to become available, v3.2
In-Reply-To: <20090421140533.GA6375@shareable.org>
Message-ID: <Pine.LNX.4.44L0.0904211026080.2981-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Apr 2009, Jamie Lokier wrote:

> Ingo Molnar wrote:
> > * Arjan van de Ven <arjan@infradead.org> wrote:
> > > But more importantly... USB *CANNOT* do this fundamental 
> > > operation. USB does not have the capability to know when you have 
> > > seen all devices that are connected. Devices just show up a random 
> > > amount of time after you turn the power on for the bus.... there's 
> > > no "and now we've seen all" operation.
> > 
> > Yes - and this is fundamentally true of any hotplug bus design.
> 
> It's not fundamental, for devices you know are plugged in at boot.
> All it takes is for the bus to support a synchronous "enumerate all"
> procedure.  That _could_ involve a timeout, but there are better ways.
> But not for USB.

Is that last sentence necessarily true?  I suppose it is true that a
USB device isn't obligated to make its presence on the bus known
immediately, but nevertheless, most of them do.  In theory we could add
code to the USB subsystem to detect when the hub driver has become idle
and therefore all devices that were initially plugged in have been
probed.

That probably would work for solving the console problem.  Storage 
devices present additional problems, however:

When usb-storage discovers a device, it generally delays a while before 
scanning it.  (The default delay is 5 seconds, but it is adjustable by 
a module parameter.)  And then when the scanning function is called, 
the SCSI subsystem turns it into an asynchronous request -- that's why 
the kernel log usually says "usb-storage: device scan complete" before 
the scan has in fact begun.

So I don't know about determining when all USB mass-storage devices 
have been detected, but USB serial devices should be practical.

If somebody would like to suggest a programming interface (a waitqueue 
perhaps?) by which the USB hub driver could send a notification when it 
becomes idle, I could implement it.

Alan Stern

