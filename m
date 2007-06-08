Return-Path: <linux-kernel-owner+w=401wt.eu-S937075AbXFHBBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937075AbXFHBBR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 21:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763194AbXFHBBA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 21:01:00 -0400
Received: from smtp.cce.hp.com ([161.114.21.25]:23718 "EHLO
	ccerelrim04.cce.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbXFHBBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 21:01:00 -0400
From: "Bob Picco" <bob.picco@hp.com>
Date: Thu, 7 Jun 2007 21:00:56 -0400
To: john stultz <johnstul@us.ibm.com>
Cc: Bob Picco <bob.picco@hp.com>, Chuck Ebbert <cebbert@redhat.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Sripathi Kodi <sripathik@in.ibm.com>, Bernhard Walle <bwalle@suse.de>,
       acme@redhat.com, apw@shadowen.org, tglx@linutronix.de,
       akpm@linux-foundation.org, andi@firstfloor.org
Subject: Re: [BUG] sysrq-m oops
Message-ID: <20070608010056.GF11999@localhost>
References: <1181176035.6275.13.camel@localhost.localdomain> <4668276E.4030504@redhat.com> <20070607182122.GE11999@localhost> <1181246081.7621.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1181246081.7621.6.camel@localhost.localdomain>
User-Agent: Mutt/1.5.11
X-PMX-Version: 5.3.1.294258, Antispam-Engine: 2.5.1.298604, Antispam-Data: 2007.6.7.174233
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

john stultz wrote:	[Thu Jun 07 2007, 03:54:41PM EDT]
[snip]
john you are welcome.

We aren't sampling for holes in memory. Thus we encounter a section hole with
empty section map pointer for SPARSEMEM and OOPs for show_mem. This issue
has been seen in 2.6.21, current git and current mm. The patch below
is for mainline and mm. It was boot tested for SPARSEMEM, current
VMEMMAP of Andy's in mm ml and DISCONTIGMEM. A slightly different patch
will be posted to stable for 2.6.21.

Previous to commit f0a5a58aa812b31fd9f197c4ba48245942364eae memory_present
was called for node_start_pfn to node_end_pfn. This would cover the hole(s)
with reserved pages and valid sections. Most SPARSEMEM supported arches
do a pfn_valid check in show_mem before computing the page structure address.

This issue was brought to my attention on IRC by Arnaldo Carvalho de Melo at
acme@redhat.com. Thanks to Arnaldo for testing.

Signed-off-by: Bob Picco <bob.picco@hp.com>

 arch/x86_64/mm/init.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6.22-rc4-mm1/arch/x86_64/mm/init.c
===================================================================
--- linux-2.6.22-rc4-mm1.orig/arch/x86_64/mm/init.c	2007-06-06 12:59:26.000000000 -0400
+++ linux-2.6.22-rc4-mm1/arch/x86_64/mm/init.c	2007-06-07 11:14:31.000000000 -0400
@@ -79,6 +79,8 @@ void show_mem(void)
 			if (unlikely(i % MAX_ORDER_NR_PAGES == 0)) {
 				touch_nmi_watchdog();
 			}
+			if (!pfn_valid(pgdat->node_start_pfn + i))
+				continue;
 			page = pfn_to_page(pgdat->node_start_pfn + i);
 			total++;
 			if (PageReserved(page))
