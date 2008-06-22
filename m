Return-Path: <linux-kernel-owner+w=401wt.eu-S1756827AbYFVTGe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827AbYFVTGe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2008 15:06:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756121AbYFVTEx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jun 2008 15:04:53 -0400
Received: from mail.suse.de ([195.135.220.2]:43568 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756106AbYFVTEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2008 15:04:51 -0400
Date: Sun, 22 Jun 2008 12:01:43 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, csnook@redhat.com, advantis@gmx.net,
       jgarzik@redhat.com, Jay Cliburn <jacliburn@bellsouth.net>
Subject: [patch 1/5] atl1: relax eeprom mac address error check
Message-ID: <20080622190143.GE20141@suse.de>
References: <20080622185327.348377223@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="atl1-relax-eeprom-mac-address-error-check.patch"
In-Reply-To: <20080622190111.GA20141@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.25-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Radu Cristescu <advantis@gmx.net>

upstream commit: 58c7821c4264a7ddd6f0c31c5caaf393b3897f10

The atl1 driver tries to determine the MAC address thusly:

	- If an EEPROM exists, read the MAC address from EEPROM and
	  validate it.
	- If an EEPROM doesn't exist, try to read a MAC address from
	  SPI flash.
	- If that fails, try to read a MAC address directly from the
	  MAC Station Address register.
	- If that fails, assign a random MAC address provided by the
	  kernel.

We now have a report of a system fitted with an EEPROM containing all
zeros where we expect the MAC address to be, and we currently handle
this as an error condition.  Turns out, on this system the BIOS writes
a valid MAC address to the NIC's MAC Station Address register, but we
never try to read it because we return an error when we find the all-
zeros address in EEPROM.

This patch relaxes the error check and continues looking for a MAC
address even if it finds an illegal one in EEPROM.

http://ubuntuforums.org/showthread.php?t=562617

[jacliburn@bellsouth.net: backport to 2.6.25.7]

Signed-off-by: Radu Cristescu <advantis@gmx.net>
Signed-off-by: Jay Cliburn <jacliburn@bellsouth.net>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/atl1/atl1_hw.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/atl1/atl1_hw.c
+++ b/drivers/net/atl1/atl1_hw.c
@@ -250,7 +250,6 @@ static int atl1_get_permanent_address(st
 			memcpy(hw->perm_mac_addr, eth_addr, ETH_ALEN);
 			return 0;
 		}
-		return 1;
 	}
 
 	/* see if SPI FLAGS exist ? */

-- 
