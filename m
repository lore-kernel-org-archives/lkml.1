Return-Path: <linux-kernel-owner+w=401wt.eu-S1945949AbXDLJh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945949AbXDLJh4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 05:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945956AbXDLJh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 05:37:56 -0400
Received: from lazybastard.de ([212.112.238.170]:34295 "EHLO
	longford.lazybastard.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945949AbXDLJhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 05:37:55 -0400
Date: Thu, 12 Apr 2007 11:33:11 +0200
From: =?utf-8?B?SsO2cm4=?= Engel <joern@lazybastard.org>
To: Neil Brown <neilb@suse.de>
Cc: Theodore Tso <tytso@mit.edu>, "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Hellwig <hch@infradead.org>,
       Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: If not readdir() then what?
Message-ID: <20070412093310.GC8175@lazybastard.org>
References: <20070407233037.GA16508@infradead.org> <46193048.6000606@zytor.com> <20070408184129.GA20871@lazybastard.org> <17947.65165.569482.976343@notabene.brown> <20070411144252.GB17778@thunk.org> <17949.25061.739035.688232@notabene.brown> <20070411232224.GF17778@thunk.org> <17949.36737.701327.104172@notabene.brown> <20070412023712.GA8175@lazybastard.org> <17949.51797.386833.917451@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <17949.51797.386833.917451@notabene.brown>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 April 2007 15:57:41 +1000, Neil Brown wrote:
> 
> > However, the collision chain gives me quite a bit of headache.  One
> > would have to store each entry's position on the chain, deal with older
> > entries getting deleted, newer entries getting removed, etc.  All this
> > requires a lot of complicated code that basically never gets tested in
> > the wild.
> 
> This is a simple consequence of the design decision to use hashes as
> the search key.  They aren't dense and they will collide.  So the
> solution will be a bit fuzzy around the edges.  And maybe that is an
> acceptable tradeoff.  But the filesystem should take full
> responsibility for it, whether in performance or correctness :-)

Sure.  And seeing that not using hashes would kill performance long
before 4 billion dentries are reached, there don't seem to be many
downsides to hashing in principle.

> > Just settling for a 64bit hash and returning -EEXIST when someone causes
> > a collision an creat() sounds more appealing.  Directories with 4
> > billion entries will cause problems, but that is hardly news to anyone.
> 
> I think you want -EFBIG or -ENOSPC.  -EEXIST sounds just wrong.

None of them are 100% correct.  But you are right, -ENOSPC seems to do
less harm.

> But there are alternatives.  e.g. internal chaining.
> Insist on a unique 64bit hash for every file.  If the hash is in use,
> increment and try again.  On lookup, if the hash leads you to a file
> with the wrong name, increment and try again until you find a hole
> (hash value that is not stored).  When you delete an entry, leave a
> place holder if the next hash is in use.  Conversely if the next hash
> is not in use, delete the entry and delete the previous one if it is a
> place holder.

That would work and is limited to reasonable complexity.  It still
suffers from getting virtually no testing in the wild and therefore
being one of the dark corners little critters thrive in.  But one can at
least add a config option to fold the hash to 16bit or so.  And cross
fingers that at least one person will occasionally test with that
option.

> You have to require 64bit cookies/fpos, but I think that today, that
> is a reasonable thing to require (5 years ago it might not have been).

Which brings us back to the start of this thread.

Jörn

-- 
Why do musicians compose symphonies and poets write poems?
They do it because life wouldn't have any meaning for them if they didn't.
That's why I draw cartoons.  It's my life.
-- Charles Shultz
