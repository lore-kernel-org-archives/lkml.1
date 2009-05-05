Return-Path: <linux-kernel-owner+w=401wt.eu-S932176AbZEEA1b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932176AbZEEA1b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 20:27:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757339AbZEEA07
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 20:26:59 -0400
Received: from smtp-out.google.com ([216.239.45.13]:37083 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756712AbZEEA06 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 20:26:58 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:content-id:x-system-of-record;
	b=I4t7pa3c7BQBfDoSAmCgHl0GoeRbYIIhLkOT8iDQDI+kF53XDST3Gbt2eGBpvKCqb
	JVbhVWrYIvyEBoh+AEJQg==
Date: Mon, 4 May 2009 17:26:55 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
cc: Nick Piggin <npiggin@suse.de>, San Mehat <san@android.com>,
       =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       linux-kernel@vger.kernel.org
Subject: [patch 2/7] lowmemorykiller: Don't count free space unless it meets
 the specified limit by itself
In-Reply-To: <alpine.DEB.2.00.0905041722040.11756@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0905041724041.11756@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905041722040.11756@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="497827084-1602254031-1241483086=:11756"
Content-ID: <alpine.DEB.2.00.0905041726550.11756@chino.kir.corp.google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--497827084-1602254031-1241483086=:11756
Content-Type: TEXT/PLAIN; CHARSET=UTF-8
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.00.0905041726551.11756@chino.kir.corp.google.com>

From: Arve Hjønnevåg <arve@android.com>

This allows processes to be killed when the kernel evict cache pages in
an attempt to get more contiguous free memory.

Signed-off-by: Arve Hjønnevåg <arve@android.com>
---
 drivers/staging/android/lowmemorykiller.c |   13 +++++++++----
 1 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -58,20 +58,25 @@ static int lowmem_shrink(int nr_to_scan, gfp_t gfp_mask)
 	int min_adj = OOM_ADJUST_MAX + 1;
 	int selected_tasksize = 0;
 	int array_size = ARRAY_SIZE(lowmem_adj);
-	int other_free = global_page_state(NR_FREE_PAGES) + global_page_state(NR_FILE_PAGES);
+	int other_free = global_page_state(NR_FREE_PAGES);
+	int other_file = global_page_state(NR_FILE_PAGES);
 	if(lowmem_adj_size < array_size)
 		array_size = lowmem_adj_size;
 	if(lowmem_minfree_size < array_size)
 		array_size = lowmem_minfree_size;
 	for(i = 0; i < array_size; i++) {
-		if(other_free < lowmem_minfree[i]) {
+		if (other_free < lowmem_minfree[i] &&
+		    other_file < lowmem_minfree[i]) {
 			min_adj = lowmem_adj[i];
 			break;
 		}
 	}
 	if(nr_to_scan > 0)
-		lowmem_print(3, "lowmem_shrink %d, %x, ofree %d, ma %d\n", nr_to_scan, gfp_mask, other_free, min_adj);
-	rem = global_page_state(NR_ACTIVE) + global_page_state(NR_INACTIVE);
+		lowmem_print(3, "lowmem_shrink %d, %x, ofree %d %d, ma %d\n", nr_to_scan, gfp_mask, other_free, other_file, min_adj);
+	rem = global_page_state(NR_ACTIVE_ANON) +
+		global_page_state(NR_ACTIVE_FILE) +
+		global_page_state(NR_INACTIVE_ANON) +
+		global_page_state(NR_INACTIVE_FILE);
 	if (nr_to_scan <= 0 || min_adj == OOM_ADJUST_MAX + 1) {
 		lowmem_print(5, "lowmem_shrink %d, %x, return %d\n", nr_to_scan, gfp_mask, rem);
 		return rem;
--497827084-1602254031-1241483086=:11756--
