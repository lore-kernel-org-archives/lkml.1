Return-Path: <linux-kernel-owner+w=401wt.eu-S1752543AbYHMIHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbYHMIHe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755174AbYHMIHK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:07:10 -0400
Received: from 8bytes.org ([88.198.83.132]:36619 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398AbYHMIHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:07:06 -0400
Date: Wed, 13 Aug 2008 10:07:05 +0200
From: Joerg Roedel <joro@8bytes.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: Setup code crashes my old 486 box
Message-ID: <20080813080705.GW31439@8bytes.org>
References: <20080812224703.GV31439@8bytes.org> <48A2155B.1020904@zytor.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ADZbWkCsHQ7r3kzd"
Content-Disposition: inline
In-Reply-To: <48A2155B.1020904@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ADZbWkCsHQ7r3kzd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 12, 2008 at 03:57:31PM -0700, H. Peter Anvin wrote:
> Right in concept, but I dislike the implementation (duplication of the 
> CPU detect code we already have).  Could you try this patch and see if 
> it works for you?

Cool, with a small modification to fix a build error with it the
resulting kernel boots my machine. Thanks.
Would be cool to have this patch one merged soon :-)
Attached is your patch with my little build fix. It redefines a values
already defines in cpufeatures.h but I can't include that file in the
boot code so I simply redeclared it. Maybe there is a cleaner solution
for this.

Joerg


--ADZbWkCsHQ7r3kzd
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="ist_fix.diff"

diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index a34b998..9d4b4b4 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -25,6 +25,8 @@
 #include <asm/boot.h>
 #include <asm/setup.h>
 
+#define NCAPINTS   8
+
 /* Useful macros */
 #define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
 
@@ -242,6 +244,12 @@ int cmdline_find_option(const char *option, char *buffer, int bufsize);
 int cmdline_find_option_bool(const char *option);
 
 /* cpu.c, cpucheck.c */
+struct cpu_features {
+	int level;		/* Family, or 64 for x86-64 */
+	int model;
+	u32 flags[NCAPINTS];
+};
+extern struct cpu_features cpu;
 int check_cpu(int *cpu_level_ptr, int *req_level_ptr, u32 **err_flags_ptr);
 int validate_cpu(void);
 
diff --git a/arch/x86/boot/cpucheck.c b/arch/x86/boot/cpucheck.c
index 7804389..c1ce030 100644
--- a/arch/x86/boot/cpucheck.c
+++ b/arch/x86/boot/cpucheck.c
@@ -30,13 +30,7 @@
 #include <asm/required-features.h>
 #include <asm/msr-index.h>
 
-struct cpu_features {
-	int level;		/* Family, or 64 for x86-64 */
-	int model;
-	u32 flags[NCAPINTS];
-};
-
-static struct cpu_features cpu;
+struct cpu_features cpu;
 static u32 cpu_vendor[3];
 static u32 err_flags[NCAPINTS];
 
diff --git a/arch/x86/boot/main.c b/arch/x86/boot/main.c
index 2296164..01aa64b 100644
--- a/arch/x86/boot/main.c
+++ b/arch/x86/boot/main.c
@@ -73,6 +73,10 @@ static void keyboard_set_repeat(void)
  */
 static void query_ist(void)
 {
+	/* Some 486 BIOSes apparently crash on this call */
+	if (cpu.level < 6)
+		return;
+
 	asm("int $0x15"
 	    : "=a" (boot_params.ist_info.signature),
 	      "=b" (boot_params.ist_info.command),

--ADZbWkCsHQ7r3kzd--
