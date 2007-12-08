Return-Path: <linux-kernel-owner+w=401wt.eu-S1755510AbXLHUr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510AbXLHUr7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 15:47:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754981AbXLHUrp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 15:47:45 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:63253 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357AbXLHUro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 15:47:44 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 216.15.117.105
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/0xBI+raG4/B6ZZC1OGsjV
Message-ID: <475B02E9.7000007@reed.com>
Date: Sat, 08 Dec 2007 15:47:37 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.5) Gecko/20070727 Fedora/2.0.0.5-2.fc7 Thunderbird/2.0.0.5 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
References: <475879CD.9080006@reed.com> <p733auekcly.fsf@bingen.suse.de> <20071207160439.71b7f46a@the-village.bc.nu> <475AEF8E.5040906@reed.com> <20071208195035.GA22497@one.firstfloor.org>
In-Reply-To: <20071208195035.GA22497@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am going to do a test on another "unused" port.

However, I realized as I was thinking about this.  0x80 is the 
"diagnostic device" port.  It is not an "unused" port.

Normally, Linux would support a device like the diagnostic device by 
providing a character device, called /dev/post-diagnosis  (for the 
power-on test diagnostic).  That device would reserve port 80 for its 
use, and the driver could be loaded if there was such a device.

Now one possibility is that my laptop contains a diagnostic code device 
that stores all the out's to port 80 (documented only to the designers, 
and kept "secret").   That device may need "clearing" periodically, 
which is perhaps done by the SMM, which is turned off when I go into 
ACPI-on state.  Or maybe it is designed to be cleared only when the 
system boots at the beginning of the BIOS.  What happens when (as 
happens in hwclock's polling of the RTC) thousands of in/out*_p calls 
are made very fast?  Well, perhaps it is not cleared quickly enough, and 
hangs the bus.

The point here is that Linux is NOT using a defined-to-be "unused" 
port.  It IS using the "diagnostic" port, and talking to a diagnostic 
device that *is* used, and may be present.

Just doesn't seem clean to me.

So I'd suggest 2 actions:

1) figure out a better implementation of _p that is "safe" and doesn't 
use questionable heuristics.  udelay seems reasonable because it doesn't 
drive contention on the busses on SMP machines, but perhaps someone has 
a better idea.

2) Start a background task with the maintainers of drivers to clean up 
their code regarding these short delays for slow devices (note that it's 
never because the *bus* is slow, but because the *device* is slow.)  
Perhaps this could be helped by "deprecating" the _p calls and 
suggesting an alternative that requires the coder to be precise about 
what the delay is for, and how long it is supposed to be, perhaps on a 
per-machine basis.


