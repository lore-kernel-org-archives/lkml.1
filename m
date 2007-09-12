Return-Path: <linux-kernel-owner+w=401wt.eu-S1763577AbXILBkw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763577AbXILBkw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 21:40:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760048AbXILBkn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 21:40:43 -0400
Received: from smtp-out.google.com ([216.239.33.17]:44917 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502AbXILBkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 21:40:43 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:references:in-reply-to:content-type:content-transfer-encoding;
	b=uPl/8cEWfYjXSQDJ4XGk7o91kxXc7tYZZxcbPopvDqolX1pXFE6U1G2O6ceq3xSz6
	kTjg/v4W24PCtpnmG83rw==
Message-ID: <46E7437D.3000501@google.com>
Date: Tue, 11 Sep 2007 18:40:13 -0700
From: Ethan Solomita <solo@google.com>
User-Agent: Thunderbird 1.5.0.12 (X11/20070604)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
       Christoph Lameter <clameter@sgi.com>
Subject: [PATCH 4/6] cpuset write vmscan
References: <469D3342.3080405@google.com> <46E741B1.4030100@google.com>
In-Reply-To: <46E741B1.4030100@google.com>
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

Patch against 2.6.23-rc4-mm1

diff -uprN -X 0/Documentation/dontdiff 3/mm/vmscan.c 4/mm/vmscan.c
--- 3/mm/vmscan.c	2007-09-11 14:41:56.000000000 -0700
+++ 4/mm/vmscan.c	2007-09-11 14:50:41.000000000 -0700
@@ -1301,7 +1301,8 @@ unsigned long do_try_to_free_pages(struc
 		 */
 		if (total_scanned > sc->swap_cluster_max +
 					sc->swap_cluster_max / 2) {
-			wakeup_pdflush(laptop_mode ? 0 : total_scanned, NULL);
+			wakeup_pdflush(laptop_mode ? 0 : total_scanned,
+				&cpuset_current_mems_allowed);
 			sc->may_writepage = 1;
 		}
 

