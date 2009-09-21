Return-Path: <linux-kernel-owner+w=401wt.eu-S1753866AbZIUUSM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbZIUUSM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 16:18:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751232AbZIUUSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 16:18:10 -0400
Received: from mail-out1.uio.no ([129.240.10.57]:35754 "EHLO mail-out1.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175AbZIUUSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 16:18:09 -0400
Subject: Re: [PATCH] VFS: document what MAY_ACCESS means
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Jamie Lokier <jamie@shareable.org>
Cc: Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
       hch@infradead.org
In-Reply-To: <20090921185336.GA5633@shareable.org>
References: <20090921012933.2631.85495.stgit@paris.rdu.redhat.com>
	 <20090921081047.GA20006@shareable.org>
	 <1253536193.17222.21.camel@heimdal.trondhjem.org>
	 <20090921185336.GA5633@shareable.org>
Content-Type: text/plain
Date: Mon, 21 Sep 2009 16:18:05 -0400
Message-Id: <1253564285.17222.120.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
X-UiO-Ratelimit-Test: rcpts/h 8 msgs/h 2 sum rcpts/h 11 sum msgs/h 2 total rcpts 1524 max rcpts/h 27 ratelimit 0
X-UiO-Spam-info: not spam, SpamAssassin (score=-5.0, required=5.0, autolearn=disabled, UIO_MAIL_IS_INTERNAL=-5, uiobl=NO, uiouri=NO)
X-UiO-Scanned: FF3AF39B5D5A15EF9EF85BE4B14913ADE58FF4FB
X-UiO-SPAM-Test: remote_host: 68.40.207.222 spam_score: -49 maxlevel 80 minaction 2 bait 0 mail/h: 2 total 269 max/h 6 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-21 at 19:53 +0100, Jamie Lokier wrote:
> Trond Myklebust wrote:
> > On Mon, 2009-09-21 at 09:10 +0100, Jamie Lokier wrote
> > > (Btw, side issue: I was very surprised to find fchdir() to an open
> > > directory can fail on NFS due to change of permissions, so the pattern
> > > dir = open("."); chdir("foo"); fchdir(dir) can fail to restore the
> > > current directory).
> > 
> > Welcome to the world of stateless server-enforced security. Unlike the
> > POSIX model, a NFS server doesn't have the ability to track what
> > permissions have already been checked using a file descriptor. It
> > therefore needs to check permissions on each RPC operation you perform
> > using the credential you present then and there.
> 
> No, no, it's not that.
> 
> It's allowed to have the current directory be a directory you can't
> access any more.  You find out you've lost permission, as you say,
> later when you _do_ something with the directory.  In other words when
> you do a lookup or readdir from the directory.
> 
> Putting it another way, this will _never_ error due to another process
> messing with the permissions of the original directory after subdir is
> opened:
> 
>     dir=open(".");
>     dir2=open("/elsewhere");
>     fstatat(dir2, "something_elsewhere");
> 
> But this can fail, leaving you in a different directory:
> 
>     dir=open(".");
>     dir2=open("/elsewhere");
>     fchdir(dir2);
>     stat("something_elsewhere");
>     fchdir(dir);
> 
> I find that surprising.  Imho, both codes are intended to have the
> same behaviour.
> 
> Is there something in POSIX which says fchdir() must verify you still
> have execute permission in the directory you are switching to at the
> time you call fchdir()?
> 
> I suspect having fchdir() fail in this admittedly obscure case is more
> likely to cause problems than the RPC permission check, due to
> surprise and no obvious error recovery strategy in an application
> where fchdir is used in some subroutine to temporarily switch
> directory and then return to the caller, which doesn't expect the
> current directory might be changed by the call.  I suspect when that
> happens, most applications will either terminate abruptly or behave
> wrongly later.  It's just a guess though....

Oh, I see what you're getting at.

So, looking at the code for fchdir(), it would appear that the
permission check there is being made by the VFS, not NFS. I suspect that
is because it is mandated by POSIX.
Indeed, looking at the spec for fchdir(), it would appear that you _do_
need valid permissions. See

   http://www.opengroup.org/onlinepubs/009695399/functions/fchdir.html

which states that the function returns EACCES if the process doesn't
have search permissions.

Cheers
  Trond

