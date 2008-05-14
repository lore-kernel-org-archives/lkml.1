Return-Path: <linux-kernel-owner+w=401wt.eu-S1756848AbYENPO1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848AbYENPO1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 11:14:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753807AbYENPOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 11:14:18 -0400
Received: from mu-out-0910.google.com ([209.85.134.191]:28422 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990AbYENPOR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 11:14:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=lG6kDpycoWBRh+Zdp9hkvNwfm0rCx4q7SFv1iSqPrpyTBjC5cZh4neLjyLK/VlHwh2//HVf+1EeZqlxTVeMFl0y6dEk3pK2hCNhEHILgRgBOFW0KbGms/DN7x1QXnHwiVesEQUBWA7nxc7r8GrAcav7GzXcMyRjic9/yyJFcokM=
Date: Wed, 14 May 2008 19:14:07 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Andreas Schwab <schwab@suse.de>
Cc: Adrian Bunk <bunk@kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: m68k: main.c:(.init.text+0x730): undefined reference to
	`strlen'
Message-ID: <20080514151407.GD6902@cvg>
References: <Pine.LNX.4.64.0805140958400.5778@anakin> <jeprrpth5m.fsf@sykes.suse.de> <20080514141056.GB19909@cs181133002.pp.htv.fi> <jeabitt0xj.fsf@sykes.suse.de> <20080514144031.GA6902@cvg> <je63thszo6.fsf@sykes.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <je63thszo6.fsf@sykes.suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Andreas Schwab - Wed, May 14, 2008 at 04:55:37PM +0200]
| Cyrill Gorcunov <gorcunov@gmail.com> writes:
| 
| > I think it would help to see ..tmp_vmlinux1.cmd to ensure for inclusion
| > of lib/lib.a. strlen was there without my patch as Andreas already pointed,
| > I've just added strncat wich is coming from lib/string.o for this arch.
| 
| Actually the way strncat is used here is broken anyway, it does not
| prevent array overrun.  The third argument of strncat only limits the
| amount of characters copied, without taking into account the length of
| the string already in the buffer.  Consequently gcc has optimized the
| call to strncat into a simple call to strcat, since none of the copied
| strings are longer than sizeof(msgbuf).  This strcat call is then
| expanded to include a call to strlen.
| 
| So a better fix would probably be to make msgbuf big enough and use
| strcat instead.
| 
| Andreas.
| 
| 

Andreas, could you test/review the following patch
(what is worse - I *have* introduced buffer overflow with my
patch, so I think we should fix it asap)
---

Index: linux-2.6.git/init/main.c
===================================================================
--- linux-2.6.git.orig/init/main.c	2008-05-14 17:55:10.000000000 +0400
+++ linux-2.6.git/init/main.c	2008-05-14 19:11:18.000000000 +0400
@@ -702,7 +702,7 @@ static void __init do_initcalls(void)
 
 	for (call = __initcall_start; call < __initcall_end; call++) {
 		ktime_t t0, t1, delta;
-		char msgbuf[40];
+		char msgbuf[64];
 		int result;
 
 		if (initcall_debug) {
@@ -729,11 +729,11 @@ static void __init do_initcalls(void)
 			sprintf(msgbuf, "error code %d ", result);
 
 		if (preempt_count() != count) {
-			strncat(msgbuf, "preemption imbalance ", sizeof(msgbuf));
+			strcat(msgbuf, "preemption imbalance ");
 			preempt_count() = count;
 		}
 		if (irqs_disabled()) {
-			strncat(msgbuf, "disabled interrupts ", sizeof(msgbuf));
+			strcat(msgbuf, "disabled interrupts ");
 			local_irq_enable();
 		}
 		if (msgbuf[0]) {
