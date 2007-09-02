Return-Path: <linux-kernel-owner+w=401wt.eu-S933824AbXIBBSq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933824AbXIBBSq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2007 21:18:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933388AbXIBBSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Sep 2007 21:18:37 -0400
Received: from wa-out-1112.google.com ([209.85.146.179]:4462 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933003AbXIBBSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2007 21:18:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=rhStz40uQpYRsr1bWc/LXPs+PWDH+7c1TiYp2YvaBk/bKhj8eQzWwjl3gH9y5dO+ri/veUSDKilPtT4kk9YM5KkzGwjISX3aUzEN9yh76+GXxTL4vKhWzzVQB4tAbJOX8T4btIAjob/C6oM+VDFL0IfFvw6Wx1YG7aATDs0dBbo=
Message-ID: <d2ad857f0709011818o7954b40csfc9d5267f9fb3f8b@mail.gmail.com>
Date: Sat, 1 Sep 2007 21:18:35 -0400
From: "Adit Ranadive" <adit.262@gmail.com>
To: netdev@vger.kernel.org
Subject: PATCH - Pktgen srcmac fix - Kernel 2.6.22.6
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

diff -urNp linux-orig/net/core/pktgen.c linux-mod/net/core/pktgen.c
--- linux-orig/net/core/pktgen.c        2007-08-31 02:21:01.000000000 -0400
+++ linux-mod/net/core/pktgen.c 2007-09-01 20:51:22.000000000 -0400
@@ -111,6 +111,9 @@
  *
  * 802.1Q/Q-in-Q support by Francesco Fondelli (FF)
<francesco.fondelli@gmail.com>
  *
+ * Fixed src_mac command to set source mac of packet to value specified in
+ * command by Adit Ranadive <adit.262@gmail.com>
+ *
  */
 #include <linux/sys.h>
 #include <linux/types.h>
@@ -1415,7 +1418,9 @@ static ssize_t pktgen_if_write(struct fi
        }
        if (!strcmp(name, "src_mac")) {
                char *v = valstr;
+               unsigned char old_smac[ETH_ALEN];
                unsigned char *m = pkt_dev->src_mac;
+               memcpy(old_smac, pkt_dev->src_mac, ETH_ALEN);

                len = strn_len(&user_buffer[i], sizeof(valstr) - 1);
                if (len < 0) {
@@ -1445,6 +1450,10 @@ static ssize_t pktgen_if_write(struct fi
                        }
                }

+               /* Set up Src MAC */
+               if (compare_ether_addr(old_smac, pkt_dev->src_mac))
+                       memcpy(&(pkt_dev->hh[6]), pkt_dev->src_mac, ETH_ALEN);
+
                sprintf(pg_result, "OK: srcmac");
                return count;
        }


-- 
Adit Ranadive
MS CS Candidate
Georgia Institute of Technology,
Atlanta, GA
