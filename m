Return-Path: <linux-kernel-owner+w=401wt.eu-S1757945AbYFTX46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945AbYFTX46 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 19:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755919AbYFTX4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 19:56:45 -0400
Received: from jurassic.park.msu.ru ([195.208.223.243]:33938 "EHLO
	jurassic.park.msu.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752341AbYFTX4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 19:56:44 -0400
X-Greylist: delayed 1870 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Jun 2008 19:56:44 EDT
Date: Sat, 21 Jun 2008 03:26:21 +0400
From: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Richard Henderson <rth@twiddle.net>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] alpha: link failure fix
Message-ID: <20080620232621.GB8061@jurassic.park.msu.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With built-in scsi disk driver, the final link fails with a following
error:
`.exit.text' referenced in section `.rodata' of drivers/built-in.o:
defined in discarded section `.exit.text' of drivers/built-in.o

This happens with -Os (CONFIG_CC_OPTIMIZE_FOR_SIZE=y) with all gcc-4
versions, and also with -O2 and gcc-4.3.

The problem is in sd.c:sd_major() being inlined into __exit function
exit_sd(), and the compiler generating a jump table in .rodata section
for the 'switch' statement in sd_major(). So we have references to
discarded section.

Fixed with a big hammer in the form of -fno-jump-tables.

Note that jump tables vs. discarded sections is a generic problem,
other architectures are just lucky not to suffer from it. But with
a slightly more complex switch/case statement it can be reproduced
on x86 as well. So maybe at some point we should consider
-fno-jump-tables as a generic compile option...

Signed-off-by: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
---
 arch/alpha/Makefile |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/alpha/Makefile b/arch/alpha/Makefile
index 4e1a8e2..4759fe7 100644
--- a/arch/alpha/Makefile
+++ b/arch/alpha/Makefile
@@ -13,6 +13,7 @@ NM := $(NM) -B
 LDFLAGS_vmlinux	:= -static -N #-relax
 CHECKFLAGS	+= -D__alpha__ -m64
 cflags-y	:= -pipe -mno-fp-regs -ffixed-8 -msmall-data
+cflags-y	+= $(call cc-option, -fno-jump-tables)
 
 cpuflags-$(CONFIG_ALPHA_EV4)		:= -mcpu=ev4
 cpuflags-$(CONFIG_ALPHA_EV5)		:= -mcpu=ev5
