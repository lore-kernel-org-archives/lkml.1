Return-Path: <linux-kernel-owner+w=401wt.eu-S1759411AbXE0VOk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759411AbXE0VOk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2007 17:14:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756446AbXE0VOa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 May 2007 17:14:30 -0400
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:36374
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753693AbXE0VO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2007 17:14:29 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Maximilian Engelhardt <maxi@daemonizer.de>
Subject: Re: b44: regression in 2.6.22 (resend)
Date: Sun, 27 May 2007 23:13:32 +0200
User-Agent: KMail/1.9.6
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
       "linux-wireless" <linux-wireless@vger.kernel.org>,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
       Jeff Garzik <jgarzik@pobox.com>, Gary Zambrano <zambrano@broadcom.com>,
       netdev@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <20070525172431.60affaca@freepuppy> <200705261901.18110.mb@bu3sch.de> <200705272125.25506.maxi@daemonizer.de>
In-Reply-To: <200705272125.25506.maxi@daemonizer.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200705272313.33129.mb@bu3sch.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 27 May 2007 21:25:17 Maximilian Engelhardt wrote:
> 2.6.21.1:
> [  5] local 192.168.1.2 port 58414 connected with 192.168.1.1 port 5001
> [  5]  0.0-60.6 sec  1.13 MBytes    157 Kbits/sec
> [  4] local 192.168.1.2 port 5001 connected with 192.168.1.1 port 57837
> [  4]  0.0-63.1 sec  2.82 MBytes    375 Kbits/sec

> 2.6.22-rc3:
> [  5] local 192.168.1.2 port 46557 connected with 192.168.1.1 port 5001
> [  5]  0.0-60.4 sec  58.9 MBytes  8.18 Mbits/sec
> [  4] local 192.168.1.2 port 5001 connected with 192.168.1.1 port 51633
> [  4]  0.0-63.1 sec  7.27 MBytes    967 Kbits/sec

This is the diff between these two kernels.
I'm not sure why you see a much better TX throughput here.

Can you re-check to make sure it's not just some test-jitter?


--- linux-2.6.21.1/drivers/net/b44.c    2007-05-27 22:58:01.000000000 +0200
+++ linux-2.6.22-rc3/drivers/net/b44.c  2007-05-27 23:01:44.000000000 +0200
@@ -825,12 +825,11 @@
                        if (copy_skb == NULL)
                                goto drop_it_no_recycle;
 
-                       copy_skb->dev = bp->dev;
                        skb_reserve(copy_skb, 2);
                        skb_put(copy_skb, len);
                        /* DMA sync done above, copy just the actual packet */
-                       memcpy(copy_skb->data, skb->data+bp->rx_offset, len);
-
+                       skb_copy_from_linear_data_offset(skb, bp->rx_offset,
+                                                        copy_skb->data, len);
                        skb = copy_skb;
                }
                skb->ip_summed = CHECKSUM_NONE;
@@ -1007,7 +1006,8 @@
                        goto err_out;
                }
 
-               memcpy(skb_put(bounce_skb, len), skb->data, skb->len);
+               skb_copy_from_linear_data(skb, skb_put(bounce_skb, len),
+                                         skb->len);
                dev_kfree_skb_any(skb);
                skb = bounce_skb;
        }

-- 
Greetings Michael.
