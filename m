Return-Path: <linux-kernel-owner+w=401wt.eu-S1758508AbZBJTS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758508AbZBJTS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 14:18:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755942AbZBJTEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 14:04:14 -0500
Received: from kroah.org ([198.145.64.141]:54111 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755928AbZBJTEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 14:04:12 -0500
Date: Tue, 10 Feb 2009 11:01:17 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Hugh Dickins <hugh@veritas.com>
Subject: [patch 41/53] mm: fix error case in mlock downgrade reversion
Message-ID: <20090210190117.GP14308@kroah.com>
References: <20090210185337.000769713@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mm-fix-error-case-in-mlock-downgrade-reversion.patch"
In-Reply-To: <20090210185924.GA14308@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.
------------------

From: Hugh Dickins <hugh@veritas.com>

commit d5b562330ec766292a3ac54ae5e0673610bd5b3d upstream.

Commit 27421e211a39784694b597dbf35848b88363c248, Manually revert
"mlock: downgrade mmap sem while populating mlocked regions", has
introduced its own regression: __mlock_vma_pages_range() may report
an error (for example, -EFAULT from trying to lock down pages from
beyond EOF), but mlock_vma_pages_range() must hide that from its
callers as before.

Reported-by: Sami Farin <safari-kernel@safari.iki.fi>
Signed-off-by: Hugh Dickins <hugh@veritas.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

---
 mm/mlock.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -310,7 +310,10 @@ long mlock_vma_pages_range(struct vm_are
 			is_vm_hugetlb_page(vma) ||
 			vma == get_gate_vma(current))) {
 
-		return __mlock_vma_pages_range(vma, start, end, 1);
+		__mlock_vma_pages_range(vma, start, end, 1);
+
+		/* Hide errors from mmap() and other callers */
+		return 0;
 	}
 
 	/*

