Return-Path: <linux-kernel-owner+w=401wt.eu-S1761777AbXHOAFI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761777AbXHOAFI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 20:05:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755666AbXHOAEy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 20:04:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56433 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755441AbXHOAEx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 20:04:53 -0400
Date: Tue, 14 Aug 2007 17:04:49 -0700
Message-Id: <200708150004.l7F04nks025010@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Two more x86 setup fixes
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull:


  git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-x86setup.git for-linus

H. Peter Anvin (2):
      [x86 setup] The current display page is returned in %bh, not %bl
      [x86 setup] Don't use EDD to get the MBR signature

 arch/i386/boot/edd.c   |   28 ----------------------------
 arch/i386/boot/video.c |    2 +-
 2 files changed, 1 insertions(+), 29 deletions(-)

[Log messages and full diffs follow]

commit c031c43503412b1f60ff92fdf4527787a6c98afd
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Mon Aug 13 16:27:42 2007 -0700

    [x86 setup] Don't use EDD to get the MBR signature
    
    At least one machine has been identified in the field which advertises
    EDD for all drives but locks up if one attempts an extended read from
    a non-primary drive.
    
    The MBR is always at CHS 0-0-1, so there is no reason to use an
    extended read, other than the possibility that the BIOS cannot handle
    it.
    
    Although this might break as many machines as it fixes (a small number
    either way), the current state is a regression but the reverse is not.
    Therefore revert to the previous state of not using extended read.
    
    Quite probably the Right Thing to do is to read using plain (CHS) read
    and extended read on failure, but that change would definitely have to
    go through -mm first.
    
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/arch/i386/boot/edd.c b/arch/i386/boot/edd.c
index 658834d..ba1b37b 100644
--- a/arch/i386/boot/edd.c
+++ b/arch/i386/boot/edd.c
@@ -19,41 +19,13 @@
 
 #if defined(CONFIG_EDD) || defined(CONFIG_EDD_MODULE)
 
-struct edd_dapa {
-	u8	pkt_size;
-	u8	rsvd;
-	u16	sector_cnt;
-	u16	buf_off, buf_seg;
-	u64	lba;
-	u64	buf_lin_addr;
-};
-
 /*
  * Read the MBR (first sector) from a specific device.
  */
 static int read_mbr(u8 devno, void *buf)
 {
-	struct edd_dapa dapa;
 	u16 ax, bx, cx, dx, si;
 
-	memset(&dapa, 0, sizeof dapa);
-	dapa.pkt_size = sizeof(dapa);
-	dapa.sector_cnt = 1;
-	dapa.buf_off = (size_t)buf;
-	dapa.buf_seg = ds();
-	/* dapa.lba = 0; */
-
-	ax = 0x4200;		/* Extended Read */
-	si = (size_t)&dapa;
-	dx = devno;
-	asm("pushfl; stc; int $0x13; setc %%al; popfl"
-	    : "+a" (ax), "+S" (si), "+d" (dx)
-	    : "m" (dapa)
-	    : "ebx", "ecx", "edi", "memory");
-
-	if (!(u8)ax)
-		return 0;	/* OK */
-
 	ax = 0x0201;		/* Legacy Read, one sector */
 	cx = 0x0001;		/* Sector 0-0-1 */
 	dx = devno;

commit 362cea339a34e04caae6cad67ea9bde5c100d12b
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Fri Aug 10 14:20:26 2007 -0700

    [x86 setup] The current display page is returned in %bh, not %bl
    
    The current display page is an 8-bit number, even though struct
    screen_info gives it a 16-bit number.  The number is returned in %bh,
    so it needs to be >> 8 before storing.
    
    Special thanks to Jeff Chua for detailed bug reporting.
    
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/arch/i386/boot/video.c b/arch/i386/boot/video.c
index 958130e..693f20d 100644
--- a/arch/i386/boot/video.c
+++ b/arch/i386/boot/video.c
@@ -61,7 +61,7 @@ static void store_video_mode(void)
 
 	/* Not all BIOSes are clean with respect to the top bit */
 	boot_params.screen_info.orig_video_mode = ax & 0x7f;
-	boot_params.screen_info.orig_video_page = page;
+	boot_params.screen_info.orig_video_page = page >> 8;
 }
 
 /*
