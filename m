Return-Path: <linux-kernel-owner+w=401wt.eu-S1758521AbZCSVE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758521AbZCSVE6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 17:04:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753221AbZCSVEt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 17:04:49 -0400
Received: from www.tglx.de ([62.245.132.106]:53385 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752541AbZCSVEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 17:04:48 -0400
Date: Thu, 19 Mar 2009 22:02:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Sam Ravnborg <sam@ravnborg.org>
cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] kbuild: work around distcc/icecc madness
Message-ID: <alpine.LFD.2.00.0903192121300.29264@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: workaround for distcc/icecc

Peter and I noticed that distcc and icecc based kernel compiles
started to show random full kernel rebuilds even when nothing or just
a .c file changed. The reason is "change of the command line" which
caused scripts/mod/empty.o to rebuild and due to the dependencies the
complete kernel tree. I never change the command line simply because I
use a script for my builds.

The root cause for this problem is the check for the CFI support in
x86 binutils. The call is generated via:

    echo -e "$(1)" | $(CC) $(KBUILD_AFLAGS) -c -xassembler -o "$$TMP" -

This works fine as long as a local gcc is used or distcc/icecc use the
local machine. When distcc/icecc offload the compile to a remote
machine the compile fails with the following error message:
   gcc: : No such file or directory

Now we get command lines with -DCONFIG_CFI* and without every other
compile which causes the full rebuilds.

Digging trough the distcc/icecc code it seems that the stdin input for
remote compiles is not handled correctly. Indeed there is some strange
comment about this, but unfortunately no decision to compile it
local. :(

distcc and icecc are used by many developers and we can not fix the
versions which are out there in the wild, but we can avoid the stdin
based call easily: echo the asm code into the temp file which is used
for the output and use it as input file for the compiler.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 scripts/Kbuild.include |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6-tip/scripts/Kbuild.include
===================================================================
--- linux-2.6-tip.orig/scripts/Kbuild.include
+++ linux-2.6-tip/scripts/Kbuild.include
@@ -98,8 +98,9 @@ as-option = $(call try-run,\
 # as-instr
 # Usage: cflags-y += $(call as-instr,instr,option1,option2)
 
-as-instr = $(call try-run,\
-	echo -e "$(1)" | $(CC) $(KBUILD_AFLAGS) -c -xassembler -o "$$TMP" -,$(2),$(3))
+as-instr = $(call try-run,		\
+	echo -e "$(1)" > "$$TMP"; 	\
+	$(CC) $(KBUILD_AFLAGS) -c -xassembler -o "$$TMP" "$$TMP",$(2),$(3))
 
 # cc-option
 # Usage: cflags-y += $(call cc-option,-march=winchip-c6,-march=i586)
