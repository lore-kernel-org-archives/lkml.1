Return-Path: <linux-kernel-owner+w=401wt.eu-S1759363AbYHRTLE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759363AbYHRTLE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:11:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755876AbYHRTGQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:06:16 -0400
Received: from mx1.suse.de ([195.135.220.2]:44332 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762884AbYHRTGO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:06:14 -0400
Date: Mon, 18 Aug 2008 11:45:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
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
       alan@lxorguk.ukuu.org.uk, Joerg Roedel <joro@8bytes.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>
Subject: [patch 53/60] x86: fix setup code crashes on my old 486 box
Message-ID: <20080818184530.GB29394@suse.de>
References: <20080818183230.966310219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="x86-fix-setup-code-crashes-on-my-old-486-box.patch"
In-Reply-To: <20080818184035.GA29394@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Joerg Roedel <joro@8bytes.org>

commit 7b27718bdb1b70166383dec91391df5534d449ee upstream

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
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/boot/boot.h     |    8 ++++++++
 arch/x86/boot/cpucheck.c |    8 +-------
 arch/x86/boot/main.c     |    4 ++++
 3 files changed, 13 insertions(+), 7 deletions(-)

--- a/arch/x86/boot/boot.h
+++ b/arch/x86/boot/boot.h
@@ -25,6 +25,8 @@
 #include <asm/boot.h>
 #include <asm/setup.h>
 
+#define NCAPINTS   8
+
 /* Useful macros */
 #define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))
 
@@ -242,6 +244,12 @@ int cmdline_find_option(const char *opti
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

-- 
