Return-Path: <linux-kernel-owner+w=401wt.eu-S1761481AbXEUKoc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761481AbXEUKoc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 06:44:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755966AbXEUKoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 06:44:23 -0400
Received: from as4.cineca.com ([130.186.84.213]:36858 "EHLO as4.cineca.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756673AbXEUKoV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 06:44:21 -0400
Message-ID: <465177E9.3060601@users.sourceforge.net>
From: Andrea Righi <righiandr@users.sourceforge.net>
Reply-To: righiandr@users.sourceforge.net
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.3) Gecko/20070326 Thunderbird/2.0.0.0 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bernd Eckenfels <ecki@lina.inka.de>, linux-kernel@vger.kernel.org,
       Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 1/2] limit print_fatal_signal() rate
References: <E1Hp5PV-0001Bn-00@calista.eckenfels.net>	<464ED258.2010903@users.sourceforge.net> <20070520203123.5cde3224.akpm@linux-foundation.org>
In-Reply-To: <20070520203123.5cde3224.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.0
OpenPGP: id=77CEF397;
	url=keyserver.veridis.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Mon, 21 May 2007 12:44:20 +0200 (MEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> Well OK.  But vdso-print-fatal-signals.patch is designated not-for-mainline
> anyway.
> 
> I think the DoS which you identify has been available for a very long time
> on ia64, x86_64 and perhaps others.
> 

For the mainline a fix could be the following...

---

Limit the rate of the kernel logging for the segfaults of user applications, to
avoid potential message floods or denial-of-service attacks.

Signed-off-by: Andrea Righi <a.righi@cineca.it>

diff -urpN linux-2.6.22-rc2/arch/avr32/mm/fault.c linux-2.6.22-rc2-limit-segfaults-printk-rate/arch/avr32/mm/fault.c
--- linux-2.6.22-rc2/arch/avr32/mm/fault.c	2007-05-19 13:11:30.000000000 +0200
+++ linux-2.6.22-rc2-limit-segfaults-printk-rate/arch/avr32/mm/fault.c	2007-05-21 11:48:37.000000000 +0200
@@ -158,7 +158,7 @@ bad_area:
 	up_read(&mm->mmap_sem);
 
 	if (user_mode(regs)) {
-		if (exception_trace)
+		if (exception_trace && printk_ratelimit())
 			printk("%s%s[%d]: segfault at %08lx pc %08lx "
 			       "sp %08lx ecr %lu\n",
 			       is_init(tsk) ? KERN_EMERG : KERN_INFO,
diff -urpN linux-2.6.22-rc2/arch/x86_64/mm/fault.c linux-2.6.22-rc2-limit-segfaults-printk-rate/arch/x86_64/mm/fault.c
--- linux-2.6.22-rc2/arch/x86_64/mm/fault.c	2007-05-21 11:42:07.000000000 +0200
+++ linux-2.6.22-rc2-limit-segfaults-printk-rate/arch/x86_64/mm/fault.c	2007-05-21 11:45:55.000000000 +0200
@@ -489,7 +489,8 @@ bad_area_nosemaphore:
 		    (address >> 32))
 			return;
 
-		if (exception_trace && unhandled_signal(tsk, SIGSEGV)) {
+		if (exception_trace && unhandled_signal(tsk, SIGSEGV) &&
+		    printk_ratelimit()) {
 			printk(
 		       "%s%s[%d]: segfault at %016lx rip %016lx rsp %016lx error %lx\n",
 					tsk->pid > 1 ? KERN_INFO : KERN_EMERG,
