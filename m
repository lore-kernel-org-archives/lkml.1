Return-Path: <linux-kernel-owner+w=401wt.eu-S1946081AbXBBVSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946081AbXBBVSS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 16:18:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946088AbXBBVSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 16:18:18 -0500
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:55408 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1946081AbXBBVSS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 16:18:18 -0500
Date: Fri, 2 Feb 2007 21:30:19 +0000
From: Alan <alan@lxorguk.ukuu.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, Zach Brown <zach.brown@oracle.com>,
       linux-kernel@vger.kernel.org, linux-aio@kvack.org,
       Suparna Bhattacharya <suparna@in.ibm.com>,
       Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 2 of 4] Introduce i386 fibril scheduling
Message-ID: <20070202213019.202e8db5@localhost.localdomain>
In-Reply-To: <Pine.LNX.4.64.0702021155460.15057@woody.linux-foundation.org>
References: <patchbomb.1170193181@tetsuo.zabbo.net>
	<df7bc026d50ec5bbdd8e.1170193183@tetsuo.zabbo.net>
	<20070201083611.GC18233@elte.hu>
	<Pine.LNX.4.64.0702011154110.3632@woody.linux-foundation.org>
	<20070202104900.GA13941@elte.hu>
	<Pine.LNX.4.64.0702020738500.15057@woody.linux-foundation.org>
	<20070202195932.15b9b4ed@localhost.localdomain>
	<Pine.LNX.4.64.0702021155460.15057@woody.linux-foundation.org>
X-Mailer: Claws Mail 2.7.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> They are NOT the generic co-routine that some languages support natively. 
> So I think trying to call them coroutines would be even more misleading 
> than calling them fibrils.

Its actually pretty damned close the Honeywell B co-routine package, with
a kernel twist to be honest.

> ends up looking like. There's a good reason why people program mostly in 
> linear flow: that's how people think consciously - even if it's obviously 
> not how the brain actually works).

The IRQ example below is an example of how it linearizes - so it cuts
both ways like most tools, admittedly one of the blades is at the handle
end in this case ...

> Basically, what I'm hoping can come out of this (and this is a simplistic 
> example, but perhaps exactly *because* of that it hopefully also shows 
> that we canactually make *simple* interfaces for complex asynchronous 
> things):
> 
> 	struct one_entry *prev = NULL;
> 	struct dirent *de;
> 
> 	while ((de = readdir(dir)) != NULL) {
> 		struct one_entry *entry = malloc(..);
> 
> 		/* Add it to the list, fill in the name */
> 		entry->next = prev;
> 		prev = entry;
> 		strcpy(entry->name, de->d_name);
> 
> 		/* Do the stat lookup async */
> 		async_stat(de->d_name, &entry->stat_buf);
> 	}
> 	wait_for_async();

The brown and sticky will hit the rotating air impeller pretty hard if you
are not very careful about how that ends up scheduled. Its one thing to
exploit the ability to pull all the easy lookups out in advance, and
another having created all the parallelism to turn into into sane disk
scheduling and wakeups without scaling hit. But you do at least have the
opportunity to exploit it I guess.

> > You get some other funny things from co-routines which are very powerful,
> > very dangerous, or plain insane
> 
> You forgot "very hard to think about". 

I'm not sure handing a fibril off to another task is that hard to think
about. It's not easy to turn it around as an async_exit() keeping the
other fibrils around because of the mass of rules and behaviours tied to
process exit but its perhaps not impossible.

Other minor evil. If we use fibrils we need to be careful we
know in advance how many fibrils an operation needs so we don't deadlock
on them in critical places like writeout paths when we either hit the per
task limit or we have no page for another stack.

Alan
