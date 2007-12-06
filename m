Return-Path: <linux-kernel-owner+w=401wt.eu-S1755892AbXLFWiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755892AbXLFWiX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 17:38:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752971AbXLFWiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 17:38:13 -0500
Received: from mho-02-bos.mailhop.org ([63.208.196.179]:62793 "EHLO
	mho-02-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752959AbXLFWiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 17:38:10 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 207.47.95.62
X-Report-Abuse-To: abuse@dyndns.com (see http://www.mailhop.org/outbound/abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18SVlpRcRTlb/XdfpmzmnA2
Message-ID: <475879CD.9080006@reed.com>
Date: Thu, 06 Dec 2007 17:38:05 -0500
From: "David P. Reed" <dpreed@reed.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.5) Gecko/20070727 Fedora/2.0.0.5-2.fc7 Thunderbird/2.0.0.5 Mnenhy/0.7.5.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: RFC: outb 0x80 in inb_p, outb_p harmful on some modern AMD64 with
 MCP51 laptops
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After much, much testing (months, off and on, pursuing hypotheses), I've 
discovered that the use of "outb al,0x80" instructions to "delay" after 
inb and outb instructions causes solid freezes on my HP dv9000z laptop, 
when ACPI is enabled.

It takes a fair number of out's to 0x80, but the hard freeze is reliably 
reproducible by writing a driver that solely does a loop of 50 outb's to 
0x80 and calling it in a loop 1000 times from user space.  !!!

The serious impact is that the /dev/rtc and /dev/nvram devices are very 
unreliable - thus "hwclock" freezes very reliably while looping waiting 
for a new second value and calling "cat /dev/nvram" in a loop freezes 
the machine if done a few times in a row.

This is reproducible, but requires a fair number of outb's to the 0x80 
diagnostic port, and seems to require ACPI to be on.

io_64.h is the source of these particular instructions, via the 
CMOS_READ and CMOS_WRITE macros, which are defined in mc146818_64.h.  (I 
wonder if the same problem occurs in 32-bit mode).

I'm happy to complete and test a patch, but I'm curious what the right 
approach ought to be.  I have to say I have no clue as to what ACPI is 
doing on this chipset  (nvidia MCP51) that would make port 80 do this.  
A raw random guess is that something is logging POST codes, but if so, 
not clear what is problematic in ACPI mode.

ANy help/suggestions?

Changing the delay instruction sequence from the outb to short jumps 
might be the safe thing.  But Linus, et al. may have experience with 
that on other architectures like older Pentiums etc.
