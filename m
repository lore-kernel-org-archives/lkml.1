Return-Path: <linux-kernel-owner+w=401wt.eu-S1753918AbZKWAxS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918AbZKWAxS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Nov 2009 19:53:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752434AbZKWAxR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Nov 2009 19:53:17 -0500
Received: from ozlabs.org ([203.10.76.45]:36154 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892AbZKWAxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Nov 2009 19:53:16 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Shirley Ma <mashirle@us.ibm.com>
Subject: Re: [PATCH 0/1] Defer skb allocation for both mergeable buffers and big packets in virtio_net
Date: Mon, 23 Nov 2009 11:23:18 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Avi Kivity <avi@redhat.com>,
       netdev@vger.kernel.org, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org, Anthony Liguori <anthony@codemonkey.ws>
References: <1258697359.7416.14.camel@localhost.localdomain>
In-Reply-To: <1258697359.7416.14.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <200911231123.18898.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Nov 2009 04:39:19 pm Shirley Ma wrote:
> Guest virtio_net receives packets from its pre-allocated vring 
> buffers, then it delivers these packets to upper layer protocols
> as skb buffs. So it's not necessary to pre-allocate skb for each
> mergable buffer, then frees it when it's useless. 
> 
> This patch has deferred skb allocation when receiving packets for
> both big packets and mergeable buffers. It reduces skb pre-allocations 
> and skb_frees.
> 
> Based on Mickael & Avi's suggestion. A destroy function has been created
> to push virtio free buffs to vring for unused pages, and used page private
> to maintain page list.
> 
> I didn't touch small packet skb allocation to avoid extra copies for small
> packets.
> 
> This patch has tested and measured against 2.6.32-rc5 git. It is built again
>  2.6.32-rc7 kernel. Tests have been done for small packets, big packets and
> mergeable buffers.
> 
> The single netperf TCP_STREAM performance improved for host to guest. 
> It also reduces UDP packets drop rate.
> 
> The netperf laptop results were:
> 
> mtu=1500
> netperf -H xxx -l 120
> 
> 		w/o patch	w/i patch (two runs)	
> guest to host:  3336.84Mb/s   3730.14Mb/s ~ 3582.88Mb/s
> 
> host to guest:  3165.10Mb/s   3370.39Mb/s ~ 3407.96Mb/s

Nice!

Is this using mergeable_rx_bufs?  Or just big_packets?

I'd like to drop big packet support from our driver, but I don't know
how many kvm hosts will not offer mergable rx bufs yet.  Anthony?

Thanks,
Rusty.
