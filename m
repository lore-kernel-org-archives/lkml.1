Return-Path: <linux-kernel-owner+w=401wt.eu-S1758439AbZC0Vxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758439AbZC0Vxl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 17:53:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751428AbZC0Vxc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 17:53:32 -0400
Received: from mail-in-01.arcor-online.net ([151.189.21.41]:36034 "EHLO
	mail-in-01.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750738AbZC0Vxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 17:53:31 -0400
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-10.arcor-online.net 8147C28EEA5
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: Linux 2.6.29
To: Theodore Tso <tytso@mit.edu>, Theodore Tso <tytso@mit.edu>,
       Matthew Garrett <mjg59@srcf.ucam.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Reply-To: 7eggert@gmx.de
Date: Fri, 27 Mar 2009 22:53:26 +0100
References: <cjGbn-6Xx-35@gated-at.bofh.it> <cjGl4-7ak-61@gated-at.bofh.it> <cjJsv-3Uu-5@gated-at.bofh.it> <cjKHX-5MF-19@gated-at.bofh.it> <ck7XP-JA-13@gated-at.bofh.it> <ck8h7-18H-1@gated-at.bofh.it> <ck8AA-1y0-7@gated-at.bofh.it> <ck8Kd-20o-7@gated-at.bofh.it> <ckaVR-5o8-9@gated-at.bofh.it> <ckbf4-5M8-7@gated-at.bofh.it> <ckcE8-845-9@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7Bit
Message-Id: <E1LnJzS-0001vn-Vf@be1.7eggert.dyndns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso <tytso@mit.edu> wrote:
> On Fri, Mar 27, 2009 at 03:47:05AM +0000, Matthew Garrett wrote:

>> Oh, for the love of a whole range of mythological figures. ext3 didn't
>> train application programmers that they could be careless about fsync().
>> It gave them functionality that they wanted, ie the ability to do things
>> like rename a file over another one with the expectation that these
>> operations would actually occur in the same order that they were
>> generated. More to the point, it let them do this *without* having to
>> call fsync(), resulting in a significant improvement in filesystem
>> usability.

> There were plenty of applications that were written for Unix *and*
> Linux systems before ext3 existed, and they worked just fine.  Back
> then, people were drilled into the fact that they needed to use
> fsync(), and fsync() wan't expensive, so there wasn't a big deal in
> terms of usability.  The fact that fsync() was expensive was precisely
> because of ext3's data=ordered problem.  Writing files safely meant
> that you had to check error returns from fsync() *and* close().

> In fact, if you care about making sure that data doesn't get lost due
> to disk errors, you *must* call fsync().

People don't care about data getting lost if hell breaks lose, but they
care if you ensure that killing the data happens, while keeping the data
is delayed.

Or more simple: Old state: good. New state: good. Inbetween state: bad.
And journaling with delayed data is exposing the inbetween state for
a long period.

> Pavel may have complained 
> that fsync() can sometimes drop errors if some other process also has
> the file open and calls fsync() --- but if you don't, and you rely on
> ext3 to magically write the data blocks out as a side effect of the
> commit in data=ordered mode, there's no way to signal the write error
> to the application, and you are *guaranteed * to lose the I/O error
> indication.

Fortunately, IO errors are not common, and errors=remount-ro will
prevent it from being fatal.

> I can tell you quite authoritatively that we didn't implement
> data=ordered to make life easier for application writers, and
> application writers didn't come to ext3 developers asking for this
> convenience.  It may have **accidentally** given them convenience that
> they wanted, but it also made fsync() slow.

data=ordered is a sane way of handling data. Otherwise, the millions
would change their ext3 to data=writeback.

>> I'm utterly and screamingly bored of this "Blame userspace" attitude.
> 
> I'm not blaming userspace.  I'm blaming ourselves, for implementing an
> attractive nuisance, and not realizing that we had implemented an
> attractive nuisance; which years later, is also responsible for these
> latency problems, both with and without fsync() ---- *and* which have
> also traied people into believing that fsync() is always expensive,
> and must be avoided at all costs --- which had not previously been
> true!

I've been waiting ages for a sync() to complete long before reiserfs was
out to make ext2 jealous. Besides that, I don't need the data to be on disk,
I need the update to be mostly-atomic, leaving only small gaps to destroy my
data. Pure chance can (and usually will) give me a better guarantee than what
ext4 did.

I don't know about the logic you put into ext4 to work around the issue, but
I can imagine marking empty-file inodes (and O_APPEND or any i~?) as poisoned
if delayed blocks are appended, and if these poisoned inodes (and depending
operations) don't get played back, it might work acceptably.

