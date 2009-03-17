Return-Path: <linux-kernel-owner+w=401wt.eu-S1756313AbZCQCNX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313AbZCQCNX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 22:13:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbZCQCNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 22:13:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:56121 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576AbZCQCNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 22:13:10 -0400
Date: Tue, 17 Mar 2009 02:12:34 GMT
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, jeremy@goop.org, hpa@zytor.com,
       mingo@redhat.com, akataria@vmware.com, tglx@linutronix.de,
       jeremy.fitzhardinge@citrix.com
Reply-To: mingo@redhat.com, hpa@zytor.com, jeremy@goop.org,
       linux-kernel@vger.kernel.org, tglx@linutronix.de, akataria@vmware.com,
       jeremy.fitzhardinge@citrix.com
In-Reply-To: <49BEEDC2.2070809@goop.org>
References: <49BEEDC2.2070809@goop.org>
Subject: [tip:x86/urgent] x86, paravirt: prevent gcc from generating the wrong addressing mode
Message-ID: <tip-42854dc0a6320ff36722749acafa0697522d9556@git.kernel.org>
Git-Commit-ID: 42854dc0a6320ff36722749acafa0697522d9556
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 17 Mar 2009 02:12:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  42854dc0a6320ff36722749acafa0697522d9556
Gitweb:     http://git.kernel.org/tip/42854dc0a6320ff36722749acafa0697522d9556
Author:     Jeremy Fitzhardinge <jeremy@goop.org>
AuthorDate: Mon, 16 Mar 2009 17:24:34 -0700
Commit:     H. Peter Anvin <hpa@zytor.com>
CommitDate: Mon, 16 Mar 2009 18:36:31 -0700

x86, paravirt: prevent gcc from generating the wrong addressing mode

Impact: fix crash on VMI (VMware)

When we generate a call sequence for calling a paravirtualized
function, we presume that the generated code is "call *0xXXXXX",
which is a 6 byte opcode; this is larger than a normal
direct call, and so we can patch a direct call over it.

At the moment, however we give gcc enough rope to hang us by
putting the address in a register and generating a two byte
indirect-via-register call.  Prevent this by explicitly
dereferencing the function pointer and passing it into the
asm as a constant.

This prevents crashes in VMI, as it cannot handle unpatchable
callsites.

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Cc: Alok Kataria <akataria@vmware.com>
LKML-Reference: <49BEEDC2.2070809@goop.org>
Signed-off-by: H. Peter Anvin <hpa@zytor.com>


---
 arch/x86/include/asm/paravirt.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/paravirt.h b/arch/x86/include/asm/paravirt.h
index e299287..0c212d5 100644
--- a/arch/x86/include/asm/paravirt.h
+++ b/arch/x86/include/asm/paravirt.h
@@ -360,7 +360,7 @@ extern struct pv_lock_ops pv_lock_ops;
 
 #define paravirt_type(op)				\
 	[paravirt_typenum] "i" (PARAVIRT_PATCH(op)),	\
-	[paravirt_opptr] "m" (op)
+	[paravirt_opptr] "i" (&(op))
 #define paravirt_clobber(clobber)		\
 	[paravirt_clobber] "i" (clobber)
 
@@ -412,7 +412,7 @@ int paravirt_disable_iospace(void);
  * offset into the paravirt_patch_template structure, and can therefore be
  * freely converted back into a structure offset.
  */
-#define PARAVIRT_CALL	"call *%[paravirt_opptr];"
+#define PARAVIRT_CALL	"call *%c[paravirt_opptr];"
 
 /*
  * These macros are intended to wrap calls through one of the paravirt
