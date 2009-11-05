Return-Path: <linux-kernel-owner+w=401wt.eu-S1759046AbZKEX3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759046AbZKEX3A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 18:29:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758986AbZKEX27
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 18:28:59 -0500
Received: from smtp3-g21.free.fr ([212.27.42.3]:47568 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758976AbZKEX27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 18:28:59 -0500
From: Jim Meyering <jim@meyering.net>
To: Theodore Tso <tytso@mit.edu>
Cc: Ulrich Drepper <drepper@gmail.com>, Ulrich Drepper <drepper@redhat.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bug-coreutils@gnu.org
Subject: Re: make getdents/readdir POSIX compliant wrt mount-point dirent.d_ino
In-Reply-To: <20091105194858.GP6510@mit.edu> (Theodore Tso's message of "Thu,
	5 Nov 2009 14:48:58 -0500")
References: <87y6oyhkz8.fsf@meyering.net> <20090901201943.GB6996@mit.edu>
	<a36005b50909011503y73efdf56yabc4d981db2989bc@mail.gmail.com>
	<87my32rsw3.fsf@meyering.net> <20091105194858.GP6510@mit.edu>
Date: Fri, 06 Nov 2009 00:28:56 +0100
Message-ID: <874op8lfev.fsf@meyering.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> On Wed, Nov 04, 2009 at 08:29:00PM +0100, Jim Meyering wrote:
>> One way to accommodate the current automount semantics, is to make fts.c
>> incur, _for every directory traversed_, the cost of an additional
>> stat (fstatat, actually) call just in case this happens to be one of
>> those rare mount points.
>>
>> I would really rather not pessimize most[*] hierarchy-traversing
>> command-line tools by up to 17% (though usually far less) in order
>> to accommodate device-number change semantics that arise
>> for an automountable directory.
>
> I must be missing something.  How do you come up with the 17% penalty
> figure?  And what does this actually mean in real life?

Actually, it can approach 25%.  See below.

> stat() in Linux is fast.  Really fast.

Sure.  But so are chown, rm, du, etc.
And an extra stat can make more than a measurable difference.
On an absolute scale, the difference is not prohibitive,
but wouldn't it be a shame to penalize everyone
for a feature that some of us don't ever use?

> A quick benchmark clocks
> stat() on my system at 0.814 *microseconds* in the warm cache case,
> and if you're stating a directory that you've traversed, odds are
> extremely high that it will still be in the cache.
>
> My entire laptop root filesystem has 53,934 directories, so an extra
> stat() per directory translates to an extra 43 milliseconds, assuming
> I needed to walk my entire root filesystem.  It's really hard to see
> why kernel developers should get worked up into a lather over that
> kind of "performance penalty".

Here's a comparison with fewer than 5000 directories:
Given a directory named z, with 70 subdirs, each containing 70 empty subdirs.
All names are in 0..69.  Hot cache.  On a tmpfs file system.
linux 2.6.31.1-56.fc12.x86_64

Compare chgrp -R applied to "z", with and without the stat-adding patch:

  $ for i in 1 2 3; do for p in prev .; do echo $p; \
    env time $p/chgrp -R group2 z; done; done;
  prev
  0.03user 0.31system 0:00.34elapsed 99%CPU (0avgtext+0avgdata 0maxresident)k
  0inputs+0outputs (0major+235minor)pagefaults 0swaps
  .
  0.02user 0.39system 0:00.42elapsed 99%CPU (0avgtext+0avgdata 0maxresident)k
  0inputs+0outputs (0major+235minor)pagefaults 0swaps
  prev
  0.03user 0.30system 0:00.34elapsed 99%CPU (0avgtext+0avgdata 0maxresident)k
  0inputs+0outputs (0major+235minor)pagefaults 0swaps
  .
  0.04user 0.38system 0:00.43elapsed 96%CPU (0avgtext+0avgdata 0maxresident)k
  0inputs+0outputs (0major+236minor)pagefaults 0swaps
  prev
  0.03user 0.31system 0:00.34elapsed 99%CPU (0avgtext+0avgdata 0maxresident)k
  0inputs+0outputs (0major+236minor)pagefaults 0swaps
  .
  0.04user 0.37system 0:00.41elapsed 99%CPU (0avgtext+0avgdata 0maxresident)k
  0inputs+0outputs (0major+235minor)pagefaults 0swaps

That's a 23.5% performance hit. (42-34)/34

Sure, it's not even 1/10th of a second, but remember this is a tiny
hierarchy, and it's not just chgrp, but also find, rm, du, etc. that
are affected.  And this is not the sole reason to make a change, but
rather one more reason, in addition to the one that started this thread.
