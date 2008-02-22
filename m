Return-Path: <linux-kernel-owner+w=401wt.eu-S933429AbYBVVnK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933429AbYBVVnK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 16:43:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932521AbYBVVmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 16:42:46 -0500
Received: from mx2.suse.de ([195.135.220.15]:60243 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932425AbYBVVmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 16:42:44 -0500
Date: Fri, 22 Feb 2008 13:39:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jesper Juhl <jesper.juhl@gmail.com>, Mike Miller <mike.miller@hp.com>,
       Oliver Pinter <oliver.pntr@gmail.com>
Subject: [patch 01/23] cciss: fix memory leak
Message-ID: <20080222213954.GB8686@suse.de>
References: <20080222213114.583282464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="cciss-fix-memory-leak.patch"
In-Reply-To: <20080222213927.GA8686@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.22-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jesper Juhl <jesper.juhl@gmail.com>

mainline: f2912a1223c0917a7b4e054f18086209137891ea

There's a memory leak in the cciss driver.

in alloc_cciss_hba() we may leak sizeof(ctlr_info_t) bytes if a
call to alloc_disk(1 << NWD_SHIFT) fails.
This patch should fix the issue.

Spotted by the Coverity checker.

Signed-off-by: Jesper Juhl <jesper.juhl@gmail.com>
Acked-by: Mike Miller <mike.miller@hp.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oliver Pinter <oliver.pntr@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/block/cciss.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/block/cciss.c
+++ b/drivers/block/cciss.c
@@ -3225,12 +3225,15 @@ static int alloc_cciss_hba(void)
 	for (i = 0; i < MAX_CTLR; i++) {
 		if (!hba[i]) {
 			ctlr_info_t *p;
+
 			p = kzalloc(sizeof(ctlr_info_t), GFP_KERNEL);
 			if (!p)
 				goto Enomem;
 			p->gendisk[0] = alloc_disk(1 << NWD_SHIFT);
-			if (!p->gendisk[0])
+			if (!p->gendisk[0]) {
+				kfree(p);
 				goto Enomem;
+			}
 			hba[i] = p;
 			return i;
 		}

-- 
