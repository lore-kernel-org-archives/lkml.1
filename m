Return-Path: <linux-kernel-owner+w=401wt.eu-S965082AbXJPUVE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965082AbXJPUVE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2007 16:21:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935801AbXJPUUf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Oct 2007 16:20:35 -0400
Received: from khc.piap.pl ([195.187.100.11]:43539 "EHLO khc.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935563AbXJPUUe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2007 16:20:34 -0400
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-user@lists.sourceforge.net
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: VIA VT6307 OHCI version?
References: <m3sl4ciz1h.fsf@maximus.localdomain>
	<4714EF01.2060609@s5r6.in-berlin.de>
From: Krzysztof Halasa <khc@pm.waw.pl>
Date: Tue, 16 Oct 2007 22:20:27 +0200
In-Reply-To: <4714EF01.2060609@s5r6.in-berlin.de> (Stefan Richter's message of "Tue, 16 Oct 2007 19:04:01 +0200")
Message-ID: <m3d4vebylw.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter <stefanr@s5r6.in-berlin.de> writes:

> AFAIK all 6306 are OHCI 1.0.  I presume that currently produced 6307 are
> OHCI 1.1 and maybe only first revisions of it were 1.0 --- but that's
> just my speculation.  I would be surprised though if it was merely a
> matter of EEPROM contents.

Both VT6306 and VT6307 datasheets claim selectable OHCI 1.0/1.1.
I guess they did that for compatibility or something like that.

The 6307 chip allows for either I^2C (24c01 etc) or 93c64 EEPROM (there
is a pin to select), while 6306 works with 93c64 only (4-wire: chip
select, clock, data-in, data-out).

I examined 3 machines with VT6307 using a simple home-made signal
analyzer:
a) using 93C46 EEPROM and OHCI 1.0
b) using 24C01A EEPROM and OHCI 1.0
c) using 24C01A EEPROM and OHCI 1.1

All 3 chips have PCI vendorID 1106 and deviceID 3044, revision is 0x80.

The VT6307 chip reads the EEPROM (after reset) in the following order:

ADDR	ADDR	a)	b)	c)
4-wire	I^2C
 A	14	subsystem vendor ID
 B	16	subsystem device ID

10	20	103C	103C	103C	values same on all machines
 C	18	DF03	DF03	DF03
 D	1A	8040	8040	8040
 E	1C	2000	2000	2000
 F	1E	7300	7300	7300

11	22	0000	0000	0008
12	24	0000	0000	0000
 0	 0	4000	0000	1000	config_rom: offset 0E
 1	 2	0063	DC10	00DC	(GUID)		   0C
 2	 4	0100	FD00	0101			   12
 3	 6	D0D4	8F75	F2D4			   10

 4	 8	0404	0404	0404	values same on all machines
 5	 A	5532	5532	5532	
 6	 C	00F8	00F8	00F8	
 7	 E	02A2	02A2	02A2	
 8	10	00A1	00A1	00A1	
 9	12	6340	6340	6340	

The only difference (not counting GUID) is at address 0x11 (0x22
for I2C).
I haven't yet checked if it changes OHCI version - I of course
could program the EEPROM externally but I think I'd better find
how to do that from PCI side.
-- 
Krzysztof Halasa
