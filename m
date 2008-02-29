Return-Path: <linux-kernel-owner+w=401wt.eu-S933354AbYB2ROs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933354AbYB2ROs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 12:14:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751635AbYB2ROj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 12:14:39 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44583 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199AbYB2ROi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 12:14:38 -0500
Subject: Re: [RFC/PATCH] RLIMIT_ARG_MAX
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Michael Kerrisk <michael.kerrisk@googlemail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, aaw <aaw@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, michael.kerrisk@gmail.com,
       carlos@codesourcery.com, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>, drepper@redhat.com,
       mtk.manpages@gmail.com
In-Reply-To: <c49095e30802290858t42eb8a61ua0ed73e27971bc77@mail.gmail.com>
References: <1204119455.6242.403.camel@lappy>
	 <alpine.LFD.1.00.0802290801290.17889@woody.linux-foundation.org>
	 <c49095e30802290858t42eb8a61ua0ed73e27971bc77@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 29 Feb 2008 18:14:04 +0100
Message-Id: <1204305244.6243.111.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.90 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2008-02-29 at 17:58 +0100, Michael Kerrisk wrote:
> [Adding Ulrich D to the CC]
> 
> On Fri, Feb 29, 2008 at 5:05 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> >
> >  On Wed, 27 Feb 2008, Peter Zijlstra wrote:
> >  >
> >  > Currently these arrays are considered part of the stack, and
> >  > RLIMIT_STACK includes them. However POSIX does not specify it must be
> >  > so.
> >
> >  What's the real advantage of this? I'm not seeing it. Just an extra
> >  complexity "niceness" that nobody can rely on anyway since it's not even
> >  specified, and older kernels won't do it.
> 
> The advantages are the following:
> 
> 1. We don't break the ABI.  in 2.6.23, RLIMIT_STACK acquired an
> additional semantic: RLIMIT_STACK/4 specified the size for
> argv+environ.  aaw@google.com added this feature to allow processes to
> have much larger argument lists.  However, if the user sets
> RLIMIT_STACK to less than 512k, then the amount of space for
> argv+environ falls below the space guaranteed by kernel 2.6.22 and
> earlier.    (Older kernels guaranteed at least 128k for argv+environ.)
>  Manipulating RLIMIT_STACK did not previously have this effect.  (One
> place this matters is with NPTL, where, if RLIMIT_STACK is set to
> anything other than unlimited, then it is used as the default stack
> size when creating new threads.  When creating many threads, it may
> well be desirable to set RLIMIT_STACK to a value lower than 512k.)
> 
> While the new functionality provided by aaw@google.com's work is
> useful, RLIMIT_STACK really should not have been overloaded with a
> second meaning, since it is no longer possible to control stack size
> without also changing the limit on argv+environ space.    Hence the
> proposal of a new resource limit.
> 
> 2. It provides a sane mechanism for an application to determine the
> space available for argv+environ.  Formerly this space was an
> invariant, advertised via sysconf(_SC_ARG_MAX).
> 
> 3. The implementation details about stack size and size/location of
> argv+environ can be decoupled.

You fail to mention that <23 will still fault the first time it tries to
grow the stack when you set rlimit_stack to 128k and actually supply
128k of env+arg.



