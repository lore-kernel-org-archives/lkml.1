Return-Path: <linux-kernel-owner+w=401wt.eu-S2992438AbXDLKbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992438AbXDLKbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 06:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946120AbXDLKbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 06:31:33 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:56422 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946078AbXDLKbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 06:31:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=i4Gwyye6SbMqliP1iIT+TY2sTJk4B5vdhutvjTGJe9ZWdemiGC5t0T+Sx4NNZnvzJRMV9rauimJdor1vlK82JcSHmPC4UxYco2/nt6P+75itG3NFHYidKT4Jz+GWB86pqYKAimLHAQP052f2fgyhUFvsEt+Id3mYtSqHqkGoWjk=
Message-ID: <6d6a94c50704120331m36957148iae111ab7324c88c2@mail.gmail.com>
Date: Thu, 12 Apr 2007 18:31:30 +0800
From: "Aubrey Li" <aubreylee@gmail.com>
To: "Stephen Hemminger" <shemminger@osdl.org>,
       "Herbert Xu" <herbert@gondor.apana.org.au>,
       "Matt Mackall" <mpm@selenic.com>
Subject: udp checksum issue in netpoll mode.
Cc: netdev@vger.kernel.org, "Linux Kernel" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I think we discussed this issue before.

The current checksum function doesn't consider the kind of packet
which is padded to reach a specific minimum length. I believe that's
the problem caused my test case failed. Is this issue fixed? Or is it
acceptable if I make a patch not calculating this kind of packet?

Thanks,
-Aubrey
===============================================
static __sum16 checksum_udp(struct sk_buff *skb, struct udphdr *uh,
                            unsigned short ulen, __be32 saddr, __be32 daddr)
{
        __wsum psum;

        if (uh->check == 0 || skb->ip_summed == CHECKSUM_UNNECESSARY)
                return 0;

        psum = csum_tcpudp_nofold(saddr, daddr, ulen, IPPROTO_UDP, 0);
        if (skb->ip_summed == CHECKSUM_COMPLETE &&
            !csum_fold(csum_add(psum, skb->csum)))
                return 0;

        skb->csum = psum;

        return __skb_checksum_complete(skb);
}
===============================================
