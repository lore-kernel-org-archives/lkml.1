Return-Path: <linux-kernel-owner+w=401wt.eu-S1760583AbYEQXFU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760583AbYEQXFU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 19:05:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbYEQXFI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 19:05:08 -0400
Received: from nf-out-0910.google.com ([64.233.182.186]:30310 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbYEQXFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 19:05:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent:from;
        b=H2khN8o4KqoOsr6ZYXg1xpgOsJ4PwVlDjPbHWCjISwHWjgcCPt27cedxYYIyU45alqp/+sY7GuiU/bsWJOFAwvAvCwq2EX1AtQz2dsX0qRSZG0XCzYnYK8MiS1mH6e8AYo04SFdi16goJVBaY3ztP2dwQ80N3bshw4nr2Dn0I5s=
Date: Sun, 18 May 2008 01:04:58 +0200
To: Pekka Enberg <penberg@cs.helsinki.fi>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@linux.intel.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH] kmemcheck: support for x86_64
Message-ID: <20080517230458.GA18588@damson.getinternet.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
From: Vegard Nossum <vegard.nossum@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here comes a particularly difficult patch. I am not submitting it for
application to any tree yet, but I have a small hope that somebody will
put their head out to look at it :-)

I am fairly sure the REX handling bits themselves are okay -- the kernel
gets to the point where it tries to mount the root partition. But before
that, there is a torrent of error reports coming from kmemcheck.

Most of them look something like this:

kmemcheck: Caught 8-bit read from freed memory (ffff81000780a904)
ifffffffifffffffifffffffifffffffifffffffifffffffifffffffifffffff
    ^

and my theory so far is that X86_64 uses some currently unhandled
instruction set extensions like MMX, SSE, etc. (Not 3DNow! because we
have a dependency for that), for a fairly common operation -- something
like memset(), and where we decode the size of the instruction to being
8 bits when in fact it is 64 and thus only mark 8 bits of the shadow
memory as being initialized.

(I guess the easiest way to catch this would be to make cases for those
instructions and WARN(), but... Did I mention I hate this opcode decoding
business? It's just too ugly.)

Do the #ifdef X86_64 parts look okay?

The patch applies to the 'current' branch of kmemcheck.git:
http://git.kernel.org/?p=linux/kernel/git/vegard/kmemcheck.git;a=shortlog;h=current

Note: kmemcheck reports from x86_64 are still not very good because of the
stacktrace issues reported earlier; in short, we can't look further than
the page fault stack entry, which makes it rather useless for debugging.
We do still have the RIP of the crash, though. End of note.

Thanks.


Vegard


>From d7978af9df6e61b75f1d15a65cf455b89aafea08 Mon Sep 17 00:00:00 2001
From: Vegard Nossum <vegard.nossum@gmail.com>
Date: Sun, 11 May 2008 14:06:49 +0200
Subject: [PATCH] kmemcheck: support for x86_64

Add REX prefix handling to kmemcheck's opcode decoder.

Signed-off-by: Vegard Nossum <vegard.nossum@gmail.com>
---
 arch/x86/Kconfig.debug      |    2 +-
 arch/x86/kernel/kmemcheck.c |   67 ++++++++++++++++++++++++++++++++++--------
 2 files changed, 55 insertions(+), 14 deletions(-)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index af6c1b3..8f02410 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -244,7 +244,7 @@ endif
 
 config KMEMCHECK
 	bool "kmemcheck: trap use of uninitialized memory"
-	depends on X86_32
+	depends on X86
 	depends on !X86_USE_3DNOW
 	depends on SLUB || SLAB
 	depends on !CC_OPTIMIZE_FOR_SIZE
diff --git a/arch/x86/kernel/kmemcheck.c b/arch/x86/kernel/kmemcheck.c
index 80ef428..bd52609 100644
--- a/arch/x86/kernel/kmemcheck.c
+++ b/arch/x86/kernel/kmemcheck.c
@@ -600,6 +600,12 @@ opcode_is_prefix(uint8_t b)
 		|| b == 0x67;
 }
 
