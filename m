Return-Path: <linux-kernel-owner+w=401wt.eu-S1755867AbZJFAvb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbZJFAvb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 20:51:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755851AbZJFAvb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 20:51:31 -0400
Received: from claw.goop.org ([74.207.240.146]:35242 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754626AbZJFAuy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 20:50:54 -0400
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
To: Xen-devel <xen-devel@lists.xensource.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       kurt.hackel@oracle.com, Dan Magenheimer <dan.magenheimer@oracle.com>,
       Keir Fraser <keir.fraser@eu.citrix.com>,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Avi Kivity <avi@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       the arch/x86 maintainers <x86@kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 4/5] x86/fixmap: add a predicate for usermode fixmaps
Date: Mon,  5 Oct 2009 17:50:10 -0700
Message-Id: <1254790211-15416-5-git-send-email-jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1254790211-15416-1-git-send-email-jeremy.fitzhardinge@citrix.com>
References: <1254790211-15416-1-git-send-email-jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some set of fixmaps are intented to be mapped into usermode.  Add an
predicate to test for those fixmaps.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/fixmap.h |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index ff3cffa..0edc2bb 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -181,6 +181,24 @@ static inline void __set_fixmap(enum fixed_addresses idx,
 
 extern void __this_fixmap_does_not_exist(void);
 
+static inline bool user_fixmap(enum fixed_addresses fixmap)
+{
+	switch (fixmap) {
+#ifdef CONFIG_X86_32
+	case FIX_HOLE ... FIX_VDSO:
+#else
+	case VSYSCALL_LAST_PAGE ... VSYSCALL_HPET:
+#ifdef CONFIG_PARAVIRT_CLOCK_VSYSCALL
+	case FIX_PVCLOCK_TIME_INFO:
+#endif
+#endif
+		return true;
+
+	default:
+		return false;
+	}
+}
+
 /*
  * 'index to address' translation. If anyone tries to use the idx
  * directly without translation, we catch the bug with a NULL-deference
-- 
1.6.2.5

