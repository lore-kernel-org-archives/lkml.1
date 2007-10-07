Return-Path: <linux-kernel-owner+w=401wt.eu-S1752888AbXJGGyP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbXJGGyP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2007 02:54:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbXJGGx7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Oct 2007 02:53:59 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59519
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751399AbXJGGx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2007 02:53:59 -0400
Date: Sat, 06 Oct 2007 23:53:58 -0700 (PDT)
Message-Id: <20071006.235358.104048815.davem@davemloft.net>
To: dbrownell@users.sourceforge.net
CC: linux-usb-users@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       greg@kroah.com
Subject: OHCI root_port_reset() deadly loop...
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


When root_port_reset() in ohci-hub.c polls for the end of the reset,
it puts no limit on the loop and will only exit the loop when either
the RH_PS_PRS bit clears or the register returns all 1's (the latter
condition is a recent addition).

If for some reason the bit never clears, we sit here forever and never
exit the loop.

I actually hit this on one of my machines, and I'm trying to track
down what's happening.

Regardless of why my machine is doing this, there absolutely should be
some upper bound put on the number of times we will run through this
loop, perhaps enough such that up to 5 seconds elapses waiting for the
reset bit to clear.  And if it times out we should print a loud
message onto the console, but still try to continue.

Thanks!
