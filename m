Return-Path: <linux-kernel-owner+w=401wt.eu-S932693AbXBONnH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693AbXBONnH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 08:43:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932759AbXBONnG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 08:43:06 -0500
Received: from relay.2ka.mipt.ru ([194.85.82.65]:39735 "EHLO 2ka.mipt.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932693AbXBONnF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 08:43:05 -0500
Date: Thu, 15 Feb 2007 16:35:50 +0300
From: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Christoph Hellwig <hch@infradead.org>, Andrew Morton <akpm@zip.com.au>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ulrich Drepper <drepper@redhat.com>, Zach Brown <zach.brown@oracle.com>,
       "David S. Miller" <davem@davemloft.net>,
       Benjamin LaHaise <bcrl@kvack.org>,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 05/11] syslets: core code
Message-ID: <20070215133550.GA29274@2ka.mipt.ru>
References: <20070213142035.GF638@elte.hu> <Pine.LNX.4.64.0702141223270.20368@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0702141223270.20368@woody.linux-foundation.org>
User-Agent: Mutt/1.5.9i
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.7.5 (2ka.mipt.ru [0.0.0.0]); Thu, 15 Feb 2007 16:36:07 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 14, 2007 at 12:38:16PM -0800, Linus Torvalds (torvalds@linux-foundation.org) wrote:
> Or how would you do the trivial example loop that I explained was a good 
> idea:
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
> 
> 
> Notice? This also "chains system calls together", but it does it using a 
> *much* more powerful entity called "user space". That's what user space 
> is. And yeah, it's a pretty complex sequencer, but happily we have 
> hardware support for accelerating it to the point that the kernel never 
> even needs to care.
> 
> The above is a *realistic* schenario, where you actually have things like 
> memory allocation etc going on. In contrast, just chaining system calls 
> together isn't a realistic schenario at all.

One can still perfectly fine and easily use sys_async_exec(...stat()...)
in above scenario. Although I do think that having a web server in
kernel is overkill, having a proper state machine for good async
processing is a must.
Not that I agree, that it should be done on top of syscalls as basic
elements, but it is an initial state.

> So I think we have one _known_ usage schenario:
> 
>  - replacing the _existing_ aio_read() etc system calls (with not just 
>    existing semantics, but actually binary-compatible)
> 
>  - simple code use where people are willing to perhaps do something 
>    Linux-specific, but because it's so _simple_, they'll do it.
> 
> In neither case does the "chaining atoms together" seem to really solve 
> the problem. It's clever, but it's not what people would actually do.

It is an example of what can be done. If one do not like it - do not use
it. State machine is implemented in sendfile() syscall - and although it
is not a good idea to have async sendfile as is in micro-thread design
(due to network blocking and small per-page reading), it is still a state 
machine, which can be used with syslet state machine (if it could be 
extended).

> And yes, you can hide things like that behind an abstraction library, but 
> once you start doing that, I've got three questions for you:
> 
>  - what's the point?
>  - we're adding overhead, so how are we getting it back
>  - how do we handle independent libraries each doing their own thing and 
>    version skew between them?
> 
> In other words, the "let user space sort out the complexity" is not a good 
> answer. It just means that the interface is badly designed.

Well, if we can setup iocb structure, why we can not setup syslet one?

Yes, with syscalls as a state machine elements 99% of users will not use
it (I can only think about proper fadvice()+read()/sendfile() states),
but there is no problem to setup a structure in userspace at all. And if
there is possibility to use it for other things, it is definitely a win.

Actually complex structure setup argument is stupid - everyone forces to 
have timeval structure instead of number of microseconds.

So there is no point in 'complex setup and overhead', but there is
a. limit of the AIO (although my point is not to have huge amount of
	working threads - they were created by people who can not
	program state machines (c) Alan Cox)
b. possibility to implement a state machine (in current form likely will
	not be used except maybe some optional hints for IO tasks like
	fadvice)
c. in all other ways it has all pros and cons of micro-thread design (it
	looks neat and simple, although is utterly broken in some usage
	cases).

> 			Linus

-- 
	Evgeniy Polyakov
