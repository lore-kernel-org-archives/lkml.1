Return-Path: <linux-kernel-owner+w=401wt.eu-S1030346AbXDPKk4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030346AbXDPKk4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 06:40:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752250AbXDPKk4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 06:40:56 -0400
Received: from thunk.org ([69.25.196.29]:44684 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752834AbXDPKkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 06:40:55 -0400
Date: Mon, 16 Apr 2007 06:39:50 -0400
From: Theodore Tso <tytso@mit.edu>
To: Neil Brown <neilb@suse.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, "J. Bruce Fields" <bfields@fieldses.org>,
       =?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
       Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: If not readdir() then what?
Message-ID: <20070416103950.GE27533@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Neil Brown <neilb@suse.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"J. Bruce Fields" <bfields@fieldses.org>,
	=?iso-8859-1?Q?J=F6rn?= Engel <joern@lazybastard.org>,
	Christoph Hellwig <hch@infradead.org>,
	Ulrich Drepper <drepper@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <17949.25061.739035.688232@notabene.brown> <20070411232224.GF17778@thunk.org> <17949.36737.701327.104172@notabene.brown> <20070412023712.GA8175@lazybastard.org> <17949.51797.386833.917451@notabene.brown> <20070412122116.GD28148@thunk.org> <20070412171831.GD3028@fieldses.org> <461E6DF5.6040808@zytor.com> <20070416030511.GC27533@thunk.org> <17955.3561.821387.134466@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <17955.3561.821387.134466@notabene.brown>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2007 at 03:47:21PM +1000, Neil Brown wrote:
> "my guess", "pretty much" really bother me.
> 
> It sounds like "The largest anyone has asked for is 128bits, or let's
> double it and hope that is enough until the next protocol revision".
> Which was probably reasonable when NFSv2 was being developed and maybe
> even when v3 was developed, but I kind of hoped we were beyond that.
> 
> If a filesystem wanted to order filenames lexically, it really needs
> 256 *bytes*.  And it is fairly silly having a cookie that big.
> 
> I still thinking that 
>    filename + 64bits
> is required and plenty (aka necessary and sufficient).  

Sure, but if you're going to include the filename in the cookie, on
the client side you now have to store a variable-length state, which
probably means you'll need to allocate and free memory each time; and
if the filename is 256 characters, you'll have to send that back in
the next readdir() request. 

If we could get filename + 64bits, sure, that would be great.  I was
just assuming we couldn't get it --- and if we can't get it, 256 bits
is two SHA-1 hashes.  So that's one hash for the filename, and 128
bits for a filesystem's internal hash collision.  There might be other
ways that the space could be divided up, which might be somewhat
wasteful of space --- say you need a host identifier for a clustered
filesystem, although arguably adding a host might be infrequent enough
that you just use the cookie verifier hammer and force the client to
get a new set of readdir cookies.  :-)

> I wouldn't argue against 128bits (64 for a search key and 64 to
> guarantee uniqueness) but I really think 256 excessive with no value.
> We we still need the last-filename in the READDIR key.

I wouldn't complain too much about 128 bits, but if we're going to go
fixed size, I can imagine filesystems where that might not be enough.
And the differecen between 16 and 32 bytes isn't that great.  But I
could easily live with either filename + 64bits, or 128 bits.

						- Ted