+static bool
+opcode_is_rex_prefix(uint8_t b)
+{
+	return (b & 0xf0) == 0x40;
+}
+
 /* This is a VERY crude opcode decoder. We only need to find the size of the
  * load/store that caused our #PF and this should work for all the opcodes
  * that we care about. Moreover, the ones who invented this instruction set
@@ -616,6 +622,15 @@ opcode_get_size(const uint8_t *op)
 			operand_size_override = 16;
 	}
 
+#ifdef X86_64
+	/* REX prefix */
+	if (opcode_is_rex_prefix(*op)) {
+		if (*op & 0x08)
+			return 64;
+		++op;
+	}
+#endif
+
 	/* escape opcode */
 	if (*op == 0x0f) {
 		++op;
@@ -633,7 +648,10 @@ static const uint8_t *
 opcode_get_primary(const uint8_t *op)
 {
 	/* skip prefixes */
-	for (; opcode_is_prefix(*op); ++op);
+	while (opcode_is_prefix(*op))
+		++op;
+	if (opcode_is_rex_prefix(*op))
+		++op;
 	return op;
 }
 
@@ -644,22 +662,16 @@ opcode_get_primary(const uint8_t *op)
 static bool
 check_page_boundary(struct pt_regs *regs, unsigned long addr, unsigned int size)
 {
-	unsigned long page[4];
-
 	if (size == 8)
 		return false;
-
-	page[0] = (addr + 0) & PAGE_MASK;
-	page[1] = (addr + 1) & PAGE_MASK;
-
-	if (size == 16 && page[0] == page[1])
+	if (size == 16 && (addr & PAGE_MASK) == ((addr + 1) & PAGE_MASK))
 		return false;
-
-	page[2] = (addr + 2) & PAGE_MASK;
-	page[3] = (addr + 3) & PAGE_MASK;
-
-	if (size == 32 && page[0] == page[2] && page[0] == page[3])
+	if (size == 32 && (addr & PAGE_MASK) == ((addr + 3) & PAGE_MASK))
 		return false;
+#ifdef X86_64
+	if (size == 64 && (addr & PAGE_MASK) == ((addr + 7) & PAGE_MASK))
+		return false;
+#endif
 
 	/*
 	 * XXX: The addr/size data is also really interesting if this
@@ -683,6 +695,17 @@ test(void *shadow, unsigned int size)
 	 * code to access neighboring bytes.
 	 */
 	switch (size) {
+#ifdef X86_64
+	case 64:
+		if (x[7] == SHADOW_INITIALIZED)
+			return x[7];
+		if (x[6] == SHADOW_INITIALIZED)
+			return x[6];
+		if (x[5] == SHADOW_INITIALIZED)
+			return x[5];
+		if (x[4] == SHADOW_INITIALIZED)
+			return x[4];
+#endif
 	case 32:
 		if (x[3] == SHADOW_INITIALIZED)
 			return x[3];
@@ -697,6 +720,17 @@ test(void *shadow, unsigned int size)
 	}
 #else
 	switch (size) {
+#ifdef X86_64
+	case 64:
+		if (x[7] != SHADOW_INITIALIZED)
+			return x[7];
+		if (x[6] != SHADOW_INITIALIZED)
+			return x[6];
+		if (x[5] != SHADOW_INITIALIZED)
+			return x[5];
+		if (x[4] != SHADOW_INITIALIZED)
+			return x[4];
+#endif
 	case 32:
 		if (x[3] != SHADOW_INITIALIZED)
 			return x[3];
@@ -722,6 +756,13 @@ set(void *shadow, unsigned int size)
 	x = shadow;
 
 	switch (size) {
+#ifdef X86_64
+	case 64:
+		x[7] = SHADOW_INITIALIZED;
+		x[6] = SHADOW_INITIALIZED;
+		x[5] = SHADOW_INITIALIZED;
+		x[4] = SHADOW_INITIALIZED;
+#endif
 	case 32:
 		x[3] = SHADOW_INITIALIZED;
 		x[2] = SHADOW_INITIALIZED;
-- 
1.5.4.1

