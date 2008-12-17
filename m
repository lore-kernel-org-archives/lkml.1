Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1760011AbYLQAHA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760011AbYLQAHA (ORCPT <rfc822;akpm@linux-foundation.org>);
	Tue, 16 Dec 2008 19:07:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759603AbYLQAF5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 19:05:57 -0500
Received: from kroah.org ([198.145.64.141]:41243 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759532AbYLQAF4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 19:05:56 -0500
Date: Tue, 16 Dec 2008 16:04:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
        Zwane Mwaikambo <zwane@arm.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
        Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
        Chris Wedgwood <reviews@ml.cw.f00f.org>,
        Michael Krufky <mkrufky@linuxtv.org>,
        Chuck Ebbert <cebbert@redhat.com>,
        Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
        Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
        Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [patch 07/22] e1000e: fix double release of mutex
Message-ID: <20081217000412.GH4504@kroah.com>
References: <20081216235704.347182084@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="e1000e-fix-double-release-of-mutex.patch"
In-Reply-To: <20081217000306.GA4504@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

commit 30bb0e0dce78427f3e5cb728d6b5ea73acbefffa upstream.

During a reset, releasing the swflag after it failed to be acquired would
cause a double unlock of the mutex.  Instead, test whether acquisition of
the swflag was successful and if not, do not release the swflag.  The reset
must still be done to bring the device to a quiescent state.

This resolves [BUG 12200] BUG: bad unlock balance detected! e1000e
http://bugzilla.kernel.org/show_bug.cgi?id=12200

Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/e1000e/ich8lan.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/net/e1000e/ich8lan.c
+++ b/drivers/net/e1000e/ich8lan.c
@@ -1791,12 +1791,17 @@ static s32 e1000_reset_hw_ich8lan(struct
 		ctrl |= E1000_CTRL_PHY_RST;
 	}
 	ret_val = e1000_acquire_swflag_ich8lan(hw);
+	/* Whether or not the swflag was acquired, we need to reset the part */
 	hw_dbg(hw, "Issuing a global reset to ich8lan");
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

