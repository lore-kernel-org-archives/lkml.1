Return-Path: <linux-kernel-owner+w=401wt.eu-S1753285AbXDIODs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285AbXDIODs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 10:03:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753289AbXDIODs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 10:03:48 -0400
Received: from pat.uio.no ([129.240.10.15]:38106 "EHLO pat.uio.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753285AbXDIODq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 10:03:46 -0400
Subject: Re: If not readdir() then what?
From: Trond Myklebust <trond.myklebust@fys.uio.no>
To: Theodore Tso <tytso@mit.edu>
Cc: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>
In-Reply-To: <20070409131918.GC18580@thunk.org>
References: <a36005b50704070957v2d2e6c4g5fac49b5ff1a5789@mail.gmail.com>
	 <20070407203633.GA21555@thunk.org> <20070407233037.GA16508@infradead.org>
	 <46193048.6000606@zytor.com> <20070408184129.GA20871@lazybastard.org>
	 <20070408191955.GD29180@thunk.org> <46194260.3050900@zytor.com>
	 <20070409014426.GA18580@thunk.org> <20070409110927.GA23240@lazybastard.org>
	 <1176121897.6210.8.camel@heimdal.trondhjem.org>
	 <20070409131918.GC18580@thunk.org>
Content-Type: text/plain; charset=utf-8
Date: Mon, 09 Apr 2007 10:03:15 -0400
Message-Id: <1176127395.6210.34.camel@heimdal.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 
Content-Transfer-Encoding: 8BIT
X-UiO-Resend: resent
X-UiO-Spam-info: not spam, SpamAssassin (score=-0.1, required=12.0, autolearn=disabled, AWL=-0.125)
X-UiO-Scanned: 622D820AEA2144093D0E770159887DE563730C28
X-UiO-SPAM-Test: remote_host: 129.240.10.9 spam_score: 0 maxlevel 200 minaction 2 bait 0 mail/h: 74 total 937438 max/h 7466 blacklist 0 greylist 0 ratelimit 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2007-04-09 at 09:19 -0400, Theodore Tso wrote:
> On Mon, Apr 09, 2007 at 08:31:37AM -0400, Trond Myklebust wrote:
> > On Mon, 2007-04-09 at 13:09 +0200, Jörn Engel wrote:
> > > That surely doesn't make life any easier for filesystem developers, I
> > > agree.  From that point of view, all telldir cookies should end their
> > > life at closedir time.  For "rm -r" it would be sufficient if the nfs
> > > client simply didn't seekdir at all.  For "ls -lR", this would return
> > > duplicate dentries.
> > 
> > Please go read the NFS spec. The only thing an NFS client has in order
> > to read a directory is a READDIR operation that in essence takes a
> > filehandle and a cookie as its arguments. Unless the server is able to
> > return the entire rest of the directory in one RPC reply, the client
> > needs to send a second READDIR operation with a cookie from the previous
> > READDIR operation. The server is expected to return cookies for _each_
> > entry in the directory.
> > 
> > That is a protocol limitation, not a client limitation.
> 
> <Groan>
> 
> And after quickly checking RFC 3010, I see this limitation hasn't been
> lifted in NFSv4.

If we can come up with an interface that makes sense in the context of
NFS, then we should be able to push it into a future minor revision of
NFSv4. It is unfortunately looking too late to push it into v4.1, since
the final drafts of the RFC are already circulating.

> Speaking of which, right now ext3 doesn't know whether it's talking to
> an NFSv2 or NFS v3/v4 server, so it's always passing a 32-bit cookie.
> If NFSv3/v4 could use an explicit interface to request a 64-bit
> cookie, instead of just relying on the f_pos field in the file handle,
> we can reduce the chance of hash collisions when reading an ext3
> directory significantly.   

We could perhaps teach nfsd to open the file without the O_LARGEFILE
attribute in the case of NFSv2?

> If there are 2 or 3 directory entries that have a hash collision,
> would the NFS protocol allow the server to juggle things so that those
> 2-3 directory entries with the hash collision are sent back in a
> single readdir RPC reply?  Is it aceptable/legal to have multiple
> entries in the same READDIR reply packet have the same cookie value?

Not really.

However on NFSv3 and v4 there is actually a mechanism for declaring that
the existing set of cookies have expired and are no longer valid: you
have an 8-byte opaque 'verifier' which is supplied by the server, and
which is supposed to be returned by the client on every call to READDIR.
If the server wants to change its cookie scheme, then it signals it to
the client by changing its verifier, and returning an error whenever the
client tries to use the old verifier. Upon receiving that error, the
client is supposed to clear out all cached cookies, and read the
directory in again from the start.

In practice, though, this sort of behaviour has to be managed carefully
by the server. Forcing a client to re-read the entire contents of the
directory doesn't really scale too well...
Note also that we would have to fix the client implementation. Nobody
has bothered working on the code to handle verifier changes since there
are no servers out there in the wild that use it.

Cheers
  Trond

