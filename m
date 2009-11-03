Return-Path: <linux-kernel-owner+w=401wt.eu-S1755449AbZKCWTp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbZKCWTp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 17:19:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755218AbZKCWTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 17:19:44 -0500
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:29324 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755116AbZKCWTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 17:19:44 -0500
X-Trace: 283613562/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.31.224/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.31.224
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsAEAJs78EpPRR/g/2dsb2JhbACBTt1lgkGBfAQ
X-IronPort-AV: E=Sophos;i="4.44,676,1249254000"; 
   d="scan'208";a="283613562"
Date: Tue, 3 Nov 2009 22:19:43 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Jiri Slaby <jirislaby@gmail.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Subject: [PATCH mmotm] fix to swap_info-include-first_swap_extent-fix.patch
In-Reply-To: <Pine.LNX.4.64.0911021222010.32400@sister.anvils>
Message-ID: <Pine.LNX.4.64.0911032215290.29276@sister.anvils>
References: <1257155103-9189-1-git-send-email-jirislaby@gmail.com>
 <Pine.LNX.4.64.0911021222010.32400@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, just noticed what the diff contexts don't show: Jiri's patch
is initializing p->first_swap_extent.list at a point before p has
been decided - we may kfree that newly allocated p and go on to
reuse an existing free entry for p.

Now, the patch is not actually wrong: an existing free entry will have
a good empty first_swap_extent.list; but it looks suspicious, it seems
strange to initialize a field in something we're about to kfree, and
I'd rather we put that initialization back to where it was in 2.6.32.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---

 mm/swapfile.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- mmotm/mm/swapfile.c	2009-11-03 18:05:36.000000000 +0000
+++ linux/mm/swapfile.c	2009-11-03 18:08:26.000000000 +0000
@@ -1768,7 +1768,6 @@ SYSCALL_DEFINE2(swapon, const char __use
 		kfree(p);
 		goto out;
 	}
-	INIT_LIST_HEAD(&p->first_swap_extent.list);
 	if (type >= nr_swapfiles) {
 		p->type = type;
 		swap_info[type] = p;
@@ -1787,6 +1786,7 @@ SYSCALL_DEFINE2(swapon, const char __use
 		 * would be relying on p->type to remain valid.
 		 */
 	}
+	INIT_LIST_HEAD(&p->first_swap_extent.list);
 	p->flags = SWP_USED;
 	p->next = -1;
 	spin_unlock(&swap_lock);
