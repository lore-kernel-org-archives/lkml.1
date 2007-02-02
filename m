Return-Path: <linux-kernel-owner+w=401wt.eu-S1946041AbXBBUOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946041AbXBBUOn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 15:14:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946042AbXBBUOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 15:14:43 -0500
Received: from smtp.osdl.org ([65.172.181.24]:38329 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946041AbXBBUOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 15:14:42 -0500
Date: Fri, 2 Feb 2007 12:14:15 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Alan <alan@lxorguk.ukuu.org.uk>
cc: Ingo Molnar <mingo@elte.hu>, Zach Brown <zach.brown@oracle.com>,
       linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
In-Reply-To: <20070202195932.15b9b4ed@localhost.localdomain>
Message-ID: <Pine.LNX.4.64.0702021155460.15057@woody.linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
 <df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net> <20070201083611.GC18233@elte.hu>
 <Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org>
 <20070202104900.GA13941@elte.hu> <Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org>
 <20070202195932.15b9b4ed@localhost.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 2 Feb 2007, Alan wrote:
>
> This one got shelved while I sorted other things out as it warranted a
> longer look. Some comments follow, but firstly can we please bury this
> "fibril" name. The constructs Zach is using appear to be identical to
> co-routines, and they've been called that in computer science literature
> for fifty years. They are one of the great and somehow forgotten ideas.
> (and I admit I've used them extensively in past things where its
> wonderful for multi-player gaming so I'm a convert already).

Well, they are indeed coroutines, but they are coroutines in the same 
sense any "CPU scheduler" ends up being a coroutine.

They are NOT the generic co-routine that some languages support natively. 
So I think trying to call them coroutines would be even more misleading 
than calling them fibrils.

In other workds the whole *point* of the fibril is that you can do 
"coroutine-like stuff" while using a "normal functional linear programming 
paradign".

Wouldn't you agree?

(I love the concept of coroutines, but I absolutely detest what the code 
ends up looking like. There's a good reason why people program mostly in 
linear flow: that's how people think consciously - even if it's obviously 
not how the brain actually works).

And we *definitely* don't want to have a coroutine programming interface 
in the kernel. Not in C.

> The stuff however isn't as free as you make out. Current kernel logic
> knows about various things being "safe" but with fibrils you have to
> address additional questions such as "What happens if I issue an I/O and
> change priority". You also have an 800lb gorilla hiding behind a tree
> waiting for you in priviledge and permission checking.

This is why I think it should be 100% clear that things happen in process 
context. That just answers everything. If you want to synchronize with 
async events and change IO priority, you should do exactly that:

	wait_for_async();
	ioprio(newprority);

and that "solves" that problem. Leave it to user space.

> Right now current->*u/gid is safe across a syscall start to end, with an
> asynchronous setuid all hell breaks loose. I'm not saying we shouldn't do
> this, in fact we'd be able to do some of the utterly moronic poxix thread
> uid handling in kernel space if we did, just that it isn't free. We have
> locking rules defined by the magic serializing construct called
> "the syscall" and you break those.

I agree. As mentioned, we probably will have fallout. 

> The number of co-routines and stacks can be dealt with two ways - you use
> small stacks allocated when you create a fibril, or you grab a page, use
> separate IRQ stacks and either fail creation with -ENOBUFS etc which
> drops work on user space, or block (for which cases ??) which also means
> an overhead on co-routine exits. That can be tunable, for embedded easily
> tuned right down.

Right. It should be possible to just say "use a max parallelism factor of 
5", and if somebody submits a hundred AIO calls and they all block, when 
it hits #6, it will just do it synchronously.

Basically, what I'm hoping can come out of this (and this is a simplistic 
example, but perhaps exactly *because* of that it hopefully also shows 
that we canactually make *simple* interfaces for complex asynchronous 
things):

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

and it *should* allow us to do all the stat lookup asynchronously.

Done right, this should basically be no slower than doing it with a real 
stat() if everything was cached. That would kind of be the holy grail 
here.

> You get some other funny things from co-routines which are very powerful,
> very dangerous, or plain insane

You forgot "very hard to think about". 

We DO NOT want coroutines in general. It's clever, but it's
 (a) impossible to do without language support that C doesn't have, or 
     some really really horrid macro constructs that really only work for 
     very specific and simple cases.
 (b) very non-intuitive unless you've worked with coroutines a lot (and 
     almost nobody has)

> Linus will now tell me I'm out of my tree...

I don't think you're wrong in theory, I just thnk that in practice, 
withing the confines of (a) existing code, (b) existing languages, and (c) 
existing developers, we really REALLY don't want to expose coroutines as 
such.

But if you wanted to point out that what we want to do is get the 
ADVANTAGES of coroutines, without actually have to program them as such, 
then yes, I agree 100%. But we shouldn't call them coroutines, because the 
whole point is that as far as the user interface is concerned, they don't 
look like that. In the kernel, they just look like normal linear 
programming.

		Linus
