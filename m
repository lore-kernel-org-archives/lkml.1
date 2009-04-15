Return-Path: <linux-kernel-owner+w=401wt.eu-S1756928AbZDOXse@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928AbZDOXse (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 19:48:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752989AbZDOXsV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 19:48:21 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:37481
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751669AbZDOXsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 19:48:20 -0400
Date: Wed, 15 Apr 2009 16:48:11 -0700 (PDT)
Message-Id: <20090415.164811.19905145.davem@davemloft.net>
To: dada1@cosmosbay.com
Cc: shemminger@vyatta.com, kaber@trash.net, jeff.chua.linux@gmail.com,
       paulmck@linux.vnet.ibm.com, paulus@samba.org, mingo@elte.hu,
       torvalds@linux-foundation.org, laijs@cn.fujitsu.com, jengelh@medozas.de,
       r000n@r000n.net, linux-kernel@vger.kernel.org,
       netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
       benh@kernel.crashing.org
Subject: Re: [PATCH] netfilter: use per-cpu spinlock rather than RCU (v3)
From: David Miller <davem@davemloft.net>
In-Reply-To: <49E64C91.5020708@cosmosbay.com>
References: <49E5BDF7.8090502@trash.net>
	<20090415135526.2afc4d18@nehalam>
	<49E64C91.5020708@cosmosbay.com>
X-Mailer: Mew version 6.2.51 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <dada1@cosmosbay.com>
Date: Wed, 15 Apr 2009 23:07:29 +0200

> Well, it seems original patch was not so bad after all
> 
> http://lists.netfilter.org/pipermail/netfilter-devel/2006-January/023175.html
> 
> So change per-cpu spinlocks to per-cpu rwlocks 
> 
> and use read_lock() in ipt_do_table() to allow recursion...

Grumble, one more barrier to getting rid of rwlocks in the whole
tree. :-/

I really think we should entertain the idea where we don't RCU quiesce
when adding rules.  That was dismissed as not workable because the new
rule must be "visible" as soon as we return to userspace but let's get
real, effectively it will be.

If there are any stale object reference issues, we can use RCU object
destruction to handle that kind of thing.

I almost cringed when the per-spinlock idea was proposed, but per-cpu
rwlocks just takes things too far for my tastes.
