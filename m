Return-Path: <linux-kernel-owner+w=401wt.eu-S1754900AbYHXOHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbYHXOHf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 10:07:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751666AbYHXOH1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 10:07:27 -0400
Received: from bu3sch.de ([62.75.166.246]:39866 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751483AbYHXOH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 10:07:26 -0400
From: Michael Buesch <mb@bu3sch.de>
To: benh@kernel.crashing.org
Subject: Re: Random crashes with 2.6.27-rc3 on PPC
Date: Sun, 24 Aug 2008 15:44:11 +0200
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: linuxppc-dev@ozlabs.org, linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@osdl.org>
References: <200808231610.46473.mb@bu3sch.de> <1219531969.21386.205.camel@pasglop>
In-Reply-To: <1219531969.21386.205.camel@pasglop>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808241544.12412.mb@bu3sch.de>
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 24 August 2008, Benjamin Herrenschmidt wrote:
> Random guess:
> 
> CONFIG_FRAME_POINTER=y
> CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
> 
> Note sure what those together do, check if you have any file compiled
> with -fno-omit-frame-pointer and if you do, try to change things so
> that you don't ... we found some miscompiles when that is set, exposed
> by FTRACE typically (which you don't have enabled) but possibly by other
> things.


Thanks for your random guess.
The following workaround seems to fix the crashes on powerpc.
However, this patch is clearly not what we want for other architectures,
as they might need -fno-omit-frame-pointer to function properly.

I reproduced the random crashes of kernel and userspace applications
(without the following patch) on a vanilla 2.6.26 and 2.6.27-rc{1-4}
kernel. I did _not_ try a 2.6.25 kernel with -fno-omit-frame-pointer, so
I don't know if it would also crash then.

I'm currently running more tests on a patched 2.6.27-rc4 kernel, but it
didn't crash, yet. I already did 5 complete kernel tree compilations. It
should have crashed by now, but it didn't :)

The compiler is:
gcc (GCC) 4.1.3 20070929 (prerelease) (Ubuntu 4.1.2-16ubuntu2)


Index: linux-2.6/Makefile
===================================================================
--- linux-2.6.orig/Makefile	2008-08-24 11:49:53.000000000 +0200
+++ linux-2.6/Makefile	2008-08-24 12:16:42.000000000 +0200
@@ -523,13 +523,13 @@ endif
 
 # Force gcc to behave correct even for buggy distributions
 # Arch Makefiles may override this setting
 KBUILD_CFLAGS += $(call cc-option, -fno-stack-protector)
 
 ifdef CONFIG_FRAME_POINTER
-KBUILD_CFLAGS	+= -fno-omit-frame-pointer -fno-optimize-sibling-calls
+KBUILD_CFLAGS	+= -fno-optimize-sibling-calls
 else
 KBUILD_CFLAGS	+= -fomit-frame-pointer
 endif
 
 ifdef CONFIG_DEBUG_INFO
 KBUILD_CFLAGS	+= -g
Index: linux-2.6/kernel/Makefile
===================================================================
--- linux-2.6.orig/kernel/Makefile	2008-08-24 11:50:23.000000000 +0200
+++ linux-2.6/kernel/Makefile	2008-08-24 12:15:54.000000000 +0200
@@ -92,13 +92,13 @@ obj-$(CONFIG_SMP) += sched_cpupri.o
 ifneq ($(CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER),y)
 # According to Alan Modra <alan@linuxcare.com.au>, the -fno-omit-frame-pointer is
 # needed for x86 only.  Why this used to be enabled for all architectures is beyond
 # me.  I suspect most platforms don't need this, but until we know that for sure
 # I turn this off for IA-64 only.  Andreas Schwab says it's also needed on m68k
 # to get a correct value for the wait-channel (WCHAN in ps). --davidm
-CFLAGS_sched.o := $(PROFILING) -fno-omit-frame-pointer
+CFLAGS_sched.o := $(PROFILING)
 endif
 
 $(obj)/configs.o: $(obj)/config_data.h
 
 # config_data.h contains the same information as ikconfig.h but gzipped.
 # Info from config_data can be extracted from /proc/config*
