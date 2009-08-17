Return-Path: <linux-kernel-owner+w=401wt.eu-S1757407AbZHQIXX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407AbZHQIXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 04:23:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757330AbZHQIXW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 04:23:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35470 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757223AbZHQIXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 04:23:21 -0400
Date: Mon, 17 Aug 2009 01:21:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Stefani Seibold <stefani@seibold.net>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
       Amerigo Wang <xiyou.wangcong@gmail.com>, Joe Perches <joe@perches.com>
Subject: Re: [PATCH 2/7] kfifo: move out spinlock
Message-Id: <20090817012150.9bb699ed.akpm@linux-foundation.org>
In-Reply-To: <20090817090829.689a604c@lxorguk.ukuu.org.uk>
References: <1250455161.28540.4.camel@wall-e>
	<1250455590.28540.10.camel@wall-e>
	<20090816235843.0f7f11de@lxorguk.ukuu.org.uk>
	<20090816163422.a147a918.akpm@linux-foundation.org>
	<20090817074820.3585206b@lxorguk.ukuu.org.uk>
	<20090817003617.2abe0a95.akpm@linux-foundation.org>
	<20090817090829.689a604c@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Aug 2009 09:08:29 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > > Those wrappers happen to be called kfifo_get and kfifo_put
> > 
> > Those names are wrong.
> 
> We've had them for years

So?  It's been wrong for years.  This is a chance to fix it.

> > They're wrong because they are the spinlock-specific variant.  What are
> > we going to call the mutex_lock-specific variant?
> 
> There isn't one.

Oh come on.

> > 
> > > > But the happens-to-use-spin_lock functions shouldn't be called
> > > > kfifo_get(), because that steals namespace from the unlocked functions,
> > > > and makes the naming for the happens-to-use-mutex_lock functions look
> > > > weird.
> > > 
> > > All over the kernel unlocked function versions have a leading _ name.
> > > It's the kernel convention.
> > 
> > tisn't.  radix-tree, rbrtee, idr, list_head, prio_tree, flex_array -
> > none of them use that convention.
> 
> Some random "10 second grep" examples, and this is also used more
> generally for the "without extra goo" variant of things
> 
> __set_special_pids
> __sysrq_put_key_op
> __sysrq_get_key_op
> __handle_sysrq
> __audit_getname
> __audit_inode
> __audit_node_child
> 
> and the without extra goo use includes such minor classics
> __get_user
> __put_user
> 
> the kernel contains lots and lots of
> 
> __foo()
> 
> foo()
> {
> 	spin_lock(bar);
> 	__foo()
> 	spin_unlock(bar)
> }

None of those functions are part of general container libraries.  All
the ones I mentioned _are_ part of general container libraries.

Plus, as I've said enty en times and keep getting ignored: the current
naming is wrong.  The generic kfifo_get() should not be assuming that
the caller wants spinlock-based locking.

> > > The other thing I must say I dislike about these patches is the
> > > gratuitious 'let's rename all the functions' approach it takes. The kfifo
> > > API is documented, used and random API of the year type changes mess
> > > stuff up and cause unneeded churn.
> > 
> > It fixes naming mistakes.  Long-term it is the correct thing to do. 
> > Best to do it now before we get more callers.
> 
> Why don't we fix all the really dumb naming mistakes then - things like
> the chrdev interfaces ? Massive churn, massive confusion. Patches are
> always being rejected (and rightfully so) for causing such messes.

These patches don't make a mess.  Stefani has already fixed all callers
in a small number of patches.

> And remember: its very hard to fix existing API documentation and books.
> It's doubly dangerous (and IMHO a complete no-no) to change the API of an
> interface if you don't change it such that old code will not reliably get
> a compile time failure.

The patchet will cause unmigrated code to fail to build, won't it?
