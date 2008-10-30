Return-Path: <linux-kernel-owner+w=401wt.eu-S1757621AbYJ3Rza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621AbYJ3Rza (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 13:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755150AbYJ3RzS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 13:55:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:23379 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754493AbYJ3RzQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 13:55:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,516,1220252400"; 
   d="scan'208";a="354094785"
Subject: Re: [2.6.28-rc2]: iwl4965 doesn't connect / cfg80211 failure
From: reinette chatre <reinette.chatre@intel.com>
To: Mirco Tischler <mt-ml@gmx.de>
Cc: "Zhu, Yi" <yi.zhu@intel.com>, Arjan van de Ven <arjan@infradead.org>,
       lkml <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       "John W.Linville" <linville@tuxdriver.com>,
       Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <20081030182433.0a4eb471@mtlp.12.dimension>
References: <20081028020212.0dfcb6c9@mtlp.12.dimension>
	 <1225157618.2917.215.camel@debian.sh.intel.com>
	 <20081027213217.53558319@infradead.org>
	 <1225171414.2917.229.camel@debian.sh.intel.com>
	 <20081028172418.3c8e91f1@mtlp.12.dimension>
	 <1225261084.2917.254.camel@debian.sh.intel.com>
	 <20081030182433.0a4eb471@mtlp.12.dimension>
Content-Type: text/plain
Date: Thu, 30 Oct 2008 10:55:38 -0700
Message-Id: <1225389338.1115.338.camel@rc-desk>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-10-30 at 10:24 -0700, Mirco Tischler wrote:
> On Wed, 29 Oct 2008 14:18:04 +0800, Zhu Yi wrote:
> > Can you try attached patch?
> > 
> > Thanks,
> > -yi
> I did. Didn't solve the problems but here's the output:

That helped us to obtain more information. Could you please try commit
9685e33a2c919c1e95cb7072988fc1e0f0bad3d9 ?

Reproduced here for convenience:

commit 9685e33a2c919c1e95cb7072988fc1e0f0bad3d9
Author: Mohamed Abbas <mohamed.abbas@intel.com>
Date:   Thu Oct 23 23:48:54 2008 -0700

    iwlwifi: clear scanning bits upon failure
    
    In iwl_bg_request_scan function, if we could not send a
    scan command it will go to done.
    In done it does the right thing to call mac80211 with
    scan complete, but the problem is STATUS_SCAN_HW is still
    set causing any future scan to fail. Fix by clearing the scanning status
    bits if scan fails.
    
    Signed-off-by: Mohamed Abbas <mohamed.abbas@intel.com>
    Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 3379b41..b0abf89 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -834,6 +834,13 @@ static void iwl_bg_request_scan(struct work_struct *data)
 	return;
 
  done:
+	/* Cannot perform scan. Make sure we clear scanning
+	* bits from status so next scan request can be performed.
+	* If we don't clear scanning status bit here all next scan
+	* will fail
+	*/
+	clear_bit(STATUS_SCAN_HW, &priv->status);
+	clear_bit(STATUS_SCANNING, &priv->status);
 	/* inform mac80211 scan aborted */
 	queue_work(priv->workqueue, &priv->scan_completed);
 	mutex_unlock(&priv->mutex);



