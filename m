Return-Path: <linux-kernel-owner+w=401wt.eu-S932459AbZKXMl2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459AbZKXMl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 07:41:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932236AbZKXMl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 07:41:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11741 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932329AbZKXMl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 07:41:26 -0500
Date: Tue, 24 Nov 2009 13:41:07 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: mingo@elte.hu, rostedt@goodmis.org, fweisbec@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: cannot compile linux-2.6-tip tree
Message-ID: <20091124124107.GA1975@jolsa.lab.eng.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

I just updated 'linux-2.6-tip' and was not able to link drivers/pnp
I bisected the issue, but not sure what happened:

(git tree git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git, x86_64 arch)


[jolsa@jolsa linux-2.6-tip]$ git checkout -b test-good 2e7c0e0cafee5f04a029f06e71e22f9af69ae472~
Switched to a new branch 'test-good'
[jolsa@jolsa linux-2.6-tip]$ find drivers/pnp/ -name *.o | xargs rm
[jolsa@jolsa linux-2.6-tip]$ make drivers/pnp/
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  CC      arch/x86/kernel/asm-offsets.s
  GEN     include/asm/asm-offsets.h
  CALL    scripts/checksyscalls.sh
  CC      drivers/pnp/core.o
  CC      drivers/pnp/card.o
  CC      drivers/pnp/driver.o
  CC      drivers/pnp/resource.o
  CC      drivers/pnp/manager.o
  CC      drivers/pnp/support.o
  CC      drivers/pnp/interface.o
  CC      drivers/pnp/quirks.o
  CC      drivers/pnp/pnpacpi/core.o
  CC      drivers/pnp/pnpacpi/rsparser.o
  LD      drivers/pnp/pnpacpi/built-in.o
  CC      drivers/pnp/system.o
  LD      drivers/pnp/built-in.o
[jolsa@jolsa linux-2.6-tip]$ git checkout -b test-bad 2e7c0e0cafee5f04a029f06e71e22f9af69ae472
Switched to a new branch 'test-bad'
[jolsa@jolsa linux-2.6-tip]$ find drivers/pnp/ -name *.o | xargs rm
[jolsa@jolsa linux-2.6-tip]$ make drivers/pnp/
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  CC      arch/x86/kernel/asm-offsets.s
  GEN     include/asm/asm-offsets.h
  CALL    scripts/checksyscalls.sh
  CC      drivers/pnp/core.o
  CC      drivers/pnp/card.o
objdump: drivers/pnp/.tmp_card.o: File truncated
nm: drivers/pnp/card.o: File truncated
objdump: drivers/pnp/card.o: File truncated
  CC      drivers/pnp/driver.o
  CC      drivers/pnp/resource.o
  CC      drivers/pnp/manager.o
  CC      drivers/pnp/support.o
  CC      drivers/pnp/interface.o
  CC      drivers/pnp/quirks.o
  CC      drivers/pnp/pnpacpi/core.o
  CC      drivers/pnp/pnpacpi/rsparser.o
  LD      drivers/pnp/pnpacpi/built-in.o
  CC      drivers/pnp/system.o
  LD      drivers/pnp/built-in.o
drivers/pnp/card.o: file not recognized: File format not recognized
make[1]: *** [drivers/pnp/built-in.o] Error 1
make: *** [drivers/pnp/] Error 2
[jolsa@jolsa linux-2.6-tip]$ 


the bisected commit looks innocent:

[jolsa@jolsa tip-new]$ git show 2e7c0e0cafee5f04a029f06e71e22f9af69ae472
commit 2e7c0e0cafee5f04a029f06e71e22f9af69ae472
Merge: 4c96088 fd12a0d
Author: Ingo Molnar <mingo@elte.hu>
Date:   Mon Nov 23 19:48:07 2009 +0100

    Merge branch 'x86/mm'

diff --cc arch/x86/kernel/x86_init.c
index d11c5ff,bcc749e..e60844e
--- a/arch/x86/kernel/x86_init.c
+++ b/arch/x86/kernel/x86_init.c
@@@ -13,8 -13,8 +13,9 @@@
  #include <asm/e820.h>
  #include <asm/time.h>
  #include <asm/irq.h>
+ #include <asm/pat.h>
  #include <asm/tsc.h>
 +#include <asm/iommu.h>
  
  void __cpuinit x86_init_noop(void) { }
  void __init x86_init_uint_noop(unsigned int unused) { }
[jolsa@jolsa tip-new]$ 


I guess I'm not alone, hopefully :)

wbr,
jirka
