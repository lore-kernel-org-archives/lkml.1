Return-Path: <linux-kernel-owner+w=401wt.eu-S1754008Ab0AZXnD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008Ab0AZXnD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 18:43:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753949Ab0AZXm6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 18:42:58 -0500
Received: from kroah.org ([198.145.64.141]:35069 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753871Ab0AZXm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 18:42:56 -0500
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jan 26 15:39:21 2010
Message-Id: <20100126233921.234239513@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 26 Jan 2010 15:33:29 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Xiaotian Feng <dfeng@redhat.com>,
       Alexey Starikovskiy <astarikovskiy@suse.de>,
       Len Brown <len.brown@intel.com>
Subject: [03/98] ACPI: dont cond_resched if irq is disabled
In-Reply-To: <20100126233950.GA5372@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Xiaotian Feng <dfeng@redhat.com>

commit c084ca704a3661bf77690a05bc6bd2c305d87c34 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/acpi/platform/aclinux.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/acpi/platform/aclinux.h
+++ b/include/acpi/platform/aclinux.h
@@ -152,7 +152,7 @@ static inline void *acpi_os_acquire_obje
 #include <linux/hardirq.h>
 #define ACPI_PREEMPTION_POINT() \
 	do { \
-		if (!in_atomic_preempt_off()) \
+		if (!in_atomic_preempt_off() && !irqs_disabled()) \
 			cond_resched(); \
 	} while (0)
 


