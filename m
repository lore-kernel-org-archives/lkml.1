Return-Path: <linux-kernel-owner+w=401wt.eu-S1757544AbZKJWCo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757544AbZKJWCo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 17:02:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756391AbZKJWCn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 17:02:43 -0500
Received: from mk-filter-3-a-1.mail.uk.tiscali.com ([212.74.100.54]:26807 "EHLO
	mk-filter-3-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755546AbZKJWCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 17:02:42 -0500
X-Trace: 284590392/mk-filter-3.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.44.180/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.44.180
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AjkFAB5y+UpPRSy0/2dsb2JhbACBTt0khD4E
X-IronPort-AV: E=Sophos;i="4.44,718,1249254000"; 
   d="scan'208";a="284590392"
Date: Tue, 10 Nov 2009 22:02:46 +0000 (GMT)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: Izik Eidus <ieidus@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 5/6] mm: stop ptlock enlarging struct page
In-Reply-To: <Pine.LNX.4.64.0911102142570.2272@sister.anvils>
Message-ID: <Pine.LNX.4.64.0911102200480.2816@sister.anvils>
References: <Pine.LNX.4.64.0911102142570.2272@sister.anvils>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_DEBUG_SPINLOCK adds 12 or 16 bytes to a 32- or 64-bit spinlock_t,
and CONFIG_DEBUG_LOCK_ALLOC adds another 12 or 24 bytes to it: lockdep
enables both of those, and CONFIG_LOCK_STAT adds 8 or 16 bytes to that.

When 2.6.15 placed the split page table lock inside struct page (usually
sized 32 or 56 bytes), only CONFIG_DEBUG_SPINLOCK was a possibility, and
we ignored the enlargement (but fitted in CONFIG_GENERIC_LOCKBREAK's 4
by letting the spinlock_t occupy both page->private and page->mapping).

Should these debugging options be allowed to double the size of a struct
page, when only one minority use of the page (as a page table) needs to
fit a spinlock in there?  Perhaps not.

Take the easy way out: switch off SPLIT_PTLOCK_CPUS when DEBUG_SPINLOCK
or DEBUG_LOCK_ALLOC is in force.  I've sometimes tried to be cleverer,
kmallocing a cacheline for the spinlock when it doesn't fit, but given
up each time.  Falling back to mm->page_table_lock (as we do when ptlock
is not split) lets lockdep check out the strictest path anyway.

And now that some arches allow 8192 cpus, use 999999 for infinity.

(What has this got to do with KSM swapping?  It doesn't care about the
size of struct page, but may care about random junk in page->mapping -
to be explained separately later.)

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
---

 mm/Kconfig |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- mm4/mm/Kconfig	2009-11-04 10:52:58.000000000 +0000
+++ mm5/mm/Kconfig	2009-11-04 10:53:13.000000000 +0000
@@ -161,11 +161,13 @@ config PAGEFLAGS_EXTENDED
 # Default to 4 for wider testing, though 8 might be more appropriate.
 # ARM's adjust_pte (unused if VIPT) depends on mm-wide page_table_lock.
 # PA-RISC 7xxx's spinlock_t would enlarge struct page from 32 to 44 bytes.
+# DEBUG_SPINLOCK and DEBUG_LOCK_ALLOC spinlock_t also enlarge struct page.
 #
 config SPLIT_PTLOCK_CPUS
 	int
-	default "4096" if ARM && !CPU_CACHE_VIPT
-	default "4096" if PARISC && !PA20
+	default "999999" if ARM && !CPU_CACHE_VIPT
+	default "999999" if PARISC && !PA20
+	default "999999" if DEBUG_SPINLOCK || DEBUG_LOCK_ALLOC
 	default "4"
 
 #
