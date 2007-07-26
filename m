Return-Path: <linux-kernel-owner+w=401wt.eu-S1762542AbXGZJzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762542AbXGZJzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 05:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753738AbXGZJzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 05:55:23 -0400
Received: from ik-out-1112.google.com ([66.249.90.176]:3623 "EHLO
	ik-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752865AbXGZJzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 05:55:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=SLOzrboiBIzdvZt987QxrSVmrOQbiwgbg1X9VyVJ6bWXrtmpx4axSLTjh/pZUgwse0uzHTr8IESbS3H0AsuGCIa1BKYwN9YbwFD/IVGDlP8+58KPELZB28LDxT8Nhi1XGcsE8IKyD/kP+7WDt+PGArhtWGM7xJ4tkJtYUpxPSuU=
Message-ID: <416aa1ad0707260255h650468f5m67cef596523f949e@mail.gmail.com>
Date: Thu, 26 Jul 2007 15:25:20 +0530
From: "kalash nainwal" <kalash.nainwal@gmail.com>
To: netdev@vger.kernel.org
Subject: inconsistency in dev->hard_header() arguments?
Cc: linux-kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The function is called like this- dev->hard_header(skb, dev, ptype,
dest_hw, src_hw, skb->len); where "skb->protocol" is same as "ptype",
but the former is expected to be in network byte order before calling
hard_header, while latter in host byte order (eth_header internally
does its own conversion of ptype). Is this deliberate? or a bug?

We've a driver, which sends pkt over ethernet. Here's the sample send routine-

my_eth_send(struct sk_buff * mp, struct net_device *dev, int linkno)
{
<snip>
        mp->protocol = link->ln_sap;
        mp->nh.raw = mp->data;
        dev->hard_header(mp, mp->dev, ntohs(link->ln_sap),
                dest_node->n_linkinfo[linkno].n_addr,
                src_node->n_linkinfo[linkno].n_addr,
                mp->len);
         dev_queue_xmit(mp);
}

We store the type field (i.e., link->ln_sap) in our driver in network
byte order only (as skb->protocol is expected to be in network byte
order), but as eth_header internally does the conversion again, we've
to un-convert it (for every outgoing pkt!!) unnecessarily. We can get
away with this by using two different variables for ptype- one in n/w
order, other in host order; but unless there's some hidden magic
behind the current behavior, I'd like to send a patch to fix this in
kernel. Or if you think it would touch too many files, might break too
many things...we can let it be.

Regards,
-Kalash
