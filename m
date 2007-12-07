Return-Path: <linux-kernel-owner+w=401wt.eu-S1754193AbXLGAXt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754193AbXLGAXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 19:23:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbXLGAXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 19:23:42 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:57883 "EHLO
	pd2mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbXLGAXm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 19:23:42 -0500
Date: Thu, 06 Dec 2007 18:23:27 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64 with
 MCP51 laptops
In-reply-to: <fa./27SNSh+L5T3iqFNPdHClEu+yT0@ifi.uio.no>
To: "David P. Reed" <dpreed@reed.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Message-id: <4758927F.50500@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa./27SNSh+L5T3iqFNPdHClEu+yT0@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David P. Reed wrote:
> After much, much testing (months, off and on, pursuing hypotheses), I've 
> discovered that the use of "outb al,0x80" instructions to "delay" after 
> inb and outb instructions causes solid freezes on my HP dv9000z laptop, 
> when ACPI is enabled.
> 
> It takes a fair number of out's to 0x80, but the hard freeze is reliably 
> reproducible by writing a driver that solely does a loop of 50 outb's to 
> 0x80 and calling it in a loop 1000 times from user space.  !!!
> 
> The serious impact is that the /dev/rtc and /dev/nvram devices are very 
> unreliable - thus "hwclock" freezes very reliably while looping waiting 
> for a new second value and calling "cat /dev/nvram" in a loop freezes 
> the machine if done a few times in a row.
> 
> This is reproducible, but requires a fair number of outb's to the 0x80 
> diagnostic port, and seems to require ACPI to be on.
> 
> io_64.h is the source of these particular instructions, via the 
> CMOS_READ and CMOS_WRITE macros, which are defined in mc146818_64.h.  (I 
> wonder if the same problem occurs in 32-bit mode).
> 
> I'm happy to complete and test a patch, but I'm curious what the right 
> approach ought to be.  I have to say I have no clue as to what ACPI is 
> doing on this chipset  (nvidia MCP51) that would make port 80 do this.  
> A raw random guess is that something is logging POST codes, but if so, 
> not clear what is problematic in ACPI mode.
> 
> ANy help/suggestions?
> 
> Changing the delay instruction sequence from the outb to short jumps 
> might be the safe thing.  But Linus, et al. may have experience with 
> that on other architectures like older Pentiums etc.

The fact that these "pausing" calls are needed in the first place seems 
rather cheesy. If there's hardware that's unable to respond to IO port 
writes as fast as possible, then surely there's a better solution than 
trying to stall the IOs by an arbitrary and hardware-dependent amount of 
time, like udelay calls, etc. Does any remotely recent hardware even 
need this?

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

