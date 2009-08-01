Return-Path: <linux-kernel-owner+w=401wt.eu-S1752761AbZHAI6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbZHAI6c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Aug 2009 04:58:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752407AbZHAI6b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Aug 2009 04:58:31 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:51139 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751835AbZHAI6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Aug 2009 04:58:30 -0400
Date: Sat, 1 Aug 2009 10:55:53 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: [PATCH 10/10] drivers/net/wireless: introduce missing kfree
Message-ID: <Pine.LNX.4.64.0908011055250.23408@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Error handling code following a kzalloc should free the allocated data.

The semantic match that finds the problem is as follows:
(http://www.emn.fr/x-info/coccinelle/)

// <smpl>
@r exists@
local idexpression x;
statement S;
expression E;
identifier f,f1,l;
position p1,p2;
expression *ptr != NULL;
@@

x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
<... when != x
     when != if (...) { <+...x...+> }
(
x->f1 = E
|
 (x->f1 == NULL || ...)
|
 f(...,x->f1,...)
)
...>
(
 return \(0\|<+...x...+>\|ptr\);
|
 return@p2 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
---
 drivers/net/wireless/iwmc3200wifi/commands.c   |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwmc3200wifi/commands.c b/drivers/net/wireless/iwmc3200wifi/commands.c
index 0d66370..2bf9ef9 100644
--- a/drivers/net/wireless/iwmc3200wifi/commands.c
+++ b/drivers/net/wireless/iwmc3200wifi/commands.c
@@ -233,6 +233,7 @@ int iwm_store_rxiq_calib_result(struct iwm_priv *iwm)
 	eeprom_rxiq = iwm_eeprom_access(iwm, IWM_EEPROM_CALIB_RXIQ);
 	if (IS_ERR(eeprom_rxiq)) {
 		IWM_ERR(iwm, "Couldn't access EEPROM RX IQ entry\n");
+		kfree(rxiq);
 		return PTR_ERR(eeprom_rxiq);
 	}
 
