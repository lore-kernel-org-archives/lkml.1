Return-Path: <linux-kernel-owner+w=401wt.eu-S1751110AbXBNUjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751110AbXBNUjk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 15:39:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932567AbXBNUjk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 15:39:40 -0500
Received: from smtp.osdl.org ([65.172.181.24]:44342 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110AbXBNUjj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 15:39:39 -0500
Date: Wed, 14 Feb 2007 12:38:16 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
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
In-Reply-To: <20070213142035.GF638@elte.hu>
Message-ID: <Pine.LNX.4.64.0702141223270.20368@woody.linux-foundation.org>
References: <20070213142035.GF638@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 13 Feb 2007, Ingo Molnar wrote:
> 
> the core syslet / async system calls infrastructure code.

Ok, having now looked at it more, I can say:

 - I hate it.

I dislike it intensely, because it's so _close_ to being usable. But the 
programming interface looks absolutely horrid for any "casual" use, and 
while the loops etc look like fun, I think they are likely to be less than 
useful in practice. Yeah, you can do the "setup and teardown" just once, 
but it ends up being "once per user", and it ends up being a lot of stuff 
to do for somebody who wants to just do some simple async stuff.

And the whole "lock things down in memory" approach is bad. It's doing 
expensive things like mlock(), making the overhead for _single_ system 
calls much more expensive. Since I don't actually believe that the 
non-single case is even all that interesting, I really don't like it.

I think it's clever and potentially useful to allow user mode to see the 
data structures (and even allow user mode to *modify* them) while the 
async thing is running, but it really seems to be a case of excessive 
cleverness.

For example, how would you use this to emulate the *current* aio_read() 
etc interfaces that don't have any user-level component except for the 
actual call? And if you can't do that, the whole exercise is pointless.

Or how would you do the trivial example loop that I explained was a good 
idea:

        struct one_entry *prev = NULL;
        struct dirent *de;

        while ((de = readdir(dir)) != NULL) {
                struct one_entry *entry = malloc(..);

                /* Add it to the list, fill in the name */
                entry->next = prev;
                prev = entry;
                strcpy(entry->name, de->d_name);

                /* Do the stat lookup async */
                async_stat(de->d_name, &entry->stat_buf);
        }
        wait_for_async();
        .. Ta-daa! All done ..


Notice? This also "chains system calls together", but it does it using a 
*much* more powerful entity called "user space". That's what user space 
is. And yeah, it's a pretty complex sequencer, but happily we have 
hardware support for accelerating it to the point that the kernel never 
even needs to care.

The above is a *realistic* schenario, where you actually have things like 
memory allocation etc going on. In contrast, just chaining system calls 
together isn't a realistic schenario at all.

So I think we have one _known_ usage schenario:

 - replacing the _existing_ aio_read() etc system calls (with not just 
   existing semantics, but actually binary-compatible)

 - simple code use where people are willing to perhaps do something 
   Linux-specific, but because it's so _simple_, they'll do it.

In neither case does the "chaining atoms together" seem to really solve 
the problem. It's clever, but it's not what people would actually do.

And yes, you can hide things like that behind an abstraction library, but 
once you start doing that, I've got three questions for you:

 - what's the point?
 - we're adding overhead, so how are we getting it back
 - how do we handle independent libraries each doing their own thing and 
   version skew between them?

In other words, the "let user space sort out the complexity" is not a good 
answer. It just means that the interface is badly designed.

			Linus
