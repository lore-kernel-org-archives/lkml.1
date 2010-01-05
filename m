Return-Path: <linux-kernel-owner+w=401wt.eu-S1754823Ab0AEAnL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab0AEAnL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 19:43:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754641Ab0AEAm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 19:42:59 -0500
Received: from kroah.org ([198.145.64.141]:34508 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754444Ab0AEAfv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 19:35:51 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 69/97] b43: avoid PPC fault during resume
Date: Mon,  4 Jan 2010 16:33:22 -0800
Message-Id: <1262651630-7354-69-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100105003133.GA7199@kroah.com>
References: <20100105003133.GA7199@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Larry Finger <Larry.Finger@lwfinger.net>

commit c2ff581acab16c6af56d9e8c1a579bf041ec00b1 upstream.

The routine b43_is_hw_radio_enabled() has long been a problem.
For PPC architecture with PHY Revision < 3, a read of the register
B43_MMIO_HWENABLED_LO will cause a CPU fault unless b43_status()
returns a value of 2 (B43_STAT_STARTED) (BUG 14181). Fixing that
results in Bug 14538 in which the driver is unable to reassociate
after resuming from hibernation because b43_status() returns 0.

The correct fix would be to determine why the status is 0; however,
I have not yet found why that happens. The correct value is found for
my device, which has PHY revision >= 3.

Returning TRUE when the PHY revision < 3 and b43_status() returns 0 fixes
the regression for 2.6.32.

This patch fixes the problem in Red Hat Bugzilla #538523.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Tested-by: Christian Casteyde <casteyde.christian@free.fr>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/net/wireless/b43/rfkill.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/b43/rfkill.c b/drivers/net/wireless/b43/rfkill.c
index ffdce6f..78016ae 100644
--- a/drivers/net/wireless/b43/rfkill.c
+++ b/drivers/net/wireless/b43/rfkill.c
@@ -33,8 +33,14 @@ bool b43_is_hw_radio_enabled(struct b43_wldev *dev)
 		      & B43_MMIO_RADIO_HWENABLED_HI_MASK))
 			return 1;
 	} else {
-		if (b43_status(dev) >= B43_STAT_STARTED &&
-		    b43_read16(dev, B43_MMIO_RADIO_HWENABLED_LO)
+		/* To prevent CPU fault on PPC, do not read a register
+		 * unless the interface is started; however, on resume
+		 * for hibernation, this routine is entered early. When
+		 * that happens, unconditionally return TRUE.
+		 */
+		if (b43_status(dev) < B43_STAT_STARTED)
+			return 1;
+		if (b43_read16(dev, B43_MMIO_RADIO_HWENABLED_LO)
 		    & B43_MMIO_RADIO_HWENABLED_LO_MASK)
 			return 1;
 	}
-- 
1.6.6

