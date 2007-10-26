Return-Path: <linux-kernel-owner+w=401wt.eu-S1756153AbXJZMQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbXJZMQz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2007 08:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751244AbXJZMQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Oct 2007 08:16:47 -0400
Received: from twin.jikos.cz ([213.151.79.26]:33476 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbXJZMQr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2007 08:16:47 -0400
Date: Fri, 26 Oct 2007 14:16:21 +0200 (CEST)
From: Jiri Kosina <jikos@jikos.cz>
To: Hugh Dickins <hugh@veritas.com>, Andrew Morton <akpm@linux-foundation.org>
cc: Sami Farin <safari-kernel@safari.iki.fi>,
       Linux kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jiri Kosina <jkosina@suse.cz>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH] [RFC] brk randomization: compute RLIMIT_DATA properly
 (was Re: x86: randomize brk() and RLIMIT_DATA)
In-Reply-To: <Pine.LNX.4.64.0710261247520.24322@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0710261414030.18815@twin.jikos.cz>
References: <20071025134124.wc44gdud7ixghfxv@m.safari.iki.fi>
 <20071025071324.2eac21d6@laptopd505.fenrus.org> <Pine.LNX.4.64.0710251644460.12935@jikos.suse.cz>
 <20071025171942.pjff7jbpempfcuri@m.safari.iki.fi>
 <Pine.LNX.4.64.0710261235270.18815@twin.jikos.cz>
 <Pine.LNX.4.64.0710261247520.24322@blonde.wat.veritas.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Oct 2007, Hugh Dickins wrote:

> > -	if (rlim < RLIM_INFINITY && brk - mm->start_data > rlim)
> > +	if (rlim < RLIM_INFINITY && brk - mm->start_data -
> > +			(mm->start_brk - mm->end_data) > rlim)
> I find the order in that test mysterious.

I agree that the order you proposed is easier to understand on the first 
sight.


From: Jiri Kosina <jkosina@suse.cz>

brk randomization: compute RLIMIT_DATA properly

In cases of heap area placed at randomly-generated offset from
mm->end_data (arch_randomize_brk()), we need to subtract the value of the
offset for setrlimit(RLIMIT_DATA) to work properly -- otherwise we count
the unoccupied memory between mm->end_data and mm->start_brk as occupied.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>

diff --git a/mm/mmap.c b/mm/mmap.c
index facc1a7..673ac7d 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -251,7 +251,8 @@ asmlinkage unsigned long sys_brk(unsigned long brk)
 	 * not page aligned -Ram Gupta
 	 */
 	rlim = current->signal->rlim[RLIMIT_DATA].rlim_cur;
-	if (rlim < RLIM_INFINITY && brk - mm->start_data > rlim)
+	if (rlim < RLIM_INFINITY && (brk - mm->start_brk) +
+			(mm->end_data - mm->start_data) > rlim)
 		goto out;
 
 	newbrk = PAGE_ALIGN(brk);
