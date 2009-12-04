Return-Path: <linux-kernel-owner+w=401wt.eu-S1755952AbZLDE0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbZLDE0X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 23:26:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755405AbZLDE0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 23:26:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753922AbZLDE0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 23:26:20 -0500
From: Xiaotian Feng <dfeng@redhat.com>
To: lenb@kernel.org, ming.m.lin@intel.com, robert.moore@intel.com,
       linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>
Subject: [PATCH] ACPICA: don't cond_resched() when irq_disabled or in_atomic
Date: Fri,  4 Dec 2009 12:26:00 +0800
Message-Id: <1259900760-6424-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 8bd108d adds preemption point after each opcode parse, then
a sleeping function called from invalid context bug was founded
during suspend/resume stage. this was fixed in commit abe1dfa by
don't cond_resched when irq_disabled. But recent commit 138d156 changes
the behaviour to don't cond_resched when in_atomic. This makes the
sleeping function called from invalid context bug happen again, which
is reported in http://lkml.org/lkml/2009/12/1/371.

The fix is to cond_sched() only when preemptible, which means not in
irq_disabled or in_atomic.

Reported-and-bisected-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
---
 include/acpi/platform/aclinux.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
index 9d7febd..5b415ee 100644
--- a/include/acpi/platform/aclinux.h
+++ b/include/acpi/platform/aclinux.h
@@ -152,7 +152,7 @@ static inline void *acpi_os_acquire_object(acpi_cache_t * cache)
 #include <linux/hardirq.h>
 #define ACPI_PREEMPTION_POINT() \
 	do { \
-		if (!in_atomic_preempt_off()) \
+		if (preemptible()) \
 			cond_resched(); \
 	} while (0)
 
-- 
1.6.5.2

