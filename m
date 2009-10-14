Return-Path: <linux-kernel-owner+w=401wt.eu-S1759219AbZJNTa6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759219AbZJNTa6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 15:30:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759174AbZJNTa5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 15:30:57 -0400
Received: from claw.goop.org ([74.207.240.146]:55340 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759096AbZJNT36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 15:29:58 -0400
From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Xen-devel <xen-devel@lists.xensource.com>, kurt.hackel@oracle.com,
       Glauber de Oliveira Costa <gcosta@redhat.com>,
       Avi Kivity <avi@redhat.com>, the arch/x86 maintainers <x86@kernel.org>,
       Chris Mason <chris.mason@oracle.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: [PATCH 11/12] x86/fixmap: add a predicate for usermode fixmaps
Date: Wed, 14 Oct 2009 12:28:35 -0700
Message-Id: <1255548516-15260-12-git-send-email-jeremy.fitzhardinge@citrix.com>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1255548516-15260-1-git-send-email-jeremy.fitzhardinge@citrix.com>
References: <1255548516-15260-1-git-send-email-jeremy.fitzhardinge@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some set of fixmaps are intented to be mapped into usermode.  Add a
predicate to test for those fixmaps.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
---
 arch/x86/include/asm/fixmap.h |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index b15c865..026ee10 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -183,6 +183,24 @@ static inline void __set_fixmap(enum fixed_addresses idx,
 
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

