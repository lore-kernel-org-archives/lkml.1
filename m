Return-Path: <linux-kernel-owner+w=401wt.eu-S1756138AbYGMUpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbYGMUpd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 16:45:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755035AbYGMUpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 16:45:23 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35825 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976AbYGMUpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 16:45:22 -0400
Message-ID: <487A67C3.50000@zytor.com>
Date: Sun, 13 Jul 2008 13:38:27 -0700
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
References: <200807010148.02135.rjw@sisk.pl> <487A2431.2050103@myrealbox.com> <487A4CB7.1080001@firstfloor.org> <200807132115.08230.rjw@sisk.pl> <487A617B.80707@firstfloor.org>
In-Reply-To: <487A617B.80707@firstfloor.org>
Content-Type: multipart/mixed;
 boundary="------------080302050107090707030103"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080302050107090707030103
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Andi Kleen wrote:
> 
> We're in real mode for now nd should not care about the hidden state.
> 

Sorry, Andi, that's not how real mode works.

That may be how real mode is *documented*, but that's not how it works.

The segment descriptor registers (what Intel calls "segment cache") is 
always active.  The only thing that changes based on CR0.PE is how it is 
*loaded* and the interpretation of the CS flags.

The segment descriptor registers contain of the following sub-registers: 
selector (the "visible" part), base, limit and flags.  In protected mode 
or long mode, they are loaded from descriptors (or fs.base or gs.base 
can be manipulated directly in long mode.)  In real mode, the only thing 
changed by a segment register load is the selector and the base, where 
the base <- selector << 4.  In particular, *the limit and the flags are 
not changed*.

As far as the handling of the CS flags: a code segment cannot be 
writable in protected mode, whereas it is "just another segment" in real 
mode, so there is some kind of quirk that kicks in for this when CR0.PE 
<- 0.  I'm not sure if this is accomplished by actually changing the 
cs.flags register or just changing the interpretation; it might be 
something that is CPU-specific.  In particular, the Transmeta CPUs had 
an explicit "CS is writable if you're in real mode" override, so even if 
you had loaded CS with an execute-only segment it'd be writable (but not 
readable!) on return to real mode.  I'm not at all sure if that is how 
other CPUs behave.

The most likely explanation for this is that the VESA BIOS expects to be 
entered in Big Real Mode (*.limit = 0xffffffff) instead of ordinary Real 
Mode.  Here is a completely untested patch which changes the segment 
descriptors to Big Real Mode instead.  It would be worth testing out.

	-hpa

--------------080302050107090707030103
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff"

diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index 36af01f..97648aa 100644
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
+		GDT_ENTRY(0x809b, acpi_wakeup_address << 16, 0xfffff);
 	/* GDT[2]: real-mode-like data segment */
-	header->wakeup_gdt[2] = (0x0093ULL << 40) +
-		((u64)acpi_wakeup_address << 16) + 0xffff;
+	header->wakeup_gdt[2] =
+		GDT_ENTRY(0x8093, acpi_wakeup_address << 16, 0xfffff);
 
 #ifndef CONFIG_64BIT
 	store_gdt((struct desc_ptr *)&header->pmode_gdt);

--------------080302050107090707030103--
