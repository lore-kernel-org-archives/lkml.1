Return-Path: <linux-kernel-owner+w=401wt.eu-S1755574AbYHMKAj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbYHMKAj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 06:00:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752579AbYHMKAb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 06:00:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41602 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362AbYHMKAa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 06:00:30 -0400
Date: Wed, 13 Aug 2008 12:00:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joro@8bytes.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, mingo@redhat.com, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: Setup code crashes my old 486 box
Message-ID: <20080813100013.GD2214@elte.hu>
References: <20080812224703.GV31439@8bytes.org> <48A2155B.1020904@zytor.com> <20080813080705.GW31439@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080813080705.GW31439@8bytes.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Joerg Roedel <joro@8bytes.org> wrote:

> On Tue, Aug 12, 2008 at 03:57:31PM -0700, H. Peter Anvin wrote:
> > Right in concept, but I dislike the implementation (duplication of the 
> > CPU detect code we already have).  Could you try this patch and see if 
> > it works for you?
> 
> Cool, with a small modification to fix a build error with it the
> resulting kernel boots my machine. Thanks.
> Would be cool to have this patch one merged soon :-)
> Attached is your patch with my little build fix. It redefines a values
> already defines in cpufeatures.h but I can't include that file in the
> boot code so I simply redeclared it. Maybe there is a cleaner solution
> for this.

thanks, i've commited the fix below to tip/x86/urgent - it should show 
up in v2.6.27-rc4 and it might even be backportable to -stable. I've 
added your Signed-off-by - is that ok with you?

	Ingo

------------->
>From 7b27718bdb1b70166383dec91391df5534d449ee Mon Sep 17 00:00:00 2001
From: Joerg Roedel <joro@8bytes.org>
Date: Wed, 13 Aug 2008 10:07:05 +0200
Subject: [PATCH] x86: fix setup code crashes on my old 486 box

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

Alan Cox observed that it's available since the Pentium II, so cpuid
levels 4 and 5 can be excluded altogether.

H. Peter Anvin cleaned up the code some more:

> Right in concept, but I dislike the implementation (duplication of the
> CPU detect code we already have).  Could you try this patch and see if
> it works for you?

which, with a small modification to fix a build error with it the
resulting kernel boots on my machine.

Signed-off-by: Joerg Roedel <joro@8bytes.org>
Signed-off-by: "H. Peter Anvin" <hpa@zytor.com>
Cc: <stable@kernel.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/boot/boot.h     |    8 ++++++++
 arch/x86/boot/cpucheck.c |    8 +-------
 arch/x86/boot/main.c     |    4 ++++
 3 files changed, 13 insertions(+), 7 deletions(-)

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
