Return-Path: <linux-kernel-owner+w=401wt.eu-S932960AbYB2Q71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932960AbYB2Q71 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 11:59:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760757AbYB2Q64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 11:58:56 -0500
Received: from wr-out-0506.google.com ([64.233.184.234]:59961 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933623AbYB2Q6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 11:58:55 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=gUDJP8YmIufvPiTKfpU0WeOYQ30nFuCnfM9HQ5Rc4+h4CPf0dCxYonSmT9Gquf0dazRLZdLq+t20VO0W+2J5heLTuvnhlyglGc5zQdQi2kVgeDV91xy0G0VyD/IQ3AmOziCo4z4iJc0LgxexoKpdNnaHYL6DKqwKtW4F1y7JdHM=
Message-ID: <c49095e30802290858t42eb8a61ua0ed73e27971bc77@mail.gmail.com>
Date: Fri, 29 Feb 2008 17:58:52 +0100
From: "Michael Kerrisk" <michael.kerrisk@googlemail.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [RFC/PATCH] RLIMIT_ARG_MAX
Cc: "Peter Zijlstra" <a.p.zijlstra@chello.nl>, aaw <aaw@google.com>,
       "Andrew Morton" <akpm@linux-foundation.org>, michael.kerrisk@gmail.com,
       carlos@codesourcery.com, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>, drepper@redhat.com,
       mtk.manpages@gmail.com
In-Reply-To: <alpine.LFD.1.00.0802290801290.17889@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1204119455.6242.403.camel@lappy>
	 <alpine.LFD.1.00.0802290801290.17889@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Adding Ulrich D to the CC]

On Fri, Feb 29, 2008 at 5:05 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
>  On Wed, 27 Feb 2008, Peter Zijlstra wrote:
>  >
>  > Currently these arrays are considered part of the stack, and
>  > RLIMIT_STACK includes them. However POSIX does not specify it must be
>  > so.
>
>  What's the real advantage of this? I'm not seeing it. Just an extra
>  complexity "niceness" that nobody can rely on anyway since it's not even
>  specified, and older kernels won't do it.

The advantages are the following:

1. We don't break the ABI.  in 2.6.23, RLIMIT_STACK acquired an
additional semantic: RLIMIT_STACK/4 specified the size for
argv+environ.  aaw@google.com added this feature to allow processes to
have much larger argument lists.  However, if the user sets
RLIMIT_STACK to less than 512k, then the amount of space for
argv+environ falls below the space guaranteed by kernel 2.6.22 and
earlier.    (Older kernels guaranteed at least 128k for argv+environ.)
 Manipulating RLIMIT_STACK did not previously have this effect.  (One
place this matters is with NPTL, where, if RLIMIT_STACK is set to
anything other than unlimited, then it is used as the default stack
size when creating new threads.  When creating many threads, it may
well be desirable to set RLIMIT_STACK to a value lower than 512k.)

While the new functionality provided by aaw@google.com's work is
useful, RLIMIT_STACK really should not have been overloaded with a
second meaning, since it is no longer possible to control stack size
without also changing the limit on argv+environ space.    Hence the
proposal of a new resource limit.

2. It provides a sane mechanism for an application to determine the
space available for argv+environ.  Formerly this space was an
invariant, advertised via sysconf(_SC_ARG_MAX).

3. The implementation details about stack size and size/location of
argv+environ can be decoupled.

Cheers,

Michael
