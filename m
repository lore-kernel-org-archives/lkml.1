Return-Path: <linux-kernel-owner+w=401wt.eu-S940805AbXGaEaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940805AbXGaEaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 00:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S940655AbXGaE3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 00:29:38 -0400
Received: from canuck.infradead.org ([209.217.80.40]:42232 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S940618AbXGaE3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 00:29:37 -0400
Date: Mon, 30 Jul 2007 21:31:19 -0700
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
       andi@firstfloor.org, johnstul@us.ibm.com,
       Bernhard Walle <bwalle@suse.de>, Bob Picco <bob.picco@hp.com>,
       acme@redhat.com, Sripathi Kodi <sripathik@in.ibm.com>,
       tglx@linutronix.de, Chris Wright <chrisw@sous-sol.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 02/26] sparsemem: fix oops in x86_64 show_mem
Message-ID: <20070731043119.GC3975@kroah.com>
References: <20070731042108.546594256@blue.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="fix-show_mem-x86_64-sparsemem.patch"
In-Reply-To: <20070731043047.GA3975@kroah.com>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


-stable review patch.  If anyone has any objections, please let us know.

------------------

We aren't sampling for holes in memory. Thus we encounter a section hole with
empty section map pointer for SPARSEMEM and OOPs for show_mem. This issue
has been seen in 2.6.21, current git and current mm. This patch is for
2.6.21 stable. It was tested against sparsemem.

Previous to commit f0a5a58aa812b31fd9f197c4ba48245942364eae memory_present
was called for node_start_pfn to node_end_pfn. This would cover the hole(s)
with reserved pages and valid sections. Most SPARSEMEM supported arches
do a pfn_valid check in show_mem before computing the page structure address.

This issue was brought to my attention on IRC by Arnaldo Carvalho de Melo at
acme@redhat.com. Thanks to Arnaldo for testing.

Signed-off-by: Bob Picco <bob.picco@hp.com>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---

 arch/x86_64/mm/init.c |    2 ++
 1 file changed, 2 insertions(+)

--- linux-2.6.21.6.orig/arch/x86_64/mm/init.c
+++ linux-2.6.21.6/arch/x86_64/mm/init.c
@@ -72,6 +72,8 @@ void show_mem(void)
 
 	for_each_online_pgdat(pgdat) {
                for (i = 0; i < pgdat->node_spanned_pages; ++i) {
+			if (!pfn_valid(pgdat->node_start_pfn + i))
+				continue;
 			page = pfn_to_page(pgdat->node_start_pfn + i);
 			total++;
 			if (PageReserved(page))

-- 
