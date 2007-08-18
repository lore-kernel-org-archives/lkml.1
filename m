Return-Path: <linux-kernel-owner+w=401wt.eu-S1757545AbXHRVJn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbXHRVJn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 17:09:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751280AbXHRVJd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 17:09:33 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:36016 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751079AbXHRVJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 17:09:32 -0400
Date: Sat, 18 Aug 2007 23:09:31 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Robert Hancock <hancockr@shaw.ca>
cc: Brennan Ashton <comphappy@gmail.com>,
       Marty Leisner <leisner@rochester.rr.com>, linux-kernel@vger.kernel.org
Subject: Re: power off disk drives while running
In-Reply-To: <46C7551E.7090408@shaw.ca>
Message-ID: <Pine.LNX.4.64.0708182305220.5186@fbirervta.pbzchgretzou.qr>
References: <fa.l/ISoqsJwIs1QBGVs0hodyygNPM@ifi.uio.no>
 <fa.FVj1AVbAlk/6U33GB0rOY45WWqM@ifi.uio.no> <fa.CQDcAiLY+yM/ENberToamsw+vFw@ifi.uio.no>
 <46C7551E.7090408@shaw.ca>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 18 2007 14:22, Robert Hancock wrote:
>> I see this a a very important feature in the embedded system relm, I
>> have worked on two projects that required extreme power management,
>> and massive data storage.  The ability to fully turn off a drive while
>> the system is running is key. It seems like this should be able to be
>> done from a kernel point of view rather than extra hardware. Although
>> if is not in the IDE/SATA spec then extra hardware would be necessary.
>
> You can put a drive into sleep mode with ATA commands, that one requires a
> reset to take it out of that state (as opposed to standby which spins down but
> will spin up on any command that's issued afterwards). That's as close as it
> gets to fully powering off a drive through software.

An IDE reset bringing the disk up again -- that does not sound like
it is powered down. Power down for me means: as if the plug was pulled.


Well, you could also rewrite the standy ioctl to do this:

 - flush data
 - send spindown request
 - wait 1ms - 1s (give drive some time to park heads)
 - outportb(0x378, 0) - poweroff by setting LPT data line to 0
   (who knows? they might control the disk power!)

But you'd still have to fiddle with bringing it up again. That is, you have to
patch the block or device driver to outportb(0x378, 255) again when something
is supposed to spin up again.

Oh and of course you have to deal with the problem that all userspace apps may
hang because they are waiting for the disk.

Also consider that frequently spinning up/down is said to reduce lifetime.


	Jan
-- 
