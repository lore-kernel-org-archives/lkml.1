Return-Path: <linux-kernel-owner+w=401wt.eu-S1759538AbYHAVye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759538AbYHAVye (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:54:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754899AbYHAVy1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:54:27 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:59097 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752387AbYHAVy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:54:26 -0400
Date: Sat, 2 Aug 2008 06:53:38 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian Bunk <bunk@kernel.org>
Cc: sam@ravnborg.org, linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: sh O= builds broken
Message-ID: <20080801215338.GC13448@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian Bunk <bunk@kernel.org>, sam@ravnborg.org,
	linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080801212728.GF19682@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080801212728.GF19682@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 02, 2008 at 12:27:28AM +0300, Adrian Bunk wrote:
> Most likely caused by the headers move:
> 
> <--  snip  -->
> 
> ...
>   CC      init/main.o
> In file included from /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/sh/include/asm/irq.h:4,
>                  from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/irq.h:23,
>                  from /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/sh/include/asm/hardirq.h:5,
>                  from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/hardirq.h:7,
>                  from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/asm-generic/local.h:5,
>                  from /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/sh/include/asm/local.h:4,
>                  from /home/bunk/linux/kernel-2.6/git/linux-2.6/include/linux/module.h:19,
>                  from /home/bunk/linux/kernel-2.6/git/linux-2.6/init/main.c:13:
> /home/bunk/linux/kernel-2.6/git/linux-2.6/arch/sh/include/asm/machvec.h:15:27: 
> error: asm/machtypes.h: No such file or directory
> make[2]: *** [init/main.o] Error 1
> 
> <--  snip  -->
> 
Ok, so this is what I get for moving the auto-generated header outside of
include/asm-sh.. it seemed like a good idea at the time.

---

diff --git a/arch/sh/Makefile b/arch/sh/Makefile
index 25659ce..7b70cfd 100644
--- a/arch/sh/Makefile
+++ b/arch/sh/Makefile
@@ -164,7 +164,7 @@ KBUILD_AFLAGS		+= $(cflags-y)
 PHONY += maketools FORCE
 
 maketools:  include/linux/version.h FORCE
-	$(Q)$(MAKE) $(build)=arch/sh/tools arch/sh/include/asm/machtypes.h
+	$(Q)$(MAKE) $(build)=arch/sh/tools include/asm-sh/machtypes.h
 
 all: $(KBUILD_IMAGE)
 
@@ -215,4 +215,4 @@ arch/sh/lib64/syscalltab.h: arch/sh/kernel/syscalls_64.S
 	$(call filechk,gen-syscalltab)
 
 CLEAN_FILES += arch/sh/lib64/syscalltab.h \
-	       arch/sh/include/asm/machtypes.h
+	       include/asm-sh/machtypes.h
diff --git a/arch/sh/tools/Makefile b/arch/sh/tools/Makefile
index b5d202b..567516b 100644
--- a/arch/sh/tools/Makefile
+++ b/arch/sh/tools/Makefile
@@ -10,7 +10,7 @@
 # Shamelessly cloned from ARM.
 #
 
-arch/sh/include/asm/machtypes.h: $(src)/gen-mach-types $(src)/mach-types
+include/asm-sh/machtypes.h: $(src)/gen-mach-types $(src)/mach-types
 	@echo '  Generating $@'
-	$(Q)if [ ! -d arch/sh/include/asm ]; then mkdir -p arch/sh/include/asm; fi
+	$(Q)if [ ! -d include/asm-sh ]; then mkdir -p include/asm-sh; fi
 	$(Q)$(AWK) -f $^ > $@ || { rm -f $@; /bin/false; }
