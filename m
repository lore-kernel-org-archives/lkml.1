Return-Path: <linux-kernel-owner+w=401wt.eu-S1759882AbYB1Nca@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759882AbYB1Nca (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 08:32:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbYB1NcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 08:32:21 -0500
Received: from triton.rz.uni-saarland.de ([134.96.7.25]:13647 "EHLO
	triton.rz.uni-saarland.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766AbYB1NcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 08:32:21 -0500
Date: Thu, 28 Feb 2008 14:28:23 +0100
From: Alexander van Heukelum <heukelum@mailshack.com>
To: Ingo Molnar <mingo@elte.hu>, Ian Campbell <ijc@hellion.org.uk>
Cc: Alexander van Heukelum <heukelum@fastmail.fm>,
       "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Mark McLoughlin <markmc@redhat.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [RFC] use realmode code to reserve end-of-conventional-memory to 1MB
Message-ID: <20080228132822.GA25278@mailshack.com>
References: <20080224174605.GA21661@mailshack.com> <47C22568.1010405@zytor.com> <1203958478.20033.1239002461@webmail.messagingengine.com> <20080225170134.GA15839@elte.hu> <20080225180750.GA31054@mailshack.com> <20080228131341.GA25213@mailshack.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080228131341.GA25213@mailshack.com>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (triton.rz.uni-saarland.de [134.96.7.25]); Thu, 28 Feb 2008 14:31:17 +0100 (CET)
X-AntiVirus: checked by AntiVir MailGate (version: 2.1.2-14; AVE: 7.6.0.67; VDF: 7.0.2.206; host: AntiVir3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using early reservations inside the kernel code,
we could use the realmode code to modify the e820 memmap.
This patch shows what that would look like. I have not looked
at the case where the BIOS does not provide an e820 memmap
yet. Probably a full solution would need to create a fake
e820 memmap in that case.

Comments?

Signed-off-by: Alexander van Heukelum <heukelum@fastmail.fm>

diff --git a/arch/x86/boot/memory.c b/arch/x86/boot/memory.c
index e77d89f..522920a 100644
--- a/arch/x86/boot/memory.c
+++ b/arch/x86/boot/memory.c
@@ -23,6 +23,7 @@ static int detect_memory_e820(void)
 	int count = 0;
 	u32 next = 0;
 	u32 size, id;
+	u32 lowmem, ebda_addr;
 	u8 err;
 	struct e820entry *desc = boot_params.e820_map;
 
@@ -50,13 +51,51 @@ static int detect_memory_e820(void)
 		   just return failure. */
 		if (id != SMAP) {
 			count = 0;
-			break;
+			goto out;
 		}
 
 		count++;
 		desc++;
-	} while (next && count < E820MAX);
-
+	} while (next && count < (E820MAX - 1));
+
+	/* Some BIOSes do not reserve the EBDA/XBDA area correctly in.
+	   The e820-map. Find out where the EBDA resides by looking at
+	   the BIOS data area and reserve the EBDA and the following
+	   legacy adapter area explicitly. */
+#define BIOS_EBDA_SEGMENT 0x40E
+#define BIOS_LOWMEM_KILOBYTES 0x413
+
+	/* end of low (conventional) memory */
+	set_fs(0);
+	lowmem = rdfs16(BIOS_LOWMEM_KILOBYTES);
+	lowmem <<= 10;
+
+	/* start of EBDA area */
+	ebda_addr = rdfs16(BIOS_EBDA_SEGMENT);
+	ebda_addr <<= 4;
+
+	/* Fixup: bios puts an EBDA in the top 64K segment */
+	/* of conventional memory, but does not adjust lowmem. */
+	if ((lowmem - ebda_addr) <= 0x10000)
+		lowmem = ebda_addr;
+
+	/* Fixup: bios does not report an EBDA at all. */
+	/* Some old Dells seem to need 4k anyhow (bugzilla 2990) */
+	if ((ebda_addr == 0) && (lowmem >= 0x9f000))
+		lowmem = 0x9f000;
+
+	/* Paranoia: should never happen, but... */
+	if (lowmem >= 0x100000)
+		lowmem = 0xa0000;
+
+	/* reserve all memory between lowmem and the 1MB mark */
+	desc->addr = lowmem;
+	desc->size = 0x100000 - lowmem;
+	desc->type = E820_RESERVED;
+	count++;
+	desc++;
+
+out:
 	return boot_params.e820_entries = count;
 }
 

