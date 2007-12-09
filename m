Return-Path: <linux-kernel-owner+w=401wt.eu-S1754273AbXLIVqa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754273AbXLIVqa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2007 16:46:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751413AbXLIVqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Dec 2007 16:46:22 -0500
Received: from mail.prans.org ([64.79.206.200]:56044 "EHLO mail.prans.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751225AbXLIVqV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2007 16:46:21 -0500
X-Greylist: delayed 2017 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Dec 2007 16:46:21 EST
From: Elvis Pranskevichus <el@prans.net>
Subject: Re: [lm-sensors] 2.6.24-rc4 hwmon it87 probe fails
To: Jean Delvare <khali@linux-fr.org>, Mike Houston <mikeserv@bmts.com>,
       Adrian Bunk <bunk@stusta.de>, mhoffman@lightlink.com,
       linux-kernel@vger.kernel.org, lm-sensors@lm-sensors.org,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Adam Belay <ambx1@neo.rr.com>
Date: Sun, 09 Dec 2007 16:12:25 -0500
References: <20071204215154.7f26285e.mikeserv@bmts.com> <20071209000554.GF20441@stusta.de> <20071208212234.e00b74cd.mikeserv@bmts.com> <20071209105028.06ed52a6@hyperion.delvare>
User-Agent: KNode/0.10.5
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1J1TRp-0000ZF-6J@asgard.prans.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean Delvare wrote:

> Hi Mike,
> 
> On Sat, 8 Dec 2007 21:22:34 -0500, Mike Houston wrote:
>> On Sun, 9 Dec 2007 01:05:54 +0100
>> Adrian Bunk <bunk@stusta.de> wrote:
>> 
>> > On Tue, Dec 04, 2007 at 09:51:54PM -0500, Mike Houston wrote:
>> > > I finally got around to testing Linux 2.6.24 (2.6.24-rc4) and
>> > > found that the it87 driver fails to probe and consequently, my
>> > > sensors no longer work. This was fine with Linux 2.6.23.8 (the
>> > > last kernel I was using)
>> > > 
>> > > The necessary modules load, but:
>> > > 
>> > > it87: Found IT8718F chip at 0x290, revision 2
>> > > it87: in3 is VCC (+5V)
>> > > it87 it87.656: Failed to request region 0x290-0x297
>> > > it87: probe of it87.656 failed with error -16
>> > > 
>> > > Coretemp still works.
>> > > 
>> > > It appears it has something to do with the ioport range being
>> > > reserved for some reason:
>> > > 
>> > > system 00:01: ioport range 0x290-0x29f has been reserved
>> 
>> > 
>> > Thanks for your report.
>> > 
>> > Please also provide:
>> > - dmesg from 2.6.23.8
>> > - The output of "cat /proc/ioports" for both kernels
>> 
>> Thanks Adrian, here is the information you have requested, for
>> both kernels (I have 2.6.23.9 now though where it87 still works)
>> 
>> Linux 2.6.23.9:
>> http://www.mikeserv.com/temp/proc_ioports-2.6.23.9.txt
>> http://www.mikeserv.com/temp/dmesg-2.6.23.9.txt
>> http://www.mikeserv.com/temp/config-2.6.23.9.txt
>> 
>> Linux 2.6.24-rc4:
>> http://www.mikeserv.com/temp/proc_ioports-2.6.24-rc4.txt
>> http://www.mikeserv.com/temp/dmesg-2.6.24-rc4.txt
> 
> This one shows:
> 
> system 00:01: ioport range 0x290-0x29f has been reserved
> (...)
> system 00:01: ioport range 0x290-0x294 has been reserved
> 
> This is clearly not correct as both areas overlap. The second
> reservation is responsible for the it87 breakage, because it conflicts
> with what the it87 driver later attempts to request (0x290-0x297). The
> first is wrong as well (the IT87xxF environment controller I/O area is
> 8 port wide, not 16) but shouldn't be a problem in practice.
> 
> These port reservations weren't happening in 2.6.23.9 according to your
> dmesg output for that kernel. I don't know what changed in this area
> since 2.6.23.9, maybe Bjorn or Adam (Cc'd) can tell.
> 

Hi,

I have exactly the same problem here on a Gigabyte GA-965G-DS3 motherboard
based box:

it87: Found IT8718F chip at 0x290, revision 1
it87: in3 is VCC (+5V)
it87 it87.656: Failed to request region 0x290-0x297
it87: probe of it87.656 failed with error -16

git bisecting revealed the offending commit:

a7839e960675b54: PNP: increase the maximum number of resources

Happened between rc3 and rc4.

> Either way, the overlapping areas smell like a BIOS bug, meaning that
> you should look for an updated BIOS for your system first.
> 
>> http://www.mikeserv.com/temp/config-2.6.24-rc4.txt
> 

This indeed looks like a broken ACPI BIOS since the aforementioned commit
touches only the PNP ACPI driver. I'm not sure how to work around this,
though. Ideas?

--
          Elvis

