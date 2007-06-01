Return-Path: <linux-kernel-owner+w=401wt.eu-S1759737AbXFAGN3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759737AbXFAGN3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 02:13:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757386AbXFAGNU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 02:13:20 -0400
Received: from smtp-out.google.com ([216.239.45.13]:39597 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757176AbXFAGNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 02:13:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=FKLePwX6NbosHBLq5kHdwYjR+mAu2bbXmK6pyreopZ2JD9Kbtt9oS8rL8a2QQb7zP
	7fK3fWe0j7tk1rZYoIgeQ==
Message-ID: <465FB8F1.7040806@google.com>
Date: Thu, 31 May 2007 23:13:05 -0700
From: Ethan Solomita <solo@google.com>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@google.com>, a.p.zijlstra@chello.nl
Subject: [RFC 4/7] cpuset write vmscan
References: <465FB6CF.4090801@google.com>
In-Reply-To: <465FB6CF.4090801@google.com>
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

Originally by Christoph Lameter <clameter@sgi.com>

Signed-off-by: Ethan Solomita <solo@google.com>

---

diff -uprN -X 0/Documentation/dontdiff 3/mm/vmscan.c 4/mm/vmscan.c
--- 3/mm/vmscan.c	2007-05-30 11:34:21.000000000 -0700
+++ 4/mm/vmscan.c	2007-05-30 11:36:17.000000000 -0700
@@ -1198,7 +1198,8 @@ unsigned long try_to_free_pages(struct z
 		 */
 		if (total_scanned > sc.swap_cluster_max +
 					sc.swap_cluster_max / 2) {
-			wakeup_pdflush(laptop_mode ? 0 : total_scanned, NULL);
+			wakeup_pdflush(laptop_mode ? 0 : total_scanned,
+				&cpuset_current_mems_allowed);
 			sc.may_writepage = 1;
 		}
 

