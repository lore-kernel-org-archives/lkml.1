Return-Path: <linux-kernel-owner+w=401wt.eu-S1759624AbZFLKrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759624AbZFLKrY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 06:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754336AbZFLKrR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 06:47:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:57711 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751516AbZFLKrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 06:47:16 -0400
Date: Fri, 12 Jun 2009 12:47:07 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20090612104707.GA31014@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-fixes-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-fixes-for-linus

 Thanks,

	Ingo

------------------>
Catalin Marinas (1):
      x86: Provide _sdata in the vmlinux.lds.S file

Yinghai Lu (1):
      x86: handle initrd that extends into unusable memory


 arch/x86/kernel/setup.c       |   15 +++------------
 arch/x86/kernel/vmlinux.lds.S |    2 ++
 2 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index d1c636b..be5ae80 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -301,15 +301,13 @@ static void __init reserve_brk(void)
 
 #ifdef CONFIG_BLK_DEV_INITRD
 
-#ifdef CONFIG_X86_32
-
 #define MAX_MAP_CHUNK	(NR_FIX_BTMAPS << PAGE_SHIFT)
 static void __init relocate_initrd(void)
 {
 
 	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
 	u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
-	u64 end_of_lowmem = max_low_pfn << PAGE_SHIFT;
+	u64 end_of_lowmem = max_low_pfn_mapped << PAGE_SHIFT;
 	u64 ramdisk_here;
 	unsigned long slop, clen, mapaddr;
 	char *p, *q;
@@ -365,14 +363,13 @@ static void __init relocate_initrd(void)
 		ramdisk_image, ramdisk_image + ramdisk_size - 1,
 		ramdisk_here, ramdisk_here + ramdisk_size - 1);
 }
-#endif
 
 static void __init reserve_initrd(void)
 {
 	u64 ramdisk_image = boot_params.hdr.ramdisk_image;
 	u64 ramdisk_size  = boot_params.hdr.ramdisk_size;
 	u64 ramdisk_end   = ramdisk_image + ramdisk_size;
-	u64 end_of_lowmem = max_low_pfn << PAGE_SHIFT;
+	u64 end_of_lowmem = max_low_pfn_mapped << PAGE_SHIFT;
 
 	if (!boot_params.hdr.type_of_loader ||
 	    !ramdisk_image || !ramdisk_size)
@@ -402,14 +399,8 @@ static void __init reserve_initrd(void)
 		return;
 	}
 
-#ifdef CONFIG_X86_32
 	relocate_initrd();
-#else
-	printk(KERN_ERR "initrd extends beyond end of memory "
-	       "(0x%08llx > 0x%08llx)\ndisabling initrd\n",
-	       ramdisk_end, end_of_lowmem);
-	initrd_start = 0;
-#endif
+
 	free_early(ramdisk_image, ramdisk_end);
 }
 #else
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 4c85b2e..367e878 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -108,6 +108,8 @@ SECTIONS
 	/* Data */
 	. = ALIGN(PAGE_SIZE);
 	.data : AT(ADDR(.data) - LOAD_OFFSET) {
+		/* Start of data section */
+		_sdata = .;
 		DATA_DATA
 		CONSTRUCTORS
 
