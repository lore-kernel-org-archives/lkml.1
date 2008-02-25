Return-Path: <linux-kernel-owner+w=401wt.eu-S1757537AbYBYSIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537AbYBYSIh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 13:08:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbYBYSI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 13:08:29 -0500
Received: from theia.rz.uni-saarland.de ([134.96.7.31]:28647 "EHLO
	theia.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138AbYBYSI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 13:08:28 -0500
Date: Mon, 25 Feb 2008 19:07:51 +0100
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] reserve_early end-of-conventional-memory to 1MB
Message-ID: <20080225180750.GA31054@mailshack.com>
References: <20080224174605.GA21661@mailshack.com> <47C22568.1010405@zytor.com> <1203958478.20033.1239002461@webmail.messagingengine.com> <20080225170134.GA15839@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080225170134.GA15839@elte.hu>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (theia.rz.uni-saarland.de [134.96.7.31]); Mon, 25 Feb 2008 19:08:01 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.6.0.67; VDF: 7.0.2.189; host: AntiVir1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Explicitly reserve_early the whole address range from the end of
conventional memory as reported by the bios data area up to the
1Mb mark. Regard the info retrieved from the BIOS data area with
a bit of paranoia, though, because some biosses forget to register
the EBDA correctly.

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

--

I think this patch is against -x86.git#testing :-/.

Greetings,
	Alexander

 arch/x86/kernel/head64.c |   45 +++++++++++++++++++++++++++------------------
 1 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index 38f32e7..b684552 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -49,33 +49,42 @@ static void __init copy_bootdata(char *real_mode_data)
 	}
 }
 
-#define EBDA_ADDR_POINTER 0x40E
+#define BIOS_EBDA_SEGMENT 0x40E
+#define BIOS_LOWMEM_KILOBYTES 0x413
 
+/*
+ * The BIOS places the EBDA/XBDA at the top of conventional
+ * memory, and usually decreases the reported amount of
+ * conventional memory (int 0x12) too.
+ */
 static __init void reserve_ebda(void)
 {
-	unsigned ebda_addr, ebda_size;
+	unsigned int lowmem, ebda_addr;
 
-	/*
-	 * there is a real-mode segmented pointer pointing to the
-	 * 4K EBDA area at 0x40E
-	 */
-	ebda_addr = *(unsigned short *)__va(EBDA_ADDR_POINTER);
+	/* end of low (conventional) memory */
+	lowmem = *(unsigned short *)__va(BIOS_LOWMEM_KILOBYTES);
+	lowmem <<= 10;
+
+	/* start of EBDA area */
+	ebda_addr = *(unsigned short *)__va(BIOS_EBDA_SEGMENT);
 	ebda_addr <<= 4;
 
-	if (!ebda_addr)
-		return;
+	/* Fixup: bios puts an EBDA in the top 64K segment */
+	/* of conventional memory, but does not adjust lowmem. */
+	if ((lowmem - ebda_addr) <= 0x10000)
+		lowmem = ebda_addr;
 
-	ebda_size = *(unsigned short *)__va(ebda_addr);
+	/* Fixup: bios does not report an EBDA at all. */
+	/* Some old Dells seem to need 4k anyhow (bugzilla 2990) */
+	if ((ebda_addr == 0) && (lowmem >= 0x9f000))
+		lowmem = 0x9f000;
 
-	/* Round EBDA up to pages */
-	if (ebda_size == 0)
-		ebda_size = 1;
-	ebda_size <<= 10;
-	ebda_size = round_up(ebda_size + (ebda_addr & ~PAGE_MASK), PAGE_SIZE);
-	if (ebda_size > 64*1024)
-		ebda_size = 64*1024;
+	/* Paranoia: should never happen, but... */
+	if (lowmem >= 0x100000)
+		lowmem = 0xa0000;
 
-	reserve_early(ebda_addr, ebda_addr + ebda_size, "EBDA");
+	/* reserve all memory between lowmem and the 1MB mark */
+	reserve_early(lowmem, 0x100000, "BIOS reserved");
 }
 
 void __init x86_64_start_kernel(char * real_mode_data)
