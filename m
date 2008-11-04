Return-Path: <linux-kernel-owner+w=401wt.eu-S1753730AbYKDDMs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753730AbYKDDMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 22:12:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbYKDDMf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 22:12:35 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39128
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751348AbYKDDMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 22:12:35 -0500
Date: Mon, 03 Nov 2008 19:12:10 -0800 (PST)
Message-Id: <20081103.191210.149092227.davem@davemloft.net>
To: adobriyan@gmail.com
Cc: simon@fire.lp0.eu, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: xfrm_policy_kill: inconsistent {softirq-on-W} ->
 {in-softirq-W} usage
From: David Miller <davem@davemloft.net>
In-Reply-To: <20081103205726.GA3589@x200.localdomain>
References: <490F3C08.6000209@simon.arlott.org.uk>
	<20081103205726.GA3589@x200.localdomain>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Mon, 3 Nov 2008 23:57:26 +0300

> If it's easily reproducible, try this patch:
> 
> --- a/net/xfrm/xfrm_policy.c
> +++ b/net/xfrm/xfrm_policy.c
> @@ -315,9 +315,9 @@ static void xfrm_policy_kill(struct xfrm_policy *policy)

This looks clearly like the correct fix for this lockdep
warning, so I'm adding it to net-2.6 as follows even though
Simon can't readily test it.

Thanks.

commit bbb770e7ab9a436752babfc8765e422d7481be1f
Author: Alexey Dobriyan <adobriyan@gmail.com>
Date:   Mon Nov 3 19:11:29 2008 -0800

    xfrm: Fix xfrm_policy_gc_lock handling.
    
    From: Alexey Dobriyan <adobriyan@gmail.com>
    
    Based upon a lockdep trace by Simon Arlott.
    
    xfrm_policy_kill() can be called from both BH and
    non-BH contexts, so we have to grab xfrm_policy_gc_lock
    with BH disabling.
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 2587274..058f04f 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -315,9 +315,9 @@ static void xfrm_policy_kill(struct xfrm_policy *policy)
 		return;
 	}
 
-	spin_lock(&xfrm_policy_gc_lock);
+	spin_lock_bh(&xfrm_policy_gc_lock);
 	hlist_add_head(&policy->bydst, &xfrm_policy_gc_list);
-	spin_unlock(&xfrm_policy_gc_lock);
+	spin_unlock_bh(&xfrm_policy_gc_lock);
 
 	schedule_work(&xfrm_policy_gc_work);
 }
