Return-Path: <linux-kernel-owner+w=401wt.eu-S1758831AbZBDXtA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758831AbZBDXtA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 18:49:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755365AbZBDXss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 18:48:48 -0500
Received: from wa-out-1112.google.com ([209.85.146.176]:15643 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524AbZBDXsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 18:48:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=kzsJwBdndS7415GqdS39NdANxgSnF2DCAaPe9db8FKNAd737A5U+aQ6nm0P6uBIT3H
         LvnXNXm2JqI5bFe7SNyBTX7lZCfek43dUU5NgFFDTjTNx0MgDDnA0DVsVCtSoOm5IuE7
         h2pR/6zPEWgxzoimBfX+TkxGITCaAwJrb20Jk=
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <alpine.DEB.1.10.0902041526590.6214@alien.or.mcafeemobile.com>
References: <alpine.DEB.1.10.0902041349180.6214@alien.or.mcafeemobile.com>
	 <20090204150507.665b5b7c.akpm@linux-foundation.org>
	 <alpine.DEB.1.10.0902041509060.6214@alien.or.mcafeemobile.com>
	 <20090204152434.c8f65d52.akpm@linux-foundation.org>
	 <alpine.DEB.1.10.0902041526590.6214@alien.or.mcafeemobile.com>
Date: Thu, 5 Feb 2009 12:48:45 +1300
Message-ID: <cfd18e0f0902041548q3c392cb0wb642cb00bc58c1b3@mail.gmail.com>
Subject: Re: [patch/rfc] eventfd semaphore-like behavior
From: Michael Kerrisk <mtk.manpages@googlemail.com>
To: Davide Libenzi <davidel@xmailserver.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-api@vger.kernel.org, Ulrich Drepper <drepper@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 5, 2009 at 12:27 PM, Davide Libenzi <davidel@xmailserver.org> wrote:
> On Wed, 4 Feb 2009, Andrew Morton wrote:
>
>> On Wed, 4 Feb 2009 15:18:43 -0800 (PST)
>> Davide Libenzi <davidel@xmailserver.org> wrote:
>>
>> > > > Simple test here:
>> > > >
>> > > > http://www.xmailserver.org/eventfd-sem.c
>> > > >
>> > > >
>> > > > Signed-off-by: Davide Libenzi <davidel@xmailserver.org>
>> > > >
>> > > > +/*
>> > > > + * CAREFUL: Check include/asm-generic/fcntl.h when defining
>> > > > + * new flags, since they might collide with O_* ones. We want
>> > > > + * to re-use O_* flags that couldn't possibly have a meaning
>> > > > + * from eventfd, in order to leave a free define-space for
>> > > > + * shared O_* flags.
>> > > > + */
>> > > > +#define EFD_SEMAPHORE (1 << 0)
>> > > >  #define EFD_CLOEXEC O_CLOEXEC
>> > > >  #define EFD_NONBLOCK O_NONBLOCK
>> > > >
>> > > > +#define EFD_SHARED_FCNTL_FLAGS (O_CLOEXEC | O_NONBLOCK)
>> > > > +#define EFD_FLAGS_SET (EFD_SHARED_FCNTL_FLAGS | EFD_SEMAPHORE)
>> > >
>> > > How would you recommend that userspace determine whether its kernel
>> > > supports this feature, bearing in mind that someone might backport this
>> > > patch into arbitrarily earlier kernel versions?
>> > >
>> > > What should be userspace's fallback strategy if that support is not
>> > > present?
>> >
>> > #ifdef EFD_SEMAPHORE, maybe?
>>
>> That's compile-time.  People who ship binaries will probably want
>> to find a runtime thing for back-compatibility.
>
> I dunno. How do they actually do when we add new flags, like the O_ ones?

Maybe I missed something, but I think we're okay, aren't we?  Viz:

a) The glibc eventfd() wrapper invokes sys_eventfd2() (which allows a
flags arg) if it is available, and otherwise fall back to
sys_eventfd() (which does not support a flags arg).

b) If glibc falls back to sys_eventfd(), then it knows to reject
non-zero flags.  (The glibc wrapper already does this.)

c) If the old sys_eventfd2() is given a flag that it doesn't
recognize, then it fails with EINVAL.  (That check is already in the
code.)

So, userspace can determine whether EFD_SEMAPHORE is supported by not
getting an EINVAL error.  (Okay, this falls down for binaries that
bypass glibc's eventfd() wrapper, but there are unlikely to be such
binaries.)

Cheers,

Michael
-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
git://git.kernel.org/pub/scm/docs/man-pages/man-pages.git
man-pages online: http://www.kernel.org/doc/man-pages/online_pages.html
Found a bug? http://www.kernel.org/doc/man-pages/reporting_bugs.html
