Return-Path: <linux-kernel-owner+w=401wt.eu-S1765668AbXHOA64@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765668AbXHOA64 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 20:58:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757744AbXHOA6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 20:58:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59720 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757671AbXHOA6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 20:58:47 -0400
Date: Tue, 14 Aug 2007 17:58:40 -0700
Message-Id: <200708150058.l7F0webH018221@tazenda.hos.anvin.org>
From: "H. Peter Anvin" <hpa@zytor.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Corrected - x86 setup fixes (now 3)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull:

  git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-x86setup.git for-linus

H. Peter Anvin (3):
      [x86 setup] The current display page is returned in %bh, not %bl
      [x86 setup] Don't use EDD to get the MBR signature
      [x86 setup] edd.c: make sure MBR signatures actually get reported

 arch/i386/boot/edd.c   |   54 ++++++++++-------------------------------------
 arch/i386/boot/video.c |    2 +-
 2 files changed, 13 insertions(+), 43 deletions(-)

[Log messages and full diffs follow]

commit 9a5f35d4ede43fee791a486e0850e9e3afdde0a7
Author: H. Peter Anvin <hpa@zytor.com>
Date:   Tue Aug 14 17:36:00 2007 -0700

    [x86 setup] edd.c: make sure MBR signatures actually get reported
    
    When filling in the MBR signature array, the setup code failed to advance
    boot_params.edd_mbr_sig_buf_entries, which resulted in the valid data
    being ignored.
    
    Signed-off-by: H. Peter Anvin <hpa@zytor.com>

diff --git a/arch/i386/boot/edd.c b/arch/i386/boot/edd.c
index d65dd21..82b5c84 100644
--- a/arch/i386/boot/edd.c
+++ b/arch/i386/boot/edd.c
@@ -37,11 +37,10 @@ static int read_mbr(u8 devno, void *buf)
 	return -(u8)ax;		/* 0 or -1 */
 }
 
-static u32 read_mbr_sig(u8 devno, struct edd_info *ei)
+static u32 read_mbr_sig(u8 devno, struct edd_info *ei, u32 *mbrsig)
 {
 	int sector_size;
 	char *mbrbuf_ptr, *mbrbuf_end;
-	u32 mbrsig;
 	u32 buf_base, mbr_base;
 	extern char _end[];
 
@@ -57,15 +56,15 @@ static u32 read_mbr_sig(u8 devno, struct edd_info *ei)
 
 	/* Make sure we actually have space on the heap... */
 	if (!(boot_params.hdr.loadflags & CAN_USE_HEAP))
-		return 0;
+		return -1;
 	if (mbrbuf_end > (char *)(size_t)boot_params.hdr.heap_end_ptr)
-		return 0;
+		return -1;
 
 	if (read_mbr(devno, mbrbuf_ptr))
-		return 0;
+		return -1;
 
-	mbrsig = *(u32 *)&mbrbuf_ptr[EDD_MBR_SIG_OFFSET];
-	return mbrsig;
+	*mbrsig = *(u32 *)&mbrbuf_ptr[EDD_MBR_SIG_OFFSET];
+	return 0;
 }
 
 static int get_edd_info(u8 devno, struct edd_info *ei)
@@ -132,6 +131,7 @@ void query_edd(void)
 	int do_edd = 1;
 	int devno;
 	struct edd_info ei, *edp;
+	u32 *mbrptr;
 
 	if (cmdline_find_option("edd", eddarg, sizeof eddarg) > 0) {
 		if (!strcmp(eddarg, "skipmbr") || !strcmp(eddarg, "skip"))
@@ -140,7 +140,8 @@ void query_edd(void)
 			do_edd = 0;
 	}
 
-	edp = (struct edd_info *)boot_params.eddbuf;
+	edp    = boot_params.eddbuf;
+	mbrptr = boot_params.edd_mbr_sig_buffer;
 
 	if (!do_edd)
 		return;
@@ -158,11 +159,8 @@ void query_edd(void)
 			boot_params.eddbuf_entries++;
 		}
 
-		if (do_mbr) {
-			u32 mbr_sig;
-			mbr_sig = read_mbr_sig(devno, &ei);
-			boot_params.edd_mbr_sig_buffer[devno-0x80] = mbr_sig;
-		}
+		if (do_mbr && !read_mbr_sig(devno, &ei, mbrptr++))
+			boot_params.edd_mbr_sig_buf_entries = devno-0x80+1;
 	}
 }
 

commit c1a6e2b082a7cefe58315af7a461bbf2f33221a3
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
index 658834d..d65dd21 100644
--- a/arch/i386/boot/edd.c
+++ b/arch/i386/boot/edd.c
@@ -19,40 +19,12 @@
 
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
-	u16 ax, bx, cx, dx, si;
-
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
+	u16 ax, bx, cx, dx;
 
 	ax = 0x0201;		/* Legacy Read, one sector */
 	cx = 0x0001;		/* Sector 0-0-1 */

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
