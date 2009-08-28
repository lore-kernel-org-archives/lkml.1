Return-Path: <linux-kernel-owner+w=401wt.eu-S1751835AbZH1Qok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751835AbZH1Qok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 12:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751569AbZH1Qoj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 12:44:39 -0400
Received: from mail2.shareable.org ([80.68.89.115]:42336 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbZH1Qoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 12:44:38 -0400
Date: Fri, 28 Aug 2009 17:44:32 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Ulrich Drepper <drepper@redhat.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: adding proper O_SYNC/O_DSYNC, was Re: O_DIRECT and barriers
Message-ID: <20090828164432.GA8036@shareable.org>
References: <20090821135403.GA6208@shareable.org> <20090821142635.GB30617@infradead.org> <20090821152459.GC6929@shareable.org> <20090821174525.GA28861@infradead.org> <20090822005006.GA22530@shareable.org> <20090824023422.GA775@infradead.org> <20090827143459.GB31453@shareable.org> <20090827171044.GA5427@infradead.org> <4A96C14C.8040105@redhat.com> <20090828154647.GA15808@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090828154647.GA15808@infradead.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Thu, Aug 27, 2009 at 10:24:28AM -0700, Ulrich Drepper wrote:
> > The problem with O_* extensions is that the syscall doesn't fail if the  
> > flag is not handled.  This is a problem in the open implementation which  
> > can only be fixed with a new syscall.
> >
> > Why cannot just go on and say we interpret O_SYNC like O_SYNC and  
> > O_SYNC|O_DSYNC like O_DSYNC.  The POSIX spec explicitly requires that  
> > the latter handled like O_SYNC.
> >
> > We could handle it by allocating two bits, only one is handled in the  
> > kernel.  If the O_DSYNC definition for userlevel would be different from  
> > the kernel definition then the kernel could interpret O_SYNC|O_DSYNC  
> > like O_DSYNC.  The libc would then have to translate the userlevel  
> > O_DSYNC into the kernel O_DSYNC.  If the libc is too old for the kernel  
> > and the application, the userlevel flag would be passed to the kernel  
> > and nothing bad happens.
> 
> What about hte following variant:
> 
>  - given that our current O_SYNC really is and always has been actuall
>    Posix O_DSYNC keep the numerical value and rename it to O_DSYNC in
>    the headers.
>  - Add a new O_SYNC definition:
> 
> 	#define O_SYNC		(O_DSYNC|O_REALLY_SYNC)
> 
>    and do full O_SYNC handling in new kernels if O_REALLY_SYNC is
>    present.

That looks good for the kernel.

However, for userspace, there's an issue with applications which were
compiled with an old libc and used O_SYNC.  Most of them probably
expected O_SYNC behaviour but all they got was O_DSYNC, because Linux
didn't do it right.

But they *didn't know* that.

When using a newer kernel which actually implements O_SYNC behaviour,
I'm thinking those applications which asked for O_SYNC should get it,
even though they're still linked with an old libc.

That's because this thread is the first time I've heard that Linux
O_SYNC was really the weaker O_DSYNC in disguise, and judging from the
many Googlings I've done about O_SYNC in applications and on different
OS, it'll be news to other people too.

(I always thought the "#define O_DSYNC O_SYNC" was because Linux
didn't implement the weaker O_DSYNC).

(Oh, and Ulrich: Why is there a "#define O_RSYNC O_SYNC" in the Glibc
headers?  That doesn't make sense: O_RSYNC has nothing to do with
writing.)

To achieve that, libc could implement two versions of open() at the
same time as it updates header files.  The new libc's __old_open() would
do:

    /* Only O_DSYNC is set for apps built against old libc which
       were compiled
    if (flags & O_DSYNC)
        flags |= O_SYNC;

I'm not exactly sure how symbol versioning works, but perhaps the
header file in the new libc would need __REDIRECT_NTH to map open() to
__new_open(), which just calls the kernel.  This is to ensure .o and
.a files built with an old libc's headers but then linked to a new
libc will get __old_open().

Although libc's __new_open() could have this:

    /* Old kernels only look at O_DSYNC.  It's better than nothing. */
    if (flags & O_SYNC)
        flags |= O_DSYNC;

Imho, it's better to not do that, and instead have

    #define O_SYNC          (O_DSYNC|__O_SYNC_KERNEL)

as Chris suggests, in the libc header the same as the kernel header,
because that way applications which use the syscall() function or have
to invoke a syscall directly (I've seen clone-using code doing it),
won't spontaneously start losing their O_SYNCness on older kernels.
Unless there is some reason why "flags &= ~O_SYNC" is not permitted to
clear the O_DSYNC flag, or other reason why they must be separate flags.

-- Jamie
