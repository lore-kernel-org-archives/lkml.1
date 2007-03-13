Return-Path: <linux-kernel-owner+w=401wt.eu-S1030772AbXCMQYZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030772AbXCMQYZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 12:24:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030767AbXCMQYY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 12:24:24 -0400
Received: from wr-out-0506.google.com ([64.233.184.228]:30104 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030765AbXCMQYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 12:24:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=PMyBoAgxBj4xaM5emKjs/HA3xdTIYn/WE3RhWqTmC3QP5gw49zVD1Efbbb+yRYBPKz0hnXzBgHdikhJyMSoglLI31eUhBNMpri6LxNY+KvfCFbcjZaxdiLEkSUEvWu6sMpd9mmBu9UvPv+SEkctmK954KXkAsyXUh6H1BmJsVZc=
Message-ID: <f2b55d220703130924h11786d9fh1d87f90bcd1b3d60@mail.gmail.com>
Date: Tue, 13 Mar 2007 09:24:22 -0700
From: "Michael K. Edwards" <medwards.linux@gmail.com>
To: "David Miller" <davem@davemloft.net>
Subject: Re: sys_write() racy for multi-threaded append?
Cc: alan@lxorguk.ukuu.org.uk, 7eggert@gmx.de, dada1@cosmosbay.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070313.004224.41634994.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f2b55d220703121746k1a849b78rec3131cb6f5eae38@mail.gmail.com>
	 <20070313022430.57503b08@lxorguk.ukuu.org.uk>
	 <f2b55d220703130025l48ea2e8ci15ddf0563cf21bf9@mail.gmail.com>
	 <20070313.004224.41634994.davem@davemloft.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/13/07, David Miller <davem@davemloft.net> wrote:
> You're not even safe over standard output, simply run the program over
> ssh and you suddenly have socket semantics to deal with.

I'm intimately familiar with this one.  Easily worked around by piping
the output through cat or tee.  Not that one should ever write code
for a *nix box that can't cope with stdout being a socket or tty; but
sometimes the quickest way to glue existing code into a pipeline is to
pass /dev/stdout in place of a filename, and there's no real value in
reworking legacy code to handle short writes when you can just drop in
cat.

> In short, if you don't handle short writes, you're writing a program
> for something other than unix.

Right in one.  You're writing a program for a controlled environment,
whether it's a Linux-only API (netlink sockets) or a Linux-only
embedded product.  And there's no need for that controlled environment
to gratuitously reproduce the overly vague semantics of the *nix zoo.

> We're not changing write() to interlock with other parallel callers or
> messing with the f_pos semantics in such cases, that's stupid, please
> cope, kthx.

This is not what I am proposing, and certainly not what I'm
implementing.  Right now f_pos handling is gratuitously thread-unsafe
even in the common, all writes completed normally case.  writev()
opens the largest possible window to f_pos corruption by delaying the
f_pos update until after the vfs_writev() completes.  That's the main
thing I want to see fixed.

_If_ it proves practical to wrap accessor functions around f_pos
accesses, and _if_ accesses to f_pos from outside read_write.c can be
made robust against transient overshoot, then there is no harm in
tightening up f_pos semantics so that successful pipelined writes to
the same file don't collide so easily.  If read-modify-write on f_pos
were atomic, it would be easy to guarantee that it is in a sane state
any time a syscall is not actually outstanding on that struct file.
There's even a potential performance gain from streamlining the
pattern of L1 cache usage in the common case, although I expect it's
negligible.

Making read-modify-write atomic on f_pos is of course not free on all
platforms.  But once you have the accessors, you can decide at kernel
compile time whether or not to interlock them with spinlocks and
memory barriers or some such.  Most platforms probably needn't bother;
there are much bigger time bombs lurking elsewhere in the kernel.  x86
is a bit dicey, because there's no way to atomically update a 64-bit
loff_t in memory, and so in principle you could get a race on carry
across the 32-bit boundary.  (This file instantaneously jumped from
4GB to 8GB in size?  What the hell?  How long would it take you to
spot a preemption between writing out the upper and lower halves of a
64-bit integer?)

In any case, I have certainly gotten the -ENOPATCH message by now.  It
must be nice not to have to care whether things work in the field if
you can point at something stupid that an application programmer did.
I don't always have that luxury.

Cheers,
- Michael
