Return-Path: <linux-kernel-owner+w=401wt.eu-S1758788AbZJGK3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758788AbZJGK3t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 06:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758150AbZJGK3t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 06:29:49 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:50923 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757923AbZJGK3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 06:29:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=a6h+XCEcf1IqjIy9I1HEOLwPH49dVMYE+dXqWLTWfoYOMXxp7B+jJ43jIFjOC4hTnE
         zZ36MpOjERwdRAOeXa+VmcKFrVygMyNihrP+x/AmOnlHIEloKYykM5KPVxCtR2zFFICl
         Q98wHTuhQibqMVf0OUOk9rNOx7kxZu5Bft6pw=
Message-ID: <4ACC6D74.7010001@tuffmail.co.uk>
Date: Wed, 07 Oct 2009 11:29:08 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Russell King <rmk+kernel@arm.linux.org.uk>
CC: linux-arm-kernel@lists.infradead.org,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Tejun Heo <htejun@gmail.com>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH] arm: use unified discard definition in linker script
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I selfishly request an Acked-by for the following. My aim is to submit it as
part of a larger series ("module: Speed up symbol resolution during module
loading") which would not go through the ARM tree.

------------------------------------------------------------------->
>From 52c4a00b22fecf3ecb352618356bb61f7f4b261b Mon Sep 17 00:00:00 2001
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Date: Wed, 7 Oct 2009 11:08:34 +0100
Subject: [PATCH] arm: use unified discard definition in linker script

Commit 023bf6f "linker script: unify usage of discard definition"
changed the linker scripts for all architectures except for ARM.
I can find no discussion about this exception, so here are the changes
for ARM.

These changes are exactly parallel to the ia64 case.

"ia64 is notable because it first throws away some ia64 specific
 subsections and then include the rest of the sections into the final
 image, so those sections must be discarded before the inclusion."

Not boot-tested.  In build testing, the modified linker script generated
an identical vmlinux file.


[I would like to be able to rely on this unified discard definition.
 I want to sort the kernel symbol tables to allow faster symbol
 resolution during module loading. The simplest way appears to be
 to generate sorted versions from vmlinux.o, link them in to vmlinux,
 _and discard the original unsorted tables_.

 This work is driven by my x86 netbook, but it is implemented at a
 generic level. It is possible it will benefit some ARM systems also.]


Signed-off-by: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
CC: Tejun Heo <tj@kernel.org>
---
 arch/arm/kernel/vmlinux.lds.S |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/arm/kernel/vmlinux.lds.S b/arch/arm/kernel/vmlinux.lds.S
index aecf87d..ec511d4 100644
--- a/arch/arm/kernel/vmlinux.lds.S
+++ b/arch/arm/kernel/vmlinux.lds.S
@@ -79,11 +79,11 @@ SECTIONS
 #endif
 	}
 
-	/DISCARD/ : {			/* Exit code and data		*/
-		EXIT_TEXT
-		EXIT_DATA
-		*(.exitcall.exit)
-		*(.discard)
+	/*
+	 * unwind exit sections must be discarded before the rest of the
+	 * unwind sections get included.
+	 */
+	/DISCARD/ : {
 		*(.ARM.exidx.exit.text)
 		*(.ARM.extab.exit.text)
 #ifndef CONFIG_HOTPLUG_CPU
@@ -271,6 +271,9 @@ SECTIONS
 	.stab.index 0 : { *(.stab.index) }
 	.stab.indexstr 0 : { *(.stab.indexstr) }
 	.comment 0 : { *(.comment) }
+
+	/* Default discards */
+	DISCARDS
 }
 
 /*
-- 
1.6.3.2



