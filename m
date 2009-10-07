Return-Path: <linux-kernel-owner+w=401wt.eu-S1754840AbZJGWAq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840AbZJGWAq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 18:00:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754711AbZJGWAp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 18:00:45 -0400
Received: from mail-bw0-f210.google.com ([209.85.218.210]:39009 "EHLO
	mail-bw0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754704AbZJGWAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 18:00:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=RYPOItueCxOXDJazTylK69KpcA9pdol2myJHm9aRy/oiq9IgByWKby2zpK9lC/HvuP
         kUCCgHfWapGh4bsYX3pMLgoKul2Cdu+U55dpGYdHxxirC0/y3HC66nzCYELRa0SAcbZb
         WjUrxj9AnhW2wEaQotMCGbxO+RZluQVm3GuKA=
MIME-Version: 1.0
In-Reply-To: <4ACC917D.3090302@directfb.org>
References: <4ACC917D.3090302@directfb.org>
Date: Wed, 7 Oct 2009 23:00:06 +0100
Message-ID: <9b2b86520910071500q3eb571efrc50ccdc54119ef58@mail.gmail.com>
Subject: Re: DirectFB "Fusion" module inclusion?
From: Alan Jenkins <sourcejedi.lkml@googlemail.com>
To: Niels Roest <niels@directfb.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/7/09, Niels Roest <niels@directfb.org> wrote:
> Hi all.
>
> This is to request some comments about our interest to have our "Fusion"
> kernel module included in the kernel.
> I hope you will let me now if it is feasible, desirable, etcetera.

Possibly not.

> What is Fusion? Fusion is the low-level layer of DirectFB
> (www.directfb.org). DirectFB is basically a graphics library that offers
> hardware acceleration and multi-process cooperation on top of e.g. the
> frame buffer device.
>
> What does Fusion offer? Fusion takes care of IPC by providing the
> following primitives: skirmishes (locks), calls (partially via a
> user-space library handling callback threads), properties and shared
> memory pools. The main two reasons for us to make a kernel module out of
> this is: crashing applications will not take down the "DirectFB" system,
> since resources are handled in the kernel; and debug
> information/deadlock status is shared via /proc/fusion.
>
> Fusion documentation (fusion.pdf) can be found at
> http://git.directfb.org/?p=core/linux-fusion.git;a=tree;f=doc;
> Fusion source files can be found at the same git location:
> http://git.directfb.org/?p=core/linux-fusion.git;a=tree
>
> Fusion is implemented as a device driver with an ioctl interface. In our
> case, Fusion is used together with libfusion.so (LGPL), which abstracts
> the kernel ioctls away, among other things. DirectFB resides on top of
> libfusion.so.
>
> We would probably rework Fusion significantly if needed - we want to
> have the benefit of having Fusion inside kernel mainline, and we hope
> that it is indeed interesting enough to consider, so let's hear it :)

I do have some suggestions.  These carry no weight or guarantee of
acceptance, they are simply my impressions as a slightly curious
bystander.

I believe the ioctls would have to be replaced with system calls.

The easy example is shared memory.  We already have mmap() to map it,
and ftruncate() to increase the size of the memory region; you just
need to provide a way to obtain a file descriptor.

Similarly we already have sockets.  We don't have RPCs per se; but it
seems to be covered by sending formatted "call" and "return" messages
over sockets.  It looks like unix domain sockets would work already.

Refs and reactors have no obvious parallels.  You get to defend the
utility of the system calls and possibly other ABIs you need in order
to implement them, or find less novel alternatives which can be made
to work.  It may be possible to implement refs in userspace using
shared memory and futexes.  If so, make sure you read the paper which
describes the pitfalls encountered when implementing pthread mutexes
using futexes :-).  Reactors are tricky; they might be accepted as a
new socket type, or perhaps implemented using new socket options.

Then you want to tie them all together with a common namespace.  This
is commonly known as a filesystem :-P.  Top level directory defines
the "world"; the second level directory gives you the "fusion ID".
Ideally you've avoided adding a new type of filesystem node so you can
use an arbitrary filesystem.  I believe tmpfs is already used as the
standard backing store for posix shared memory.

I guess you can block on world (directory) creation using inotify.

For debugging information you will probably have to create a new
filesystem.  You're not allowed to shove everything in procfs anymore
:-).

BTW, your /proc documentation includes "properties" but they don't
seem to be mentioned any where else.

Regards
Alan
