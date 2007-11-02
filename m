Return-Path: <linux-kernel-owner+w=401wt.eu-S1754182AbXKBKP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182AbXKBKP6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 06:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752946AbXKBKPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 06:15:50 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:59742 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752920AbXKBKPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 06:15:49 -0400
Subject: Re: writeout stalls in current -git
From: Peter Zijlstra <peterz@infradead.org>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Cc: Torsten Kaiser <just.for.lkml@googlemail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, David Chinner <dgc@sgi.com>,
       linux-fsdevel@vger.kernel.org
In-Reply-To: <E1InmAI-0003ME-2i@localhost>
References: <200710220822.52370.maximlevitsky@gmail.com>
	 <200710221421.21439.maximlevitsky@gmail.com> <393056632.00561@ustc.edu.cn>
	 <200710221505.35397.maximlevitsky@gmail.com>
	 <20071022131045.GA5357@mail.ustc.edu.cn> <393060478.03650@ustc.edu.cn>
	 <64bb37e0710310822r5ca6b793p8fd97db2f72a8655@mail.gmail.com>
	 <393903856.06449@ustc.edu.cn>
	 <64bb37e0711011120i63cdfe3ci18995d57b6649a8@mail.gmail.com>
	 <64bb37e0711011200n228e708eg255640388f83da22@mail.gmail.com>
	 <E1InmAI-0003ME-2i@localhost>
Content-Type: text/plain
Date: Fri, 02 Nov 2007 11:15:32 +0100
Message-Id: <1193998532.27652.343.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-11-02 at 10:21 +0800, Fengguang Wu wrote:

> Interestingly, no background_writeout() appears, but only
> balance_dirty_pages() and wb_kupdate.  Obviously wb_kupdate won't
> block the process.

Yeah, the background threshold is not (yet) scaled. So it can happen
that the bdi_dirty limit is below the background limit.

I'm curious though as to these stalls, though, I can't seem to think of
what goes wrong.. esp since most writeback seems to happen from pdflush.

(or I'm totally misreading it - quite a possible as I'm still recovering
from a serious cold and not all the green stuff has yet figured out its
proper place wrt brain cells 'n stuff)


I still have this patch floating around:

---
Subject: mm: speed up writeback ramp-up on clean systems

We allow violation of bdi limits if there is a lot of room on the
system. Once we hit half the total limit we start enforcing bdi limits
and bdi ramp-up should happen. Doing it this way avoids many small
writeouts on an otherwise idle system and should also speed up the
ramp-up.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 mm/page-writeback.c |   19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

Index: linux-2.6/mm/page-writeback.c
===================================================================
--- linux-2.6.orig/mm/page-writeback.c	2007-09-28 10:08:33.937415368 +0200
+++ linux-2.6/mm/page-writeback.c	2007-09-28 10:54:26.018247516 +0200
@@ -355,8 +355,8 @@ get_dirty_limits(long *pbackground, long
  */
 static void balance_dirty_pages(struct address_space *mapping)
 {
-	long bdi_nr_reclaimable;
-	long bdi_nr_writeback;
+	long nr_reclaimable, bdi_nr_reclaimable;
+	long nr_writeback, bdi_nr_writeback;
 	long background_thresh;
 	long dirty_thresh;
 	long bdi_thresh;
@@ -376,11 +376,26 @@ static void balance_dirty_pages(struct a
 
 		get_dirty_limits(&background_thresh, &dirty_thresh,
 				&bdi_thresh, bdi);
+
+		nr_reclaimable = global_page_state(NR_FILE_DIRTY) +
+					global_page_state(NR_UNSTABLE_NFS);
+		nr_writeback = global_page_state(NR_WRITEBACK);
+
 		bdi_nr_reclaimable = bdi_stat(bdi, BDI_RECLAIMABLE);
 		bdi_nr_writeback = bdi_stat(bdi, BDI_WRITEBACK);
+
 		if (bdi_nr_reclaimable + bdi_nr_writeback <= bdi_thresh)
 			break;
 
+		/*
+		 * Throttle it only when the background writeback cannot
+		 * catch-up. This avoids (excessively) small writeouts
+		 * when the bdi limits are ramping up.
+		 */
+		if (nr_reclaimable + nr_writeback <
+				(background_thresh + dirty_thresh) / 2)
+			break;
+
 		if (!bdi->dirty_exceeded)
 			bdi->dirty_exceeded = 1;
 


