Return-Path: <linux-kernel-owner+w=401wt.eu-S934237AbZLJL5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934237AbZLJL5X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 06:57:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934093AbZLJL5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 06:57:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934007AbZLJL5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 06:57:16 -0500
From: Xiaotian Feng <dfeng@redhat.com>
To: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>,
       Len Brown <lenb@kernel.org>, Bob Moore <robert.moore@intel.com>,
       Lin Ming <ming.m.lin@intel.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Pavel Machek <pavel@ucw.cz>
Subject: [PATCH -V2] acpi: don't cond_resched if irq is disabled
Date: Thu, 10 Dec 2009 19:56:45 +0800
Message-Id: <1260446205-16868-1-git-send-email-dfeng@redhat.com>
In-Reply-To: <20091210100907.GA2446@ucw.cz>
References: <20091210100907.GA2446@ucw.cz>
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

This patch also fixes http://bugzilla.kernel.org/show_bug.cgi?id=14483

Reported-and-bisected-by: Larry Finger <Larry.Finger@lwfinger.net>
Reported-and-bisected-by: Justin P. Mattock <justinmattock@gmail.com>
Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
Cc: Len Brown <lenb@kernel.org>
Cc: Bob Moore <robert.moore@intel.com>
Cc: Lin Ming <ming.m.lin@intel.com>
Cc: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: Pavel Machek <pavel@ucw.cz>
---
 include/acpi/platform/aclinux.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/acpi/platform/aclinux.h b/include/acpi/platform/aclinux.h
index 9d7febd..0946997 100644
--- a/include/acpi/platform/aclinux.h
+++ b/include/acpi/platform/aclinux.h
@@ -152,7 +152,7 @@ static inline void *acpi_os_acquire_object(acpi_cache_t * cache)
 #include <linux/hardirq.h>
 #define ACPI_PREEMPTION_POINT() \
 	do { \
-		if (!in_atomic_preempt_off()) \
+		if (!in_atomic_preempt_off() && !irqs_disabled()) \
 			cond_resched(); \
 	} while (0)
 
-- 
1.6.5.2

