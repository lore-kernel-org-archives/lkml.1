Return-Path: <linux-kernel-owner+w=401wt.eu-S1759694AbZFIKTw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759694AbZFIKTw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:19:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760404AbZFIKRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:17:53 -0400
Received: from kroah.org ([198.145.64.141]:54470 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760395AbZFIKRw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:17:52 -0400
X-Mailbox-Line: From greg@blue.kroah.org Tue Jun  9 02:40:56 2009
Message-Id: <20090609094056.238393901@blue.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 09 Jun 2009 02:39:06 -0700
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
       alan@lxorguk.ukuu.org.uk, linux-mm@kvack.org,
       Matt Mackall <mpm@selenic.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 18/87] mm: SLUB fix reclaim_state
References: <20090609093848.204935043@blue.kroah.org>
Content-Disposition: inline; filename=mm-slub-fix-reclaim_state.patch
In-Reply-To: <20090609094451.GA26439@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Nick Piggin <npiggin@suse.de>

commit 1eb5ac6466d4be7b15b38ce3ab709600f1bc891f upstream.

SLUB does not correctly account reclaim_state.reclaimed_slab, so it will
break memory reclaim. Account it like SLAB does.

Cc: linux-mm@kvack.org
Cc: Matt Mackall <mpm@selenic.com>
Acked-by: Christoph Lameter <cl@linux-foundation.org>
Signed-off-by: Nick Piggin <npiggin@suse.de>
Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/slub.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/mm/slub.c
+++ b/mm/slub.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/mm.h>
+#include <linux/swap.h> /* struct reclaim_state */
 #include <linux/module.h>
 #include <linux/bit_spinlock.h>
 #include <linux/interrupt.h>
@@ -1175,6 +1176,8 @@ static void __free_slab(struct kmem_cach
 
 	__ClearPageSlab(page);
 	reset_page_mapcount(page);
+	if (current->reclaim_state)
+		current->reclaim_state->reclaimed_slab += pages;
 	__free_pages(page, order);
 }
 


