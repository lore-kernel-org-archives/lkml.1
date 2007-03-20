Return-Path: <linux-kernel-owner+w=401wt.eu-S1750782AbXCTLAG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750782AbXCTLAG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2007 07:00:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753683AbXCTLAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Mar 2007 07:00:06 -0400
Received: from rubis.org ([82.230.33.161]:37106 "EHLO rubis.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753682AbXCTLAC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2007 07:00:02 -0400
X-Greylist: delayed 468 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Mar 2007 07:00:01 EDT
Date: Tue, 20 Mar 2007 11:52:01 +0100
From: Stephane Jourdois <kwisatz@rubis.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: 2.6.21-rc4-mm1 [PATCH] init/missing_syscalls.h fix
Message-ID: <20070320105200.GA10516@ambre.rubis.org>
Mail-Followup-To: Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
References: <20070319205623.299d0378.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070319205623.299d0378.akpm@linux-foundation.org>
X-Operating-System: Linux 2.6.21-rc3-mm1
X-Send-From: ambre.rubis.org
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2007 at 08:56:23PM -0800, Andrew Morton wrote:
> 
> Temporarily at
> 
>   http://userweb.kernel.org/~akpm/2.6.21-rc4-mm1/

[..]

> +complain-about-missing-system-calls.patch
> +complain-about-missing-system-calls-update.patch


Hi,

I needed the following patch to fix this compile error (which does not
happend at first compile):

kwisatz@ambre:/usr/src/linux-2.6.21-rc4-mm1 $ rm init/missing_syscalls.h 
kwisatz@ambre:/usr/src/linux-2.6.21-rc4-mm1 $ make init
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CHK     include/linux/compile.h
  GEN     init/missing_syscalls.h
  CC      init/missing_syscalls.o
  LD      init/built-in.o
kwisatz@ambre:/usr/src/linux-2.6.21-rc4-mm1 $ cat init/.missing_syscalls.h.cmd
cmd_init/missing_syscalls.h := sed -n '/^\#define/s/[^_]*__NR_\([^[:space:]]*\).*/ \#if !defined (__NR_) \&\& !defined (__IGNORE_)
 \#warning syscall  not implemented
 \#endif/p' /usr/src/linux-2.6.21-rc4-mm1/include/asm-i386/unistd.h >init/missing_syscalls.h

# (note all three \1 missing, replaced by char '^A', not visible here.
# note also that my /bin/sh is symlinked to dash (not bash) 0.5.3

kwisatz@ambre:/usr/src/linux-2.6.21-rc4-mm1 $ make init
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
init/.missing_syscalls.h.cmd:2: *** séparateur manquant . Arrêt.
make: *** [init] Erreur 2


As far as I understand it, Makefile rule cmd_missing_syscalls (from
init/Makefile) is used twice in two different ways:
- At first compile:
  - run the command directly from Makefile,
  - dump this command to init/.missing_syscalls.h.cmd for further use;
- At every but first compile:
  - run existing init/.missing_syscalls.h.cmd


Can someone confirm that this is the right way to patch this ?



Thanks,
- Stéphane.

# complain-about-missing-system-calls-fix.patch
# Make generation of init/missing_syscalls.h more robust.
# Note: This fix is required only for "all but first" compilations, and
# perhaps only on some configurations (cf. /bin/sh).

Signed-off-by: Stéphane (kwisatz) Jourdois <kwisatz@rubis.org>

diff -uNr linux-2.6.21-rc4-mm1.orig/init/Makefile linux-2.6.21-rc4-mm1/init/Makefile
--- linux-2.6.21-rc4-mm1.orig/init/Makefile	2007-03-20 09:54:23.000000000 +0100
+++ linux-2.6.21-rc4-mm1/init/Makefile	2007-03-20 11:19:02.000000000 +0100
@@ -35,10 +35,8 @@
 
 
 quiet_cmd_missing_syscalls = GEN     $@
-      cmd_missing_syscalls = sed -n '/^\#define/s/[^_]*__NR_\([^[:space:]]*\).*/\
-	\#if !defined (__NR_\1) \&\& !defined (__IGNORE_\1)\n\
-	\#warning syscall \1 not implemented\n\
-	\#endif/p' $(srctree)/include/asm-i386/unistd.h >$@
+      cmd_missing_syscalls = sed -n -f scripts/mkmissing_syscalls_h \
+      			$(srctree)/include/asm-i386/unistd.h >$@
 targets += missing_syscalls.h
 $(obj)/missing_syscalls.h: include/asm-i386/unistd.h
 	$(call if_changed,missing_syscalls)
diff -uNr linux-2.6.21-rc4-mm1.orig/scripts/mkmissing_syscalls_h linux-2.6.21-rc4-mm1/scripts/mkmissing_syscalls_h
--- linux-2.6.21-rc4-mm1.orig/scripts/mkmissing_syscalls_h	1970-01-01 01:00:00.000000000 +0100
+++ linux-2.6.21-rc4-mm1/scripts/mkmissing_syscalls_h	2007-03-20 11:34:21.000000000 +0100
@@ -0,0 +1,6 @@
+/^\#define/ {
+	s/[^_]*__NR_\([^[:space:]]*\).*/\
+\#if !defined (__NR_\1) \&\& !defined (__IGNORE_\1)\
+\#warning syscall \1 not implemented\
+\#endif/p
+}

-- 
 ///  Stephane Jourdois     /"\  ASCII RIBBON CAMPAIGN \\\
(((    Consultant securite  \ /    AGAINST HTML MAIL    )))
 \\\   24 rue Cauchy         X                         ///
  \\\  75015  Paris         / \    +33 6 8643 3085    ///
