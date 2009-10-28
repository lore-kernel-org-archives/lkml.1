Return-Path: <linux-kernel-owner+w=401wt.eu-S1755228AbZJ1RSU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755228AbZJ1RSU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 13:18:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755167AbZJ1RSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 13:18:18 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33412 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755163AbZJ1RSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 13:18:17 -0400
Subject: [PATCH 1/3] kmemleak: Release the object lock before calling
	put_object()
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Wed, 28 Oct 2009 17:18:20 +0000
Message-ID: <20091028171820.19220.70957.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20091028171426.19220.658.stgit@pc1117.cambridge.arm.com>
References: <20091028171426.19220.658.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.15-1-g9f9ed
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 28 Oct 2009 17:18:21.0149 (UTC) FILETIME=[A5F528D0:01CA57F2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The put_object() function may free the object if the use_count
dropped to 0. There shouldn't be further accesses to such object unless
it is known that the use_count is non-zero.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 mm/kmemleak.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 9610635..f06c092 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1025,11 +1025,14 @@ static void scan_block(void *_start, void *_end,
 		 * added to the gray_list.
 		 */
 		object->count++;
-		if (color_gray(object))
+		if (color_gray(object)) {
 			list_add_tail(&object->gray_list, &gray_list);
-		else
-			put_object(object);
+			spin_unlock_irqrestore(&object->lock, flags);
+			continue;
+		}
+
 		spin_unlock_irqrestore(&object->lock, flags);
+		put_object(object);
 	}
 }
 

