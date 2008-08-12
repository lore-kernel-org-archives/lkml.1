Return-Path: <linux-kernel-owner+w=401wt.eu-S1753593AbYHLWrS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593AbYHLWrS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 18:47:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752108AbYHLWrH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 18:47:07 -0400
Received: from 8bytes.org ([88.198.83.132]:51373 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbYHLWrG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 18:47:06 -0400
Date: Wed, 13 Aug 2008 00:47:03 +0200
From: Joerg Roedel <joro@8bytes.org>
To: hpa@zytor.com
Cc: mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Setup code crashes my old 486 box
Message-ID: <20080812224703.GV31439@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

yesterday I tried to reactivate my old 486 box and wanted to install a
current Linux with latest kernel on it. But it turned out that the
latest kernel does not boot because the machine crashes early in the
setup code.
After some debugging it turned out that the problem is the query_ist()
function. If this interrupt with that function is called the machine
simply locks up. It looks like a BIOS bug. Looking for a workaround for
this problem I wrote the attached patch. It checks for the CPUID
instruction and if it is not implemented it does not call the speedstep
BIOS function. As far as I know speedstep should be available since some
Pentium earliest.
Is this an acceptable workaround or is there a better one for this?

Regards,

Joerg

Here is the patch which makes the kernel boot on my old box again:

From: Joerg Roedel <joro@8bytes.org>

This patch adds a check to the query_ist function to check for the cpuid
instruction before calling the speedstep init code. This works around a
buggy 486 BIOS which crashes the machine on the speedstep BIOS initcall.

Signed-off-by: Joerg Roedel <joro@8bytes.org>
---
 arch/x86/boot/main.c |   47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 47 insertions(+), 0 deletions(-)

diff --git a/arch/x86/boot/main.c b/arch/x86/boot/main.c
index 2296164..3bf5fa0 100644
--- a/arch/x86/boot/main.c
+++ b/arch/x86/boot/main.c
@@ -68,11 +68,58 @@ static void keyboard_set_repeat(void)
 		     : : "ecx", "edx", "esi", "edi");
 }
 
+static unsigned read_flags(void)
+{
+	unsigned eax;
+
+	asm volatile("pushf\n\t"
+		     "popl %%eax\n\t"
+		     : "=a" (eax));
+
+	return eax;
+}
+
+static inline void write_flags(unsigned f)
+{
+	asm volatile("pushl %0\n\t"
+		     "popf\n\t"
+		     : : "r" (f));
+}
+
+static int has_cpuid(void)
+{
+	unsigned f = read_flags();
+	unsigned id_mask = (1 << 21);
+
+	write_flags(f | id_mask);
+	f = read_flags() & id_mask;
+	if (!f)
+		return 0;
+	f = read_flags() & ~id_mask;
+	write_flags(f);
+	f = read_flags() & id_mask;
+	if (f)
+		return 0;
+
+	return 1;
+}
+
+static int no_ist_check(void)
+{
+	if (!has_cpuid())
+		return 1;
+
+	return 0;
+}
+
 /*
  * Get Intel SpeedStep (IST) information.
  */
 static void query_ist(void)
 {
+	if (no_ist_check())
+		return;
+
 	asm("int $0x15"
 	    : "=a" (boot_params.ist_info.signature),
 	      "=b" (boot_params.ist_info.command),
-- 
1.5.4.3

