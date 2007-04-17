Return-Path: <linux-kernel-owner+w=401wt.eu-S1751674AbXDQGxu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751674AbXDQGxu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2007 02:53:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751693AbXDQGxu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Apr 2007 02:53:50 -0400
Received: from nz-out-0506.google.com ([64.233.162.229]:5542 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672AbXDQGxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2007 02:53:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=akWhwbfjIgIEGJ4S6cpLQbOxFlGhso7nbP+yaUSGeAhE3d1EkwzEBKe0uutqu42uLOhqlPlBECT/fzUsZI6bp2iMWhRRsneZeOkXdJvYPyrtJc02KhnZS8sv93om1E8f+F57PQYT9dcPIy3M7sBIO+qzzRu2RD9ReCDNkT6X+4g=
Message-ID: <6d6a94c50704162353p2b96b3e4kd05489a59aa9bba7@mail.gmail.com>
Date: Tue, 17 Apr 2007 14:53:48 +0800
From: "Aubrey Li" <aubreylee@gmail.com>
To: davem@davemloft.net, kuznet@ms2.inr.ac.ru, pekkas@netcore.fi,
       jmorris@namei.org, kaber@coreworks.de
Subject: [PATCH] Fix UDP checksum issue in net poll mode.
Cc: netdev@vger.kernel.org, "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In net poll mode, the current checksum function doesn't consider the
kind of packet which is padded to reach a specific minimum length. I
believe that's the problem causing my test case failed. The following
patch fixed this issue.

Signed-off-by: Aubrey.Li <aubreylee@gmail.com>
---
 net/core/netpoll.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 823215d..522e441 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -471,6 +471,13 @@ int __netpoll_rx(struct sk_buff *skb)
 	if (skb->len < len || len < iph->ihl*4)
 		goto out;

+	/*
+	 * Our transport medium may have padded the buffer out.
+	 * Now We trim to the true length of the frame.
+	 */
+	if (pskb_trim_rcsum(skb, len))
+		goto out;
+
 	if (iph->protocol != IPPROTO_UDP)
 		goto out;

-- 
1.5.1
