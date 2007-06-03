Return-Path: <linux-kernel-owner+w=401wt.eu-S1752115AbXFCV6A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752115AbXFCV6A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 17:58:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751240AbXFCV5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 17:57:52 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:59870 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbXFCV5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 17:57:51 -0400
X-Originating-Ip: 72.143.65.211
Date: Sun, 3 Jun 2007 17:56:10 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: thockin@google.com, Andrew Morton <akpm@osdl.org>
Subject: [PATCH] COBALT:  Remove all traces of COBALT from nvram.c
Message-ID: <Pine.LNX.4.64.0706031754290.23965@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00, RCVD_IN_SORBS_DUL 20.00,
	UPPERCASE_25_50 0.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Drop all references to the COBALT arch from drivers/char/nvram.c.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>

---

diff --git a/drivers/char/nvram.c b/drivers/char/nvram.c
index 204deaa..98dec38 100644
--- a/drivers/char/nvram.c
+++ b/drivers/char/nvram.c
@@ -42,19 +42,12 @@

 #define PC		1
 #define ATARI		2
-#define COBALT		3

 /* select machine configuration */
 #if defined(CONFIG_ATARI)
 #  define MACH ATARI
 #elif defined(__i386__) || defined(__x86_64__) || defined(__arm__)  /* and others?? */
-#define MACH PC
-#  if defined(CONFIG_COBALT)
-#    include <linux/cobalt-nvram.h>
-#    define MACH COBALT
-#  else
-#    define MACH PC
-#  endif
+#  define MACH PC
 #else
 #  error Cannot build nvram driver for this machine configuration.
 #endif
@@ -76,18 +69,6 @@

 #endif

-#if MACH == COBALT
-
-#define CHECK_DRIVER_INIT()     1
-
-#define NVRAM_BYTES		(128-NVRAM_FIRST_BYTE)
-
-#define mach_check_checksum	cobalt_check_checksum
-#define mach_set_checksum	cobalt_set_checksum
-#define mach_proc_infos		cobalt_proc_infos
-
-#endif
-
 #if MACH == ATARI

 /* Special parameters for RTC in Atari machines */
