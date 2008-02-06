Return-Path: <linux-kernel-owner+w=401wt.eu-S1764708AbYBGABH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764708AbYBGABH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:01:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761678AbYBFXyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 18:54:44 -0500
Received: from mail.suse.de ([195.135.220.2]:45234 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764252AbYBFXyn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:54:43 -0500
Date: Wed, 6 Feb 2008 15:51:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Peter Tyser <ptyser@xes-inc.com>,
       Stephen Hemminger <shemminger@linux-foundation.org>
Subject: [patch 14/73] sky2: RX lockup fix
Message-ID: <20080206235126.GO13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=sky2-1
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: Stephen Hemminger <shemminger@linux-foundation.org>

Backport commit 798fdd07fcc131f396e521febb4a7d42559bf4b5

I'm using a Marvell 88E8062 on a custom PPC64 blade and ran into RX
lockups while validating the sky2 driver.  The receive MAC FIFO would
become stuck during testing with high traffic.  One port of the 88E8062
would lockup, while the other port remained functional.  Re-inserting
the sky2 module would not fix the problem - only a power cycle would.

I looked over Marvell's most recent sk98lin driver and it looks like
they had a "workaround" for the Yukon XL that the sky2 doesn't have yet.
The sk98lin driver disables the RX MAC FIFO flush feature for all
revisions of the Yukon XL.

According to skgeinit.c of the sk98lin driver, "Flushing must be enabled
(needed for ASF see dev. #4.29), but the flushing mask should be
disabled (see dev. #4.115)".  Nice. I implemented this same change in
the sky2 driver and verified that the RX lockup I was seeing was
resolved.

Signed-off-by: Peter Tyser <ptyser@xes-inc.com>
Signed-off-by: Stephen Hemminger <shemminger@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 drivers/net/sky2.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -812,8 +812,13 @@ static void sky2_mac_init(struct sky2_hw
 
 	sky2_write32(hw, SK_REG(port, RX_GMF_CTRL_T), rx_reg);
 
-	/* Flush Rx MAC FIFO on any flow control or error */
-	sky2_write16(hw, SK_REG(port, RX_GMF_FL_MSK), GMR_FS_ANY_ERR);
+	if (hw->chip_id == CHIP_ID_YUKON_XL) {
+		/* Hardware errata - clear flush mask */
+		sky2_write16(hw, SK_REG(port, RX_GMF_FL_MSK), 0);
+	} else {
+		/* Flush Rx MAC FIFO on any flow control or error */
+		sky2_write16(hw, SK_REG(port, RX_GMF_FL_MSK), GMR_FS_ANY_ERR);
+	}
 
 	/* Set threshold to 0xa (64 bytes) + 1 to workaround pause bug  */
 	reg = RX_GMF_FL_THR_DEF + 1;

-- 
