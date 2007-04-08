Return-Path: <linux-kernel-owner+w=401wt.eu-S1751762AbXDHSsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbXDHSsG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 14:48:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbXDHSsG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 14:48:06 -0400
Received: from thunk.org ([69.25.196.29]:34154 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762AbXDHSsE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 14:48:04 -0400
Date: Sun, 8 Apr 2007 14:47:35 -0400
From: Theodore Tso <tytso@mit.edu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christoph Hellwig <hch@infradead.org>, Ulrich Drepper <drepper@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: If not readdir() then what?
Message-ID: <20070408184735.GC29180@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Christoph Hellwig <hch@infradead.org>,
	Ulrich Drepper <drepper@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <a36005b50704070957v2d2e6c4g5fac49b5ff1a5789@mail.gmail.com> <20070407203633.GA21555@thunk.org> <20070407233037.GA16508@infradead.org> <46193048.6000606@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46193048.6000606@zytor.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 08, 2007 at 11:11:20AM -0700, H. Peter Anvin wrote:
> Christoph Hellwig wrote:
> >On Sat, Apr 07, 2007 at 04:36:33PM -0400, Theodore Tso wrote:
> >>this functionality, and it is highly questionable how useful it is,
> >>anyway.  If you use telldir/seekdir and keep the cookie for a long
> >>time, even the POSIX-provided guarantees about files that are created
> >>and deleted between the telldir() and seekdir() points in time makes
> >>its utility highly dubious.
> >
> >It's not going to solve anything at all.  We can't stop supporting
> >functionality that has been there forever. 
> 
> Well, the question is if you can keep the seekdir/telldir cookie around 
> as a pointer -- preferrably in userspace, of course.  You would 
> presumably garbage-collect them on closedir() -- there is no other point 
> at which you could.
> 
> I personally suspect that hch is right -- this stuff has been there 
> since time immemorial and it'll be hard or impossible to deprecate it.

You could, but then you're succeptible to a memory allocation attack.
If you have an arbitrarily large directory (say, one with multiple
millions of entries), and the attacker program calls seekdir() after
every single readdir() call, you would then force the kernel to
allocate and then pin arbitrarily large amounts of memory, which as
you point out, as currently specified by the POSIX specification, you
are not allowed to release until closedir().

This could be done in userspace, by forcing glibc to readdir() the
entire directory into memory, at which point seekdir()/telldir() will
work just fine.  But for a really big directory, this could consume a
huge amount of space. 

If we had the 64-byte telldir cookie that I had proposed, then in
userspace we could simply associate that 64-byte telldir cookie with a
small 32-bit integer, either in memory, or in some berkdb or tdb
interface, at least until the use of telldir/seekdir had actually
disappeared.  (Which probably wouldn't take that long; I really doubt
there are that many users of it out there, so it's probably OK if they
suffer a performance penality if they use this really wretched and
horrible interface.)

I'll also note, by the way, that there are those who have been much
more cavalier with breaking the wireless interface or the udev/sys
interface after one year.  Not that I would agree with that, but over
some deprecation period measured in years, I think it is possible to
nuke what was a horribly misguided interface that should have never
existed.  Whoever invented it really should receive the brown paper
award for one of the worst design decisions of all time.

						- Ted
