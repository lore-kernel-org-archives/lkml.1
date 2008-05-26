Return-Path: <linux-kernel-owner+w=401wt.eu-S1756143AbYEZWTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbYEZWTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 18:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754889AbYEZWTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 18:19:34 -0400
Received: from styx.suse.cz ([82.119.242.94]:53100 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754753AbYEZWTd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 18:19:33 -0400
Date: Tue, 27 May 2008 00:19:32 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Ingo Molnar <mingo@elte.hu>, Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: m68k libc5 regression
In-Reply-To: <Pine.LNX.4.64.0805262226280.11902@anakin>
Message-ID: <Pine.LNX.4.64.0805270014110.6718@jikos.suse.cz>
References: <Pine.LNX.4.64.0805262226280.11902@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 May 2008, Geert Uytterhoeven wrote:

> Recently I noticed a regression when running an old libc5 binary
> (amiga-lilo) on m68k. It fails with the error message:

Hmm, libc5 is known to make broken assumptions about brk location, that's 
why we introduced CONFIG_COMPAT_BRK, do you have that option turned on?

> So I bisected it to:
> commit 4cc6028d4040f95cdb590a87db478b42b8be0508
> Author: Jiri Kosina <jkosina@suse.cz>
> Date:   Wed Feb 6 22:39:44 2008 +0100
>     brk: check the lower bound properly

Indeed, this should take CONFIG_COMPAT_BRK into account. Does the patch 
below fix it? (assuming that you have CONFIG_COMPAT_BRK=y):



From: Jiri Kosina <jkosina@suse.cz>

brk: check lower bound properly

The check in sys_brk() on minimum value the brk might have must take 
CONFIG_COMPAT_BRK setting into account. When this option is turned on 
(i.e. we support ancient legacy binaries, e.g. libc5-linked stuff), the 
lower bound on brk value is mm->end_code, otherwise the brk start is 
allowed to be arbitrarily shifted.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/mm/mmap.c b/mm/mmap.c
index fac6633..834118b 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -245,10 +245,16 @@ asmlinkage unsigned long sys_brk(unsigned long brk)
 	unsigned long rlim, retval;
 	unsigned long newbrk, oldbrk;
 	struct mm_struct *mm = current->mm;
+	unsigned long min_brk;
 
 	down_write(&mm->mmap_sem);
 
-	if (brk < mm->start_brk)
+#ifdef CONFIG_COMPAT_BRK
+	min_brk = mm->end_code;
+#else
+	min_brk = mm->start_brk;
+#endif
+	if (brk < min_brk)
 		goto out;
 
 	/*
