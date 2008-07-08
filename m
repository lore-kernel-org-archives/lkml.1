Return-Path: <linux-kernel-owner+w=401wt.eu-S932065AbYGHXb5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065AbYGHXb5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 19:31:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757826AbYGHXP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 19:15:27 -0400
Received: from gw.goop.org ([64.81.55.164]:51214 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756208AbYGHXOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 19:14:42 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 18 of 55] xen64: get active_mm from the pda
X-Mercurial-Node: 49bcf419cdd58fe65fcb7bc0a08004ac2867faac
Message-Id: <49bcf419cdd58fe65fcb.1215554800@localhost>
In-Reply-To: <patchbomb.1215554782@localhost>
Date: Tue, 08 Jul 2008 15:06:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
       Stephen Tweedie <sct@redhat.com>, Eduardo Habkost <ehabkost@redhat.com>,
       Mark McLoughlin <markmc@redhat.com>, x86@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

x86_64 stores the active_mm in the pda, so fetch it from there.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/xen/mmu.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -805,8 +805,15 @@
 static void drop_other_mm_ref(void *info)
 {
 	struct mm_struct *mm = info;
+	struct mm_struct *active_mm;
 
-	if (__get_cpu_var(cpu_tlbstate).active_mm == mm)
+#ifdef CONFIG_X86_64
+	active_mm = read_pda(active_mm);
+#else
+	active_mm = __get_cpu_var(cpu_tlbstate).active_mm;
+#endif
+
+	if (active_mm == mm)
 		leave_mm(smp_processor_id());
 
 	/* If this cpu still has a stale cr3 reference, then make sure


