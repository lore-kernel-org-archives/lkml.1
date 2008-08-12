Return-Path: <linux-kernel-owner+w=401wt.eu-S1754661AbYHLW6b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661AbYHLW6b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 18:58:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754506AbYHLW55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 18:57:57 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51889 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752424AbYHLW54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 18:57:56 -0400
Message-ID: <48A2155B.1020904@zytor.com>
Date: Tue, 12 Aug 2008 15:57:31 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: mingo@redhat.com, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: Setup code crashes my old 486 box
References: <20080812224703.GV31439@8bytes.org>
In-Reply-To: <20080812224703.GV31439@8bytes.org>
Content-Type: multipart/mixed;
 boundary="------------040605050804090606040102"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040605050804090606040102
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Joerg Roedel wrote:
> Hello,
> 
> yesterday I tried to reactivate my old 486 box and wanted to install a
> current Linux with latest kernel on it. But it turned out that the
> latest kernel does not boot because the machine crashes early in the
> setup code.
> After some debugging it turned out that the problem is the query_ist()
> function. If this interrupt with that function is called the machine
> simply locks up. It looks like a BIOS bug. Looking for a workaround for
> this problem I wrote the attached patch. It checks for the CPUID
> instruction and if it is not implemented it does not call the speedstep
> BIOS function. As far as I know speedstep should be available since some
> Pentium earliest.
> Is this an acceptable workaround or is there a better one for this?
> 
> Regards,
> 
> Joerg

Right in concept, but I dislike the implementation (duplication of the 
CPU detect code we already have).  Could you try this patch and see if 
it works for you?

	-hpa

--------------040605050804090606040102
Content-Type: text/plain;
 name="diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="diff"

diff --git a/arch/x86/boot/boot.h b/arch/x86/boot/boot.h
index a34b998..9ce8d29 100644
--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -242,6 +242,12 @@ int cmdline_find_option(const char *option, char *buffer, int bufsize);
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
index 2296164..9b04773 100644
--- a/arch/x86/boot/main.c
+++ b/arch/x86/boot/main.c
@@ -73,6 +73,10 @@ static void keyboard_set_repeat(void)
  */
 static void query_ist(void)
 {
+	/* Some 486 BIOSes apparently crash on this call */
+	if (cpu.level < 5)
+		return;
+
 	asm("int $0x15"
 	    : "=a" (boot_params.ist_info.signature),
 	      "=b" (boot_params.ist_info.command),

--------------040605050804090606040102--
