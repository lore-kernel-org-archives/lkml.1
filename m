Return-Path: <linux-kernel-owner+w=401wt.eu-S936166AbXGZVrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936166AbXGZVrp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 17:47:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932259AbXGZVrh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 17:47:37 -0400
Received: from ra.tuxdriver.com ([70.61.120.52]:3723 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763232AbXGZVrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 17:47:36 -0400
Date: Thu, 26 Jul 2007 17:46:33 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, wwoods@redhat.com
Subject: Re: [PATCH] core_pattern: Add ability for core_pattern to parse arguments when pattern is a pipe
Message-ID: <20070726214633.GA11008@hmsreliant.homelinux.net>
References: <20070726173923.GA5701@hmsreliant.homelinux.net> <20070726114832.faf14bb0.akpm@linux-foundation.org> <20070726193145.GC5701@hmsreliant.homelinux.net> <20070726124731.0b7c4ecc.akpm@linux-foundation.org> <20070726202018.GA10490@hmsreliant.homelinux.net> <20070726133536.f8bb16cc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070726133536.f8bb16cc.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2007 at 01:35:36PM -0700, Andrew Morton wrote:
> On Thu, 26 Jul 2007 16:20:18 -0400 Neil Horman <nhorman@tuxdriver.com> wrote:
> 
> > If you'd like to back them all out, I have them
> > all in a git tree here, and I can repost (say early next week when I finish
> > local testing) as a patch sequence, with all my screw-ups properly fixed,
> > and with an appropriate changelog describing the whole sequence.
> 
> hm, I have six fixes here against
> allow-individual-core-dump-methods-to-be-unlimited-when-sending-to-a-pipe.patch
> and I always worry that some might get lost.
> 
> How many more patches have you after this one?

I think the best organization that I could give you would leave me with one
patch remaining, for a total of three that you would have to carry:

Patch 1) Removing the RLIMIT_CORE restriction on core_dumps in do_coredump and
the core_dump methods from fs/binfmt_*.c

Patch 2) Add the ability to parse arguments out of
/proc/sys/kernel/core_pattern, along with the ability to specify the origional
RLIMIT_CORE size as an option.

Patch 3) fix up some pre-existing bugs that I found while doing the other work.
Specifically I found that call_usermodehelper_pipe waits for the usermodehelper
to exit.  Since we are redirecting stdin for the helper to a pipe, any reader of
the pipe will cause a deadlock in the do_coredump path.  I want to fix up that
and a few simmilar bugs.

You have the first two as you know, and I plan to be done with the third on
friday or monday.  Just let me know if you would like me to repost the first two
with the third as a sequence set.

As far as the changelog for these three (or six, if you want to count the
interviening fixes separately), you can use this:

For some time now /proc/sys/core_pattern has allowed for the specification that
the output desitination of a core dump be a pipe to a user space process, rather
than a file system location.  This enables a class of applications that allows
for intellegent handling of application crashes.  While the pipe core_pattern
infrastrucutre is beneficial, it is lacking in certain points.  Specifically it
is unable to dump cores if a users core dump ulimit is too low, despite the fact
that no data need be written to a filesystem.  It is also lacking in the sense
that while an application can be specified as the reader end of the pipe,
arguments cannot be currently passed to this application.  This set of patches
seeks to improve this infrastructure by:

1) Ignoring RLIMIT_CORE restrictions when the core destination is a pipe,
relying instead on user space security to prevent oversubscription of resources

2) Allowing arguments to be specified and passed to applications specified in
core_pattern

3) Fixing a few pre-existing bugs discovered during the aforementioned two
development points.


Thanks and Regards
Neil

P.S. Will, please send me email addresses for relevant interested parties from
ubuntu, and I'll happily copy them on these patches.


-- 
/***************************************************
 *Neil Horman
 *Software Engineer
 *Red Hat, Inc.
 *nhorman@tuxdriver.com
 *gpg keyid: 1024D / 0x92A74FA1
 *http://pgp.mit.edu
 ***************************************************/
