Return-Path: <linux-kernel-owner+w=401wt.eu-S964804AbXBNWOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964804AbXBNWOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 17:14:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964805AbXBNWOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 17:14:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33868 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964804AbXBNWON (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 17:14:13 -0500
Date: Wed, 14 Feb 2007 23:09:48 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 05/11] syslets: core code
Message-ID: <20070214220948.GA3790@elte.hu>
References: <20070213142035.GF638@elte.hu> <Pine.LNX.4.64.0702141223270.20368@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702141223270.20368@woody.linux-foundation.org>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.3
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.3 required=5.9 tests=ALL_TRUSTED,BAYES_40 autolearn=no SpamAssassin version=3.1.7
	-1.8 ALL_TRUSTED            Passed through trusted hosts only via SMTP
	0.5 BAYES_40               BODY: Bayesian spam probability is 20 to 40%
	[score: 0.3147]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Or how would you do the trivial example loop that I explained was a 
> good idea:
> 
>         struct one_entry *prev = NULL;
>         struct dirent *de;
> 
>         while ((de = readdir(dir)) != NULL) {
>                 struct one_entry *entry = malloc(..);
> 
>                 /* Add it to the list, fill in the name */
>                 entry->next = prev;
>                 prev = entry;
>                 strcpy(entry->name, de->d_name);
> 
>                 /* Do the stat lookup async */
>                 async_stat(de->d_name, &entry->stat_buf);
>         }
>         wait_for_async();
>         .. Ta-daa! All done ..

i think you are banging on open doors. That async_stat() call is very 
much what i'd like to see glibc to provide, not really the raw syslet 
interface. Nor do i want to see raw syscalls exposed to applications. 
Plus the single-atom thing is what i think will be used mostly 
initially, so all my optimizations went into that case.

while i agree with you that state machines are hard, it's all a function 
of where the concentration of processing is. If most of the application 
complexity happens in user-space, then the logic should live there. But 
for infrastructure things (like the async_stat() calls, or aio_read(), 
or other, future interfaces) i wouldnt mind at all if they were 
implemented using syslets. Likewise, if someone wants to implement the 
hottest accept loop in Apache or Samba via syslets, keeping them from 
wasting time on writing in-kernel webservers (oops, did i really say 
that?), it can be done. If a JVM wants to use syslets, sure - it's an 
abstraction machine anyway so application programmers are not exposed to 
it.

syslets are just a realization that /if/ the thing we want to do is 
mostly on the kernel side, then we might as well put the logic to the 
kernel side. It's more of a 'compound interface builder' than the place 
for real program logic. It makes our interfaces usable more flexibly, 
and it allows the kernel to provide 'atomic' APIs, instead of having to 
provide the most common compounded uses as well.

and note that if you actually try to do an async_stat() sanely, you do 
get quite close to the point of having syslets. You get basically up to 
a one-shot atom concept and 90% of what i have in kernel/async.c. The 
remaining 10% of further execution control is easy and still it opens up 
these new things that were not possible before: compounding, vectoring, 
simple program logic, etc.

The 'cost' of syslets is mostly the atom->next pointer in essence. The 
whole async infrastructure only takes up 20 nsecs more in the cached 
case. (but with some crazier hacks i got the one-shot atom overhead 
[compared to a simple synchronous null syscall] to below 10 nsecs, so 
there's room in there for further optimizations. Our current null 
syscall latency is around ~150 nsecs.)

	Ingo
