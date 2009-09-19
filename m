Return-Path: <linux-kernel-owner+w=401wt.eu-S1753721AbZISIX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721AbZISIX4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Sep 2009 04:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbZISIXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Sep 2009 04:23:55 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:42128 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751367AbZISIXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Sep 2009 04:23:53 -0400
X-Greylist: delayed 46317 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Sep 2009 04:23:52 EDT
From: Jim Meyering <jim@meyering.net>
To: Theodore Tso <tytso@mit.edu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: efficient access to "rotational";  new fcntl?
In-Reply-To: <20090918221658.GB28781@mit.edu> (Theodore Tso's message of "Fri,
	18 Sep 2009 18:16:58 -0400")
References: <87vdjgqcbd.fsf@meyering.net> <20090918221658.GB28781@mit.edu>
Date: Sat, 19 Sep 2009 10:01:51 +0200
Message-ID: <87pr9npdlc.fsf@meyering.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Fri, Sep 18, 2009 at 09:31:50PM +0200, Jim Meyering wrote:
>>     chgrp, chmod, chown, chcon, du, rm: now all display linear performance,
>>     even when operating on million-entry directories on ext3 and ext4 file
>>     systems.  Before, they would exhibit O(N^2) performance, due to linear
>>     per-entry seek time cost when operating on entries in readdir order.
>>     Rm was improved directly, while the others inherit the improvement
>>     from the newer version of fts in gnulib.
>
> Excellent!  I didn't know that (since my userspace is still Ubuntu
> 9.04, which is still using coreutils 6.10).

Heh.  Time to upgrade.
With the upcoming coreutils-7.7, I've removed a quadratic
component in rm -r (without -f), and rewrote it to give
rm -rf an additional 4-5x speed-up in some nasty cases.

>> However, with e.g., an ext4 partition on non-rotational hardware like
>> an SSD, that preprocessing is unnecessary and in fact wasted effort.
>> I'd like to avoid the waste by querying the equivalent of
>> /sys/.../rotational, via a syscall like fcntl or statvfs,
>> given a file descriptor.
>
> Have you benchmarked it both ways?  The preprocessing will cost some
> extra CPU time, sure, but for a sufficiently large directory, or if
> the user is deleting a very large directory hierarchy, such that "rm
> -rf" spans multiple journal transactions, deleting the files in inode
> order will still avoid some filesystem metadata blocks getting written
> multiple times (which for SSD's, especially the crappier ones with
> nasty write amplification factors) could show a performance impact.

Yeah, I mentioned I should do exactly that on IRC yesterday.
I've just run some tests, and see that at least with one SSD (OCZ Summit
120GB), the 0.5s cost of sorting pays off handsomely with a 12-x speed-up,
saving 5.5 minutes, when removing a 1-million-empty-file directory.

----------------------------------------
Timing rm -rf million-file-dir vs. ext4 on a 120GB OCZ Summit on Fedora 11
This is using the very latest rm/remove.c from coreutils.git.
The one rewritten to use fts.

Creation took about 63 seconds:
    mkdir d;(cd d && seq 1000000|xargs touch)

Removal with inode-sort preprocessing (the 0.543s is sort duration):
  $ env time ./rm -rf d
  0.543050295
  1.62user 20.13system 0:28.25elapsed 77%CPU (0avgtext+0avgdata 0maxresident)k
  9968inputs+8outputs (0major+74445minor)pagefaults 0swaps

2nd trial: (create million-file dir)
  $ mkdir d;(cd d && seq 1000000|env time xargs touch)
  0.63user 62.14system 1:06.49elapsed 94%CPU (0avgtext+0avgdata 0maxresident)k
  40inputs+16outputs (1major+19701minor)pagefaults 0swaps

Remove it:
  $ env time ./rm -rf d
  0.570515343
  1.72user 18.49system 0:26.45elapsed 76%CPU (0avgtext+0avgdata 0maxresident)k
  0inputs+8outputs (0major+74445minor)pagefaults 0swaps
---------------------------------------------

Repeating, but with fts' sort-on-inode disabled:
  ouch. It would have taken about 6 minutes.
  I killed it after ~3, when it had removed half of the entries.

Conclusion:
  Even on an SSD, this sort-on-inode preprocessing gives more
  than a 10-x speed-up when removing a 1-million-empty-file directory.
  Hence, fts does not need access to the "rotational" bit, after all.
