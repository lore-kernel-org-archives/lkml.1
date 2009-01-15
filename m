Return-Path: <linux-kernel-owner+w=401wt.eu-S932709AbZAOUJj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932709AbZAOUJj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 15:09:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765911AbZAOUAh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 15:00:37 -0500
Received: from kroah.org ([198.145.64.141]:48849 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762158AbZAOUA2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 15:00:28 -0500
Date: Thu, 15 Jan 2009 11:57:46 -0800
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
       alan@lxorguk.ukuu.org.uk, Cliff Wickman <cpw@sgi.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 15/94] x86, UV: remove erroneous BAU initialization
Message-ID: <20090115195746.GO14419@kroah.com>
References: <20090115194806.804618825@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-uv-remove-erroneous-bau-initialization.patch"
In-Reply-To: <20090115195520.GA14403@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.28-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Cliff Wickman <cpw@sgi.com>

commit 46814dded1b972a07b1609d81632eef3009fbb10 upstream.

Impact: fix crash on x86/UV

UV is the SGI "UltraViolet" machine, which is x86_64 based.
BAU is the "Broadcast Assist Unit", used for TLB shootdown in UV.

This patch removes the allocation and initialization of an unused table.

This table is left over from a development test mode.  It is unused in
the present code.

And it was incorrectly initialized: 8 entries allocated but 17 initialized,
causing slab corruption.

This patch should go into 2.6.27 and 2.6.28 as well as the current tree.

Diffed against 2.6.28 (linux-next, 12/30/08)

Signed-off-by: Cliff Wickman <cpw@sgi.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/tlb_uv.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/arch/x86/kernel/tlb_uv.c
+++ b/arch/x86/kernel/tlb_uv.c
@@ -586,7 +586,6 @@ static int __init uv_ptc_init(void)
 static struct bau_control * __init uv_table_bases_init(int blade, int node)
 {
 	int i;
-	int *ip;
 	struct bau_msg_status *msp;
 	struct bau_control *bau_tabp;
 
@@ -603,13 +602,6 @@ static struct bau_control * __init uv_ta
 		bau_cpubits_clear(&msp->seen_by, (int)
 				  uv_blade_nr_possible_cpus(blade));
 
-	bau_tabp->watching =
-	    kmalloc_node(sizeof(int) * DEST_NUM_RESOURCES, GFP_KERNEL, node);
-	BUG_ON(!bau_tabp->watching);
-
-	for (i = 0, ip = bau_tabp->watching; i < DEST_Q_SIZE; i++, ip++)
-		*ip = 0;
-
 	uv_bau_table_bases[blade] = bau_tabp;
 
 	return bau_tabp;
@@ -632,7 +624,6 @@ uv_table_bases_finish(int blade, int nod
 		bcp->bau_msg_head	= bau_tablesp->va_queue_first;
 		bcp->va_queue_first	= bau_tablesp->va_queue_first;
 		bcp->va_queue_last	= bau_tablesp->va_queue_last;
-		bcp->watching		= bau_tablesp->watching;
 		bcp->msg_statuses	= bau_tablesp->msg_statuses;
 		bcp->descriptor_base	= adp;
 	}

