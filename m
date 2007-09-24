Return-Path: <linux-kernel-owner+w=401wt.eu-S1754867AbXIXQnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbXIXQnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760993AbXIXQ2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:28:49 -0400
Received: from canuck.infradead.org ([209.217.80.40]:58159 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761087AbXIXQ2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:28:48 -0400
Date: Mon, 24 Sep 2007 09:22:49 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk, bunk@kernel.org,
       "David S. Miller" <davem@davemloft.net>
Subject: [48/50] Fix pktgen src_mac handling.
Message-ID: <20070924162249.GW13510@kroah.com>
References: <20070924161246.983665021@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-pktgen-src_mac-handling.patch"
In-Reply-To: <20070924161733.GA13510@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adit Ranadive <adit.262@gmail.com>

commit ce5d0b47f13f83dfb9fbb8ac91adad7120747aaf in mainline

Subject: [48/50] [PATCH] [PKTGEN]: srcmac fix

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>

---
 net/core/pktgen.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/net/core/pktgen.c
+++ b/net/core/pktgen.c
@@ -111,6 +111,9 @@
  *
  * 802.1Q/Q-in-Q support by Francesco Fondelli (FF) <francesco.fondelli@gmail.com>
  *
+ * Fixed src_mac command to set source mac of packet to value specified in
+ * command by Adit Ranadive <adit.262@gmail.com>
+ *
  */
 #include <linux/sys.h>
 #include <linux/types.h>
@@ -1415,8 +1418,11 @@ static ssize_t pktgen_if_write(struct fi
 	}
 	if (!strcmp(name, "src_mac")) {
 		char *v = valstr;
+		unsigned char old_smac[ETH_ALEN];
 		unsigned char *m = pkt_dev->src_mac;
 
+		memcpy(old_smac, pkt_dev->src_mac, ETH_ALEN);
+
 		len = strn_len(&user_buffer[i], sizeof(valstr) - 1);
 		if (len < 0) {
 			return len;
@@ -1445,6 +1451,10 @@ static ssize_t pktgen_if_write(struct fi
 			}
 		}
 
+		/* Set up Src MAC */
+		if (compare_ether_addr(old_smac, pkt_dev->src_mac))
+			memcpy(&(pkt_dev->hh[6]), pkt_dev->src_mac, ETH_ALEN);
+
 		sprintf(pg_result, "OK: srcmac");
 		return count;
 	}

-- 
