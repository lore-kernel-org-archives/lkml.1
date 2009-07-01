Return-Path: <linux-kernel-owner+w=401wt.eu-S1763952AbZGAAv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763952AbZGAAv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761369AbZGAAeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:34:24 -0400
Received: from kroah.org ([198.145.64.141]:60124 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761084AbZGAAeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:34:21 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:17 2009
Message-Id: <20090701002417.581497504@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:23:05 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Andy Gospodarek <andy@greyhouse.net>,
       Alexander Duyck <alexander.h.duyck@intel.com>,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 016/108] e1000e: stop unnecessary polling when using msi-x
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=e1000e-stop-unnecessary-polling-when-using-msi-x.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Andy Gospodarek <andy@greyhouse.net>

[ Upstream commit 679e8a0f0ae3333e94b1d374d07775fce9066025 ]

The last hunk of this commit:

    commit 12d04a3c12b420f23398b4d650127642469a60a6
    Author: Alexander Duyck <alexander.h.duyck@intel.com>
    Date:   Wed Mar 25 22:05:03 2009 +0000

        e1000e: commonize tx cleanup routine to match e1000 & igb

changed the logic for determining if we should call napi_complete or
not at then end of a napi poll.

If the NIC is using MSI-X with no work to do in ->poll, net_rx_action
can just spin indefinitely on older kernels and for 2 jiffies on newer
kernels since napi_complete is never called and budget isn't
decremented.

Discovered and verified while testing driver backport to an older
kernel.

Signed-off-by: Andy Gospodarek <andy@greyhouse.net>
Acked-by: Alexander Duyck <alexander.h.duyck@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/e1000e/netdev.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/e1000e/netdev.c
+++ b/drivers/net/e1000e/netdev.c
@@ -1996,7 +1996,7 @@ static int e1000_clean(struct napi_struc
 	struct e1000_adapter *adapter = container_of(napi, struct e1000_adapter, napi);
 	struct e1000_hw *hw = &adapter->hw;
 	struct net_device *poll_dev = adapter->netdev;
-	int tx_cleaned = 0, work_done = 0;
+	int tx_cleaned = 1, work_done = 0;
 
 	adapter = netdev_priv(poll_dev);
 


