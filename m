Return-Path: <linux-kernel-owner+w=401wt.eu-S1753747AbYHJR2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbYHJR2Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 13:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752069AbYHJR16
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 13:27:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50256 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752001AbYHJR16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 13:27:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Hemminger <stephen.hemminger@vyatta.com>
Subject: [PATCH] sky2: Fix suspend/hibernation/shutdown regression with WOL enabled (rev. 2)
Date: Sun, 10 Aug 2008 19:30:28 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: netdev@vger.kernel.org, Jeff Garzik <jeff@garzik.org>,
       Stephen Hemminger <shemminger@vyatta.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
References: <200808092332.29596.rjw@sisk.pl> <20080809235711.12c2f331@extreme> <200808101414.35626.rjw@sisk.pl>
In-Reply-To: <200808101414.35626.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808101930.29574.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 10 of August 2008, Rafael J. Wysocki wrote:
> On Sunday, 10 of August 2008, Stephen Hemminger wrote:
> > On Sat, 9 Aug 2008 23:32:28 +0200
> > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
[--snip--]
> > 
> > The problem is not unique to your chip version,
> 
> Well, that's the part I wasn't sure of.
> 
> > so patching out the power down is not the correct solution.
> 
> Sure.

But, shouldn't we switch to page 2 before selecting PHY_MARV_PHY_CTRL?  Things
work correctly if this is done (patch below).

Thanks,
Rafael


---
On my test box with the Asus M3A32-MVP main board there is a
regression from 2.6.26 related to suspend, hibernation and
shutdown.  Namely, if Wake-on-LAN is enabled with
'ethtool -s eth0 wol g', the box hangs solid during all of these
operations, while executing either sky2_suspend(), or
sky2_shutdown().  This patch fixes it for me.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/net/sky2.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6/drivers/net/sky2.c
===================================================================
--- linux-2.6.orig/drivers/net/sky2.c
+++ linux-2.6/drivers/net/sky2.c
@@ -666,11 +666,16 @@ static void sky2_phy_power_down(struct s
 
 	if (hw->chip_id != CHIP_ID_YUKON_EC) {
 		if (hw->chip_id == CHIP_ID_YUKON_EC_U) {
-			ctrl = gm_phy_read(hw, port, PHY_MARV_PHY_CTRL);
+			/* select page 2 to access MAC control register */
+			gm_phy_write(hw, port, PHY_MARV_EXT_ADR, 2);
 
+			ctrl = gm_phy_read(hw, port, PHY_MARV_PHY_CTRL);
 			/* enable Power Down */
 			ctrl |= PHY_M_PC_POW_D_ENA;
 			gm_phy_write(hw, port, PHY_MARV_PHY_CTRL, ctrl);
+
+			/* set page register back to 0 */
+			gm_phy_write(hw, port, PHY_MARV_EXT_ADR, 0);
 		}
 
 		/* set IEEE compatible Power Down Mode (dev. #4.99) */
