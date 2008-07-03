Return-Path: <linux-kernel-owner+w=401wt.eu-S1757914AbYGCMh1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914AbYGCMh1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:37:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751239AbYGCMhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:37:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41582 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbYGCMhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:37:07 -0400
Date: Thu, 3 Jul 2008 14:36:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ben Collins <ben.collins@canonical.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] Config option to disable info from decompression of
	the kernel
Message-ID: <20080703123642.GB9733@elte.hu>
References: <1213812275.6575.25.camel@cunning>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1213812275.6575.25.camel@cunning>
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


* Ben Collins <ben.collins@canonical.com> wrote:

> I submitted a similar patch some time ago, but rightfully it didn't 
> get accepted, as it just disabled all output from the decompress stage 
> (without a boot time option to enable it).
> 
> This patch just disables the information output from this stage, but 
> not the error output.

> +config NO_BZ_CHATTER
> +	bool "Disable decompress info messages"
> +	default n
> +	help
> +	  Disables just the informational output from the decompression stage
> +	  (e.g. bzImage) of the boot. You will still see errors. Do this if you
> +	  want to cleanup the bootup process.

applied to tip/x86/setup - thanks Ben.

Note that i've flipped around the name (i.e. got rid of the 'NO_'), and 
i renamed it to the bit more generic X86_VERBOSE_BOOTUP config variable. 
We might want to make other output dependent on that flag, not just the 
decompressor messages. Find the commit below. (please double-check it)

	Ingo

----------------------->
commit 6bcb13b35a2ea39be6c7cc0292b8ad1191b1a748
Author: Ben Collins <ben.collins@canonical.com>
Date:   Wed Jun 18 14:04:35 2008 -0400

    x86: config option to disable info from decompression of the kernel
    
    This patch allows the disabling of decompression messages during
    x86 bootup.
    
    Signed-off-by: Ben Collins <ben.collins@canonical.com>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index ac1e31b..14abaa5 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -16,6 +16,14 @@ config NONPROMISC_DEVMEM
 	  obviously disasterous, but specific access can be used by people
 	  debugging the kernel.
 
+config X86_VERBOSE_BOOTUP
+	bool "Enable verbose x86 bootup info messages"
+	default y
+	help
+	  Enables the informational output from the decompression stage
+	  (e.g. bzImage) of the boot. If you disable this you will still
+	  see errors. Disable this if you want silent bootup.
+
 config EARLY_PRINTK
 	bool "Early printk" if EMBEDDED
 	default y
diff --git a/arch/x86/boot/compressed/misc.c b/arch/x86/boot/compressed/misc.c
index d10e727..11629e9 100644
--- a/arch/x86/boot/compressed/misc.c
+++ b/arch/x86/boot/compressed/misc.c
@@ -202,7 +202,8 @@ static void free(void *where);
 static void *memset(void *s, int c, unsigned n);
 static void *memcpy(void *dest, const void *src, unsigned n);
 
-static void putstr(const char *);
+static void __putstr(int, const char *);
+#define putstr(__x)  __putstr(0, __x)
 
 #ifdef CONFIG_X86_64
 #define memptr long
@@ -266,11 +267,16 @@ static void scroll(void)
 		vidmem[i] = ' ';
 }
 
-static void putstr(const char *s)
+static void __putstr(int error, const char *s)
 {
 	int x, y, pos;
 	char c;
 
+#ifndef CONFIG_X86_VERBOSE_BOOTUP
+	if (!error)
+		return;
+#endif
+
 #ifdef CONFIG_X86_32
 	if (real_mode->screen_info.orig_video_mode == 0 &&
 	    lines == 0 && cols == 0)
@@ -363,9 +369,9 @@ static void flush_window(void)
 
 static void error(char *x)
 {
-	putstr("\n\n");
-	putstr(x);
-	putstr("\n\n -- System halted");
+	__putstr(1, "\n\n");
+	__putstr(1, x);
+	__putstr(1, "\n\n -- System halted");
 
 	while (1)
 		asm("hlt");
