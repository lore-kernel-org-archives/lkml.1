Return-Path: <linux-kernel-owner+w=401wt.eu-S1751862AbZIOJI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbZIOJI4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 05:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751327AbZIOJIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 05:08:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:40220
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751205AbZIOJIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 05:08:46 -0400
Date: Tue, 15 Sep 2009 02:09:03 -0700 (PDT)
Message-Id: <20090915.020903.93643290.davem@davemloft.net>
To: yi.zhu@intel.com
Cc: mel@csn.ul.ie, reinette.chatre@intel.com, elendil@planet.nl,
       Larry.Finger@lwfinger.net, linville@tuxdriver.com,
       penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
       akpm@linux-foundation.org, cl@linux-foundation.org,
       assaf.krauss@intel.com, johannes@sipsolutions.net,
       mohamed.abbas@intel.com, netdev@vger.kernel.org
Subject: Re: alloc skb based on a given data buffer
From: David Miller <davem@davemloft.net>
In-Reply-To: <1253005050.7549.58.camel@debian>
References: <1253003420.7549.51.camel@debian>
	<20090915.013321.07006714.davem@davemloft.net>
	<1253005050.7549.58.camel@debian>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhu Yi <yi.zhu@intel.com>
Date: Tue, 15 Sep 2009 16:57:29 +0800

> Thanks. So we can put the 8K buffer into 2 skb_shinfo()->frags[] slots
> and set nr_frags to 2, right? Is this supported allover the network code
> already? At a first glance, I didn't find any frags handling in mac80211
> stack.

You have to pre-pull the link level protocol headers into the
linear area, but that's it.

Again, see niu.c for details, it does:

static void niu_rx_skb_append(struct sk_buff *skb, struct page *page,
			      u32 offset, u32 size)
{
	int i = skb_shinfo(skb)->nr_frags;
	skb_frag_t *frag = &skb_shinfo(skb)->frags[i];

	frag->page = page;
	frag->page_offset = offset;
	frag->size = size;

	skb->len += size;
	skb->data_len += size;
	skb->truesize += size;

	skb_shinfo(skb)->nr_frags = i + 1;
}

to add pages to SKBs and then at the end it goes:

	skb_reserve(skb, NET_IP_ALIGN);
	__pskb_pull_tail(skb, min(len, NIU_RXPULL_MAX));

Right before giving the SKB to the networking stack.  NIU_RXPULL_MAX
should be a value that will be large enough to cover the largest
possible link level header.
