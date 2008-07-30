Return-Path: <linux-kernel-owner+w=401wt.eu-S1754080AbYGaALq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbYGaALq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 20:11:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757485AbYGaAK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 20:10:58 -0400
Received: from ns2.suse.de ([195.135.220.15]:36474 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762291AbYGaAK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 20:10:57 -0400
Date: Wed, 30 Jul 2008 16:58:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: [patch 20/62] x86, suspend, acpi: enter Big Real Mode
Message-ID: <20080730235831.GT12896@suse.de>
References: <20080730233050.332789722@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-suspend-acpi-enter-big-real-mode.patch"
In-Reply-To: <20080730234915.GA12426@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26 -stable review patch.  If anyone has any objections, please let
us know.

------------------
From: H. Peter Anvin <hpa@zytor.com>

Commit 3bf2e77453a87c22eb57ed4926760ac131c84459 upstream

x86, suspend, acpi: enter Big Real Mode

The explanation for recent video BIOS suspend quirk failures is that
the VESA BIOS expects to be entered in Big Real Mode (*.limit = 0xffffffff)
instead of ordinary Real Mode (*.limit = 0xffff).

This patch changes the segment descriptors to Big Real Mode instead.

The segment descriptor registers (what Intel calls "segment cache") is
always active.  The only thing that changes based on CR0.PE is how it is
*loaded* and the interpretation of the CS flags.

The segment descriptor registers contain of the following sub-registers:
selector (the "visible" part), base, limit and flags.  In protected mode
or long mode, they are loaded from descriptors (or fs.base or gs.base can
be manipulated directly in long mode.)  In real mode, the only thing
changed by a segment register load is the selector and the base, where the
base <- selector << 4.  In particular, *the limit and the flags are not
changed*.

As far as the handling of the CS flags: a code segment cannot be writable
in protected mode, whereas it is "just another segment" in real mode, so
there is some kind of quirk that kicks in for this when CR0.PE <- 0.  I'm
not sure if this is accomplished by actually changing the cs.flags register
or just changing the interpretation; it might be something that is
CPU-specific.  In particular, the Transmeta CPUs had an explicit "CS is
writable if you're in real mode" override, so even if you had loaded CS
with an execute-only segment it'd be writable (but not readable!) on return
to real mode.  I'm not at all sure if that is how other CPUs behave.

Signed-off-by: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>

---
 arch/x86/kernel/acpi/sleep.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

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

-- 
