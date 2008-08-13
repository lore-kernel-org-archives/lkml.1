Return-Path: <linux-kernel-owner+w=401wt.eu-S1755898AbYHMKh7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755898AbYHMKh7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 06:37:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbYHMKht
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 06:37:49 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34472
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751951AbYHMKhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 06:37:48 -0400
Date: Wed, 13 Aug 2008 03:37:49 -0700 (PDT)
Message-Id: <20080813.033749.165504341.davem@davemloft.net>
To: vegard.nossum@gmail.com, vegardno@ifi.uio.no
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, jgarzik@pobox.com,
       adobriyan@gmail.com
Subject: Re: [RFC][PATCH] netconsole: avoid deadlock on printk from driver
 code
From: David Miller <davem@davemloft.net>
In-Reply-To: <20080813095324.GA15055@ben.ifi.uio.no>
References: <20080813095324.GA15055@ben.ifi.uio.no>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vegard Nossum <vegardno@ifi.uio.no>
Date: Wed, 13 Aug 2008 11:53:24 +0200

> [PATCH] netconsole: avoid deadlock on printk from driver code
> 
> I encountered a hard-to-debug deadlock when I pulled out the plug of my
> RealTek 8139 which was also running netconsole: The driver wants to print
> a "link down" message. However, this triggers netconsole, which wants to
> print the message using the same device. Here is a backtrace:

See my other reply, this is absolutely the wrong way to go about
this.

You only have two sane options:

1) Defer the link status printk message into a deferred context,
   such as a workqueue, so that you can do it outside of the
   lock.

2) Do your locking differently so that the link status handling
   locking does not bisect the locking used for packet transmit
   in ->hard_start_xmit().

#2 is the reason why most other drivers don't have this silly
bug, they don't hold TX path locks when handling link status
and printing out such messages.
