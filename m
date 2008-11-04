Return-Path: <linux-kernel-owner+w=401wt.eu-S1759400AbYKDXs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400AbYKDXs4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:48:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756882AbYKDXjd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:39:33 -0500
Received: from mail.suse.de ([195.135.220.2]:47593 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757573AbYKDXjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:39:31 -0500
Date: Tue, 4 Nov 2008 15:32:03 -0800
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
       alan@lxorguk.ukuu.org.uk, Jon Tollefson <kniht@linux.vnet.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [patch 30/57] powerpc: Dont use a 16G page if beyond mem= limits
Message-ID: <20081104233203.GE659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="powerpc-don-t-use-a-16g-page-if-beyond-mem-limits.patch"
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Jon Tollefson <kniht@us.ibm.com>

commit 4792adbac9eb41cea77a45ab76258ea10d411173 upstream

If mem= is used on the boot command line to limit memory then the memory block where a 16G page resides may not be available.

Thanks to Michael Ellerman for finding the problem.

Signed-off-by: Jon Tollefson <kniht@linux.vnet.ibm.com>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/powerpc/mm/hash_utils_64.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/arch/powerpc/mm/hash_utils_64.c
+++ b/arch/powerpc/mm/hash_utils_64.c
@@ -381,8 +381,10 @@ static int __init htab_dt_scan_hugepage_
 	printk(KERN_INFO "Huge page(16GB) memory: "
 			"addr = 0x%lX size = 0x%lX pages = %d\n",
 			phys_addr, block_size, expected_pages);
-	lmb_reserve(phys_addr, block_size * expected_pages);
-	add_gpage(phys_addr, block_size, expected_pages);
+	if (phys_addr + (16 * GB) <= lmb_end_of_DRAM()) {
+		lmb_reserve(phys_addr, block_size * expected_pages);
+		add_gpage(phys_addr, block_size, expected_pages);
+	}
 	return 0;
 }
 

-- 
