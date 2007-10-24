Return-Path: <linux-kernel-owner+w=401wt.eu-S1754049AbXJXEAa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754049AbXJXEAa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 00:00:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750702AbXJXEAW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 00:00:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36626
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750701AbXJXEAV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 00:00:21 -0400
Date: Tue, 23 Oct 2007 21:00:06 -0700 (PDT)
Message-Id: <20071023.210006.28787642.davem@davemloft.net>
To: chuck.lever@oracle.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/5] NET: Make ts_recent_stamp unsigned
From: David Miller <davem@davemloft.net>
In-Reply-To: <20071023154428.28115.10406.stgit@ingres.1015granger.net>
References: <20071023154428.28115.10406.stgit@ingres.1015granger.net>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>
Date: Tue, 23 Oct 2007 11:44:28 -0400

> The get_seconds() function returns an unsigned long.  To prevent incorrect
> comparison results between values saved in ts_recent_stamp and later
> invocations of get_seconds(), change the type of ts_recent_stamp to match
> the return type of get_seconds().
> 
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> Cc: <netdev@vger.kernel.org>

I see two potential problems with this patch:

1) If you update struct tcp_options_received you should also
   update struct tcp_timewait_sock similarly.

   The fact that you missed this suggests that you didn't
   grep the tree to see how else this variable is used and
   this makes me extra concerned about this patch's correctness.

2) There are computations in the TCP stack using this member that
   probably care about the signedness, such as:

net/ipv4/tcp_ipv4.c:			     get_seconds() - tcptw->tw_ts_recent_stamp > 1))) {
include/net/tcp.h:	if (get_seconds() >= rx_opt->ts_recent_stamp + TCP_PAWS_24DAYS)
include/net/tcp.h:	if (get_seconds() >= rx_opt->ts_recent_stamp + TCP_PAWS_24DAYS)

   We should make sure we understand what is expected here, and
   why it would still be correct after making both ts_recent_stamp
   members unsigned.

Thanks.
