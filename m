Return-Path: <linux-kernel-owner+w=401wt.eu-S1756485AbYJXQJX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485AbYJXQJX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 12:09:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbYJXQJL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 12:09:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55557 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754109AbYJXQJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 12:09:09 -0400
Date: Fri, 24 Oct 2008 09:08:26 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
cc: Theodore Tso <tytso@mit.edu>, linux-kernel@vger.kernel.org,
       eugene@ibrix.com, msnitzer@ibrix.com, akpm@linux-foundation.org
Subject: Re: ext3: fix ext3_dx_readdir hash collision handling - Regression
In-Reply-To: <20081024042851.GA2360@gentoox2.trippelsdorf.de>
Message-ID: <alpine.LFD.2.00.0810240853310.3287@nehalem.linux-foundation.org>
References: <20081022093201.GA2227@gentoox2.trippelsdorf.de> <20081023032832.GE10369@mit.edu> <20081023063740.GA2438@gentoox2.trippelsdorf.de> <20081024000109.GD7842@mit.edu> <20081024042851.GA2360@gentoox2.trippelsdorf.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 24 Oct 2008, Markus Trippelsdorf wrote:
>
> Notice that I don't use "rm -rf" but "rm -r". The problem only occurs
> when I run "rm -r" without the "-f" switch.
> 
> The first time I encountered this problem was on an ext4 test partition
> a few days ago. When I tried to delete a big directory structure on that
> partition with mc (GNU Midnight Commander) by hitting F8 and then selecting
> "All" on the "Delete it recursively" popup, it just stopped deleting
> files after a while. So I had to repeat this procedure several times to
> get rid of the directory.

Hmm. I may actually have hit the same problem. I attributed it to a git 
buglet, and left it for later, because the last few days were pretty crazy 
(closing the merge window is when people always send their last-minute 
stuff even if they shouldn't, but to make things worse I was also gone for 
a day-and-a-half).

The "git buglet" looks liek this:

 - build a kernel

 - do "git clean -dqfx". This fails with

	warning: failed to remove 'include/config/'

 - do "git clean -dqfx" again. And now it works - apparently because the 
   first invocation deleted enough of the big directory.

Doing an 'strace' to see what is going on, I see:

	..
	getdents(3, /* 132 entries */, 4096)    = 3888
	lstat("include/config/sgi", {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
	open("include/config/sgi", O_RDONLY|O_NONBLOCK|O_DIRECTORY|0x80000) = 4
	fstat(4, {st_mode=S_IFDIR|0755, st_size=4096, ...}) = 0
	getdents(4, /* 3 entries */, 4096)      = 80
	lstat("include/config/sgi/partition.h", {st_mode=S_IFREG|0644, st_size=0, ...}) = 0
	unlink("include/config/sgi/partition.h") = 0
	getdents(4, /* 0 entries */, 4096)      = 0
	close(4)                                = 0
	rmdir("include/config/sgi")             = 0
	lstat("include/config/sgi", 0x7fffdc4d2110) = -1 ENOENT (No such file or directory)
	close(3)                                = 0
	write(2, "warning: failed to remove \'include/config/\'\n", 44) = 44
	..

and notice how it does that

	lstat("include/config/sgi", ..

_twice_. That, in turn (knowing the git implementation), implies that it 
was returned twice from that first "getdents(3, ...)" call.

So what git clean does is to scan over the readdir() return values, see if 
it's a file it knows about, try to remove it if not, lstat() every entry, 
recurse into them if they are directories, and then remove it. If the 
lstat() fails, "git clean" will fail.

So what happens is that it sees that "sgi" entry _twice_ in the readdir 
output, traverse into it once (and delete it), and the second time when it 
does an lstat() it will obviously fail (because now it's deleted!), and 
that will make "git clean" fail the whole thing due to an unexpected 
error.

And I _think_ that what brings this on is:

 - caring about the error value

   This is why "rm -rf" works for you, but "rm -r" does not. With "-f", rm 
   simply won't care. And like "rm -r", "git clean" cares about error 
   values.

 - large enough directories that you have *multiple* "getdents()" calls.

 - likely: removing files in between getdents() calls.

Hmm. Ted? I have not tried to revert that commit that Markus pinpointed 
(6a897cf447a83c9c3fd1b85a1e525c02d6eada7d: "ext3: fix ext3_dx_readdir hash 
collision handling"), but now that I look at that "git bug", I am getting 
pretty damn sure that it's exactly the same issue, and it's not a git bug 
at all.

Markus basically has exactly the same thing:

  rm: cannot remove `linux-2.6.27.2/arch/alpha/include/asm/statfs.h': No such file or directory

and that ENOENT is almost certainly because "rm" already removed that 
filename _once_, and it's the second time that fails.

And yes, that commit is all about returning directory entries twice. It 
claims to fix it, but I bet it breaks it.

		Linus
