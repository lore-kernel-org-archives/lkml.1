Return-Path: <linux-kernel-owner+w=401wt.eu-S935957AbZLQB3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935957AbZLQB3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 20:29:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935216AbZLQB26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 20:28:58 -0500
Received: from kroah.org ([198.145.64.141]:48122 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763683AbZLQBUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 20:20:54 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Wed Dec 16 17:16:07 2009
Message-Id: <20091217011607.132146579@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Wed, 16 Dec 2009 17:15:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Larry Finger <Larry.Finger@lwfinger.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: [70/90] b43legacy: avoid PPC fault during resume
In-Reply-To: <20091217011835.GA20434@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 316a4d966cae3c2dec83ebb1ee1a3515f97b30ff upstream.

For PPC architecture with PHY Revision < 3, a read of the register
B43_MMIO_HWENABLED_LO will cause a CPU fault unless b43legacy_status()
returns a value of 2 (B43legacy_STAT_STARTED); however, one finds that
the driver is unable to associate after resuming from hibernation unless
this routine returns 1. To satisfy both conditions, the routine is rewritten
to return TRUE whenever b43legacy_status() returns a value < 2.

This patch fixes the second problem listed in the postings for Red Hat
Bugzilla #538523.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/b43legacy/rfkill.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/net/wireless/b43legacy/rfkill.c
+++ b/drivers/net/wireless/b43legacy/rfkill.c
@@ -34,6 +34,13 @@ bool b43legacy_is_hw_radio_enabled(struc
 		      & B43legacy_MMIO_RADIO_HWENABLED_HI_MASK))
 			return 1;
 	} else {
+		/* To prevent CPU fault on PPC, do not read a register
+		 * unless the interface is started; however, on resume
+		 * for hibernation, this routine is entered early. When
+		 * that happens, unconditionally return TRUE.
+		 */
+		if (b43legacy_status(dev) < B43legacy_STAT_STARTED)
+			return 1;
 		if (b43legacy_read16(dev, B43legacy_MMIO_RADIO_HWENABLED_LO)
 		    & B43legacy_MMIO_RADIO_HWENABLED_LO_MASK)
 			return 1;


