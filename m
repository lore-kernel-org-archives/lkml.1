Return-Path: <linux-kernel-owner+w=401wt.eu-S1754698AbZICGcM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698AbZICGcM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 02:32:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754675AbZICGcM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 02:32:12 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42674
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754535AbZICGcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 02:32:10 -0400
Date: Wed, 02 Sep 2009 23:32:25 -0700 (PDT)
Message-Id: <20090902.233225.203837229.davem@davemloft.net>
To: fengguang.wu@intel.com
Cc: herbert@gondor.apana.org.au, acme@ghostprotocols.net,
       linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH][RESEND] tcp: replace hard coded GFP_KERNEL with
 sk_allocation
From: David Miller <davem@davemloft.net>
In-Reply-To: <20090902.231017.31926895.davem@davemloft.net>
References: <20090903040407.GA20094@localhost>
	<20090902.231017.31926895.davem@davemloft.net>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Wed, 02 Sep 2009 23:10:17 -0700 (PDT)

> From: Wu Fengguang <fengguang.wu@intel.com>
> Date: Thu, 3 Sep 2009 12:04:07 +0800
> 
>> This fixed a lockdep warning which appeared when doing stress
>> memory tests over NFS:
>> 
>> 	inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
>> 
>> 	page reclaim => nfs_writepage => tcp_sendmsg => lock sk_lock
>> 
>> 	mount_root => nfs_root_data => tcp_close => lock sk_lock =>
>> 			tcp_send_fin => alloc_skb_fclone => page reclaim
>> 
>> David raised a concern that if the allocation fails in tcp_send_fin(), and it's
>> GFP_ATOMIC, we are going to yield() (which sleeps) and loop endlessly waiting
>> for the allocation to succeed.
>> 
>> But fact is, the original GFP_KERNEL also sleeps. GFP_ATOMIC+yield() looks
>> weird, but it is no worse the implicit sleep inside GFP_KERNEL. Both could
>> loop endlessly under memory pressure.
>> 
>> CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
>> CC: David S. Miller <davem@davemloft.net>
>> CC: Herbert Xu <herbert@gondor.apana.org.au>
>> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> 
> Applied to net-next-2.6, thanks!

You obviously didn't build test this with TCP MD5 support
enabled, that fails.

I'm fixing it up, but if you're going to go through the motions
of submitting a patch multiple times, at least do a thorough
build test of the code you're changing.
