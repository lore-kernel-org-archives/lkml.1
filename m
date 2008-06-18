Return-Path: <linux-kernel-owner+w=401wt.eu-S1753016AbYFRIfg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753016AbYFRIfg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 04:35:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751394AbYFRIf2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 04:35:28 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:7469 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbYFRIf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 04:35:27 -0400
Message-ID: <4858C8CC.4040407@de.ibm.com>
Date: Wed, 18 Jun 2008 10:35:24 +0200
From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>,
       Andrew Morton <akpm@linux-foundation.org>
CC: linux-mm@kvack.org, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org,
       Peter Oberparleiter <oberparleiter@googlemail.com>
Subject: Re: 2.6.26-rc5-mm1
References: <OF18B05E59.2D95953A-ONC1257464.00296BEB-C1257464.002F94B3@de.ibm.com> <200806180026.27247.m.kozlowski@tuxland.pl>
In-Reply-To: <200806180026.27247.m.kozlowski@tuxland.pl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mariusz Kozlowski wrote:
> After a few hours and tons of reboots I narrowed it down to
> arch/x86/kernel/Makefile:
> 
> a) works
> 	obj-y                   += tsc_$(BITS).o io_delay.o rtc.o
> 	GCOV_tsc_$(BITS).o      := n
> 	#GCOV_io_delay.o        := n
> 	#GCOV_rtc.o     := n
> 
> b) doesn't work
> 	obj-y                   += tsc_$(BITS).o io_delay.o rtc.o
> 	#GCOV_tsc_$(BITS).o     := n
> 	#GCOV_io_delay.o        := n
> 	#GCOV_rtc.o     := n
> 
> and that points to arch/x86/kernel/tsc_64.c

Excellent work! 

I had a quick look at that file and couldn't identify any obvious reason
(for a non-x84 developer) why it shouldn't work with -fprofile-arcs.
There are some comments in the corresponding Makefile though that
indicate that tsc_64.o is a bit picky with regards to CFLAGS (no -pg,
-fno-stack-protector) so I think it's safe to simply exclude those
files from profiling.

Based on your findings, the following patch should be applied to -mm.
Thanks again for your effort.

--
[PATCH] gcov: fix run-time error on x86_64

From: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

Disable profiling of tsc_$(BITS).o to fix a run-time error when using
CONFIG_GCOV_PROFILE_ALL on x86_64:

bash[498] segfault at ffffffff80868b58 ip ffffffffff600412
          sp 7fffa3d010f0 error 7
init[1] segfault at ffffffff80868b58 ip ffffffffff600412
        sp 7fff9e97f640 error 7
init[1] segfault at ffffffff80868b58 ip ffffffffff600412
        sp 7fff9e97eed0 error 7
Kernel panic - not syncing: Attemted to kill init!
Pid 1, comm: init Not tainted 2.6.26-rc5-mm1 #1

m.kozlowski@tuxland.pl wrote:
> After a few hours and tons of reboots I narrowed it down to
> arch/x86/kernel/Makefile:
>
> a) works
>	obj-y                   += tsc_$(BITS).o io_delay.o rtc.o
> 	GCOV_tsc_$(BITS).o      := n
> 	#GCOV_io_delay.o        := n
> 	#GCOV_rtc.o     := n
>
> b) doesn't work
> 	obj-y                   += tsc_$(BITS).o io_delay.o rtc.o
> 	#GCOV_tsc_$(BITS).o     := n
> 	#GCOV_io_delay.o        := n
>	#GCOV_rtc.o     := n
>
> and that points to arch/x86/kernel/tsc_64.c

Reported-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
Reported-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Peter Oberparleiter <peter.oberparleiter@de.ibm.com>

---
 arch/x86/kernel/Makefile |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6.26-rc5-mm3/arch/x86/kernel/Makefile
===================================================================
--- linux-2.6.26-rc5-mm3.orig/arch/x86/kernel/Makefile
+++ linux-2.6.26-rc5-mm3/arch/x86/kernel/Makefile
@@ -13,6 +13,9 @@ CFLAGS_REMOVE_tsc_32.o = -pg
 CFLAGS_REMOVE_rtc.o = -pg
 endif
 
+GCOV_tsc_32.o := n
+GCOV_tsc_64.o := n
+
 #
 # vsyscalls (which work on the user stack) should have
 # no stack-protector checks:
