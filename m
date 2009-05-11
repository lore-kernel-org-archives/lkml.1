Return-Path: <linux-kernel-owner+w=401wt.eu-S1760608AbZEKWqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760608AbZEKWqo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 18:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760246AbZEKWpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 18:45:21 -0400
Received: from smtp-out.google.com ([216.239.45.13]:48032 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759725AbZEKWpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 18:45:16 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=jrskBN5oqkfpxcN+610q2qBOiv/Hg+cqiwgSTn0n8jJiQYXyu9xhT3rX3m+XTQn8C
	xCzT1bJvMxSz7BycphRFw==
Date: Mon, 11 May 2009 15:45:14 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Greg Kroah-Hartman <gregkh@suse.de>
cc: =?UTF-8?Q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
       San Mehat <san@android.com>, linux-kernel@vger.kernel.org
Subject: [patch 4/4] lowmemorykiller: fix possible android low memory killer
 NULL pointer
In-Reply-To: <alpine.DEB.2.00.0905111539500.5533@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.0905111544140.5533@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.0905111539500.5533@chino.kir.corp.google.com>
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
@@ -92,12 +92,18 @@ static int lowmem_shrink(int nr_to_scan, gfp_t gfp_mask)
 	for_each_process(p) {
 		int oom_adj;
 
-		if (!p->mm)
+		task_lock(p);
+		if (!p->mm) {
+			task_unlock(p);
 			continue;
+		}
 		oom_adj = p->oomkilladj;
-		if (oom_adj < min_adj)
+		if (oom_adj < min_adj) {
+			task_unlock(p);
 			continue;
+		}
 		tasksize = get_mm_rss(p->mm);
+		task_unlock(p);
 		if (tasksize <= 0)
 			continue;
 		if (selected) {
