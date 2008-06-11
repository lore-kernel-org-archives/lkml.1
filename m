Return-Path: <linux-kernel-owner+w=401wt.eu-S1759337AbYFKXxT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759337AbYFKXxT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 19:53:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756352AbYFKXw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 19:52:58 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:48483
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1758936AbYFKXwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 19:52:55 -0400
Date: Wed, 11 Jun 2008 16:52:55 -0700 (PDT)
Message-Id: <20080611.165255.242691774.davem@davemloft.net>
To: kuznet@ms2.inr.ac.ru
Cc: vgusev@openvz.org, mcmanus@ducksong.com, xemul@openvz.org,
       netdev@vger.kernel.org, ilpo.jarvinen@helsinki.fi, mingo@elte.hu,
       linux-kernel@vger.kernel.org
Subject: Re: [TCP]: TCP_DEFER_ACCEPT causes leak sockets
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080611135718.GA26914@ms2.inr.ac.ru>
References: <200806111658.41182.vgusev@openvz.org>
	<20080611135718.GA26914@ms2.inr.ac.ru>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>
Date: Wed, 11 Jun 2008 17:57:18 +0400

> Major issue is that tcp_defer_accept_check() manipulates with not locked
> listening socket. And from all that I know it is impossible to take
> the lock in this context.
> 
> Also I see no accounting for those sockets. With this patch any server, which
> set deferred accept, can be flooded with sockets until memory exhausts.
> I did not test and would be glad to be mistaken.
> 
> 
> Issue with locking can be solved by adding a separate spinlock for
> manipulations with accept_queue. Apparently, accounting and killing
> sockets, which become stale after closing listening socket and
> are going to be alive for up to 65535 seconds, also goes under this lock.
> 
> Frankly, cost looks too high for this feature.
> 
> Hiding from accept() sockets with only out-of-order data only
> is the only thing which is impossible with old approach. Is this really
> so valuable? My opinion: no, this is nothing but a new loophole
> to consume memory without control.

Yes, we discussed the locking issue over past few days.  See
the thread: "stuck localhost TCP connections, v2.6.26-rc3+"

More and more, the arguments are mounting to completely revert the
established code path changes, and frankly that is likely what I am
going to do by the end of today.
