Return-Path: <linux-kernel-owner+w=401wt.eu-S1758530AbYLKV65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530AbYLKV65 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 16:58:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758599AbYLKV6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 16:58:44 -0500
Received: from qmta04.westchester.pa.mail.comcast.net ([76.96.62.40]:58858
	"EHLO QMTA04.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756826AbYLKV6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 16:58:42 -0500
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [PATCH] e1000e: fix double release of mutex
To: davem@davemloft.net, akpm@linux-foundation.org
Cc: frederik.deweerdt@xprog.eu, e1000-devel@lists.sourceforge.net,
       netdev@vger.kernel.org, jesse.brandeburg@intel.com,
       linux-kernel@vger.kernel.org, stable@kernel.org, tglx@linutronix.de,
       zdenek.kabelac@gmail.com, Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Thu, 11 Dec 2008 13:58:07 -0800
Message-ID: <20081211215806.1173.24413.stgit@lost.foo-projects.org>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During a reset, releasing the swflag after it failed to be acquired would
cause a double unlock of the mutex.  Instead, test whether acquisition of
the swflag was successful and if not, do not release the swflag.  The reset
must still be done to bring the device to a quiescent state.

This resolves [BUG 12200] BUG: bad unlock balance detected! e1000e
http://bugzilla.kernel.org/show_bug.cgi?id=12200

Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---

 drivers/net/e1000e/ich8lan.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/e1000e/ich8lan.c b/drivers/net/e1000e/ich8lan.c
index 92f2ace..f2a5963 100644
--- a/drivers/net/e1000e/ich8lan.c
+++ b/drivers/net/e1000e/ich8lan.c
@@ -1939,12 +1939,17 @@ static s32 e1000_reset_hw_ich8lan(struct e1000_hw *hw)
 		ctrl |= E1000_CTRL_PHY_RST;
 	}
 	ret_val = e1000_acquire_swflag_ich8lan(hw);
+	/* Whether or not the swflag was acquired, we need to reset the part */
 	hw_dbg(hw, "Issuing a global reset to ich8lan\n");
 	ew32(CTRL, (ctrl | E1000_CTRL_RST));
 	msleep(20);
 
-	/* release the swflag because it is not reset by hardware reset */
-	e1000_release_swflag_ich8lan(hw);
+	if (!ret_val) {
+		/* release the swflag because it is not reset by
+		 * hardware reset
+		 */
+		e1000_release_swflag_ich8lan(hw);
+	}
 
 	ret_val = e1000e_get_auto_rd_done(hw);
 	if (ret_val) {

