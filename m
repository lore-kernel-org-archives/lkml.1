Return-Path: <linux-kernel-owner+w=401wt.eu-S1758729AbYEMHrT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758729AbYEMHrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 03:47:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756589AbYEMHrG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 03:47:06 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:38882
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618AbYEMHrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 03:47:05 -0400
Message-ID: <48294776.3010504@qumranet.com>
Date: Tue, 13 May 2008 10:47:02 +0300
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mark McLoughlin <markmc@redhat.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Anthony Liguori <aliguori@us.ibm.com>, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio_net: free transmit skbs in a timer
References: <1209565906-9019-1-git-send-email-markmc@redhat.com>	<200805022055.25870.rusty@rustcorp.com.au> <1210624663.14409.20.camel@muff>
In-Reply-To: <1210624663.14409.20.camel@muff>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark McLoughlin wrote:
> virtio_net currently only frees old transmit skbs just
> before queueing new ones. If the queue is full, it then
> enables interrupts and waits for notification that more
> work has been performed.
>
> However, a side-effect of this scheme is that there are
> always xmit skbs left dangling when no new packets are
> sent, against the Documentation/networking/driver.txt
> guideline:
>
>   "... it is not allowed for your TX mitigation scheme
>    to let TX packets "hang out" in the TX ring unreclaimed
>    forever if no new TX packets are sent."
>
> Add a timer to ensure that any time we queue new TX
> skbs, we will shortly free them again.
>
> This fixes an easily reproduced hang at shutdown where
> iptables attempts to unload nf_conntrack and nf_conntrack
> waits for an skb it is tracking to be freed, but virtio_net
> never frees it.
>   

Sorry to barge in late, but IMO the timer should be on the host, which 
is cheaper than on the guest (well, a 100ms timer is likely zero cost, 
but  I still don't like it).

the host should fire a tx completion interrupt whenever the completion 
queue has "enough" entries, where we can define "enough" now as the 
halfway mark or a timer expiry, whichever comes earlier.

We can later improve "enough" to be "just enough so the timer never 
triggers" and adjust it dynamically.  It probably doesn't matter for 
Linux, but I don't want to punish guests that can do true async 
networking and depend on timely completion notification.

-- 
error compiling committee.c: too many arguments to function

