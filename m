Return-Path: <linux-kernel-owner+w=401wt.eu-S932469AbXKOGqc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469AbXKOGqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2007 01:46:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762131AbXKOGmz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Nov 2007 01:42:55 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:55117 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761932AbXKOGmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2007 01:42:54 -0500
Date: Wed, 14 Nov 2007 22:40:02 -0800
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
       Jan-Bernd Themann <themann@de.ibm.com>, Jeff Garzik <jeff@garzik.org>
Subject: [patch 03/16] ehea: 64K page kernel support fix
Message-ID: <20071115064002.GC18951@kroah.com>
References: <20071115060353.071060513@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="ehea-64k-page-kernel-support-fix.patch"
In-Reply-To: <20071115063921.GA18827@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jan-Bernd Themann <ossthema@de.ibm.com>

based on 2c69448bbcedebeb8409ddb05fbc7d3fe1cfbda7 in mainline.

The current eHEA module compiled for 64K page kernels can not
be loaded with insmod due to bad hypervisor call parameters.
The patch is a subset of the follwing patch which has been applied
for 2.6.24 upstream:

http://www.spinics.net/lists/netdev/msg42814.html

Signed-off-by: Jan-Bernd Themann <themann@de.ibm.com>
Cc: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/ehea/ehea_qmr.c |   20 ++++++++------------
 drivers/net/ehea/ehea_qmr.h |    2 +-
 2 files changed, 9 insertions(+), 13 deletions(-)

--- a/drivers/net/ehea/ehea_qmr.c
+++ b/drivers/net/ehea/ehea_qmr.c
@@ -563,8 +563,7 @@ int ehea_destroy_qp(struct ehea_qp *qp)
 int ehea_create_busmap( void )
 {
 	u64 vaddr = EHEA_BUSMAP_START;
-	unsigned long abs_max_pfn = 0;
-	unsigned long sec_max_pfn;
+	unsigned long high_section_index = 0;
 	int i;
 
 	/*
@@ -574,14 +573,10 @@ int ehea_create_busmap( void )
 	ehea_bmap.valid_sections = 0;
 
 	for (i = 0; i < NR_MEM_SECTIONS; i++)
-		if (valid_section_nr(i)) {
-			sec_max_pfn = section_nr_to_pfn(i);
-			if (sec_max_pfn > abs_max_pfn)
-				abs_max_pfn = sec_max_pfn;
-			ehea_bmap.valid_sections++;
-		}
+		if (valid_section_nr(i))
+			high_section_index = i;
 
-	ehea_bmap.entries = abs_max_pfn / EHEA_PAGES_PER_SECTION + 1;
+	ehea_bmap.entries = high_section_index + 1;
 	ehea_bmap.vaddr = vmalloc(ehea_bmap.entries * sizeof(*ehea_bmap.vaddr));
 
 	if (!ehea_bmap.vaddr)
@@ -593,6 +588,7 @@ int ehea_create_busmap( void )
 		if (pfn_valid(pfn)) {
 			ehea_bmap.vaddr[i] = vaddr;
 			vaddr += EHEA_SECTSIZE;
+			ehea_bmap.valid_sections++;
 		} else
 			ehea_bmap.vaddr[i] = 0;
 	}
@@ -637,7 +633,7 @@ int ehea_reg_kernel_mr(struct ehea_adapt
 
 	mr_len = ehea_bmap.valid_sections * EHEA_SECTSIZE;
 
-	pt =  kzalloc(EHEA_MAX_RPAGE * sizeof(u64), GFP_KERNEL);
+	pt =  kzalloc(PAGE_SIZE, GFP_KERNEL);
 	if (!pt) {
 		ehea_error("no mem");
 		ret = -ENOMEM;
@@ -660,8 +656,8 @@ int ehea_reg_kernel_mr(struct ehea_adapt
 			void *sectbase = __va(i << SECTION_SIZE_BITS);
 			unsigned long k = 0;
 
-			for (j = 0; j < (PAGES_PER_SECTION / EHEA_MAX_RPAGE);
-			      j++) {
+			for (j = 0; j < (EHEA_PAGES_PER_SECTION /
+					 EHEA_MAX_RPAGE); j++) {
 
 				for (m = 0; m < EHEA_MAX_RPAGE; m++) {
 					pg = sectbase + ((k++) * EHEA_PAGESIZE);
--- a/drivers/net/ehea/ehea_qmr.h
+++ b/drivers/net/ehea/ehea_qmr.h
@@ -39,7 +39,7 @@
 #define EHEA_PAGESHIFT         12
 #define EHEA_PAGESIZE          (1UL << EHEA_PAGESHIFT)
 #define EHEA_SECTSIZE          (1UL << 24)
-#define EHEA_PAGES_PER_SECTION (EHEA_SECTSIZE >> PAGE_SHIFT)
+#define EHEA_PAGES_PER_SECTION (EHEA_SECTSIZE >> EHEA_PAGESHIFT)
 
 #if (1UL << SECTION_SIZE_BITS) < EHEA_SECTSIZE
 #error eHEA module can't work if kernel sectionsize < ehea sectionsize

-- 
