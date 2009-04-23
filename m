Return-Path: <linux-kernel-owner+w=401wt.eu-S1757207AbZDWKcZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757207AbZDWKcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 06:32:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755814AbZDWKcO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 06:32:14 -0400
Received: from hera.kernel.org ([140.211.167.34]:57872 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996AbZDWKcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 06:32:14 -0400
Message-ID: <49F043A4.2060700@kernel.org>
Date: Thu, 23 Apr 2009 19:32:04 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: linux-kernel@vger.kernel.org, fuse-devel@lists.sourceforge.net
Subject: Re: [PATCHSET] CUSE: implement CUSE, take #3
References: <1239674094-30894-1-git-send-email-tj@kernel.org> <E1Lwanr-00041r-RP@pomaz-ex.szeredi.hu> <49EFB1A9.3060503@kernel.org> <E1LwvrC-00068P-5r@pomaz-ex.szeredi.hu>
In-Reply-To: <E1LwvrC-00068P-5r@pomaz-ex.szeredi.hu>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Thu, 23 Apr 2009 10:31:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Miklos Szeredi wrote:
> VFS inode should never be needed by the CUSE codepaths.  Well, maybe
> for setting access/modification times, but in any case those need not
> be shared with fuse code.

One more usage: locking.

>>> I still think that the INIT sequence in CUSE is way too complicated
>>> and that the kernel thread is unnecessary.  How about doing the init
>>> with a single CUSE_INIT message which embeds the fuse_init_in and
>>> fuse_init_out structures.
>> I don't see why the kernel thread is such a big problem.  It's just a
>> kernel thread.
> 
> I think it's an unnecessary complication.  Threads are useful if
> something needs to be _done_, but in this case nothing is done, just
> waiting for the reply.  One example why I find it hackish is that you
> are returning error values from the thread, as if it was a synchronous
> thing, but those errors are obviously lost.

That doesn't have anything to do with whether it's done in kernel
thread or not.  If that bothers you, just make it return 0 with
comment /* return value ignored */.

> I don't see any problems with doing the device initialization in the
> context of the replying process (which will usually be the same as
> the one opening the device anyway).

I don't know.  If it's simple, sure why not.  If it makes things even
marginally more complex (state saving and so on), why go that way?

In my first job, I used to work on a quite complex state machine based
server which had to do almost everything in multiple functions.  In
the end, it was extremely ugly and ultimately the wrong kind of
optimization, so I much prefer having a stack whenever it makes things
simpler and the overhead isn't an issue.  What are the actual benefits
of doing things in several different functions in this case?
Performance definitely is not a concern here.

>>  We can surely fold FUSE_INIT inside FUSE_INIT tho but
>> one way or the other doesn't make whole lot of difference.
> 
> I just think it would be cleaner, both code-wise and protocol-wise.  I
> can do the above cleanups if you have no objection.

Sure, if you think things would be better that way.  Please go ahead.

Thanks.

-- 
tejun
