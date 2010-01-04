Return-Path: <linux-kernel-owner+w=401wt.eu-S1754187Ab0ADXn0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab0ADXn0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 18:43:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754151Ab0ADXnZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 18:43:25 -0500
Received: from eddie.linux-mips.org ([78.24.191.182]:50981 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150Ab0ADXnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 18:43:22 -0500
Date: Mon, 4 Jan 2010 23:43:20 +0000 (GMT)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: David Miller <davem@davemloft.net>
cc: hartleys@visionengravers.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH] drivers/net/defxx.c: use %pM to show MAC address
In-Reply-To: <20100104.110326.161162074.davem@davemloft.net>
Message-ID: <alpine.LFD.2.00.1001042256120.13474@eddie.linux-mips.org>
References: <BD79186B4FD85F4B8E60E381CAEE19090200F63E@mi8nycmail19.Mi8.com>        <alpine.LFD.2.00.1001041833560.13474@eddie.linux-mips.org> <20100104.110326.161162074.davem@davemloft.net>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Jan 2010, David Miller wrote:

> >  Nack.  While I appreciate your effort, the FDDI standard defines opposite 
> > bit-ordering for MAC addresses written in the dash-separated and the 
> > colon-separated hexadecimal notation, which makes your change invalid, 
> > sorry (you'd have to bit-swap them too and that would make addresses 
> > counter-intuitive).  Please note that `ifconfig' consistently uses the 
> > dash-separated notation for FDDI interfaces too (I haven't checked other 
> > tools like those in the "iproute" package; they may be buggy).
> 
> Well:
> 
> 1) It's a bootup kernel message, we can use whatever format
>    we want.
> 
> 2) As for consistency's sake, the only other FDDI driver using
>    alloc_fddidev() and friends, skfp, uses yet another format
>    for printing FDDI addresses to the log:
> 
> 	pr_debug(KERN_INFO "HW-Addr: %02x %02x %02x %02x %02x %02x\n",
> 
>    So striving for "consistency" is a bit of a stretch.
> 
>    Against a userspace tool's output format?  Even more so...
> 
> And I doubt anybody is going to suddenly faint and become
> confused if they see the MAC address in ethernet format.
> 
> In fact I'd rather see all of our FDDI drivers use the standard
> ethernet MAC format in visible kernel log messages and save all
> of that object code space that gets taken up by these by-hand
> printk's in these obscure drivers.

 I agree with you and I like things to be sweet and consistent as long as 
they don't cause confusion.

 Unfortunately FDDI defines both formats and one obvious for people that 
have only ever worked with Ethernet (i.e. in the colon-separated notation) 
is the opposite to how people familiar with FDDI would interpret it.  The 
other driver should use the same notation as this one does and I guess the 
author just couldn't decide or something.

 Here's a quotation from the relevant FDDI standard document -- that's 
"FDDI STATION MANAGEMENT (SMT)", my draft copy is marked as X3T9/92-067, 
and it looks it's been later designated as ANSI X3.229-1994 and ISO 9314-6 
too.  This is from chapter 4.1.2.3 "Notation for Addresses":

 "The ANSI/IEEE 802.1 standard has defined the canonical form for 
representing 48-bit addresses as octet strings.  The canonical form is a 
6-octet string.  The first octet contains the first 8 bits of the address, 
with the I/G bit as the least significant bit, the U/L bit as the next 
more significant bit, and so on.  When displayed for use by humans, the 
canonical form is shown as a hexadecimal string, written from left to 
right, with hyphens separating the individual octets.

 This SMT document uses the Most Significant Bit (MSB) form for 
representing 48 bit addresses as 6-octet strings.  The first octet 
contains the first 8 bits of the address, with the I/G bit as the most 
significant bit, the U/L bit as the next less significant bit, and so on.  
When displayed for use by humans, the MSB form is shown as a hexadecimal 
string, written from left to right, with colons separating the individual 
octets.

 The example below shows an address, and the sequence of bits or symbols 
that would be transmitted when the address is used in the Source Address 
or Destination Address fields on the MAC header.  The transmission line 
shows the address bits in the order transmitted, from left to right.  For 
IEEE 802 LANs these correspond to actual bits on the medium.  The FDDI 
symbols line shows how the FDDI PHY sends the address bits as encoded 
symbols.

        MSB:            35:7B:12:00:00:01
        Canonical:      AC-DE-48-00-00-80
        Transmission:   00110101 01111011 00010010 00000000 00000000 00000001
        FDDI Symbols:   35 7B 12 00 00 01"

Please note that this address has its group bit clear.

 This notation is also defined in the "FDDI MEDIA ACCESS CONTROL-2 
(MAC-2)" (X3T9/92-120) document although that book does not have a need 
to use the MSB form and it's skipped.

 As you can see the documents make it pretty clear how FDDI addresses are 
to be shown to humans and everyone at least a bit familiar with FDDI will 
expect them to look so and be confused otherwise -- whether it's a Linux 
kernel bootup message or anything else (and yes, I did have to fix things 
coming from this confusion at least once before, so please let's not go 
through this again).

 And yes, Ethernet and FDDI can be bridged between at the MAC layer (I 
have such a device), so it can be shown that it's the canonical form that 
corresponds to that used for Ethernet.

  Maciej
