Return-Path: <linux-kernel-owner+w=401wt.eu-S1760270AbZFZOOF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760270AbZFZOOF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 10:14:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758793AbZFZON1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 10:13:27 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:61947 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760459AbZFZONZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 10:13:25 -0400
Subject: [PATCH 4/4] kmemleak: Slightly change the policy on newly allocated
	objects
To: linux-kernel@vger.kernel.org
From: Catalin Marinas <catalin.marinas@arm.com>
Cc: Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Sergey Senozhatsky <sergey.senozhatsky@mail.by>
Date: Fri, 26 Jun 2009 15:12:58 +0100
Message-ID: <20090626141258.31504.36983.stgit@pc1117.cambridge.arm.com>
In-Reply-To: <20090626140847.31504.79381.stgit@pc1117.cambridge.arm.com>
References: <20090626140847.31504.79381.stgit@pc1117.cambridge.arm.com>
User-Agent: StGit/0.14.3.387.geb0c.dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 26 Jun 2009 14:12:58.0862 (UTC) FILETIME=[3555D8E0:01C9F668]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Newly allocated objects are more likely to be reported as false
positives. Kmemleak ignores the reporting of objects younger than 5
seconds. However, this age was calculated after the memory scanning
completed which usually takes longer than 5 seconds. This patch
make the minimum object age calculation in relation to the start of the
memory scanning.

Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
---
 mm/kmemleak.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index e96e0ec..c37e8e5 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -190,7 +190,9 @@ static unsigned long max_addr;
 static unsigned long next_scan_yield;
 static struct task_struct *scan_thread;
 static unsigned long jiffies_scan_yield;
+/* used to avoid reporting of recently allocated objects */
 static unsigned long jiffies_min_age;
+static unsigned long jiffies_last_scan;
 /* delay between automatic memory scannings */
 static signed long jiffies_scan_wait;
 /* enables or disables the task stacks scanning */
@@ -284,7 +286,8 @@ static int color_gray(const struct kmemleak_object *object)
 static int unreferenced_object(struct kmemleak_object *object)
 {
 	return (object->flags & OBJECT_ALLOCATED) && color_white(object) &&
-		time_is_before_eq_jiffies(object->jiffies + jiffies_min_age);
+		time_before_eq(object->jiffies + jiffies_min_age,
+			       jiffies_last_scan);
 }
 
 /*
@@ -927,6 +930,8 @@ static void kmemleak_scan(void)
 	int i;
 	int new_leaks = 0;
 
+	jiffies_last_scan = jiffies;
+
 	/* prepare the kmemleak_object's */
 	rcu_read_lock();
 	list_for_each_entry_rcu(object, &object_list, object_list) {

