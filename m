Return-Path: <linux-kernel-owner+w=401wt.eu-S1757908AbYENGHr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757908AbYENGHr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 02:07:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbYENGHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 02:07:40 -0400
Received: from ozlabs.org ([203.10.76.45]:36510 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbYENGHj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 02:07:39 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Avi Kivity <avi@qumranet.com>
Subject: Re: [PATCH] virtio_net: free transmit skbs in a timer
Date: Wed, 14 May 2008 16:07:25 +1000
User-Agent: KMail/1.9.9
Cc: Mark McLoughlin <markmc@redhat.com>, Anthony Liguori <aliguori@us.ibm.com>,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
References: <1209565906-9019-1-git-send-email-markmc@redhat.com> <1210624663.14409.20.camel@muff> <48294776.3010504@qumranet.com>
In-Reply-To: <48294776.3010504@qumranet.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805141607.26306.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 13 May 2008 17:47:02 Avi Kivity wrote:
> Mark McLoughlin wrote:
> > virtio_net currently only frees old transmit skbs just
> > before queueing new ones. If the queue is full, it then
> > enables interrupts and waits for notification that more
> > work has been performed.
> >
> > However, a side-effect of this scheme is that there are
> > always xmit skbs left dangling when no new packets are
> > sent, against the Documentation/networking/driver.txt
> > guideline:
> >
> >   "... it is not allowed for your TX mitigation scheme
> >    to let TX packets "hang out" in the TX ring unreclaimed
> >    forever if no new TX packets are sent."
> >
> > Add a timer to ensure that any time we queue new TX
> > skbs, we will shortly free them again.
> >
> > This fixes an easily reproduced hang at shutdown where
> > iptables attempts to unload nf_conntrack and nf_conntrack
> > waits for an skb it is tracking to be freed, but virtio_net
> > never frees it.
>
> Sorry to barge in late, but IMO the timer should be on the host, which
> is cheaper than on the guest (well, a 100ms timer is likely zero cost,
> but  I still don't like it).
>
> the host should fire a tx completion interrupt whenever the completion
> queue has "enough" entries, where we can define "enough" now as the
> halfway mark or a timer expiry, whichever comes earlier.
>
> We can later improve "enough" to be "just enough so the timer never
> triggers" and adjust it dynamically.  It probably doesn't matter for
> Linux, but I don't want to punish guests that can do true async
> networking and depend on timely completion notification.

This implies that we should not be supressing notifications in the guest at 
all (unless we're sure there are more packets to come, which currently we 
never are: that needs new net infrastructure).

But that means we'd get a notification on every xmit at the moment.  
Benchmarks anyone?

Rusty.
