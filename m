Return-Path: <linux-kernel-owner+w=401wt.eu-S934650AbYEUA6O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934650AbYEUA6O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 20:58:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934672AbYEUA5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 20:57:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40166 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934660AbYEUA5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 20:57:36 -0400
Date: Tue, 20 May 2008 18:56:17 -0400
From: Dave Jones <davej@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Rene Herman <rene.herman@keyaccess.nl>, Mikael Pettersson <mikpe@it.uu.se>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [X86] Add a boot parameter to force-enable PAT
Message-ID: <20080520225617.GA19002@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Rene Herman <rene.herman@keyaccess.nl>,
	Mikael Pettersson <mikpe@it.uu.se>,
	Yinghai Lu <yhlu.kernel@gmail.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
References: <200805200409.m4K49Ybn024338@gelk.kernelslacker.org> <86802c440805192253s34b3acb2r63c657db86676792@mail.gmail.com> <20080520132306.GB4843@redhat.com> <18482.58121.130009.555407@harpo.it.uu.se> <20080520195846.GA29806@redhat.com> <48334766.1020701@keyaccess.nl> <48334EFA.3070109@zytor.com> <483353DB.7010708@keyaccess.nl> <483353E9.7090001@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <483353E9.7090001@zytor.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 03:42:49PM -0700, H. Peter Anvin wrote:

 > > Yes, that would be nicer. As to the alias; "nopat" hasn't been in a 
 > > released kernel yet so should be okay to do away with? It's not like 
 > > it's in Documentation/kernel-parameters.txt or anything... ;-/
 > > 
 > 
 > OK, just double-checked... since it's not in Linus we can still change 
 > it, and as so I'd suggest the pat= option.

Not boot-tested, but it compiles for me..
I also folded in the 'debugpat' option.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index e37f456..9f9c2c2 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1478,6 +1478,12 @@ and is between 256 and 4096 characters. It is defined in the file
 			the specified number of seconds.  This is to be used if
 			your oopses keep scrolling off the screen.
 
+	pat=		[X86] Page attribute table support.
+			off	don't use page attribute tables.
+			force	enable use of page attribute tables, even if the
+				CPU isn't in the kernel's whitelist.
+			debug	output additional debugging information during setup.
+
 	pcbit=		[HW,ISDN]
 
 	pcd.		[PARIDE]
diff --git a/arch/x86/kernel/cpu/addon_cpuid_features.c b/arch/x86/kernel/cpu/addon_cpuid_features.c
index c2e1ce3..8b65f14 100644
--- a/arch/x86/kernel/cpu/addon_cpuid_features.c
+++ b/arch/x86/kernel/cpu/addon_cpuid_features.c
@@ -51,8 +51,15 @@ void __cpuinit init_scattered_cpuid_features(struct cpuinfo_x86 *c)
 }
 
 #ifdef CONFIG_X86_PAT
+int forcepat;
+
 void __cpuinit validate_pat_support(struct cpuinfo_x86 *c)
 {
+	if (forcepat == 1) {
+		printk(KERN_INFO "Force enabling PAT\n");
+		return;
+	}
+
 	switch (c->x86_vendor) {
 	case X86_VENDOR_AMD:
 		if (c->x86 >= 0xf && c->x86 <= 0x11)
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index e83b770..7429bee 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -25,8 +25,11 @@
 #include <asm/mtrr.h>
 #include <asm/io.h>
 
+static int debug_enable;
+
 #ifdef CONFIG_X86_PAT
 int __read_mostly pat_wc_enabled = 1;
+extern int forcepat;
 
 void __cpuinit pat_disable(char *reason)
 {
@@ -34,23 +37,22 @@ void __cpuinit pat_disable(char *reason)
 	printk(KERN_INFO "%s\n", reason);
 }
 
-static int nopat(char *str)
+static int __init patsetup(char *str)
 {
-	pat_disable("PAT support disabled.");
+	if (strcmp("force", str) == 0) {
+		forcepat = 1;
+		printk(KERN_INFO "Force enabling PAT\n");
+	}
+	if (strcmp("off", str) == 0)
+		pat_disable("PAT support disabled.");
+	if (strcmp("debug", str) == 0)
+		debug_enable = 1;
 	return 0;
 }
-early_param("nopat", nopat);
+early_param("pat=", patsetup);
 #endif
 
 
-static int debug_enable;
-static int __init pat_debug_setup(char *str)
-{
-	debug_enable = 1;
-	return 0;
-}
-__setup("debugpat", pat_debug_setup);
-
 #define dprintk(fmt, arg...) \
 	do { if (debug_enable) printk(KERN_INFO fmt, ##arg); } while (0)
 

-- 
http://www.codemonkey.org.uk
