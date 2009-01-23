Return-Path: <linux-kernel-owner+w=401wt.eu-S1763957AbZAWG0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763957AbZAWG0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 01:26:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752527AbZAWGQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 01:16:51 -0500
Received: from kroah.org ([198.145.64.141]:36398 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752087AbZAWGQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 01:16:47 -0500
Date: Thu, 22 Jan 2009 22:14:24 -0800
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
       alan@lxorguk.ukuu.org.uk, Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [patch 27/40] powerpc: is_hugepage_only_range() must account for
	both 4kB and 64kB slices
Message-ID: <20090123061424.GA2922@kroah.com>
References: <20090123001330.046404396@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="powerpc-is_hugepage_only_range-must-account-for-both-4kb-and-64kb-slices.patch"
In-Reply-To: <20090123001908.GA7397@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>

commit 9ba0fdbfaed2e74005d87fab948c5522b86ff733 upstream.

powerpc: is_hugepage_only_range() must account for both 4kB and 64kB slices

The subpage_prot syscall fails on second and subsequent calls for a given
region, because is_hugepage_only_range() is mis-identifying the 4 kB
slices when the process has a 64 kB page size.

Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/mm/slice.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/arch/powerpc/mm/slice.c
+++ b/arch/powerpc/mm/slice.c
@@ -710,9 +710,18 @@ int is_hugepage_only_range(struct mm_str
 			   unsigned long len)
 {
 	struct slice_mask mask, available;
+	unsigned int psize = mm->context.user_psize;
 
 	mask = slice_range_to_mask(addr, len);
-	available = slice_mask_for_size(mm, mm->context.user_psize);
+	available = slice_mask_for_size(mm, psize);
+#ifdef CONFIG_PPC_64K_PAGES
+	/* We need to account for 4k slices too */
+	if (psize == MMU_PAGE_64K) {
+		struct slice_mask compat_mask;
+		compat_mask = slice_mask_for_size(mm, MMU_PAGE_4K);
+		or_mask(available, compat_mask);
+	}
+#endif
 
 #if 0 /* too verbose */
 	slice_dbg("is_hugepage_only_range(mm=%p, addr=%lx, len=%lx)\n",

