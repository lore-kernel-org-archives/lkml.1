Return-Path: <linux-kernel-owner+w=401wt.eu-S1758913AbZAMBbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758913AbZAMBbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 20:31:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758071AbZAMB3A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 20:29:00 -0500
Received: from kroah.org ([198.145.64.141]:35947 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757073AbZAMB26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 20:28:58 -0500
Date: Mon, 12 Jan 2009 17:27:00 -0800
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
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       =?iso-8859-1?B?RnJhbsOnb2lz?= Valenduc 
	<francois.valenduc@tvcablenet.be>
Subject: [patch 06/21] iwlagn: downgrade BUG_ON in interrupt
Message-ID: <20090113012700.GG4512@kroah.com>
References: <20090113012006.063755472@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline; filename="iwlagn-downgrade-bug_on-in-interrupt.patch"
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090113012633.GA4512@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Johannes Berg <johannes@sipsolutions.net>

commit 55d6a3cd0cc85ed90c39cf32e16f622bd003117b upstream.

This BUG_ON really shouldn't trigger, but if it does, as on my machine,
it leaves you wondering what happened because you won't see it. Let's
instead leak a bit of state and memory and at least make it possible to
report it to the kerneloops project to track it.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Cc: François Valenduc <francois.valenduc@tvcablenet.be>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-tx.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -1192,10 +1192,9 @@ void iwl_tx_cmd_complete(struct iwl_priv
 	/* If a Tx command is being handled and it isn't in the actual
 	 * command queue then there a command routing bug has been introduced
 	 * in the queue management code. */
-	if (txq_id != IWL_CMD_QUEUE_NUM)
-		IWL_ERROR("Error wrong command queue %d command id 0x%X\n",
-			  txq_id, pkt->hdr.cmd);
-	BUG_ON(txq_id != IWL_CMD_QUEUE_NUM);
+	if (WARN(txq_id != IWL_CMD_QUEUE_NUM,
+		 "wrong command queue %d, command id 0x%X\n", txq_id, pkt->hdr.cmd))
+		return;
 
 	cmd_index = get_cmd_index(&priv->txq[IWL_CMD_QUEUE_NUM].q, index, huge);
 	cmd = priv->txq[IWL_CMD_QUEUE_NUM].cmd[cmd_index];

