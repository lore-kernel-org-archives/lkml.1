Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab0BRJpw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 04:45:52 -0500
Received: from mail-fx0-f220.google.com ([209.85.220.220]:56854 "EHLO
	mail-fx0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753656Ab0BRJpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 04:45:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=gn2Mx+kRWv+sbQ3uukhUq93fxUZS/rZHVFTkPxlZorxjPx8HTjuxXlTXk+S+DHRme2
         9aTL5LD5b3kaQMAE/RLFElSklA8V2WVtpCDP68BuZKni5Kb2gOYpooArB3gZ2O5RBsvX
         6DqoPusSeEnknropsZUzQxlsjaAsxvHTAlDiU=
Date: Thu, 18 Feb 2010 12:45:29 +0300
From: Dan Carpenter <error27@gmail.com>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
       Intel Linux Wireless <ilw@linux.intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Wey-Yi Guy <wey-yi.w.guy@intel.com>,
       Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] iwlwifi: testing the wrong variable
Message-ID: <20100218094529.GA1298@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The first one fixes a smatch false positive and the second one fixes
a potential bug.

drivers/net/wireless/iwlwifi/iwl-5000.c +786 iwl5000_txq_update_byte_cnt_tbl(37) error: buffer overflow 
'(scd_bc_tbl+txq_id)->tfd_offset' 320 <= 512
drivers/net/wireless/iwlwifi/iwl-5000.c +808 iwl5000_txq_inval_byte_cnt_tbl(19) error: buffer overflow 
'(scd_bc_tbl+txq_id)->tfd_offset' 320 <= 512

Signed-off-by: Dan Carpenter <error27@gmail.com>
Cc: stable@kernel.org
---
I don't have the hardware to test this change.

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index de45f30..b45150d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -781,7 +781,7 @@ void iwl5000_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
 
 	scd_bc_tbl[txq_id].tfd_offset[write_ptr] = bc_ent;
 
-	if (txq->q.write_ptr < TFD_QUEUE_SIZE_BC_DUP)
+	if (write_ptr < TFD_QUEUE_SIZE_BC_DUP)
 		scd_bc_tbl[txq_id].
 			tfd_offset[TFD_QUEUE_SIZE_MAX + write_ptr] = bc_ent;
 }
@@ -803,7 +803,7 @@ void iwl5000_txq_inval_byte_cnt_tbl(struct iwl_priv *priv,
 	bc_ent =  cpu_to_le16(1 | (sta_id << 12));
 	scd_bc_tbl[txq_id].tfd_offset[read_ptr] = bc_ent;
 
-	if (txq->q.write_ptr < TFD_QUEUE_SIZE_BC_DUP)
+	if (read_ptr < TFD_QUEUE_SIZE_BC_DUP)
 		scd_bc_tbl[txq_id].
 			tfd_offset[TFD_QUEUE_SIZE_MAX + read_ptr] =  bc_ent;
 }

