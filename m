Return-Path: <linux-kernel-owner+w=401wt.eu-S932293AbZJPRTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932293AbZJPRTu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 13:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753541AbZJPRTs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 13:19:48 -0400
Received: from kroah.org ([198.145.64.141]:48692 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755861AbZJPRSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 13:18:47 -0400
X-Mailbox-Line: From linux@linux.site Fri Oct 16 10:12:10 2009
Message-Id: <20091016171209.947222482@linux.site>
User-Agent: quilt/0.47-14.9
Date: Fri, 16 Oct 2009 10:10:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jay Sternberg <jay.e.sternberg@intel.com>,
       Reinette Chatre <reinette.chatre@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [44/46] iwlwifi: incorrect method used for finding valid OTP blocks
References: <20091016170953.128828149@linux.site>
Content-Disposition: inline; filename=iwlwifi-incorrect-method-used-for-finding-valid-otp-blocks.patch
In-Reply-To: <20091016171422.GA13339@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jay Sternberg <jay.e.sternberg@intel.com>

commit 2facba769d7f9e563cf706de709074a2d20f1bba upstream.

The address stored in the next link address is a word address but when
reading the OTP blocks, a byte address is used. Also if the blocks are
full and the last link pointer is not zero, then none of the blocks are
valid so return an error.

The algorithm is simply valid blocks have a next address and that
address's contents is zero.

Using the wrong address for the next link address gets arbitrary data,
obviously. In cases seen, the first block is considered valid when it is not.

If the block has in fact been invalidated there may be old data or
there may be no data, bad data, or partial data, there is no way of
telling. Without this patch it is possible that a device with valid OTP data
is unable to work.

Signed-off-by: Jay Sternberg <jay.e.sternberg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/iwlwifi/iwl-eeprom.c |   23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.c
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.c
@@ -335,7 +335,6 @@ static int iwl_find_otp_image(struct iwl
 					u16 *validblockaddr)
 {
 	u16 next_link_addr = 0, link_value = 0, valid_addr;
-	int ret = 0;
 	int usedblocks = 0;
 
 	/* set addressing mode to absolute to traverse the link list */
@@ -355,29 +354,29 @@ static int iwl_find_otp_image(struct iwl
 		 * check for more block on the link list
 		 */
 		valid_addr = next_link_addr;
-		next_link_addr = link_value;
+		next_link_addr = link_value * sizeof(u16);
 		IWL_DEBUG_INFO(priv, "OTP blocks %d addr 0x%x\n",
 			       usedblocks, next_link_addr);
 		if (iwl_read_otp_word(priv, next_link_addr, &link_value))
 			return -EINVAL;
 		if (!link_value) {
 			/*
-			 * reach the end of link list,
+			 * reach the end of link list, return success and
 			 * set address point to the starting address
 			 * of the image
 			 */
-			goto done;
+			*validblockaddr = valid_addr;
+			/* skip first 2 bytes (link list pointer) */
+			*validblockaddr += 2;
+			return 0;
 		}
 		/* more in the link list, continue */
 		usedblocks++;
-	} while (usedblocks < priv->cfg->max_ll_items);
-	/* OTP full, use last block */
-	IWL_DEBUG_INFO(priv, "OTP is full, use last block\n");
-done:
-	*validblockaddr = valid_addr;
-	/* skip first 2 bytes (link list pointer) */
-	*validblockaddr += 2;
-	return ret;
+	} while (usedblocks <= priv->cfg->max_ll_items);
+
+	/* OTP has no valid blocks */
+	IWL_DEBUG_INFO(priv, "OTP has no valid blocks\n");
+	return -EINVAL;
 }
 
 /**


