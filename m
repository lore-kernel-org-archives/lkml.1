Return-Path: <linux-kernel-owner+w=401wt.eu-S1756056AbXKJX3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756056AbXKJX3T (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2007 18:29:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755415AbXKJX3J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Nov 2007 18:29:09 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:53096 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563AbXKJX3I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2007 18:29:08 -0500
Message-ID: <47363EB4.4030008@garzik.org>
Date: Sat, 10 Nov 2007 18:28:52 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Tejun Heo <htejun@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Will Trives <will@trivescon.com.au>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: cd/dvd inaccessible in 2.6.24-rc2
References: <1194668831.3436.14.camel@Athas>	<20071110144923.beb7bbae.akpm@linux-foundation.org> <20071110230553.1a935ec6@the-village.bc.nu>
In-Reply-To: <20071110230553.1a935ec6@the-village.bc.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
>>> ata9.00: qc timeout (cmd 0xa0)
>>> ata9.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x2 frozen
>>> ata9.00: cmd a0/00:00:00:02:00/00:00:00:00:00/a0 tag 0 cdb 0x5a data 2
>>> in
>>>          res 51/54:03:00:02:00/00:00:00:00:00/a0 Emask 0x5 (timeout)
>>> ata9.00: status: { DRDY ERR }
> 
> Could be an IRQ/ACPI regression, and in fact to me it looks more like
> that, than an IDE one. Probably worth trying the various IRQ routing
> options and seeing if they help.


Agreed, though the output is indeed signalling an error...  IMO the EH 
should handle the error if the device is signalling an error, upon 
timeout, rather than just going ahead and resetting the device.

Its similar to where ATA devices on PCI SFF controllers signal DMA error 
via timeout, where EH must inspect BMDMA Status register to determine if 
it's a DMA error signalled by hardware, or something that requires 
additional autopsy.

EH for ATAPI is quite different from EH for ATA, so there may be some 
areas where we don't handle things the right way for ATAPI.

Decoding the error message we have:

cdb 0x5a ==
	MODE SENSE(10)
status 0x51 ==
	DRDY
	command-specific flag (aka SERV, in !overlap case)
	CHK (check condition, aka error)
error 0x54 ==
	ABRT (command aborted or command parameter invalid)
	sense key 0x5 (illegal request)
ireason 0x3 ==
	the hardcoded values (bits 0 and 1) remain hardcoded, all good

Since BSY is not set in the Status register, and given the other 
information derived from the decoded values, it looks like the device is 
otherwise happy and ready to accept additional commands.

It appears to have chewed on an ATAPI command, spit it out, but failed 
to send a completion interrupt.

So its an open question whether it's a device not completing this 
errored-out command, or whether its IRQ/ACPI stuff infecting libata.

	Jeff