@@ -604,177 +585,6 @@ pc_proc_infos(unsigned char *nvram, char *buffer, int *len,

 #endif /* MACH == PC */

-#if MACH == COBALT
-
-/* the cobalt CMOS has a wider range of its checksum */
-static int cobalt_check_checksum(void)
-{
-	int i;
-	unsigned short sum = 0;
-	unsigned short expect;
-
-	for (i = COBT_CMOS_CKS_START; i <= COBT_CMOS_CKS_END; ++i) {
-		if ((i == COBT_CMOS_CHECKSUM) || (i == (COBT_CMOS_CHECKSUM+1)))
-			continue;
-
-		sum += __nvram_read_byte(i);
-	}
-	expect = __nvram_read_byte(COBT_CMOS_CHECKSUM) << 8 |
-	    __nvram_read_byte(COBT_CMOS_CHECKSUM+1);
-	return ((sum & 0xffff) == expect);
-}
-
-static void cobalt_set_checksum(void)
-{
-	int i;
-	unsigned short sum = 0;
-
-	for (i = COBT_CMOS_CKS_START; i <= COBT_CMOS_CKS_END; ++i) {
-		if ((i == COBT_CMOS_CHECKSUM) || (i == (COBT_CMOS_CHECKSUM+1)))
-			continue;
-
-		sum += __nvram_read_byte(i);
-	}
-
-	__nvram_write_byte(sum >> 8, COBT_CMOS_CHECKSUM);
-	__nvram_write_byte(sum & 0xff, COBT_CMOS_CHECKSUM+1);
-}
-
-#ifdef CONFIG_PROC_FS
-
-static int cobalt_proc_infos(unsigned char *nvram, char *buffer, int *len,
-	off_t *begin, off_t offset, int size)
-{
-	int i;
-	unsigned int checksum;
-	unsigned int flags;
-	char sernum[14];
-	char *key = "cNoEbTaWlOtR!";
-	unsigned char bto_csum;
-
-	spin_lock_irq(&rtc_lock);
-	checksum = __nvram_check_checksum();
-	spin_unlock_irq(&rtc_lock);
-
-	PRINT_PROC("Checksum status: %svalid\n", checksum ? "" : "not ");
-
-	flags = nvram[COBT_CMOS_FLAG_BYTE_0] << 8
-	    | nvram[COBT_CMOS_FLAG_BYTE_1];
-
-	PRINT_PROC("Console: %s\n",
-		flags & COBT_CMOS_CONSOLE_FLAG ?  "on": "off");
-
-	PRINT_PROC("Firmware Debug Messages: %s\n",
-		flags & COBT_CMOS_DEBUG_FLAG ? "on": "off");
-
-	PRINT_PROC("Auto Prompt: %s\n",
-		flags & COBT_CMOS_AUTO_PROMPT_FLAG ? "on": "off");
-
-	PRINT_PROC("Shutdown Status: %s\n",
-		flags & COBT_CMOS_CLEAN_BOOT_FLAG ? "clean": "dirty");
-
-	PRINT_PROC("Hardware Probe: %s\n",
-		flags & COBT_CMOS_HW_NOPROBE_FLAG ? "partial": "full");
-
-	PRINT_PROC("System Fault: %sdetected\n",
-		flags & COBT_CMOS_SYSFAULT_FLAG ? "": "not ");
-
-	PRINT_PROC("Panic on OOPS: %s\n",
-		flags & COBT_CMOS_OOPSPANIC_FLAG ? "yes": "no");
-
-	PRINT_PROC("Delayed Cache Initialization: %s\n",
-		flags & COBT_CMOS_DELAY_CACHE_FLAG ? "yes": "no");
-
-	PRINT_PROC("Show Logo at Boot: %s\n",
-		flags & COBT_CMOS_NOLOGO_FLAG ? "no": "yes");
-
-	PRINT_PROC("Boot Method: ");
-	switch (nvram[COBT_CMOS_BOOT_METHOD]) {
-	case COBT_CMOS_BOOT_METHOD_DISK:
-		PRINT_PROC("disk\n");
-		break;
-
-	case COBT_CMOS_BOOT_METHOD_ROM:
-		PRINT_PROC("rom\n");
-		break;
-
-	case COBT_CMOS_BOOT_METHOD_NET:
-		PRINT_PROC("net\n");
-		break;
-
-	default:
-		PRINT_PROC("unknown\n");
-		break;
-	}
-
-	PRINT_PROC("Primary Boot Device: %d:%d\n",
-		nvram[COBT_CMOS_BOOT_DEV0_MAJ],
-		nvram[COBT_CMOS_BOOT_DEV0_MIN] );
-	PRINT_PROC("Secondary Boot Device: %d:%d\n",
-		nvram[COBT_CMOS_BOOT_DEV1_MAJ],
-		nvram[COBT_CMOS_BOOT_DEV1_MIN] );
-	PRINT_PROC("Tertiary Boot Device: %d:%d\n",
-		nvram[COBT_CMOS_BOOT_DEV2_MAJ],
-		nvram[COBT_CMOS_BOOT_DEV2_MIN] );
-
-	PRINT_PROC("Uptime: %d\n",
-		nvram[COBT_CMOS_UPTIME_0] << 24 |
-		nvram[COBT_CMOS_UPTIME_1] << 16 |
-		nvram[COBT_CMOS_UPTIME_2] << 8  |
-		nvram[COBT_CMOS_UPTIME_3]);
-
-	PRINT_PROC("Boot Count: %d\n",
-		nvram[COBT_CMOS_BOOTCOUNT_0] << 24 |
-		nvram[COBT_CMOS_BOOTCOUNT_1] << 16 |
-		nvram[COBT_CMOS_BOOTCOUNT_2] << 8  |
-		nvram[COBT_CMOS_BOOTCOUNT_3]);
-
-	/* 13 bytes of serial num */
-	for (i=0 ; i<13 ; i++) {
-		sernum[i] = nvram[COBT_CMOS_SYS_SERNUM_0 + i];
-	}
-	sernum[13] = '\0';
-
-	checksum = 0;
-	for (i=0 ; i<13 ; i++) {
-		checksum += sernum[i] ^ key[i];
-	}
-	checksum = ((checksum & 0x7f) ^ (0xd6)) & 0xff;
-
-	PRINT_PROC("Serial Number: %s", sernum);
-	if (checksum != nvram[COBT_CMOS_SYS_SERNUM_CSUM]) {
-		PRINT_PROC(" (invalid checksum)");
-	}
-	PRINT_PROC("\n");
-
-	PRINT_PROC("Rom Revison: %d.%d.%d\n", nvram[COBT_CMOS_ROM_REV_MAJ],
-		nvram[COBT_CMOS_ROM_REV_MIN], nvram[COBT_CMOS_ROM_REV_REV]);
-
-	PRINT_PROC("BTO Server: %d.%d.%d.%d", nvram[COBT_CMOS_BTO_IP_0],
-		nvram[COBT_CMOS_BTO_IP_1], nvram[COBT_CMOS_BTO_IP_2],
-		nvram[COBT_CMOS_BTO_IP_3]);
-	bto_csum = nvram[COBT_CMOS_BTO_IP_0] + nvram[COBT_CMOS_BTO_IP_1]
-		+ nvram[COBT_CMOS_BTO_IP_2] + nvram[COBT_CMOS_BTO_IP_3];
-	if (bto_csum != nvram[COBT_CMOS_BTO_IP_CSUM]) {
-		PRINT_PROC(" (invalid checksum)");
-	}
-	PRINT_PROC("\n");
-
-	if (flags & COBT_CMOS_VERSION_FLAG
-	 && nvram[COBT_CMOS_VERSION] >= COBT_CMOS_VER_BTOCODE) {
-		PRINT_PROC("BTO Code: 0x%x\n",
-			nvram[COBT_CMOS_BTO_CODE_0] << 24 |
-			nvram[COBT_CMOS_BTO_CODE_1] << 16 |
-			nvram[COBT_CMOS_BTO_CODE_2] << 8 |
-			nvram[COBT_CMOS_BTO_CODE_3]);
-	}
-
-	return 1;
-}
-#endif /* CONFIG_PROC_FS */
-
-#endif /* MACH == COBALT */
-
 #if MACH == ATARI

 static int
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://fsdev.net/wiki/index.php?title=Main_Page
========================================================================
