Return-Path: <linux-kernel-owner+w=401wt.eu-S1755532AbYL1XwV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755532AbYL1XwV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 18:52:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752649AbYL1XwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 18:52:04 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60123 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570AbYL1XwB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 18:52:01 -0500
Date: Mon, 29 Dec 2008 10:51:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "David S. Miller" <davem@davemloft.net>,
       Neil Horman <nhorman@tuxdriver.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Linus <torvalds@linux-foundation.org>, netdev@vger.kernel.org
Subject: linux-next: origin tree build failure
Message-Id: <20081229105159.585e4d25.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave, Neil,

Today's linux-next build (powerpc ppc64_defconfig) failed like this:

drivers/net/ehea/ehea_main.c: In function 'ehea_poll':
drivers/net/ehea/ehea_main.c:844: warning: passing argument 1 of 'netif_rx_reschedule' from incompatible pointer type
drivers/net/ehea/ehea_main.c:844: error: too many arguments to function 'netif_rx_reschedule'

Caused by commit 908a7a16b852ffd618a9127be8d62432182d81b4 ("net: Remove
unused netdev arg from some NAPI interfaces") which missed a call that
needed fixing up.  This commit was never in a linux-next tree.

I have added the below patch for today.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Mon, 29 Dec 2008 10:46:13 +1100
Subject: [PATCH] net: ehea NAPI interface cleanup fix

Commit 908a7a16b852ffd618a9127be8d62432182d81b4 ("net: Remove unused
netdev arg from some NAPI interfaces") missed one spot.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/net/ehea/ehea_main.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/ehea/ehea_main.c b/drivers/net/ehea/ehea_main.c
index 035aa7d..a2f1905 100644
--- a/drivers/net/ehea/ehea_main.c
+++ b/drivers/net/ehea/ehea_main.c
@@ -841,7 +841,7 @@ static int ehea_poll(struct napi_struct *napi, int budget)
 		if (!cqe && !cqe_skb)
 			return rx;
 
-		if (!netif_rx_reschedule(dev, napi))
+		if (!netif_rx_reschedule(napi))
 			return rx;
 
 		cqe_skb = ehea_proc_cqes(pr, EHEA_POLL_MAX_CQES);
-- 
1.6.0.5

