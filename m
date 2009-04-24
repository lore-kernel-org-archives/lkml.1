Return-Path: <linux-kernel-owner+w=401wt.eu-S1759192AbZDXWU4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759192AbZDXWU4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 18:20:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756098AbZDXWUo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 18:20:44 -0400
Received: from mail2.shareable.org ([80.68.89.115]:40815 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755602AbZDXWUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 18:20:43 -0400
Date: Fri, 24 Apr 2009 23:19:51 +0100
From: Jamie Lokier <jamie@shareable.org>
To: David VomLehn <dvomlehn@cisco.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux USB Mailing List <linux-usb@vger.kernel.org>,
       Linux Embedded Mailing List <linux-embedded@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Wait for console to become available, v3.2
Message-ID: <20090424221951.GC18260@shareable.org>
References: <20090424003555.GA31173@cuplxvomd02.corp.sa.net> <Pine.LNX.4.44L0.0904241502440.4531-100000@iolanthe.rowland.org> <20090424213238.GA5973@cuplxvomd02.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090424213238.GA5973@cuplxvomd02.corp.sa.net>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David VomLehn wrote:
> > This looks like a good plan and not hard to implement.  It even should 
> > be possible to fit USB disk drives into the scheme.
> 
> That would definitely rock. 

How about this, perhaps in the generic device model:

  1. Whenever a device's existence is detected by its parent bus,
     add the device id to a pool of "potential devices worth waiting for".

  2. Whenever a device is registered, remove that device id from the pool.

  3. Whenever a device is itself a bus, or has subdevices or
     attributes to be discovered, it triggers step 1 for all devices
     found by enumeration (or in the case of USB, whatever you have to
     wait for).  Then the bus can declare itself initialised.
 
  4. The top-level enumeration behaves as though there was a root bus,
     onto which the real buses like PCI etc. are attached as in step 3.

  5. Waiting for console / boot device / userspace waiting for other
     mount points all check this pool for device ids of matching type.

In this, the pool serves the same role as Alan Stern's global counter,
the difference being you can wait for particular types of device when
you need to, and this is more explicit about how a hierarchy is handled.

Device ids in this pool are simply "category" values for what the
device is relevant to - and a waitqueue.  If a PCI device is a serial
port, then goes into category "serial port", because it's relevant if
serial console is requested on the boot command line.

When waiting for a newly powered USB bus to settle, you may get
notification of all devices on it, but you might not know enough about
each device until the individual drivers start fetching descriptors.
Then you can either make every device go temporarily into the pool,
much as if it were a little bus itself, until it has detailed
information about what type of device it is.  Or you can wait until
all those devices have fetched descriptors before the USB bus declares
that its enumeration is complete and removes its own id.

-- Jamie
