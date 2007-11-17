Return-Path: <linux-kernel-owner+w=401wt.eu-S1757535AbXKQOgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535AbXKQOgA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2007 09:36:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbXKQOfv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Nov 2007 09:35:51 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:33789 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194AbXKQOfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2007 09:35:50 -0500
Date: Sat, 17 Nov 2007 15:37:31 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: Andreas Herrmann <aherrman@arcor.de>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Roman Zippel <zippel@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] x86: simplify "make ARCH=x86" and fix kconfig all.config
Message-ID: <20071117143731.GA7129@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Simplify "make ARCH=x86" and fix kconfig so we again
can set 64BIT in all.config.

For a fix the diffstat is nice:
 6 files changed, 3 insertions(+), 36 deletions(-)

The patch reverts these commits:
0f855aa64b3f63d35a891510cf7db932a435c116
-> kconfig: add helper to set config symbol from environment variable

2a113281f5cd2febbab21a93c8943f8d3eece4d3
-> kconfig: use $K64BIT to set 64BIT with all*config targets

Roman Zippel pointed out that kconfig supported string
compares so the additional complexity introduced by the
above two patches were not needed.

With this patch we have following behaviour:

# make {allno,allyes,allmod,rand}config [ARCH=...]
option \ host arch      | 32bit         | 64bit
=====================================================
./.                     | 32bit         | 64bit
ARCH=x86                | 32bit         | 32bit
ARCH=i386               | 32bit         | 32bit
ARCH=x86_64             | 64bit         | 64bit

The general rule are that ARCH= and native architecture
takes precedence over the configuration.
So make ARCH=i386 [whatever] will always build a 32-bit
kernel no matter what the configuration says.
The configuration will be updated to 32-bit if it was
configured to 64-bit and the other way around.

This behaviour is consistent with previous behaviour so
no suprises here.

make ARCH=x86 will per default result in a 32-bit kernel
but as the only ARCH= value x86 allow the user to select
between 32-bit and 64-bit using menuconfig. 

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Roman Zippel <zippel@linux-m68k.org>
Cc: Andreas Herrmann <aherrman@arcor.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
---

Linus - please apply to -rc3.

Note: This patch does not fix the uname -m issue - to do so
Andreas' patch is needed.

	Sam

 Makefile                    |    4 +---
 README                      |    2 --
 arch/x86/Kconfig            |    4 ++--
 scripts/kconfig/conf.c      |    1 -
 scripts/kconfig/confdata.c  |   27 ---------------------------
 scripts/kconfig/lkc_proto.h |    1 -
 6 files changed, 3 insertions(+), 36 deletions(-)

diff --git a/Makefile b/Makefile
index 9c9c4bf..b32963a 100644
--- a/Makefile
+++ b/Makefile
@@ -200,11 +200,9 @@ SRCARCH 	:= $(ARCH)
 # Additional ARCH settings for x86
 ifeq ($(ARCH),i386)
         SRCARCH := x86
-        K64BIT  := n
 endif
 ifeq ($(ARCH),x86_64)
         SRCARCH := x86
-        K64BIT  := y
 endif
 
 KCONFIG_CONFIG	?= .config
@@ -341,7 +339,7 @@ KERNELRELEASE = $(shell cat include/config/kernel.release 2> /dev/null)
 KERNELVERSION = $(VERSION).$(PATCHLEVEL).$(SUBLEVEL)$(EXTRAVERSION)
 
 export VERSION PATCHLEVEL SUBLEVEL KERNELRELEASE KERNELVERSION
-export ARCH SRCARCH K64BIT CONFIG_SHELL HOSTCC HOSTCFLAGS CROSS_COMPILE AS LD CC
+export ARCH SRCARCH CONFIG_SHELL HOSTCC HOSTCFLAGS CROSS_COMPILE AS LD CC
 export CPP AR NM STRIP OBJCOPY OBJDUMP MAKE AWK GENKSYMS PERL UTS_MACHINE
 export HOSTCXX HOSTCXXFLAGS LDFLAGS_MODULE CHECK CHECKFLAGS
 
diff --git a/README b/README
index 592f8a2..159912c 100644
--- a/README
+++ b/README
@@ -194,8 +194,6 @@ CONFIGURING the kernel:
    "make *config" checks for a file named "all{yes/mod/no/random}.config"
    for symbol values that are to be forced.  If this file is not found,
    it checks for a file named "all.config" to contain forced values.
-   Finally it checks the environment variable K64BIT and if found, sets
-   the config symbol "64BIT" to the value of the K64BIT variable.
    
 	NOTES on "make config":
 	- having unnecessary drivers will make the kernel bigger, and can
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 1eb5997..368864d 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -3,8 +3,8 @@ mainmenu "Linux Kernel Configuration for x86"
 
 # Select 32 or 64 bit
 config 64BIT
-	bool "64-bit kernel"
-	default n
+	bool "64-bit kernel" if ARCH = "x86"
+	default ARCH = "x86_64"
 	help
 	  Say yes to build a 64-bit kernel - formerly known as x86_64
 	  Say no to build a 32-bit kernel - formerly known as i386
diff --git a/scripts/kconfig/conf.c b/scripts/kconfig/conf.c
index c6bee85..a38787a 100644
--- a/scripts/kconfig/conf.c
+++ b/scripts/kconfig/conf.c
@@ -591,7 +591,6 @@ int main(int ac, char **av)
 			conf_read_simple(name, S_DEF_USER);
 		else if (!stat("all.config", &tmpstat))
 			conf_read_simple("all.config", S_DEF_USER);
-		conf_set_env_sym("K64BIT", "64BIT", S_DEF_USER);
 		break;
 	default:
 		break;
diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index e4fa3f3..e0f402f 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -145,33 +145,6 @@ static int conf_set_sym_val(struct symbol *sym, int def, int def_flags, char *p)
 	return 0;
 }
 
-/* Read an environment variable and assign the value to the symbol */
-int conf_set_env_sym(const char *env, const char *symname, int def)
-{
-	struct symbol *sym;
-	char *p;
-	int def_flags;
-
-	p = getenv(env);
-	if (p) {
-		char warning[200];
-		sprintf(warning, "Environment variable (%s = \"%s\")", env, p);
-		conf_filename = warning;
-		def_flags = SYMBOL_DEF << def;
-		if (def == S_DEF_USER) {
-			sym = sym_find(symname);
-			if (!sym)
-				return 1;
-		} else {
-			sym = sym_lookup(symname, 0);
-			if (sym->type == S_UNKNOWN)
-				sym->type = S_OTHER;
-		}
-		conf_set_sym_val(sym, def, def_flags, p);
-	}
-	return 0;
-}
-
 int conf_read_simple(const char *name, int def)
 {
 	FILE *in = NULL;
diff --git a/scripts/kconfig/lkc_proto.h b/scripts/kconfig/lkc_proto.h
index dca294e..4d09f6d 100644
--- a/scripts/kconfig/lkc_proto.h
+++ b/scripts/kconfig/lkc_proto.h
@@ -1,7 +1,6 @@
 
 /* confdata.c */
 P(conf_parse,void,(const char *name));
-P(conf_set_env_sym,int,(const char *envname, const char *symname, int def));
 P(conf_read,int,(const char *name));
 P(conf_read_simple,int,(const char *name, int));
 P(conf_write,int,(const char *name));
