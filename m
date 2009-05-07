Return-Path: <linux-kernel-owner+w=401wt.eu-S1763539AbZEGW20@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763539AbZEGW20 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 18:28:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762864AbZEGW1N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 18:27:13 -0400
Received: from mga06.intel.com ([134.134.136.21]:35559 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752860AbZEGW1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 18:27:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,312,1239001200"; 
   d="scan'208";a="410470417"
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: vgoyal@redhat.com, hbabu@us.ibm.com, kexec@lists.infradead.org,
       ying.huang@intel.com, mingo@elte.hu, tglx@linutronix.de,
       ebiederm@xmission.com, sam@ravnborg.org,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: [PATCH 03/14] x86, config: change defaults PHYSICAL_START and PHYSICAL_ALIGN
Date: Thu,  7 May 2009 15:26:51 -0700
Message-Id: <1241735222-6640-4-git-send-email-hpa@linux.intel.com>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <1241735222-6640-1-git-send-email-hpa@linux.intel.com>
References: <1241735222-6640-1-git-send-email-hpa@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: H. Peter Anvin <hpa@zytor.com>

Change the default for CONFIG_PHYSICAL_START to 16 MB; 4 MB if
EMBEDDED.  Change the default for CONFIG_PHYSICAL_ALIGN to match up
with a large page alignment datum (4 MB for non-PAE, 2 MB for PAE.)

The default of 16 MB is designed to avoid occupying ZONE_DMA, as well
as avoiding a 15-16 MB memory hole, which some vendors inexplicably
still have in their systems.

[ Impact: minor performance improvement, leave ZONE_DMA free ]

Signed-off-by: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/Kconfig |   19 +++++++++++--------
 1 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 039c3f0..13b3a5a 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1455,17 +1455,20 @@ config KEXEC_JUMP
 
 config PHYSICAL_START
 	hex "Physical address where the kernel is loaded" if (EMBEDDED || CRASH_DUMP)
-	default "0x1000000" if X86_NUMAQ
-	default "0x200000" if X86_64
-	default "0x100000"
+	default "0x400000" if EMBEDDED
+	default "0x1000000"
 	---help---
 	  This gives the physical address where the kernel is loaded.
 
 	  If kernel is a not relocatable (CONFIG_RELOCATABLE=n) then
 	  bzImage will decompress itself to above physical address and
-	  run from there. Otherwise, bzImage will run from the address where
-	  it has been loaded by the boot loader and will ignore above physical
-	  address.
+	  run from there. Otherwise, bzImage will run from the either
+	  the above physical address or where it has been loaded by
+	  the boot loader, whichever is higher.
+
+	  For embedded machines with very small memory (less than
+	  about 24 MB) this may need to be adjusted downward from the
+	  default value of 0x1000000 (16 MB).
 
 	  In normal kdump cases one does not have to set/change this option
 	  as now bzImage can be compiled as a completely relocatable image
@@ -1516,8 +1519,8 @@ config RELOCATABLE
 config PHYSICAL_ALIGN
 	hex
 	prompt "Alignment value to which kernel should be aligned" if X86_32
-	default "0x100000" if X86_32
-	default "0x200000" if X86_64
+	default "0x200000" if X86_64 || X86_PAE
+	default "0x400000"
 	range 0x2000 0x400000
 	---help---
 	  This value puts the alignment restrictions on physical address
-- 
1.6.0.6

