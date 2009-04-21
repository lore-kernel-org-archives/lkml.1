Return-Path: <linux-kernel-owner+w=401wt.eu-S1755447AbZDUIa0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbZDUIa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 04:30:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753610AbZDUIaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 04:30:10 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:35879 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754AbZDUIaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 04:30:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IEZzI8B8rR6+t1FVSwkBuouAuFRVuwLuBefEHRVopRxPjOcYKepVvUkpeFUOTbO4Pl
         0hrTo73m1Tk65R81gwb8tHZF5a17lv+it5aZryD25rRJC93twbZDmSx7c6cQkPhCOIdp
         HmFN5kZIMZxLnhRGFJUMypZWGUJZcGKqC67ms=
Date: Tue, 21 Apr 2009 10:30:02 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: Theodore Tso <tytso@mit.edu>
Cc: Jens Axboe <jens.axboe@oracle.com>, Paul Menage <menage@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, agk@sourceware.org,
       akpm@linux-foundation.org, baramsori72@gmail.com,
       Carl Henrik Lunde <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
       Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, Hirokazu Takahashi <taka@valinux.co.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, matt@bluehost.com,
       dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 9/9] ext3: do not throttle metadata and journal IO
Message-ID: <20090421083001.GA8441@linux>
References: <1239740480-28125-1-git-send-email-righi.andrea@gmail.com> <1239740480-28125-10-git-send-email-righi.andrea@gmail.com> <20090417123805.GC7117@mit.edu> <20090417125004.GY4593@kernel.dk> <20090417143903.GA30365@linux> <20090421001822.GB19186@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090421001822.GB19186@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 08:18:22PM -0400, Theodore Tso wrote:
> On Fri, Apr 17, 2009 at 04:39:05PM +0200, Andrea Righi wrote:
> > 
> > Exactly, the purpose here is is to prioritize the dispatching of journal
> > IO requests in the IO controller. I may have used an inappropriate flag
> > or a quick&dirty solution, but without this, any cgroup/process that
> > generates a lot of journal activity may be throttled and cause other
> > cgroups/processes to be incorrectly blocked when they try to write to
> > disk.
> 
> With ext3 and ext4, all journal I/O requests end up going through
> kjournald.  So the question is what I/O control group do you put
> kjournald in?  If you unrestrict it, it makes the problem go away
> entirely.  On the other hand, it is doing work on behalf of other
> processes, and there is no real way to separate out on whose behalf
> kjournald is doing said work.  So I'm not sure fundamentally you'll be
> able to do much with any filesystem journalling activity --- and ext3
> makes life especially bad because of data=ordered mode. 

OK, I've just removed the ext3/ext4 patch from io-throttle v14 and
results are pretty the same. BTW I can't even prioritize all the
BIO_RW_SYNC, because in this way all the direct IO would be never
limited at all. Or at least I should add something like a
is_in_direct_io() check or kind of.

Anyway, I agree and I think it's reasonable to always leave kiojournald
into the root cgroup, and doesn't set any IO limit for that cgroup.

But I wouldn't add additional checks for this, at the end we know that
"Unix gives you just enough rope to hang yourself".

> 
> > > I'm assuming it's the "usual" problem with lower priority IO getting
> > > access to fs exclusive data. It's quite trivial to cause problems with
> > > higher IO priority tasks then getting stuck waiting for the low priority
> > > process, since they also need to access that fs exclusive data.
> > 
> > Right. I thought about using the BIO_RW_SYNC flag instead, but as Ted
> > pointed out, some cgroups/processes might be able to evade the IO
> > control issuing a lot of fsync()s. We could also limit the fsync()-rate
> > into the IO controller, but it sounds like a dirty workaround...
> 
> Well, if you use data=writeback or Chris Mason's proposed data=guarded
> mode, then at least all of the data blocks will be written process
> context of the application, and not kjournald's process context.  So
> one solution that might be the best that we have for now is to treat
> kjournald as special from an I/O controller point of view (i.e., give
> it its own cgroup), and then use a filesystem mode which avoids data
> blocks getting written in kjournald (i.e., ext3 data=wirteback or
> data=guarded, ext4's delayed allocation, etc.)

Agree.

> 
> One major form of leakage that you're still going to have is pdflush;
> which again, is more I/O happening in somebody else's process context.
> Ultimately I think trying to throttle I/O at write submission time
> whether at entry into block layer or in the elevators, is going to be
> highly problematic.  Suppose someone dirties a large number of pages?
> That's a system resource, and delaying the writes because a particular
> container has used more than its fair share will cause the entire
> system to run out of memory, which is not a good thing.
> 
> Ultimately, I think you'll need to do is write throttling, and suspend
> processes that are dirtying too many pages, instad of trying to
> control the I/O.

We're trying to address also this issue, setting max dirty pages limit
per cgroup, and force a direct writeback when these limits are exceeded.

In this case dirty ratio throttling should happen automatically because
the process will be throttled by the IO controller when it tries to
writeback the dirty pages and submit IO requests.

What's your opinion?

Thanks,
-Andrea
