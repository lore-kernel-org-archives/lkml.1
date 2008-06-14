Return-Path: <linux-kernel-owner+w=401wt.eu-S1763517AbYFNAZe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763517AbYFNAZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2008 20:25:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761006AbYFNAPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jun 2008 20:15:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52171 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761253AbYFNAPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2008 20:15:08 -0400
Date: Fri, 13 Jun 2008 17:12:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Roland Dreier <rolandd@cisco.com>
Subject: [patch 39/47] IB/umem: Avoid sign problems when demoting npages to
	integer
Message-ID: <20080614001204.GM24698@suse.de>
References: <20080613234753.235721454@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ib-umem-avoid-sign-problems-when-demoting-npages-to-integer.patch"
In-Reply-To: <20080614000840.GA24659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Roland Dreier <rolandd@cisco.com>

commit 8079ffa0e18baaf2940e52e0c118eef420a473a4 upstream

On a 64-bit architecture, if ib_umem_get() is called with a size value
that is so big that npages is negative when cast to int, then the
length of the page list passed to get_user_pages(), namely

	min_t(int, npages, PAGE_SIZE / sizeof (struct page *))

will be negative, and get_user_pages() will immediately return 0 (at
least since 900cf086, "Be more robust about bad arguments in
get_user_pages()").  This leads to an infinite loop in ib_umem_get(),
since the code boils down to:

	while (npages) {
		ret = get_user_pages(...);
		npages -= ret;
	}

Fix this by taking the minimum as unsigned longs, so that the value of
npages is never truncated.

The impact of this bug isn't too severe, since the value of npages is
checked against RLIMIT_MEMLOCK, so a process would need to have an
astronomical limit or have CAP_IPC_LOCK to be able to trigger this,
and such a process could already cause lots of mischief.  But it does
let buggy userspace code cause a kernel lock-up; for example I hit
this with code that passes a negative value into a memory registartion
function where it is promoted to a huge u64 value.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/infiniband/core/umem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -144,7 +144,7 @@ struct ib_umem *ib_umem_get(struct ib_uc
 	ret = 0;
 	while (npages) {
 		ret = get_user_pages(current, current->mm, cur_base,
-				     min_t(int, npages,
+				     min_t(unsigned long, npages,
 					   PAGE_SIZE / sizeof (struct page *)),
 				     1, !umem->writable, page_list, vma_list);
 

-- 
