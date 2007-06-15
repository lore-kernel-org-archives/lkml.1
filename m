Return-Path: <linux-kernel-owner+w=401wt.eu-S1756654AbXFOPGp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756654AbXFOPGp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 11:06:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbXFOPGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 11:06:34 -0400
Received: from saeurebad.de ([85.214.36.134]:48559 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753134AbXFOPGd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 11:06:33 -0400
Date: Fri, 15 Jun 2007 17:06:18 +0200
From: Johannes Weiner <hannes-kernel@saeurebad.de>
To: linux-kernel@vger.kernel.org
Cc: Tom Robinson <thomas.robinson@gmail.com>, linux-mm@kvack.org,
       Stephen Tweedie <sct@redhat.com>
Subject: Re: PROBLEM: kernel BUG at mm/swap_state.c:78! (v2.6.21 under vmware)
Message-ID: <20070615150618.GA19912@saeurebad.de>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Tom Robinson <thomas.robinson@gmail.com>, linux-mm@kvack.org,
	Stephen Tweedie <sct@redhat.com>
References: <745af2c30706140842w5eabdf1bjdcc5fd7c2a92b77e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="vtzGhvizbBRQ85DL"
Content-Disposition: inline
In-Reply-To: <745af2c30706140842w5eabdf1bjdcc5fd7c2a92b77e@mail.gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I am not sure if this patch is a fix or a hiding (or leads to more trouble at
all), so, could PLEASE anyone with knowledge about the code see over it?
Thanks :)

shrink_page_list() should not pass a private page to add_to_swap().
Is it a bug if the page is private when reaching this point? I do not think
so, because a few lines below is a condition where private pages are handled
legally.


--vtzGhvizbBRQ85DL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="do-not-swap-private-pages.patch"

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 1be5a63..92573b7 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -489,7 +489,8 @@ static unsigned long shrink_page_list(struct list_head *page_list,
 		 * Anonymous process memory has backing store?
 		 * Try to allocate it some swap space here.
 		 */
-		if (PageAnon(page) && !PageSwapCache(page))
+		if (PageAnon(page) && !PageSwapCache(page) &&
+		    !PagePrivate(page))
 			if (!add_to_swap(page, GFP_ATOMIC))
 				goto activate_locked;
 #endif /* CONFIG_SWAP */

--vtzGhvizbBRQ85DL--
