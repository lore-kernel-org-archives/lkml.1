Return-Path: <linux-kernel-owner+w=401wt.eu-S1764035AbYD0XaH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764035AbYD0XaH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 19:30:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753754AbYD0X35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 19:29:57 -0400
Received: from nfitmail.nfit.au.dk ([130.225.31.129]:1398 "EHLO
	smtp.nfit.au.dk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752942AbYD0X34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 19:29:56 -0400
To: Theodore Tso <tytso@mit.edu>
Cc: linux-kernel@vger.kernel.org, alexl@redhat.com
Subject: Re: stat benchmark
References: <ye8wsmnezq9.fsf@camel05.daimi.au.dk>
	<20080425194845.GE21193@mit.edu>
From: Soeren Sandmann <sandmann@daimi.au.dk>
Date: 28 Apr 2008 01:29:52 +0200
In-Reply-To: <20080425194845.GE21193@mit.edu>
Message-ID: <ye8iqy23mhb.fsf@camel27.daimi.au.dk>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso <tytso@mit.edu> writes:

> On Thu, Apr 24, 2008 at 10:59:10PM +0200, Soeren Sandmann wrote:
> > 
> > Under the theory that disk seeks are killing us, one idea is to add a
> > 'multistat' system call that would allow statting of many files at a
> > time, which would give the disk scheduler more to work with. 
> 
> Why don't you try this version of your stat-benchmark first?  If you
> give it the -s option, it will sort the files by inode number first.
> I think you will find this should make a significant difference.

Yeah, Carl suggested this as well. 

Sorting by inode is a major improvement. The numbers are less stable,
but consistently much lower:

    Time to readdir(): 0.238737 s
    Time to stat 2366 files: 1.338904 s

compared to

    Time to readdir(): 0.227599 s
    Time to stat 2366 files: 7.981752 s

Of course, 1.3 seconds is still far from instant, but it may be the
best we can get given the realities of ext3 disk layout.

One thing that surprised me is that lstat is slightly slower than
stat. With lstat() instead of stat(), I get:

    Time to stat 2366 files: 1.472115 s
    Time to readdir(): 1.735542 s

I naively thought that stat() was a superset of lstat(), but
apparently not.

> If it works, something that would be really great if someone were to
> make a generic library which could be used instead of readdir().  I
> have something which works as an LD_PRELOAD, but apparently it's been
> blowing up on 64-bit systems, and I haven't had time to debug it.
> It's probably better to do it as a library which userspace
> applications linked against, anyway.  Would you or someone you know be
> interesed in maybe taking this idea and running with it?

After I read Carl's mail I looked at what glib - which is used by both
Nautilus and the gtk+ file open dialog - does, and in fact the latest
version does actually read chunks of 1000 dirents and sorts them by
inode. The version I had installed when I wrote the benchmark just
stat'ed in readdir() order.

For a directory of ~2360 files, chunks of a 1000 files is actually
surprisingly worse than statting all of the files at once:

    Time to stat 1000 files: 1.008735 s
    Time to stat 1000 files: 0.738936 s
    Time to stat 366 files: 0.217002 s

I guess this just shows that seeks really is pretty much all that
matters. Glib should maybe use a larger chunk size.

I don't know if a general library outside glib would be useful. It
seems that just telling people to "sort by inode before statting"
would be just as effective as telling them "use this optimized
library".



Thanks,
Soren
