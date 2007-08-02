Return-Path: <linux-kernel-owner+w=401wt.eu-S1760727AbXHBUpr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760727AbXHBUpr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 16:45:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760369AbXHBUph
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 16:45:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:41858 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760359AbXHBUpg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 16:45:36 -0400
Date: Thu, 2 Aug 2007 20:45:31 GMT
Message-Id: <200708022045.l72KjVTV001857@hera.kernel.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Antonino A. Daplas" <adaplas@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Additional x86 setup fixes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

One more batch of x86setup bug fixes.  Of these, one is a manifest bug
(EDID query failure), one is a non-manifest bug, and one is
documentation (Grub < 0.93 buggy.)

Please pull:

  git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-x86setup.git for-linus

Antonino A. Daplas (1):
      [x86 setup] video setup: Fix VBE DDC reading

H. Peter Anvin (2):
      [x86 setup] EDD: add missing =m constraint
      [x86 setup] Document grub < 0.93 as broken

 Documentation/Changes       |    1 +
 arch/i386/boot/edd.c        |    2 +-
 arch/i386/boot/video-vesa.c |    2 +-
 3 files changed, 3 insertions(+), 2 deletions(-)

[Full changelog and diffs follow]

commit c3887cd7253299cac2a6dc5ea792613a5ba5bf6a
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Thu Aug 2 13:50:43 2007 -0400

    [x86 setup] Document grub < 0.93 as broken
    
    Grub older than 0.93 are broken when the kernel setup is bigger than
    8K.  This was fixed in 2002, and 0.93 was the first grub version which
    fixed this bug.
    
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/Documentation/Changes b/Documentation/Changes
index 73a8617..cb2b141 100644
--- a/Documentation/Changes
+++ b/Documentation/Changes
@@ -45,6 +45,7 @@ o  nfs-utils              1.0.5                   # showmount --version
 o  procps                 3.2.0                   # ps --version
 o  oprofile               0.9                     # oprofiled --version
 o  udev                   081                     # udevinfo -V
+o  grub                   0.93                    # grub --version
 
 Kernel compilation
 ==================

commit 463c9a9f7d1f746c251761cef3af5c808394b7e1
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Thu Aug 2 13:45:49 2007 -0400

    [x86 setup] EDD: add missing =m constraint
    
    Add a missing =m constraint to the EDD-probing code, that could have
    caused improper dead-code elimination.
    
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/arch/i386/boot/edd.c b/arch/i386/boot/edd.c
index 77d92da..658834d 100644
--- a/arch/i386/boot/edd.c
+++ b/arch/i386/boot/edd.c
@@ -127,7 +127,7 @@ static int get_edd_info(u8 devno, struct edd_info *ei)
 	ax = 0x4800;
 	dx = devno;
 	asm("pushfl; int $0x13; popfl"
-	    : "+a" (ax), "+d" (dx)
+	    : "+a" (ax), "+d" (dx), "=m" (ei->params)
 	    : "S" (&ei->params)
 	    : "ebx", "ecx", "edi");
 

commit 59acc08fd95aefb5430458a08a82b15a4174ed74
Author: Antonino A. Daplas <adaplas@gmail.com>
Date:   Thu Aug 2 18:16:46 2007 +0800

    [x86 setup] video setup: Fix VBE DDC reading
    
    Add memory operand constraint and write-only modifier to the inline
    assembly to effect the writing of the EDID block to boot_params.edid_info.
    
    Without this, gcc would think the EDID query was dead code and would
    eliminate it.
    
    Signed-off-by: Antonino Daplas <adaplas@gmail.com>
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/arch/i386/boot/video-vesa.c b/arch/i386/boot/video-vesa.c
index e6aa9eb..f1bc71e 100644
--- a/arch/i386/boot/video-vesa.c
+++ b/arch/i386/boot/video-vesa.c
@@ -268,7 +268,7 @@ void vesa_store_edid(void)
 	dx = 0;			/* EDID block number */
 	di =(size_t) &boot_params.edid_info; /* (ES:)Pointer to block */
 	asm(INT10
-	    : "+a" (ax), "+b" (bx), "+d" (dx)
+	    : "+a" (ax), "+b" (bx), "+d" (dx), "=m" (boot_params.edid_info)
 	    : "c" (cx), "D" (di)
 	    : "esi");
 #endif /* CONFIG_FIRMWARE_EDID */
