Return-Path: <linux-kernel-owner+w=401wt.eu-S1756255AbZICT5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756255AbZICT5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 15:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756235AbZICT5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 15:57:44 -0400
Received: from gw1.cosmosbay.com ([212.99.114.194]:48548 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756214AbZICT5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 15:57:43 -0400
Message-ID: <4AA01F54.4040808@gmail.com>
Date: Thu, 03 Sep 2009 21:56:04 +0200
From: Eric Dumazet <eric.dumazet@gmail.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Christoph Lameter <cl@linux-foundation.org>,
       Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Patrick McHardy <kaber@trash.net>, Robin Holt <holt@sgi.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesper Dangaard Brouer <hawk@comx.dk>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Netfilter Developers <netfilter-devel@vger.kernel.org>,
       paulmck@linux.vnet.ibm.com, "stable@kernel.org" <stable@kernel.org>
Subject: Re: [PATCH] slub: Fix kmem_cache_destroy() with SLAB_DESTROY_BY_RCU
References: <c4e36d110908110542l3de51aaepcbd62c84b9848f2b@mail.gmail.com>	 <4A9EEF07.5070800@gmail.com>	 <c4e36d110909021531v324a9ce2x3ff2c93b7c5a57de@mail.gmail.com>	 <4A9F1620.2080105@gmail.com>	 <84144f020909022331x2b275aa5n428f88670e0ae8bc@mail.gmail.com>	 <4A9F7283.1090306@gmail.com>	 <84144f020909030051u6cf6ae01he25c268f718ff3af@mail.gmail.com>	 <alpine.DEB.1.10.0909031246010.27903@V090114053VZO-1>	 <84144f020909030705x7909cf07w7ea0d3662a66c5cc@mail.gmail.com>	 <4A9FD047.9000002@gmail.com> <84144f020909031248s56c16205j7992930c413b1bbe@mail.gmail.com>
In-Reply-To: <84144f020909031248s56c16205j7992930c413b1bbe@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 03 Sep 2009 21:56:05 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg a écrit :
> On Thu, Sep 3, 2009 at 5:18 PM, Eric Dumazet<eric.dumazet@gmail.com> wrote:
>> Here is the second patch (RCU thing). Stable candidate
>>
>> [PATCH] slub: Fix kmem_cache_destroy() with SLAB_DESTROY_BY_RCU
>>
>> kmem_cache_destroy() should call rcu_barrier() *after* kmem_cache_close()
>> and *before* sysfs_slab_remove() or risk rcu_free_slab()
>> being called after kmem_cache is deleted (kfreed).
>>
>> rmmod nf_conntrack can crash the machine because it has to
>> kmem_cache_destroy() a SLAB_DESTROY_BY_RCU enabled cache.
> 
> Do we have a bugzilla URL for this?

Well, I can crash my 2.6.30.5 machine just doing rmmod nf_conntrack

(You'll need CONFIG_SLUB_DEBUG_ON or equivalent)

Original Zdenek report : http://thread.gmane.org/gmane.linux.kernel/876016/focus=876086

> 
>> Reported-by: Zdenek Kabelac <zdenek.kabelac@gmail.com>
>> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
>> Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> OK, this is in for-next now and queued for 2.6.31. If you guys want to
> fix this in a different way, lets do that in 2.6.32.

Seems the right thing IMHO
