Return-Path: <linux-kernel-owner+w=401wt.eu-S1761246AbXJYOqo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761246AbXJYOqo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 10:46:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755385AbXJYOqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 10:46:37 -0400
Received: from styx.suse.cz ([82.119.242.94]:47222 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754336AbXJYOqg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 10:46:36 -0400
Date: Thu, 25 Oct 2007 16:46:26 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Sami Farin <safari-kernel@safari.iki.fi>,
       Linux kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86: randomize brk() and RLIMIT_DATA
In-Reply-To: <20071025071324.2eac21d6@laptopd505.fenrus.org>
Message-ID: <Pine.LNX.4.64.0710251644460.12935@jikos.suse.cz>
References: <20071025134124.wc44gdud7ixghfxv@m.safari.iki.fi>
 <20071025071324.2eac21d6@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Oct 2007, Arjan van de Ven wrote:

> > Would be neat if randomized brk and setrlimit(RLIMIT_DATA, ...)
> > worked in a predictable way:
> this isn't a valid case afaics; even on "traditional x86" (before we 
> changed the address space layout, or even today if you have an unlimited 
> stack rlimit) this isn't going to work. applications really shouldn't 
> use (s)brk() but malloc(); you have to be able to fall back to mmap 
> regardless of what you do.

I tend to agree here with Arjan. However it probably would make no harm to 
make at least a little bit consisten behavior of setrlimit(), though it 
has a little use in such cases.

Sami, does the patch below work for you?

diff --git a/mm/mmap.c b/mm/mmap.c
index facc1a7..c7ade18 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -251,7 +251,8 @@ asmlinkage unsigned long sys_brk(unsigned long brk)
 	 * not page aligned -Ram Gupta
 	 */
 	rlim = current->signal->rlim[RLIMIT_DATA].rlim_cur;
-	if (rlim < RLIM_INFINITY && brk - mm->start_data > rlim)
+	if (rlim < RLIM_INFINITY && brk - mm->start_data -
+			(mm->start_brk - mm->end_data) > rlim)
 		goto out;
 
 	newbrk = PAGE_ALIGN(brk);
