Return-Path: <linux-kernel-owner+w=401wt.eu-S1757263AbYJGAvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757263AbYJGAvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 20:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754892AbYJGAoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 20:44:12 -0400
Received: from ns.suse.de ([195.135.220.2]:46837 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757517AbYJGAoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 20:44:11 -0400
Date: Mon, 6 Oct 2008 17:38:45 -0700
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
       alan@lxorguk.ukuu.org.uk,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 31/71] x86: PAT proper tracking of set_memory_uc and friends
Message-ID: <20081007003845.GF3055@suse.de>
References: <20081007002606.723632097@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-pat-proper-tracking-of-set_memory_uc-and-friends.patch"
In-Reply-To: <20081007003634.GA3055@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us
know.

------------------
From: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>

commit c15238df3b65e34fadb1021b0fb0d5aebc7c42c6 upstream

Big thinko in pat memtype tracking code. reserve_memtype should be called
with physical address and not virtual address.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Chuck Ebbert <cebbert@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/mm/pageattr.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -789,7 +789,7 @@ int set_memory_uc(unsigned long addr, in
 	/*
 	 * for now UC MINUS. see comments in ioremap_nocache()
 	 */
-	if (reserve_memtype(addr, addr + numpages * PAGE_SIZE,
+	if (reserve_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE,
 			    _PAGE_CACHE_UC_MINUS, NULL))
 		return -EINVAL;
 
@@ -808,7 +808,7 @@ int set_memory_wc(unsigned long addr, in
 	if (!pat_wc_enabled)
 		return set_memory_uc(addr, numpages);
 
-	if (reserve_memtype(addr, addr + numpages * PAGE_SIZE,
+	if (reserve_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE,
 		_PAGE_CACHE_WC, NULL))
 		return -EINVAL;
 
@@ -824,7 +824,7 @@ int _set_memory_wb(unsigned long addr, i
 
 int set_memory_wb(unsigned long addr, int numpages)
 {
-	free_memtype(addr, addr + numpages * PAGE_SIZE);
+	free_memtype(__pa(addr), __pa(addr) + numpages * PAGE_SIZE);
 
 	return _set_memory_wb(addr, numpages);
 }

-- 
