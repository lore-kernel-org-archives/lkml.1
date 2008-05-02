Return-Path: <linux-kernel-owner+w=401wt.eu-S933845AbYEBLXw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933845AbYEBLXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 07:23:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755745AbYEBLXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 07:23:40 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58545
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752482AbYEBLXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 07:23:39 -0400
Date: Fri, 02 May 2008 04:23:38 -0700 (PDT)
Message-Id: <20080502.042338.83904533.davem@davemloft.net>
To: paravpandit@yahoo.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: motive for sending Ethernet packets in soft-irq context
From: David Miller <davem@davemloft.net>
In-Reply-To: <989596.46222.qm@web30103.mail.mud.yahoo.com>
References: <989596.46222.qm@web30103.mail.mud.yahoo.com>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Parav Pandit <paravpandit@yahoo.com>
Date: Fri, 2 May 2008 02:16:07 -0700 (PDT)

[ Your question belongs on netdev, that's where the kernel
  networking developers hang out, CC:'d ]

> What I understand is,
> It is not done into the process context of send() system call beacause,

Where did you obtain this understanding?  It's not accurate :-)

It is actually done in the send() system call thread of execution most
of the time.  soft-irqs are simply disabled during the
->hard_start_xmit() driver call so that input packet processing cannot
execute on the local cpu while this happens.

However, many packets are sent in response to received
packets.  In this case, since receive packets are
processed in soft-irq context, the response will be
sent in such a context too.

This applies for TCP data queued up waiting for the congestion
window or TCP window to open up.  When an ACK arrives which
satisfies the necessary conditions, queued up socket
data packets are send, again in soft-irq context.

So whether we send to the network card in soft-irq context
or not is entirely situation dependent.
