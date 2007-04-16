Return-Path: <linux-kernel-owner+w=401wt.eu-S1752076AbXDPKCO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752076AbXDPKCO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 06:02:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752820AbXDPKCO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 06:02:14 -0400
Received: from wr-out-0506.google.com ([64.233.184.238]:10865 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751892AbXDPKCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 06:02:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SPfeQ2+KTY9+xU8IAXH7Jes3sQ8+TJ8+Tz2/4ecsSMjyuF6OMe0lcGN5nIkklUSuPt0QacHO1kcn3MLptph+75G2Woc4kjPXQxVcOy+aS+W12+7F1hgL0VAwDvPifgfq1LwL5hJiet5Zp389oLeFkZVzuJFTglX6sdf7jrADTmY=
Message-ID: <6d6a94c50704160302n14f8bf14l3c9f2a380f74dd3f@mail.gmail.com>
Date: Mon, 16 Apr 2007 18:02:09 +0800
From: "Aubrey Li" <aubreylee@gmail.com>
To: "Stephen Hemminger" <shemminger@linux-foundation.org>
Subject: Re: udp checksum issue in netpoll mode.
Cc: "Herbert Xu" <herbert@gondor.apana.org.au>,
       "Matt Mackall" <mpm@selenic.com>, netdev@vger.kernel.org,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <461E470B.5060907@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6d6a94c50704120331m36957148iae111ab7324c88c2@mail.gmail.com>
	 <461E470B.5060907@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/12/07, Stephen Hemminger <shemminger@linux-foundation.org> wrote:
> Aubrey Li wrote:
> > I think we discussed this issue before.
> >
> > The current checksum function doesn't consider the kind of packet
> > which is padded to reach a specific minimum length. I believe that's
> > the problem caused my test case failed. Is this issue fixed? Or is it
> > acceptable if I make a patch not calculating this kind of packet?
> >
> > Thanks,
> > -Aubrey
> The caller should be trimming the packet and updating the hardware checksum
> value (like the normal UDP path).
>
OK, the following patch fixed the problem.

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
