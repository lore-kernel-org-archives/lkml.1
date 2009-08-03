Return-Path: <linux-kernel-owner+w=401wt.eu-S1754872AbZHCMNK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754872AbZHCMNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Aug 2009 08:13:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754862AbZHCMNJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Aug 2009 08:13:09 -0400
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:11075 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754859AbZHCMNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Aug 2009 08:13:08 -0400
X-Trace: 237202399/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.63.67/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.63.67
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqYEAO5wdkpPRT9D/2dsb2JhbACBUs4nhBgFgUo
X-IronPort-AV: E=Sophos;i="4.43,314,1246834800"; 
   d="scan'208";a="237202399"
Date: Mon, 3 Aug 2009 13:12:59 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Izik Eidus <ieidus@redhat.com>
cc: Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
       Chris Wright <chrisw@redhat.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org
Subject: [PATCH 4/12] ksm: break cow once unshared
In-Reply-To: <Pine.LNX.4.64.0908031304430.16449@sister.anvils>
Message-ID: <Pine.LNX.4.64.0908031311590.16754@sister.anvils>
References: <Pine.LNX.4.64.0908031304430.16449@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We kept agreeing not to bother about the unswappable shared KSM pages
which later become unshared by others: observation suggests they're not
a significant proportion.  But they are disadvantageous, and it is easier
to break COW to replace them by swappable pages, than offer statistics
to show that they don't matter; then we can stop worrying about them.

Doing this in ksm_do_scan, they don't go through cmp_and_merge_page on
this pass: give them a good chance of getting into the unstable tree
on the next pass, or back into the stable, by computing checksum now.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---

 mm/ksm.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- ksm3/mm/ksm.c	2009-08-02 13:49:51.000000000 +0100
+++ ksm4/mm/ksm.c	2009-08-02 13:49:59.000000000 +0100
@@ -1275,6 +1275,14 @@ static void ksm_do_scan(unsigned int sca
 			return;
 		if (!PageKsm(page) || !in_stable_tree(rmap_item))
 			cmp_and_merge_page(page, rmap_item);
+		else if (page_mapcount(page) == 1) {
+			/*
+			 * Replace now-unshared ksm page by ordinary page.
+			 */
+			break_cow(rmap_item->mm, rmap_item->address);
+			remove_rmap_item_from_tree(rmap_item);
+			rmap_item->oldchecksum = calc_checksum(page);
+		}
 		put_page(page);
 	}
 }
