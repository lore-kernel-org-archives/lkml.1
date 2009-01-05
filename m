Return-Path: <linux-kernel-owner+w=401wt.eu-S1753245AbZAEHMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245AbZAEHMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 02:12:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751362AbZAEHMi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 02:12:38 -0500
Received: from ey-out-2122.google.com ([74.125.78.24]:17216 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbZAEHMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 02:12:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition;
        b=Wg6nNYCyihOCd8Qd2NJSnmydiHIJkJ73fIcdp0IXI4iaLEg89RA3osH5wzPwr1AvpW
         QcMfkeb2ji6uDcfOSHYKJnmRchU4ESU0aVxGgDWL80DZgUrwTHoqABJPzebAImMJcLws
         3Lz01gexBCHPFQCvnl9vjGPu7XXPZMEcNPWdc=
Message-ID: <91b13c310901042312o44afa166t66b23e8ad10d104f@mail.gmail.com>
Date: Mon, 5 Jan 2009 15:12:33 +0800
From: "=?UTF-8?Q?Cheng_Renquan_(=E7=A8=8B=E4=BB=BB=E5=85=A8)?=" 
	<crquan@gmail.com>
To: "Arjan van de Ven" <arjan@linux.intel.com>,
       "Al Viro" <viro@zeniv.linux.org.uk>,
       "Matt Helsley" <matthltc@us.ibm.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Adrian Bunk" <bunk@kernel.org>,
       "Ananth N Mavinakayanahalli" <ananth@in.ibm.com>,
       anil.s.keshavamurthy@intel.com, davem@davemloft.net,
       mhiramat@redhat.com
Subject: KPROBE linking error (who's the maintainer of kernel/power/) ?
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha id n057CowM012431

with this .config
CONFIG_CGROUPS=yCONFIG_CGROUP_FREEZER=yCONFIG_MODULES=yCONFIG_FREEZER=yCONFIG_PM=yCONFIG_PM_SLEEP=n
the kernel will end compiling with error:
kernel/built-in.o: In function `check_safety':/usr/src/linux-2.6.28/kernel/kprobes.c:126: undefined reference to`freeze_processes'/usr/src/linux-2.6.28/kernel/kprobes.c:139: undefined reference to`thaw_processes'/usr/src/linux-2.6.28/kernel/kprobes.c:139: undefined reference to`thaw_processes'make: *** [.tmp_vmlinux1] Error 1
By read kernel/kprobes.c, I found there maybe a bug:
1. "check_safety" in "kernel/kprobes.c" call thaw_processes if bothCONFIG_PREEMPT and CONFIG_PM defined,2. "thaw_processes" function is implemented in "kernel/power/process.c",3. but it is only used if CONFIG_FREEZER defined, from <linux/freezer.h>,4. else (CONFIG_FREEZER undefined) it's a null macro defined in<linux/freezer.h>,5. but process.o only get compile if CONFIG_PM_SLEEP defined, from"kernel/power/Makefile",
Now I'm confused on how to resolve this?What's the relation of PM, PM_SLEEP, and FREEZER?Which modification of the following will be better?1. modify kernel/Kconfig, let KPROBES depends more?2. modify kernel/kprobes.c, let the conditional compile depends more?3. modify include/linux/freezer.h, move thaw_processes to include/linux/pm.h?4. modify kernel/power/Makefile, let kernel/power/process.c compile onless condition?
Furthermore, there seems no entry for maintainers of "kernel/power/",who maintain that subdir please add your name to the MAINTAINERS file?I just grab some latest touchers of kernel/power/ and kernel/kprobes.cas the recipients here.
-- Cheng Renquan (ç¨‹ä»»å…¨), Shenzhen, ChinaEddie Izzard  - "I grew up in Europe, where the history comes from."ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
