Return-Path: <linux-kernel-owner+w=401wt.eu-S1754512AbXIPXxh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbXIPXxh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2007 19:53:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753935AbXIPXxa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Sep 2007 19:53:30 -0400
Received: from mx1.redhat.com ([66.187.233.31]:46431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532AbXIPXxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2007 19:53:30 -0400
Date: Sun, 16 Sep 2007 19:53:08 -0400
From: Jeff Layton <jlayton@redhat.com>
To: "Satyam Sharma" <satyam.sharma@gmail.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       "Christoph Hellwig" <hch@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: iunique() fails to return ino_t (after commit 866b04fccbf125cd)
Message-Id: <20070916195308.90635230.jlayton@redhat.com>
In-Reply-To: <a781481a0709161228t216322dcq5dfd60062bb825be@mail.gmail.com>
References: <a781481a0709161228t216322dcq5dfd60062bb825be@mail.gmail.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Sep 2007 00:58:54 +0530
"Satyam Sharma" <satyam.sharma@gmail.com> wrote:

> Hi Jeff,
> 
> I think commit 866b04fccbf125cd39f2bdbcfeaa611d39a061a8 was wrong, and
> introduced a regression.
> 
> The "relevant" changelog [*] of that patch says:
> 
> 
> >  on filesystems w/o permanent inode numbers, i_ino values can be larger
> >  than 32 bits, which can cause problems for some 32 bit userspace programs
> >  on a 64 bit kernel.  We can't do anything for filesystems that have
> >  actual >32-bit inode numbers, but on filesystems that generate i_ino
> >  values on the fly, we should try to have them fit in 32 bits.  We could
> >  trivially fix this by making the static counters in new_inode and iunique
> >  32 bits [...]
> >
> > [...]
> > When a 32-bit program that was not compiled with large file offsets does a
> > stat and gets a st_ino value back that won't fit in the 32 bit field, glibc
> > (correctly) generates an EOVERFLOW error.  We can't do anything about fs's
> > with larger permanent inode numbers, but when we generate them on the fly,
> > we ought to try and have them fit within a 32 bit field.
> >
> > This patch takes the first step toward this by making the static counters
> > in these two functions be 32 bits.
> 
> 
> 1. First and foremost, there was nothing wrong with the existing code that
>    needed to be "fixed" at all, i.e. there was no "problem" to be solved in
>    the first place. As was said, glibc *correctly* returns EOVERFLOW when a
>    userspace application built *without* _FILE_OFFSET_BITS == 64 (i.e.
>    ino_t != __ino64_t) tries to stat(2) a file whose serial number does not
>    fit in the "st_ino" member of struct stat. This behaviour is (1) correct,
>    (2) explicitly mandated by the Single UNIX Specification, and, (3) all
>    userspace programs *must* be prepared to deal with it. [ Should probably
>    mention here that other implementations, such as Solaris, do conform with
>    SUS here. ]
> 

The ideal situation is that everyone would recompile their programs
with LFS defines. Unfortunately people have old userspace programs to
which they don't have sources, or that can't easily be recompiled this
way. These programs would occasionally break when run on 64 bit kernels
for the reasons I've described.

> 2. The patch has nothing to do with "32-bit userspace on 64-bit kernels" or
>    compatibility modes whatsoever. It is unrelated and tangential that this
>    behaviour is easy to reproduce on the above mentioned setup. Simply put,
>    the issue is that a userspace program built *without* LFS tried to
>    stat(2) a file with serial number > 2**32. Needless to say, this issue
>    must be solved in the userspace program itself (either by (1) defining
>    LFS, or, (2) making it aware of EOVERFLOW), and not in the kernel.
> 

It most certainly does have something to do with 32 bit userspace on 64
bit kernels. On a 32 bit kernel, new_inode and iunique generate no
inode numbers >32 bits. On a 64 bit kernel, they do. This means that
programs that are built this way may eventually fail on a 64 bit kernel
when the inode counter grows large enough. Those programs will work
indefinitely on a 32 bit kernel.

> 3. Solving a problem at a place where it does not exist naturally leads to
>    other breakage. After 866b04fccbf125cd, iunique() no longer returns an
>    ino_t, but only values <= 2**32, which limits the number of inodes on
>    all filesystems that use that function. Needless to say, this is a
>    *regression* w.r.t. previous kernels before that commit went in.
> 

Why is this a problem? Filesystems that truly need that many more inodes
are certainly able to generate one using a different scheme. Typically,
the inode numbers generated by iunique and new_inode are only used by
filesystems that have no permanent inode numbers of their own. In many
cases, inode number uniqueness isn't even an issue as evidenced by the
number of filesystems that simply use the number assigned by new_inode. 

This patch seems like a reasonable compromise to me. It allows us to
keep these inode numbers below 32 bits on filesystems that don't care
too much about what inode number they're using.

> 4. Last but not the least, the sample testcase program that was discussed
>    on LKML last year to show this "problem" was buggy and wrong. A program
>    built without LFS will also suffer EOVERFLOW when stat(2)'ing a file
>    due to other reasons, such as filesize not fitting inside the "st_size"
>    member. Do we propose to "fix" that "problem" in the kernel too ?
>    Of course not!
> 

Right, but that situation is the same regardless of whether you run it
on a 32 or 64 bit kernel. The issue of inode numbers generated by
new_inode and iunique crossing the 32-bit boundary, however, is not.

Can you elaborate why this testcase was buggy and wrong? It seems to me
that it correctly demonstrated the issue. Just because there are other
reasons that a program might get an EOVERFLOW doesn't mean that that one
is invalid.

> 
> IMHO it's bad to change the kernel's behaviour to avoid buggy userspace
> programs from seeing standard-mandated errors being returned from stat(2).
> 
> So please reconsider that patch -- IMHO it clearly wasn't correct.
> 

Again, I have to ask why you feel the current patch to be a problem.
Ripping this patch out will reintroduce the problem already
described. Since I'm not clear on the issue you're seeing as a
result of this patch, I'm not comfortable agreeing that it should
be removed.

-- 
Jeff Layton <jlayton@redhat.com>
