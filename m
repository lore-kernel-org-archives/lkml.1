Return-Path: <linux-kernel-owner+w=401wt.eu-S1755658AbYGNEZl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658AbYGNEZl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 00:25:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751606AbYGNEZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 00:25:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57432 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbYGNEZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 00:25:32 -0400
Message-ID: <487AD37A.2050903@zytor.com>
Date: Sun, 13 Jul 2008 21:18:02 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Andy Lutomirski <luto@myrealbox.com>,
       Matthew Garrett <mjg59@srcf.ucam.org>, Ingo Molnar <mingo@elte.hu>,
       public-kernel-testers-u79uwXL29TY76Z2rM5mHXA@lo.gmane.org,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFT] x86 acpi: normalize segment descriptor register on resume
References: <200807010148.02135.rjw@sisk.pl> <487A2431.2050103@myrealbox.com> <487A4CB7.1080001@firstfloor.org> <200807132115.08230.rjw@sisk.pl> <487A617B.80707@firstfloor.org> <487A67C3.50000@zytor.com>
In-Reply-To: <487A67C3.50000@zytor.com>
Content-Type: multipart/mixed;
 boundary="------------090300060600030007040608"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090300060600030007040608
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

H. Peter Anvin wrote:
> 
> The most likely explanation for this is that the VESA BIOS expects to be 
> entered in Big Real Mode (*.limit = 0xffffffff) instead of ordinary Real 
> Mode.  Here is a completely untested patch which changes the segment 
> descriptors to Big Real Mode instead.  It would be worth testing out.
> 

... and here is one that actually has a prayer of actually working.

	-hpa

--------------090300060600030007040608
Content-Type: text/x-patch;
 name="linux-2.6.26-bigrm-wakeup.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux-2.6.26-bigrm-wakeup.patch"

diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 36af01f..130711f 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -23,6 +23,15 @@ static unsigned long acpi_realmode;
 static char temp_stack[10240];
 #endif
 
+/* XXX: this macro should move to asm-x86/segment.h and be shared with the
+   boot code... */
+#define GDT_ENTRY(flags, base, limit)		\
+	(((u64)(base & 0xff000000) << 32) |	\
+	 ((u64)flags << 40) |			\
+	 ((u64)(limit & 0x00ff0000) << 32) |	\
+	 ((u64)(base & 0x00ffffff) << 16) |	\
+	 ((u64)(limit & 0x0000ffff)))
+
 /**
  * acpi_save_state_mem - save kernel state
  *
@@ -58,11 +67,11 @@ int acpi_save_state_mem(void)
 			((char *)&header->wakeup_gdt - (char *)acpi_realmode))
 				<< 16);
 	/* GDT[1]: real-mode-like code segment */
-	header->wakeup_gdt[1] = (0x009bULL << 40) +
-		((u64)acpi_wakeup_address << 16) + 0xffff;
+	header->wakeup_gdt[1] =
+		GDT_ENTRY(0x809b, acpi_wakeup_address, 0xfffff);
 	/* GDT[2]: real-mode-like data segment */
-	header->wakeup_gdt[2] = (0x0093ULL << 40) +
-		((u64)acpi_wakeup_address << 16) + 0xffff;
+	header->wakeup_gdt[2] =
+		GDT_ENTRY(0x8093, acpi_wakeup_address, 0xfffff);
 
 #ifndef CONFIG_64BIT
 	store_gdt((struct desc_ptr *)&header->pmode_gdt);

--------------090300060600030007040608--
