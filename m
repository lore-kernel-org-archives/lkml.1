Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbXLGOur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbXLGOur (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 09:50:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751188AbXLGOuj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 09:50:39 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:62581 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbXLGOui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 09:50:38 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 142.131.239.110
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19G4Sjsi0wDeu5hta7q/Qjc
Message-ID: <47595DB2.5080302@reed.com>
Date: Fri, 07 Dec 2007 09:50:26 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.5) Gecko/20070727 Fedora/2.0.0.5-2.fc7 Thunderbird/2.0.0.5 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64
 with MCP51 laptops
References: <475879CD.9080006@reed.com> <p733auekcly.fsf@bingen.suse.de>
In-Reply-To: <p733auekcly.fsf@bingen.suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Changing the delay instruction sequence from the outb to short jumps
>> might be the safe thing.
> I don't think that makes sense to do on anything modern. The trouble
> is that the jumps will effectively execute near "infinitely fast" on any
> modern CPU compared to the bus. But the delay really needs to be something
> that is about IO port speed.
This all presumes that you need any delay at all.  From back in the 
early days (when I was writing DOS and BIOS code on 80286 class 
machines) the /only/ reason this was a problem was using really slow 
acting, non-buffered chips compared to the processor clock (8259?).  If 
you think about it, if there is a sequence such as outb->device, 
inb<-device, the only reason for a delay would be that the device failed 
to process the out command, /and/ the device had no "done" flag.  The 
other "slow" problem would be an out->device, out->device at a rate 
higher than the device could handle because it had a one-level buffer 
that ignored input that came too fast after the previous, but didn't 
stall the bus to protect the device.  Modern machines just are not 
designed that way - a few of the early PC compatibles were.

My machine in question, for example, needs no waiting within CMOS_READs 
at all.   And I doubt any other chip/device needs waiting that isn't 
already provided by the bus. the i/o to port 80 is very, very odd in 
this context.  Actually, modern machines have potentially more serious 
problems with i/o ops to non-existent addresses, which may cause real 
bus wierdness.

So that's why I suggested the short-jump answer - it fixes the problem 
on the ancient machines, but doesn't do anything on the modern ones, 
where there should be no problem.

One patch that makes immediate sense is to use the "virtualization" 
hooks for the CMOS_READ/WRITE ops that is there in the 32-bit code to 
allow substitution of a workable sequence for the RTC, which is where I 
experience the problem on my machine.  This doesn't fix any lurking 
issues with the _p APIs, since they are not virtualized.  I'd suggest 
the safest possible route that would fix my machine would be either an 
early_quirk, a boot parameter, or both that would then control the 
virtualization hook logic.

That patch would fix my machine's current issues, and would not harm any 
machines that need the 0x80 delay.

But I know it leaves a lurking issue for another day - for all the other 
inb_p and outb_p code in the kernel drivers.  A grep suggests that they 
are used only in somewhat less modern drivers - perhaps for legacy 
machines.  I don't think any such drivers are used on any of my machines.


