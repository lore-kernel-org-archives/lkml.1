Return-Path: <linux-kernel-owner+w=401wt.eu-S1758262AbXGDRbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758262AbXGDRbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 13:31:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754476AbXGDRbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 13:31:33 -0400
Received: from styx.suse.cz ([82.119.242.94]:49350 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751500AbXGDRbc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 13:31:32 -0400
Date: Wed, 4 Jul 2007 19:35:17 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jakub Jelinek <jakub@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kratochvil <honza@jikos.cz>,
       Ingo Molnar <mingo@elte.hu>, Rik van Riel <riel@redhat.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESEND] PIE randomization
In-Reply-To: <20070704082554.GQ7012@devserv.devel.redhat.com>
Message-ID: <Pine.LNX.4.64.0707041927090.11634@jikos.suse.cz>
References: <alpine.LRH.0.98.0705111338230.22353@twin.jikos.cz>
 <20070511125629.3df919cf.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705112211440.16923@twin.jikos.cz>
 <20070511133651.63f8a14d.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705120048230.11493@jikos.suse.cz>
 <Pine.LNX.4.64.0705161851120.25986@twin.jikos.cz>
 <alpine.LRH.0.98.0705172221440.22353@twin.jikos.cz>
 <20070522161642.b71ddacb.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0705231044540.22906@jikos.suse.cz> <20070704082554.GQ7012@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jul 2007, Jakub Jelinek wrote:

> The above highlighted changes are the cause of random segfaults of PIE 
> binaries.  See 
> https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=246623 

Thanks a lot for pointing this out. Andrew, could this be folded into 
pie-randomization.patch please?


From: Jiri Kosina <jkosina@suse.cz>

pie randomization: fix BAD_ADDR macro

pie-randomization.patch makes the load_addr in load_elf_interp() the load 
bias of ld.so (difference between the actual load base address and first 
PT_LOAD segment's p_vaddr). If the difference equals (on x86) to 
0xfffff000 (which is valid [1]), SIGSEGV is incorrectly sent.

This patch changes the BAD_ADDR so that it catches the mappings to the 
error-area properly.

[1] https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=246623

Reported-by: Jakub Jelinek <jakub@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index da270d1..466477d 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -80,7 +80,7 @@ static struct linux_binfmt elf_format = {
 		.hasvdso	= 1
 };
 
-#define BAD_ADDR(x) ((unsigned long)(x) >= PAGE_MASK)
+#define BAD_ADDR(x) IS_ERR_VALUE(x)
 
 static int set_brk(unsigned long start, unsigned long end)
 {
