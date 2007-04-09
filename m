Return-Path: <linux-kernel-owner+w=401wt.eu-S932195AbXDINUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195AbXDINUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 09:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932212AbXDINUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 09:20:07 -0400
Received: from thunk.org ([69.25.196.29]:56383 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932195AbXDINUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 09:20:06 -0400
Date: Mon, 9 Apr 2007 09:19:18 -0400
From: Theodore Tso <tytso@mit.edu>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Neil Brown <neilb@suse.de>
Subject: Re: If not readdir() then what?
Message-ID: <20070409131918.GC18580@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Trond Myklebust <trond.myklebust@fys.uio.no>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Christoph Hellwig <hch@infradead.org>,
	Ulrich Drepper <drepper@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Neil Brown <neilb@suse.de>
References: <a36005b50704070957v2d2e6c4g5fac49b5ff1a5789@mail.gmail.com> <20070407203633.GA21555@thunk.org> <20070407233037.GA16508@infradead.org> <46193048.6000606@zytor.com> <20070408184129.GA20871@lazybastard.org> <20070408191955.GD29180@thunk.org> <46194260.3050900@zytor.com> <20070409014426.GA18580@thunk.org> <20070409110927.GA23240@lazybastard.org> <1176121897.6210.8.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1176121897.6210.8.camel@heimdal.trondhjem.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 09, 2007 at 08:31:37AM -0400, Trond Myklebust wrote:
> On Mon, 2007-04-09 at 13:09 +0200, Jörn Engel wrote:
> > That surely doesn't make life any easier for filesystem developers, I
> > agree.  From that point of view, all telldir cookies should end their
> > life at closedir time.  For "rm -r" it would be sufficient if the nfs
> > client simply didn't seekdir at all.  For "ls -lR", this would return
> > duplicate dentries.
> 
> Please go read the NFS spec. The only thing an NFS client has in order
> to read a directory is a READDIR operation that in essence takes a
> filehandle and a cookie as its arguments. Unless the server is able to
> return the entire rest of the directory in one RPC reply, the client
> needs to send a second READDIR operation with a cookie from the previous
> READDIR operation. The server is expected to return cookies for _each_
> entry in the directory.
> 
> That is a protocol limitation, not a client limitation.

<Groan>

And after quickly checking RFC 3010, I see this limitation hasn't been
lifted in NFSv4.

Speaking of which, right now ext3 doesn't know whether it's talking to
an NFSv2 or NFS v3/v4 server, so it's always passing a 32-bit cookie.
If NFSv3/v4 could use an explicit interface to request a 64-bit
cookie, instead of just relying on the f_pos field in the file handle,
we can reduce the chance of hash collisions when reading an ext3
directory significantly.   

If there are 2 or 3 directory entries that have a hash collision,
would the NFS protocol allow the server to juggle things so that those
2-3 directory entries with the hash collision are sent back in a
single readdir RPC reply?  Is it aceptable/legal to have multiple
entries in the same READDIR reply packet have the same cookie value?

						- Ted
