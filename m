Return-Path: <linux-kernel-owner+w=401wt.eu-S936576AbXGQVgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936576AbXGQVgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 17:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934611AbXGQVgS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 17:36:18 -0400
Received: from smtp-out.google.com ([216.239.33.17]:43566 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936304AbXGQVgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 17:36:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=LrtNfBK7fWmUKQnslJZXlAjzYD/ddywUs5luuj/9dH1ZJzXV3Z0U10ndkDA7adZ0N
	eOvTXE2K3vgallgMinaeg==
Message-ID: <469D363E.5040508@google.com>
Date: Tue, 17 Jul 2007 14:35:58 -0700
From: Ethan Solomita <solo@google.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Ethan Solomita <solo@google.com>
CC: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@google.com>, Christoph Lameter <clameter@sgi.com>
Subject: [PATCH 4/6] cpuset write vmscan
References: <469D3342.3080405@google.com>
In-Reply-To: <469D3342.3080405@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Direct reclaim: cpuset aware writeout

During direct reclaim we traverse down a zonelist and are carefully
checking each zone if its a member of the active cpuset. But then we call
pdflush without enforcing the same restrictions. In a larger system this
may have the effect of a massive amount of pages being dirtied and then either

A. No writeout occurs because global dirty limits have not been reached

or

B. Writeout starts randomly for some dirty inode in the system. Pdflush
   may just write out data for nodes in another cpuset and miss doing
   proper dirty handling for the current cpuset.

In both cases dirty pages in the zones of interest may not be affected
and writeout may not occur as necessary.

Fix that by restricting pdflush to the active cpuset. Writeout will occur
from direct reclaim the same way as without a cpuset.

Signed-off-by: Christoph Lameter <clameter@sgi.com>
Acked-by: Ethan Solomita <solo@google.com>

---

Patch against 2.6.22-rc6-mm1

diff -uprN -X 0/Documentation/dontdiff 3/mm/vmscan.c 4/mm/vmscan.c
--- 3/mm/vmscan.c	2007-07-11 21:16:14.000000000 -0700
+++ 4/mm/vmscan.c	2007-07-11 21:16:26.000000000 -0700
@@ -1183,7 +1183,8 @@ unsigned long try_to_free_pages(struct z
 		 */
 		if (total_scanned > sc.swap_cluster_max +
 					sc.swap_cluster_max / 2) {
-			wakeup_pdflush(laptop_mode ? 0 : total_scanned, NULL);
+			wakeup_pdflush(laptop_mode ? 0 : total_scanned,
+				&cpuset_current_mems_allowed);
 			sc.may_writepage = 1;
 		}
 

