Return-Path: <linux-kernel-owner+w=401wt.eu-S1763346AbYBNTSX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763346AbYBNTSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 14:18:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757644AbYBNTSJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 14:18:09 -0500
Received: from pat.uio.no ([129.240.10.15]:47828 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757423AbYBNTSI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 14:18:08 -0500
Subject: Re: [PATCH] Add MS_BIND_FLAGS mount flag
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: menage@google.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-Reply-To: <E1JPi3u-0002rp-Nz@pomaz-ex.szeredi.hu>
References: <47B283EB.8070209@google.com>
	 <E1JPZUb-00013Z-0U@pomaz-ex.szeredi.hu>
	 <6599ad830802140719l270d6fdfyd6d17806eda12a8d@mail.gmail.com>
	 <E1JPgYm-0002dm-IX@pomaz-ex.szeredi.hu>
	 <1203006419.8343.48.camel@heimdal.trondhjem.org>
	 <E1JPi3u-0002rp-Nz@pomaz-ex.szeredi.hu>
Content-Type: text/plain
Date: Thu, 14 Feb 2008 14:17:55 -0500
Message-Id: <1203016675.18369.21.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=0.0, required=5.0, autolearn=disabled, none)
X-UiO-Scanned: 69AEEB83BEF90ACFB202E3351AE95DB84FAE2576
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 205 total 6889562 max/h 8345 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-02-14 at 18:39 +0100, Miklos Szeredi wrote:
> > > And I'm not against doing it with the "at*" variants, as Trond
> > > suggested.
> > 
> > If you're going to change the syscall, then you should ensure that it
> > solves _all_ the problems that are known at this time. Ignoring the
> > automounter issue is just going to force us to redo the syscall in a
> > couple of months...
> 
> Sure.
> 
> Although, an (almost) equivalent userspace code would be:
> 
> mount_fooat(int fd, const char *path)
> {
> 	char tmpbuf[64];
> 	int tmpfd = openat(fd, path);
> 
> 	sprintf(tmpbuf, "/proc/self/fd/%i", tmpfd);
> 	return mount_foo(tmpbuf, ...);
> }
>
> Or is there something (other than not requiring proc) that the *at
> variant gives?

The ability to have a daemon handle mounting onto a directory that only
exists in another process's private namespace.

Say I'm running in my private namespace that contains paths that are not
shared by the trusted 'init' namespace. If I were to step on an
autofs-like trap, I'd like for the kernel to be able to notify the
automounter that is running in the trusted namespace set up by 'init',
and have it mount the directory onto my namespace. This should happen
even if the path is not shared.

With mountat() the kernel can still pass the necessary information to
the automounter by giving it a directory file descriptor 'fd' that
points to the directory on top of which it wants the mount to occur.
Then automounter then executes

     mountat(AT_FDCWD, dev_name, fd, '.', type, flags, data);

and hey presto, the magic occurs.

