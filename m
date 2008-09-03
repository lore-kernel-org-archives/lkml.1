Return-Path: <linux-kernel-owner+w=401wt.eu-S1758090AbYICRo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090AbYICRo6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 13:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754763AbYICRoo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 13:44:44 -0400
Received: from ns2.suse.de ([195.135.220.15]:57562 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753801AbYICRon (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 13:44:43 -0400
Date: Wed, 3 Sep 2008 10:26:35 -0700
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
       alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: [patch 34/42] sparc64: Fix cmdline_memory_size handling bugs.
Message-ID: <20080903172635.GI7731@suse.de>
References: <20080903171927.534216229@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="0002-sparc64-Fix-cmdline_memory_size-handling-bugs.patch"
In-Reply-To: <20080903172447.GA7731@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------

From: David S. Miller <davem@davemloft.net>

[ Upstream commit f2b6079464fc73cf12f08248180a618f05033a70 ]

First, lmb_enforce_memory_limit() interprets it's argument
(mostly, heh) as a size limit not an address limit.  So pass
the raw cmdline_memory_size value into it.  And we don't
need to check it against zero, lmb_enforce_memory_limit() does
that for us.

Next, free_initmem() needs special handling when the kernel
command line trims the available memory.  The problem case is
if the trimmed out memory is where the kernel image itself
resides.

When that memory is trimmed out, we don't add those physical
ram areas to the sparsemem active ranges, amongst other things.
Which means that this free_initmem() code will free up invalid
page structs, resulting in either crashes or hangs.

Just quick fix this by not freeing initmem at all if "mem="
was given on the boot command line.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc64/mm/init.c |   27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

--- a/arch/sparc64/mm/init.c
+++ b/arch/sparc64/mm/init.c
@@ -1772,8 +1772,7 @@ void __init paging_init(void)
 
 	find_ramdisk(phys_base);
 
-	if (cmdline_memory_size)
-		lmb_enforce_memory_limit(phys_base + cmdline_memory_size);
+	lmb_enforce_memory_limit(cmdline_memory_size);
 
 	lmb_analyze();
 	lmb_dump_all();
@@ -2010,6 +2009,15 @@ void __init mem_init(void)
 void free_initmem(void)
 {
 	unsigned long addr, initend;
+	int do_free = 1;
+
+	/* If the physical memory maps were trimmed by kernel command
+	 * line options, don't even try freeing this initmem stuff up.
+	 * The kernel image could have been in the trimmed out region
+	 * and if so the freeing below will free invalid page structs.
+	 */
+	if (cmdline_memory_size)
+		do_free = 0;
 
 	/*
 	 * The init section is aligned to 8k in vmlinux.lds. Page align for >8k pagesizes.
@@ -2024,13 +2032,16 @@ void free_initmem(void)
 			((unsigned long) __va(kern_base)) -
 			((unsigned long) KERNBASE));
 		memset((void *)addr, POISON_FREE_INITMEM, PAGE_SIZE);
-		p = virt_to_page(page);
 
-		ClearPageReserved(p);
-		init_page_count(p);
-		__free_page(p);
-		num_physpages++;
-		totalram_pages++;
+		if (do_free) {
+			p = virt_to_page(page);
+
+			ClearPageReserved(p);
+			init_page_count(p);
+			__free_page(p);
+			num_physpages++;
+			totalram_pages++;
+		}
 	}
 }
 

-- 
