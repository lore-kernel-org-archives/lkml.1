Return-Path: <linux-kernel-owner+w=401wt.eu-S1752285AbZJ1Kr4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285AbZJ1Kr4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 06:47:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752002AbZJ1Krz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 06:47:55 -0400
Received: from ey-out-2122.google.com ([74.125.78.27]:44690 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbZJ1Krz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 06:47:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=Fe4NbqP9ZEt7B6X1/9+Cc+l1MDcChk9mcA8L2Ofkun2ij8v36KSYSZSdSSF5Ee2Om3
         Bsyfn1XxEF0+EtuyVOTmBR4RCri/sxr6HAam0GThF+lNMCSKnDRxgjueRms4hRqsyfyT
         PRKfOJCNacumd9W2RPKy4FyClcTxJScK0KrbU=
Message-ID: <4AE823DF.8010706@gmail.com>
Date: Wed, 28 Oct 2009 11:58:39 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] asix: fix unsetting of AX88172_MEDIUM_FD in ax88172_link_reset()
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

struct skb->len is unsigned so the `< 0' test always fails.
Besides, skb_pull ensures that skb->len does not wrap. Also
correctly unset the AX88172_MEDIUM_FD bit.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
 drivers/net/usb/asix.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

// vi drivers/net/usb/asix.c +77
#define AX88172_MEDIUM_FD		0x02

// vi drivers/net/usb/asix.c +80
#define AX88172_MEDIUM_DEFAULT \
		( AX88172_MEDIUM_FD | AX88172_MEDIUM_TX | AX88172_MEDIUM_FC )

diff --git a/drivers/net/usb/asix.c b/drivers/net/usb/asix.c
index 6ce7f77..26a9d46 100644
--- a/drivers/net/usb/asix.c
+++ b/drivers/net/usb/asix.c
@@ -346,11 +346,6 @@ static int asix_rx_fixup(struct usbnet *dev, struct sk_buff *skb)
 		packet = head + sizeof(header);
 		skb_pull(skb, 4);
 	}
-
-	if (skb->len < 0) {
-		deverr(dev,"asix_rx_fixup() Bad SKB Length %d", skb->len);
-		return 0;
-	}
 	return 1;
 }
 
@@ -798,7 +793,7 @@ static int ax88172_link_reset(struct usbnet *dev)
 	mode = AX88172_MEDIUM_DEFAULT;
 
 	if (ecmd.duplex != DUPLEX_FULL)
-		mode |= ~AX88172_MEDIUM_FD;
+		mode &= ~AX88172_MEDIUM_FD;
 
 	devdbg(dev, "ax88172_link_reset() speed: %d duplex: %d setting mode to 0x%04x", ecmd.speed, ecmd.duplex, mode);
 
