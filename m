Return-Path: <linux-kernel-owner+w=401wt.eu-S1757113AbXHaTi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757113AbXHaTi2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2007 15:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751294AbXHaTiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Aug 2007 15:38:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60599 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751457AbXHaTiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2007 15:38:20 -0400
Date: Fri, 31 Aug 2007 12:37:37 -0700
Message-Id: <200708311937.l7VJbb3n018180@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Will Simoneau <simoneau@ele.uri.edu>
Subject: [GIT PULL] VESA register clobber paranoia
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull:

  git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-x86setup.git for-linus

H. Peter Anvin (1):
      [x86 setup] Don't rely on the VESA BIOS being register-clean

 arch/i386/boot/video-vesa.c |   34 +++++++++++++++++++++-------------
 1 files changed, 21 insertions(+), 13 deletions(-)

[Log messages and full diffs follow]

commit 4221d014ea04d439e6d1e65951c3b406e7c1b7ab
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Fri Aug 31 11:30:31 2007 -0700

    [x86 setup] Don't rely on the VESA BIOS being register-clean
    
    The VESA BIOS is specified to be register-clean.  However, we have now
    found at least one system which violates that.  Thus, be as paranoid
    about VESA calls as about everything else.
    
    Huge thanks to Will Simoneau for reporting, diagnosing, and testing
    this out on Dell Inspiron 5150.
    
    Cc: Will Simoneau <simoneau@ele.uri.edu>
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/arch/i386/boot/video-vesa.c b/arch/i386/boot/video-vesa.c
index f1bc71e..1921907 100644
--- a/arch/i386/boot/video-vesa.c
+++ b/arch/i386/boot/video-vesa.c
@@ -29,7 +29,7 @@ static void vesa_store_mode_params_graphics(void);
 static int vesa_probe(void)
 {
 #if defined(CONFIG_VIDEO_VESA) || defined(CONFIG_FIRMWARE_EDID)
-	u16 ax;
+	u16 ax, cx, di;
 	u16 mode;
 	addr_t mode_ptr;
 	struct mode_info *mi;
@@ -39,9 +39,11 @@ static int vesa_probe(void)
 
 	vginfo.signature = VBE2_MAGIC;
 
-	/* Optimistically assume a VESA BIOS is register-clean... */
 	ax = 0x4f00;
-	asm("int $0x10" : "+a" (ax), "=m" (vginfo) : "D" (&vginfo));
+	di = (size_t)&vginfo;
+	asm(INT10
+	    : "+a" (ax), "+D" (di), "=m" (vginfo)
+	    : : "ebx", "ecx", "edx", "esi");
 
 	if (ax != 0x004f ||
 	    vginfo.signature != VESA_MAGIC ||
@@ -64,9 +66,11 @@ static int vesa_probe(void)
 		memset(&vminfo, 0, sizeof vminfo); /* Just in case... */
 
 		ax = 0x4f01;
-		asm("int $0x10"
-		    : "+a" (ax), "=m" (vminfo)
-		    : "c" (mode), "D" (&vminfo));
+		cx = mode;
+		di = (size_t)&vminfo;
+		asm(INT10
+		    : "+a" (ax), "+c" (cx), "+D" (di), "=m" (vminfo)
+		    : : "ebx", "edx", "esi");
 
 		if (ax != 0x004f)
 			continue;
@@ -102,16 +106,18 @@ static int vesa_probe(void)
 
 static int vesa_set_mode(struct mode_info *mode)
 {
-	u16 ax;
+	u16 ax, bx, cx, di;
 	int is_graphic;
 	u16 vesa_mode = mode->mode - VIDEO_FIRST_VESA;
 
 	memset(&vminfo, 0, sizeof vminfo); /* Just in case... */
 
 	ax = 0x4f01;
-	asm("int $0x10"
-	    : "+a" (ax), "=m" (vminfo)
-	    : "c" (vesa_mode), "D" (&vminfo));
+	cx = vesa_mode;
+	di = (size_t)&vminfo;
+	asm(INT10
+	    : "+a" (ax), "+c" (cx), "+D" (di), "=m" (vminfo)
+	    : : "ebx", "edx", "esi");
 
 	if (ax != 0x004f)
 		return -1;
@@ -129,9 +135,11 @@ static int vesa_set_mode(struct mode_info *mode)
 
 
 	ax = 0x4f02;
-	asm volatile("int $0x10"
-		     : "+a" (ax)
-		     : "b" (vesa_mode), "D" (0));
+	bx = vesa_mode;
+	di = 0;
+	asm volatile(INT10
+		     : "+a" (ax), "+b" (bx), "+D" (di)
+		     : : "ecx", "edx", "esi");
 
 	if (ax != 0x004f)
 		return -1;
