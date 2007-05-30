Return-Path: <linux-kernel-owner+w=401wt.eu-S1757886AbXE3TxJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886AbXE3TxJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 15:53:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbXE3Tw5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 15:52:57 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1451 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbXE3Tw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 15:52:56 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 30 May 2007 12:52:54 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Ingo Molnar <mingo@elte.hu>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Jeff Garzik <jeff@garzik.org>, Zach Brown <zach.brown@oracle.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>,
       Evgeniy Polyakov <johnpol@2ka.mipt.ru>,
       "David S. Miller" <davem@davemloft.net>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Syslets, Threadlets, generic AIO support, v6
In-Reply-To: <20070530160913.GA14261@elte.hu>
Message-ID: <Pine.LNX.4.64.0705301242320.6272@alien.or.mcafeemobile.com>
References: <20070529212718.GH7875@mami.zabbo.net> <465CA654.5000505@garzik.org>
 <20070530072055.GA3077@elte.hu> <465D43A0.8040307@garzik.org>
 <alpine.LFD.0.98.0705300820350.26602@woody.linux-foundation.org>
 <20070530160913.GA14261@elte.hu>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 May 2007, Ingo Molnar wrote:

> 
> * Linus Torvalds <torvalds@linux-foundation.org> wrote:
> 
> > > To echo Uli and paraphrase an ad, "it's the interface, silly."
> > 
> > THERE IS NO INTERFACE! You're just making that up, and glossing over 
> > the most important part of the whole thing!
> > 
> > If you could actually point to something specific that matches what 
> > everybody needs, and is architecture-neutral, it would be a different 
> > issue. As is, you're just saying "memory-mapped interfaces" without 
> > actually going into enough detail to show HOW MUCH IT SUCKS.
> > 
> > There really are very few programs that would use them. [...]
> 
> looking over the list of our new generic APIs (see further below) i 
> think there are three important things that are needed for an API to 
> become widely used:
> 
>  1) it should solve a real problem (ha ;-), it should be intuitive to 
>     humans and it should fit into existing things naturally.
> 
>  2) it should be ubiquitous. (if it's about IO it should cover block IO,
>     network IO, timers, signals and everything) Even if it might look
>     silly in some of the cases, having complete, utter, no compromises,
>     100% coverage for everything massively helps the uptake of an API, 
>     because it allows the user-space coder to pick just one paradigm 
>     that is closest to his application and stick to it and only to it.
> 
>  3) it should be end-to-end supported by glibc.
> 
> our failed API attempts so far were:
> 
>  - sendfile(). This API mainly failed on #2. It partly failed on #1 too.
>    (couldnt be used in certain types of scenarios so was unintuitive.)
>    splice() fixes this almost completely.
> 
>  - KAIO. It fails on #2 and #3.
> 
> our more successful new APIs:
> 
>  - futexes. After some hickups they form the base of all modern 
>    user-space locking.
> 
>  - splice. (a bit too early to tell but it's looking good so far. Would
>    be nice if someone did a brute-force memcpy() based vmsplice to user
>    memory, just to make usage fully symmetric.)
> 
> partially successful, not yet failed new APIs:
> 
>  - epoll. It currently fails at #2 (v2.6.22 mostly fills the gaps but
>    not completely). Despite the non-complete coverage of event domains a
>    good number of apps are using it, and in particular a couple really
>    'high end' apps with massive amounts of event sources - which apps 
>    would have no chance with poll, select or threads.
> 
>  - inotify. It's being used quite happily on the desktop, despite some
>    of its limitations. (Possibly integratable into epoll?)

I think, as Linus pointed out (as I did a few months ago), that there's 
confusion about the term "Unification" or "Single Interface".
Unification is not about fetching all the data coming from the more 
diverse sources, into a single interface. That is just broken, because 
each data source wants a different data structure to be reported. 
This is ABI-hell 101. Unification is the ability to uniformly wait for 
readiness, and then fetch data with source-dependent collectors (read(2), 
io_getvents(2), ...). That way you have ABI isolation on the single 
data source, and not monster structures trying to blob together the more 
diverse data formats.
AFAIK, inotify works with select/poll/epoll as is.



- Davide


