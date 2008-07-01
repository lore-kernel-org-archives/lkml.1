Return-Path: <linux-kernel-owner+w=401wt.eu-S1761184AbYGAPZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761184AbYGAPZf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 11:25:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758458AbYGAPZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 11:25:07 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:45334 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758248AbYGAPZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 11:25:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=fGNirZoBZfl8I710dhqMXawUbtp0SNtFrgEUbZwaegdfIMGeo98Cx+bgSoY9Ns4qqq
         FIK2c/rYrDUn6mAkJgZBOgloJvKhm0QAKBw7Lc04EIYW39NvCbvbu06bPiJ4Rx5csR9l
         8M19qr185AhgOmokeC9i0Y/0xKQI66PNdfvQ0=
Message-ID: <a4423d670807010825t7ea2eb44oda3f08dc007c40a2@mail.gmail.com>
Date: Tue, 1 Jul 2008 19:25:03 +0400
From: "Alexander Beregalov" <a.beregalov@gmail.com>
To: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org, sparclinux@vger.kernel.org,
       "David Miller" <davem@davemloft.net>, sagar.abhishek@gmail.com,
       rostedt@goodmis.org, "Ingo Molnar" <mingo@elte.hu>
Subject: next-0630: sparc64: build failed
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David, Abhishek

$ make CROSS_COMPILE=sparc64-unknown-linux-gnu- image modules && sudo
make modules_install
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  CALL    scripts/checksyscalls.sh
  CHK     include/linux/compile.h
dnsdomainname: Unknown host
  CC      arch/sparc64/kernel/sparc64_ksyms.o
arch/sparc64/kernel/sparc64_ksyms.c:116: error: '_mcount' undeclared
here (not in a function)
cc1: warnings being treated as errors
arch/sparc64/kernel/sparc64_ksyms.c:116: error: type defaults to 'int'
in declaration of '_mcount'

This commit is cause.

commit 395a59d0f8e86bb39cd700c3d185d30c670bb958
Author: Abhishek Sagar <sagar.abhishek@gmail.com>
Date:   Sat Jun 21 23:47:27 2008 +0530

    ftrace: store mcount address in rec->ip

    Record the address of the mcount call-site. Currently all archs
except sparc64
    record the address of the instruction following the mcount call-site. Some
    general cleanups are entailed. Storing mcount addresses in rec->ip enables
    looking them up in the kprobe hash table later on to check if
they're kprobe'd.

    Signed-off-by: Abhishek Sagar <sagar.abhishek@gmail.com>
    Cc: davem@davemloft.net
    Cc: Steven Rostedt <rostedt@goodmis.org>
    Signed-off-by: Ingo Molnar <mingo@elte.hu>

diff --git a/arch/sparc64/kernel/sparc64_ksyms.c
b/arch/sparc64/kernel/sparc64_ksyms.c
index 8ac0b99..b80d982 100644
--- a/arch/sparc64/kernel/sparc64_ksyms.c
+++ b/arch/sparc64/kernel/sparc64_ksyms.c
@@ -53,6 +53,7 @@
 #include <asm/ns87303.h>
 #include <asm/timer.h>
 #include <asm/cpudata.h>
+#include <asm/ftrace.h>

 struct poll {
        int fd;
@@ -112,7 +113,6 @@ EXPORT_SYMBOL(smp_call_function);
 #endif /* CONFIG_SMP */

 #if defined(CONFIG_MCOUNT)
-extern void _mcount(void);
 EXPORT_SYMBOL(_mcount);
 #endif


gcc version 4.3.1 (Gentoo 4.3.1 p1.0)
