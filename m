Return-Path: <linux-kernel-owner+w=401wt.eu-S932656AbZAOUKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932656AbZAOUKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:10:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765933AbZAOUAj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:00:39 -0500
Received: from kroah.org ([198.145.64.141]:48872 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762658AbZAOUAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:00:30 -0500
Date: Thu, 15 Jan 2009 11:57:50 -0800
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
       alan@lxorguk.ukuu.org.uk, Adam Lackorzynski <adam@os.inf.tu-dresden.de>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: [patch 17/94] vmalloc.c: fix flushing in vmap_page_range()
Message-ID: <20090115195750.GQ14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="vmalloc.c-fix-flushing-in-vmap_page_range.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Adam Lackorzynski <adam@os.inf.tu-dresden.de>

commit 2e4e27c7d082b2198b63041310609d7191185a9d upstream.

The flush_cache_vmap in vmap_page_range() is called with the end of the
range twice.  The following patch fixes this for me.

Signed-off-by: Adam Lackorzynski <adam@os.inf.tu-dresden.de>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/vmalloc.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -151,11 +151,12 @@ static int vmap_pud_range(pgd_t *pgd, un
  *
  * Ie. pte at addr+N*PAGE_SIZE shall point to pfn corresponding to pages[N]
  */
-static int vmap_page_range(unsigned long addr, unsigned long end,
+static int vmap_page_range(unsigned long start, unsigned long end,
 				pgprot_t prot, struct page **pages)
 {
 	pgd_t *pgd;
 	unsigned long next;
+	unsigned long addr = start;
 	int err = 0;
 	int nr = 0;
 
@@ -167,7 +168,7 @@ static int vmap_page_range(unsigned long
 		if (err)
 			break;
 	} while (pgd++, addr = next, addr != end);
-	flush_cache_vmap(addr, end);
+	flush_cache_vmap(start, end);
 
 	if (unlikely(err))
 		return err;

