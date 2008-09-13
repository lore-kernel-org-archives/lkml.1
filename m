Return-Path: <linux-kernel-owner+w=401wt.eu-S1755068AbYIMETS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755068AbYIMETS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Sep 2008 00:19:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751114AbYIMETB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Sep 2008 00:19:01 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34978
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750981AbYIMETA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Sep 2008 00:19:00 -0400
Date: Fri, 12 Sep 2008 21:18:54 -0700 (PDT)
Message-Id: <20080912.211854.102505246.davem@davemloft.net>
To: linux-serial@vger.kernel.org
CC: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
       joy@entuzijast.net
Subject: [PATCH 0/2]: Allow 8250 to work on sparc.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently there is a "BROKEN || SPARC" dependency for CONFIG_SERIAL_8250
in drivers/serial/Kconfig.  These changes try to eliminate that restriction
so that Sparc users can use add-on PCI cards with 8250 serial controllers.

The core issue that prevents this from working is that all of the onboard
Sun specific serial drivers use the major=TTY_MAJOR, minor=64,65,66,...
driver major/minor namespace, just like 8250.

They coordinate amongst themselves using an internal allocator for the
minor number space.  This is contained in drivers/serial/suncore.c

This presents two problems:

1) We have to make sure the Sun drivers register first, so that their
   device indexes don't change and thus people get broken serial consoles
   and stuff like that.

2) Also, it is necessary for 8250 to partake in this minor number
   allocation scheme, otherwise it cannot register because it'll try
   to use '64' as it's base minor number and one of the Sun serial drivers
   will have taken over that minor already.

Working on this and testing it also uncovered another portability bug.
The uart_port structure uses an "unsigned int" for the "ioport" member,
but even I/O ports in PCI devices are 64-bit on sparc64, so the high
bits were being chopped off when 8250 PCI cards were tested.  The fix
is to use "unsigned long" for this type and that's what the first patch
does.

The second patch removes the !SPARC dependency for 8250 and adds the hooks
to use the Sun serial minor number allocator when registering serial8250_reg
with the UART layer.

Yes, I know, this part is a bit ugly but I can't think of any workable
alternative.  I could change all the major/minor numbers all the Sun
serial drivers use, to get out of the way of 8250's space.  But that
will break every single Sparc system out there, all the serial device
names will change as will the serial console device.  I did write a patch
which does such a set of changes, but I can't see any way in which we can
consider it seriously.

If there are no objections I'd like to toss this into my sparc-next-2.6
tree for 2.6.28 inclusion.  Is that OK with everyone?

I'd like to thank Josip Rodin for bringing this to my attention, and
testing various revisions of these patches.
