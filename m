Return-Path: <linux-kernel-owner+w=401wt.eu-S1754469AbYJFGDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbYJFGDX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 02:03:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752714AbYJFGDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 02:03:12 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:46005 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbYJFGDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 02:03:11 -0400
Message-ID: <48E9AA6E.3080608@suse.de>
Date: Mon, 06 Oct 2008 11:34:30 +0530
From: Suresh Jayaraman <sjayaraman@suse.de>
User-Agent: Thunderbird 2.0.0.16 (X11/20080421)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, netdev@vger.kernel.org, trond.myklebust@fys.uio.no,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>, Neil Brown <neilb@suse.de>,
       David Miller <davem@davemloft.net>
Subject: Re: [PATCH 00/32] Swap over NFS - v19
References: <20081002130504.927878499@chello.nl>
In-Reply-To: <20081002130504.927878499@chello.nl>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> Patches are against: v2.6.27-rc5-mm1
> 
> This release features more comments and (hopefully) better Changelogs.
> Also the netns stuff got sorted and ipv6 will now build 

Except for this one I think ;-)

net/netfilter/core.c: In function ‘nf_hook_slow’:
net/netfilter/core.c:191: error: ‘pskb’ undeclared (first use in this
function)

> and not oops on boot ;-)

The culprit is emergency-nf_queue.patch. The following change fixes the
build error for me.

Index: linux-2.6.26/net/netfilter/core.c
===================================================================
--- linux-2.6.26.orig/net/netfilter/core.c
+++ linux-2.6.26/net/netfilter/core.c
@@ -184,9 +184,12 @@ next_hook:
                ret = 1;
                goto unlock;
        } else if (verdict == NF_DROP) {
+drop:
                kfree_skb(skb);
                ret = -EPERM;
        } else if ((verdict & NF_VERDICT_MASK) == NF_QUEUE) {
+               if (skb_emergency(skb))
+                       goto drop;
                if (!nf_queue(skb, elem, pf, hook, indev, outdev, okfn,
                              verdict >> NF_VERDICT_BITS))
                        goto next_hook;


Thanks,

-- 
Suresh Jayaraman
