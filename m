Return-Path: <linux-kernel-owner+w=401wt.eu-S1753737AbYJ3TYt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbYJ3TYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 15:24:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752588AbYJ3TX5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 15:23:57 -0400
Received: from smtp-out.google.com ([216.239.45.13]:38421 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbYJ3TX4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 15:23:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=lLZ87YvBKUnZccXOS8wjN1Tr+sXWMnfETdvYALMU+6smxvXYcQ8H/HohU9gZwd09Q
	77KMWT7XKaEmeozBB7kfw==
Date: Thu, 30 Oct 2008 12:23:14 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Christoph Lameter <cl@linux-foundation.org>, Nick Piggin <npiggin@suse.de>,
       Peter Zijlstra <peterz@infradead.org>, Paul Menage <menage@google.com>,
       Derek Fults <dfults@sgi.com>, linux-kernel@vger.kernel.org
Subject: [patch 4/7] mm: cpuset aware reclaim writeout
In-Reply-To: <alpine.DEB.2.00.0810292337170.23858@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0810300311070.18283@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0810292337170.23858@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Lameter <cl@linux-foundation.org>

During direct reclaim we traverse down a zonelist and are carefully
checking each zone if it's a member of the active cpuset.  But then we
call pdflush without enforcing the same restrictions.  In a larger system
this may have the effect of a massive amount of pages being dirtied and
then either

 - no writeout occurs because global dirty limits have not been reached,
   or

 - writeout starts randomly for some dirty inode in the system.  pdflush
   may just write out data for nodes in another cpuset and miss doing
   proper dirty handling for the current cpuset.

In both cases, dirty pages in the zones of interest may not be affected
and writeout may not occur as necessary.

Fix that by restricting pdflush to the active cpuset.  Writeout will occur
from direct reclaim the same way as without a cpuset.

Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Menage <menage@google.com>
Cc: Derek Fults <dfults@sgi.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 mm/vmscan.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1604,7 +1604,8 @@ static unsigned long do_try_to_free_pages(struct zonelist *zonelist,
 		 */
 		if (total_scanned > sc->swap_cluster_max +
 					sc->swap_cluster_max / 2) {
-			wakeup_pdflush(laptop_mode ? 0 : total_scanned, NULL);
+			wakeup_pdflush(laptop_mode ? 0 : total_scanned,
+				       &cpuset_current_mems_allowed);
 			sc->may_writepage = 1;
 		}
 
