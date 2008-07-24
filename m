Return-Path: <linux-kernel-owner+w=401wt.eu-S1750975AbYGXHAy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750975AbYGXHAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 03:00:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751431AbYGXHA1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 03:00:27 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:51488 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbYGXHAZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 03:00:25 -0400
Subject: Re: Kernel WARNING: at net/core/dev.c:1330
	__netif_schedule+0x2c/0x98()
From: Peter Zijlstra <peterz@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: jarkao2@gmail.com, Larry.Finger@lwfinger.net, kaber@trash.net,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-wireless@vger.kernel.org, mingo@redhat.com
In-Reply-To: <20080723.131441.200166513.davem@davemloft.net>
References: <1216806614.7257.152.camel@twins>
	 <20080723101352.GD4561@ff.dom.local> <1216810696.7257.175.camel@twins>
	 <20080723.131441.200166513.davem@davemloft.net>
Content-Type: text/plain
Date: Thu, 24 Jul 2008 09:00:23 +0200
Message-Id: <1216882823.7257.229.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-07-23 at 13:14 -0700, David Miller wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Wed, 23 Jul 2008 12:58:16 +0200
> 
> > So I guess my question is, is netif_tx_lock() here to stay, or is the
> > right fix to convert all those drivers to use __netif_tx_lock() which
> > locks only a single queue?
> 
> It's staying.
> 
> It's trying to block all potential calls into the ->hard_start_xmit()
> method of the driver, and the only reliable way to do that is to take
> all the TX queue locks.  And in one form or another, we're going to
> have this "grab/release all the TX queue locks" construct.
> 
> I find it interesting that this cannot be simply described to lockdep
> :-)

If you think its OK to take USHORT_MAX locks at once, I'm afraid we'll
have to agree to disagree :-/

Thing is, lockdep wants to be able to describe the locking hierarchy
with classes, and each class needs to be in static storage for various
reasons.

So if you make a locking hierarchy that is USHORT_MAX deep, you need at
least that amount of static classes.

Also, you'll run into the fact that lockdep will only track like 48 held
locks, after that it self terminates.

I'm aware of only 2 sites in the kernel that break this limit. The
down-side of stretching this limit is that deep lock chains come with
costs (esp so on -rt), so I'm not particularly eager to grow this - it
might give the impresssion its a good idea to have very long lock
chains.

