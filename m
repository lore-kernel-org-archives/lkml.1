Return-Path: <linux-kernel-owner+w=401wt.eu-S1760526AbZCWTOs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760526AbZCWTOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 15:14:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758054AbZCWTOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 15:14:37 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:48759 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757072AbZCWTOf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 15:14:35 -0400
Subject: Re: [Patch] ltt-relay-alloc mmap support (due to NFS lack of
 splice support)
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
Cc: Masahiro Tamori <masahiro.tamori@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       ltt-dev <ltt-dev@lists.casi.polymtl.ca>, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, linux-nfs@vger.kernel.org,
       Jens Axboe <axboe@kernel.dk>, Nick Piggin <npiggin@suse.de>
In-Reply-To: <20090323175820.GH24084@Krystal>
References: <91e0b5050903170224k51c4895eq8a1491da7a7a9741@mail.gmail.com>
	 <20090320152857.GB30019@Krystal>
	 <91e0b5050903230534g57d1ef8byd14a1fb5ca807192@mail.gmail.com>
	 <20090323175820.GH24084@Krystal>
Content-Type: text/plain
Date: Mon, 23 Mar 2009 15:14:24 -0400
Message-Id: <1237835664.6935.14.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.0 
Content-Transfer-Encoding: 7bit
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: 1CC5C9C374C5F8EB6371D4500ED17EB9BD9FC038
X-UiO-SPAM-Test: remote_host: 71.227.91.12 spam_score: -49 maxlevel 200 minaction 2 bait 0 mail/h: 1 total 94 max/h 3 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-03-23 at 13:58 -0400, Mathieu Desnoyers wrote:
> * Masahiro Tamori (masahiro.tamori@gmail.com) wrote:
> > 2009/3/21 Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>:
> > > * Masahiro Tamori (masahiro.tamori@gmail.com) wrote:
> [...]
> > >> Our customer will use NFS to store trace data not storage device for
> > >> embedded devices.
> > >> Since newer lttng use splice() even if NFS can not support splice(),
> > >> I create a patch to support to mmap of ltt-relay-alloc.
> > >>
> [...]
> > >> ltt-relay-alloc mmap support
> > >>
> > >> Splice syscall does not support NFS. We can not save trace data to
> > >> NFS directory. If this feature is enabled, you can use mmap()
> > >> instead of splice().
> > >>
> > >
> > >
> > > Hi Masahiro,
> > >
> > > Maybe we should consider implementing splice() support in NFS instead ?
> > >
> > > I removed the mmap support from the ltt-relay-alloc files because splice
> > > is more efficient and does not require to vmap the pages.  Unless there
> > > is a strong argument telling what in NFS makes it impossible to
> > > implement splice(), I don't really see the gain in putting back the
> > > old mmap() mechanism we had.
> > >
> > > Maybe the NFS people will have some information about this ?
> > >
> > > Thanks,
> > >
> > > Mathieu
> > >
> > 
> > Hello Mathieu,
> > 
> > I think that the best solution is NFS can support splice() even if
> > it cannot zero copy.
> > 
> > The splice() will be used by any other tools, hence NFS should support
> > it sooner or later.
> > 
> > If technical issue is remained to support splice() in NFS,
> > we should support mmap in LTTng until the problem is resolved.
> > Embedded people will want to use LTTng with NFS,
> > though this is a bad choice.
> > 
> > Thank you,
> > Masahiro Tamori
> > 
> 
> There was a LKML thread on NFS splice support back in 2006 :
> 
> http://lkml.indiana.edu/hypermail/linux/kernel/0603.3/2102.html
> 
> I don't know what happened with this ? I have tested NFS v2 and v3 and
> have seen they do not support splice, but haven't tested NFSv4.
> 
> Mathieu

We do support splice reads and apparently don't support splice writes.
However I don't see what has been stopping anybody from implementing the
latter.

In fact, it looks to me as if we should just be able to use
generic_file_splice_write() as is. There is no O_APPEND support or
anything that would require us to revalidate file lengths; it's just a
perfectly ordinary write into the page cache...

Cheers
   Trond

