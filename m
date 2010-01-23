Return-Path: <linux-kernel-owner+w=401wt.eu-S932142Ab0AWTOe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932142Ab0AWTOe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jan 2010 14:14:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756151Ab0AWTOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Jan 2010 14:14:31 -0500
Received: from vms173019pub.verizon.net ([206.46.173.19]:34808 "EHLO
	vms173019pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057Ab0AWTOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jan 2010 14:14:30 -0500
Date: Sat, 23 Jan 2010 14:14:11 -0500 (EST)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: stable@kernel.org
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       Xiaotian Feng <dfeng@redhat.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 2.6.32.stable] ACPI: don't cond_resched if irq is disabled
Message-id: <alpine.LFD.2.00.1001231411540.5156@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiaotian Feng <dfeng@redhat.com>

upstream c084ca704a3661bf77690a05bc6bd2c305d87c34

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
Acked-by: Alexey Starikovskiy <astarikovskiy@suse.de>
Signed-off-by: Len Brown <len.brown@intel.com>
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
1.6.6.1.383.g5a9f

