Return-Path: <linux-kernel-owner+w=401wt.eu-S1753027AbYDIIag@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027AbYDIIag (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 04:30:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754446AbYDIIaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 04:30:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:42425 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754357AbYDIIaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 04:30:09 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Amnon Shiloh <u3557@miso.sublimeip.com>, linux-kernel@vger.kernel.org
X-Fcc: ~/Mail/linus
Subject: [PATCH 2/2] x86 vdso: don't map 32-bit vdso when disabled
In-Reply-To: Roland McGrath's message of  Wednesday, 9 April 2008 01:27:03 -0700 <20080409082703.B805926F992@magilla.localdomain>
References: <20080409082703.B805926F992@magilla.localdomain>
X-Antipastobozoticataclysm: Bariumenemanilow
Message-Id: <20080409083006.CC21A26F992@magilla.localdomain>
Date: Wed,  9 Apr 2008 01:30:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We map a VMA for the 32-bit vDSO even when it's disabled, which is stupid.
For the 32-bit kernel it's the vdso_enabled boot parameter/sysctl
and for the 64-bit kernel it's the vdso32 boot parameter/syscall32 sysctl.

When it's disabled, we don't pass AT_SYSINFO_EHDR so processes don't use
the vDSO for anything, but we still map it.  For the non-compat vDSO,
this means we're always putting an extra VMA somewhere, maybe lousing
up the control of the address space the user was hoping for.

Honor the setting by doing nothing in arch_setup_additional_pages.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/vdso/vdso32-setup.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index 348f134..f7e78d8 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -325,6 +325,9 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int exstack)
 	int ret = 0;
 	bool compat;
 
+	if (vdso_enabled == VDSO_DISABLED)
+		return 0;
+
 	down_write(&mm->mmap_sem);
 
 	/* Test compat mode once here, in case someone
