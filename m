Return-Path: <linux-kernel-owner+w=401wt.eu-S1761516AbXKOGyz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761516AbXKOGyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:54:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932442AbXKOGqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:46:55 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:57861 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762876AbXKOGqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:46:53 -0500
Date: Wed, 14 Nov 2007 22:44:18 -0800
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Roland Dreier <rolandd@cisco.com>
Subject: [patch 08/40] IB/mthca: Use mmiowb() to avoid firmware commands
	getting jumbled up
Message-ID: <20071115064418.GI19218@kroah.com>
References: <20071115062710.885284510@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ib-mthca-use-mmiowb-to-avoid-firmware-commands-getting-jumbled-up.patch"
In-Reply-To: <20071115064302.GA19218@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Roland Dreier <rdreier@cisco.com>

Upstream as 76d7cc0345a037e8eea426f8abc710abd22946dd

Firmware commands are sent to the HCA by writing multiple words to a
command register block.  Access to this block of registers is
serialized with a mutex.  However, on large SGI systems, problems were
seen with multiple CPUs issuing FW commands at the same time, because
the writes to the register block may be reordered within the system
interconnect and reach the HCA in a different order than they were
issued (even with the mutex).  Fix this by adding an mmiowb() before
dropping the mutex.

Tested-by: Arthur Kepner <akepner@sgi.com>
Signed-off-by: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/infiniband/hw/mthca/mthca_cmd.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/infiniband/hw/mthca/mthca_cmd.c
+++ b/drivers/infiniband/hw/mthca/mthca_cmd.c
@@ -290,6 +290,12 @@ static int mthca_cmd_post(struct mthca_d
 		err = mthca_cmd_post_hcr(dev, in_param, out_param, in_modifier,
 					 op_modifier, op, token, event);
 
+	/*
+	 * Make sure that our HCR writes don't get mixed in with
+	 * writes from another CPU starting a FW command.
+	 */
+	mmiowb();
+
 	mutex_unlock(&dev->cmd.hcr_mutex);
 	return err;
 }

-- 
