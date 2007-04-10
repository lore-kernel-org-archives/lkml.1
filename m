Return-Path: <linux-kernel-owner+w=401wt.eu-S1753785AbXDJN5e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbXDJN5e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 09:57:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753786AbXDJN5e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 09:57:34 -0400
Received: from thunk.org ([69.25.196.29]:36388 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753785AbXDJN5c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 09:57:32 -0400
Date: Tue, 10 Apr 2007 09:56:41 -0400
From: Theodore Tso <tytso@mit.edu>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>
Subject: Re: If not readdir() then what?
Message-ID: <20070410135641.GG13650@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Trond Myklebust <trond.myklebust@fys.uio.no>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Christoph Hellwig <hch@infradead.org>,
	Ulrich Drepper <drepper@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Neil Brown <neilb@suse.de>
References: <20070407233037.GA16508@infradead.org> <46193048.6000606@zytor.com> <20070408184129.GA20871@lazybastard.org> <20070408191955.GD29180@thunk.org> <46194260.3050900@zytor.com> <20070409014426.GA18580@thunk.org> <20070409110927.GA23240@lazybastard.org> <1176121897.6210.8.camel@heimdal.trondhjem.org> <20070409131918.GC18580@thunk.org> <1176127395.6210.34.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1176127395.6210.34.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2007 at 10:03:15AM -0400, Trond Myklebust wrote:
> We could perhaps teach nfsd to open the file without the O_LARGEFILE
> attribute in the case of NFSv2?

That might work.  But if in the long term we want to separate out what
we can send back via telldir/seekdir, and some future new Posix
interface, I wonder if we might be better off defining a formal
interface which can be used by NFSv2 and NFSv3/v4 that isn't
necessarily tied to f_pos.  Given that the semantics for what
telldir/seekdir are different from what what NFS needs
(telldir/seekdir cookies don't have to be persistent), it may be
useful to allow filesystems the option of having two separate options
for how to export this information.  

> Not really.
> 
> However on NFSv3 and v4 there is actually a mechanism for declaring that
> the existing set of cookies have expired and are no longer valid: you
> have an 8-byte opaque 'verifier' which is supplied by the server, and
> which is supposed to be returned by the client on every call to READDIR.
> If the server wants to change its cookie scheme, then it signals it to
> the client by changing its verifier, and returning an error whenever the
> client tries to use the old verifier. Upon receiving that error, the
> client is supposed to clear out all cached cookies, and read the
> directory in again from the start.

I looked at that, and it's not really helpful.  Basically if NFS
demands that cookies never collide, and states that cookies must be
some small (32 or 64) bit value that are persistent across time and
server reboots, then that's fundmaentally incompatible with any kind
of non-linear directory structure.  So whether the filesystem is
ext3/htree, or ntfs, or reiserfs, people will be cheating one way or
another.

One of the things which they could do I suppose is use a linear
offset, and then change the verifier every single time there is a
b-tree split or merge which changes the configuration of the tree.  As
you say, though, forcing the client to re-read the entire contents of
the directory each time we change the verifier doesn't scale too well.
But the fact of the matter is that if NFS protocols demands that a
per-directory entry cookie can be uniquely and permanently (including
across server reboots) identified with a small integer number, it's
dreaming.  Filesystem authors will cheat one way or another, because
there's nothing else for them to do.  

> Note also that we would have to fix the client implementation. Nobody
> has bothered working on the code to handle verifier changes since there
> are no servers out there in the wild that use it.

... which means changing the verifier every node merge/split operation
would probably cause all sorts of interesting breakages, even more
than the occasional hash collision (which as far as I know no one has
complained about so far --- but with the 32-bit cookie, the birthday
paradox states that the probability of a collision is 1 in 65536, so
it's probably happened out in the wild already).

Regards,

						- Ted
