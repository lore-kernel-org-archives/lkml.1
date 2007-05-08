Return-Path: <linux-kernel-owner+w=401wt.eu-S969057AbXEHXBy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S969057AbXEHXBy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 19:01:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S969070AbXEHXBj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 19:01:39 -0400
Received: from one.firstfloor.org ([213.235.205.2]:53693 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S969064AbXEHXBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 19:01:37 -0400
Date: Wed, 9 May 2007 01:01:34 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ken Moffat <zarniwhoop@ntlworld.com>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       Vivek Goyal <vgoyal@in.ibm.com>, Andi Kleen <ak@suse.de>
Subject: Re: Lockup after logging out of X
Message-ID: <20070508230134.GD17482@one.firstfloor.org>
References: <20070508195142.GA30030@deepthought>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070508195142.GA30030@deepthought>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 08, 2007 at 08:51:42PM +0100, Ken Moffat wrote:
>  This is a resend, with a better title and slightly more
> clarification.  Originally sent yesterday evening, but I can see no
> evidence that it got beyond my isp's mailserver.  Apologies to the
> Cc's if you did get the original.
> 
>  Using Linus' tree pulled on Sunday afternoon UK time.  Running an
> amd64 ('pure64') desktop using gdm for graphical login, on Xorg 7.2
> with a radeon 9200se.  No problems until I log out of the desktop
> and go back to gdm.  Before that, the text consoles seem to be
> working fine.  After I go back to gdm. the display is corrupted and
> only MagicSysRQ works.  Mostly, the keyboard LEDs flash, but the
> only thing that made it to the logs was this exceedingly incomplete
> oops report:
> 
> May  7 21:02:54 bluesbreaker kernel: [   46.549615] [drm] writeback
> test succeeded in 1 usecs
> May  7 21:03:24 bluesbreaker kernel: [   61.552793] Unable to handle
> kernel paging request at ffff81003befd3e8 RIP:
> May  7 21:03:24 bluesbreaker kernel: [   61.552798]
> [<ffffffff80271576>] fasync_helper+0x52/0xf0
> May  7 21:03:24 bluesbreaker kernel: [   61.552805] PGD 8063 PUD
> 9063 PMD 800000003bef11e3 BAD
> May  7 21:03:24 bluesbreaker kernel: [   61.552811] Oops: 0009 [1]
> PREEMPT
> May  7 21:04:18 bluesbreaker syslogd 1.4.1: restart.
> 
>  After trying git-bisect, it tells me:
> 0dbf7028c0c1f266c9631139450a1502d3cd457e is first bad commit
> commit 0dbf7028c0c1f266c9631139450a1502d3cd457e

Already known, although it is still unclear what the bug actually is.
Can you run with the appended patch please (from Eric Biederman) 
and post any backtraces the WARN_ON in there spews out? 

Also do you use swiotlb?

Thanks

-Andi

diff --git a/include/asm-x86_64/page.h b/include/asm-x86_64/page.h
index b17fc16..e6a4d1e 100644
--- a/include/asm-x86_64/page.h
+++ b/include/asm-x86_64/page.h
@@ -105,7 +105,18 @@ extern unsigned long phys_base;
 
 /* Note: __pa(&symbol_visible_to_c) should be always replaced with __pa_symbol.
    Otherwise you risk miscompilation. */
-#define __pa(x)			((unsigned long)(x) - PAGE_OFFSET)
+#define __pa(x)	\
+({									\
+	unsigned long v;						\
+	asm("" : "=r" (v) : "0" ((unsigned long)(x)));			\
+	WARN_ON(v >= __START_KERNEL_map);					\
+	if (likely(v < __START_KERNEL_map))				\
+		v -= PAGE_OFFSET;					\
+	else								\
+		v = (v - __START_KERNEL_map) + phys_base;		\
+	v; 								\
+}) 
+
 /* __pa_symbol should be used for C visible symbols.
    This seems to be the official gcc blessed way to do such arithmetic. */ 
 #define __pa_symbol(x)		\


