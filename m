Return-Path: <linux-kernel-owner+w=401wt.eu-S1754117AbZKLSsh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbZKLSsh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 13:48:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbZKLSsf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 13:48:35 -0500
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:6743 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753539AbZKLSsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 13:48:32 -0500
Subject: [PATCH 09/11] cciss: Do not automatically rescan on UNIT
	ATTENTION/LUN DATA CHANGED
To: axboe@kernel.dk, akpm@linux-foundation.org
From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: linux-kernel@vger.kernel.org, mikem@beardog.cce.hp.com, achiang@hp.com,
       brace@beardog.cce.hp.com
Date: Thu, 12 Nov 2009 12:49:55 -0600
Message-ID: <20091112184955.23389.59794.stgit@beardog.cce.hp.com>
In-Reply-To: <20091112184542.23389.36220.stgit@beardog.cce.hp.com>
References: <20091112184542.23389.36220.stgit@beardog.cce.hp.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

cciss: Do not automatically rescan on UNIT ATTENTION/LUN DATA CHANGED
There are problems with doing this.  If, say, several logical drives
are deleted at once, several such UNIT ATTENTIONS will be encountered,
often during the rescan triggered by the first such UNIT ATTENTION.
The block layer may be in the midst of trying to add logical drives
which were just deleted (resulting in the subsequent UNIT ATTENTION(s).)
Making the rescan code robust enough to tolerate this kind of thing
is too complicated for the moment.  So, for now, we just don't do it.
Note: This UNIT ATTENTION/LUN DATA CHANGED situation only occurs on
the MSA2012.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/block/cciss.c |   18 ++++++++++++++++--
 1 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
index 42eaddb..bf2d1c8 100644
--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3416,8 +3416,22 @@ static int check_for_unit_attention(ctlr_info_t *h, CommandList_struct *c)
 	case REPORT_LUNS_CHANGED:
 		printk(KERN_WARNING "cciss%d: report LUN data "
 			"changed\n", h->ctlr);
-		add_to_scan_list(h);
-		wake_up_process(cciss_scan_thread);
+	/*
+	 * Here, we could call add_to_scan_list and wake up the scan thread,
+	 * except that it's quite likely that we will get more than one
+	 * REPORT_LUNS_CHANGED condition in quick succession, which means
+	 * that those which occur after the first one will likely happen
+	 * *during* the scan_thread's rescan.  And the rescan code is not
+	 * robust enough to restart in the middle, undoing what it has already
+	 * done, and it's not clear that it's even possible to do this, since
+	 * part of what it does is notify the block layer, which starts
+	 * doing it's own i/o to read partition tables and so on, and the
+	 * driver doesn't have visibility to know what might need undoing.
+	 * In any event, if possible, it is horribly complicated to get right
+	 * so we just don't do it for now.
+	 *
+	 * Note: this REPORT_LUNS_CHANGED condition only occurs on the MSA2012.
+	 */
 		return 1;
 	break;
 	case POWER_OR_RESET:

