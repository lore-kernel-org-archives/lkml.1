Return-Path: <linux-kernel-owner+w=401wt.eu-S1758172AbZEDQfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758172AbZEDQfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 12:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757506AbZEDQf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 12:35:29 -0400
Received: from smtp-out.google.com ([216.239.33.17]:22971 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757341AbZEDQf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 12:35:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=u5NwfYup3SO1R2CUl+shGWoe8vwOggZMb4DmrIkeSxQZkjabKQHqbS63OfpnAYt2c
	fiEYTuOtZXMtRheA2qMWg==
Date: Mon, 4 May 2009 09:35:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Nick Piggin <npiggin@suse.de>, San Mehat <san@android.com>,
       linux-kernel@vger.kernel.org
Subject: [patch 2/5] oom: fix possible android low memory killer NULL
 pointer
In-Reply-To: <alpine.DEB.2.00.0905031305130.18426@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0905031306140.18426@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905031305130.18426@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_mm_rss() atomically dereferences the actual without checking for a
NULL pointer, which is possible since task_lock() is not held.

Cc: San Mehat <san@android.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/staging/android/lowmemorykiller.c |   10 ++++++++--
 1 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/android/lowmemorykiller.c b/drivers/staging/android/lowmemorykiller.c
--- a/drivers/staging/android/lowmemorykiller.c
+++ b/drivers/staging/android/lowmemorykiller.c
@@ -80,12 +80,18 @@ static int lowmem_shrink(int nr_to_scan, gfp_t gfp_mask)
 	for_each_process(p) {
 		int oom_adj;
 
-		if (!p->mm)
+		task_lock(p);
+		if (!p->mm) {
+			task_unlock(p);
 			continue;
+		}
 		oom_adj = p->oomkilladj;
-		if (oom_adj < 0)
+		if (oom_adj < 0) {
+			task_unlock(p);
 			continue;
+		}
 		tasksize = get_mm_rss(p->mm);
+		task_unlock(p);
 		if (nr_to_scan > 0 && tasksize > 0) {
 			if (!selected || oom_adj > selected_oom_adj ||
 			    (oom_adj == selected_oom_adj &&
