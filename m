Return-Path: <linux-kernel-owner+w=401wt.eu-S1761504AbZDQOjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761504AbZDQOjV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 10:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756821AbZDQOjM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 10:39:12 -0400
Received: from mail-bw0-f163.google.com ([209.85.218.163]:48212 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754867AbZDQOjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 10:39:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=jr8HXulz0yHftrneexaR0pDcBhj9uze2HZ593KpG9aam6mvkI8dd9dLh8ACv1C5aPh
         fbpSBFL3r8tGQOxyaNED3pDuKGiqoWavNBSubE6Q6F2V9+Ipxyigztli9JXdHfudBLjm
         wgTZt0tYqtfDGVFhbLB5pkjqpNndyi7A4wZBo=
Date: Fri, 17 Apr 2009 16:39:05 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Theodore Tso <tytso@mit.edu>, Paul Menage <menage@google.com>,
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
Message-ID: <20090417143903.GA30365@linux>
Mail-Followup-To: Jens Axboe <jens.axboe@oracle.com>,
	Theodore Tso <tytso@mit.edu>, Paul Menage <menage@google.com>,
	Balbir Singh <balbir@linux.vnet.ibm.com>,
	Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	agk@sourceware.org, akpm@linux-foundation.org,
	baramsori72@gmail.com, Carl Henrik Lunde <chlunde@ping.uio.no>,
	dave@linux.vnet.ibm.com, Divyesh Shah <dpshah@google.com>,
	eric.rannaud@gmail.com, fernando@oss.ntt.co.jp,
	Hirokazu Takahashi <taka@valinux.co.jp>,
	Li Zefan <lizf@cn.fujitsu.com>, matt@bluehost.com,
	dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
	roberto@unbit.it, Ryo Tsuruta <ryov@valinux.co.jp>,
	Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
	yoshikawa.takuya@oss.ntt.co.jp,
	containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1239740480-28125-1-git-send-email-righi.andrea@gmail.com> <1239740480-28125-10-git-send-email-righi.andrea@gmail.com> <20090417123805.GC7117@mit.edu> <20090417125004.GY4593@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090417125004.GY4593@kernel.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 02:50:04PM +0200, Jens Axboe wrote:
> On Fri, Apr 17 2009, Theodore Tso wrote:
> > On Tue, Apr 14, 2009 at 10:21:20PM +0200, Andrea Righi wrote:
> > > Delaying journal IO can unnecessarily delay other independent IO
> > > operations from different cgroups.
> > > 
> > > Add BIO_RW_META flag to the ext3 journal IO that informs the io-throttle
> > > subsystem to account but not delay journal IO and avoid potential
> > > priority inversion problems.
> > 
> > So this worries me for two reasons.  First of all, the meaning of
> > BIO_RW_META is not well defined, but I'm concerned that you are using
> > the flag in a manner that in a way that wasn't its original intent.
> > I've included Jens on the cc list so he can comment on that score.
> 
> I was actually already on the cc, though with my private mail address! I
> did read the patch this morning and initially thought it was a bad idea
> as well, but then I thought that perhaps it's not that different to view
> journal IO as a form of meta data to some extent.
> 
> But still, putting any sort of value into the meta flag is a bad idea.
> It's assuming that it will get you some sort of extra guarantee, which
> isn't the case. If journal IO is that much more important than other IO,
> it should be prioritized explicitly. I'm not sure there's a good
> solution to this problem.

Exactly, the purpose here is is to prioritize the dispatching of journal
IO requests in the IO controller. I may have used an inappropriate flag
or a quick&dirty solution, but without this, any cgroup/process that
generates a lot of journal activity may be throttled and cause other
cgroups/processes to be incorrectly blocked when they try to write to
disk.

> 
> > Secondly, there are many more locations than these which can end up
> > causing I/O which will ending up causing the journal commit to block
> > until they are completed.  I've done a lot of work in the past few
> > weeks to make sure those writes get marked using BIO_RW_SYNC.  In
> > data=ordered mode, the journal commit will block waiting for data
> > blocks to be written out, and that implies you really need to treat as
> > high priority all of the block writes that are marked with the
> > BIO_RW_SYNC flag.
> > 
> > The flip side of this is it may end up making your I/O controller to
> > leaky; that is, someone might be able to evade your I/O controller's
> > attempt to impose limits by using fsync() all the time.  This is a
> > hard problem, though, because filesystem I/O is almost always
> > intertwined.
> > 
> > What sort of scenarios and workloads are you envisioning might use
> > this I/O controller?  And can you say more about the specifics about
> > the priority inversion problem you are concerned about?
> 
> I'm assuming it's the "usual" problem with lower priority IO getting
> access to fs exclusive data. It's quite trivial to cause problems with
> higher IO priority tasks then getting stuck waiting for the low priority
> process, since they also need to access that fs exclusive data.

Right. I thought about using the BIO_RW_SYNC flag instead, but as Ted
pointed out, some cgroups/processes might be able to evade the IO
control issuing a lot of fsync()s. We could also limit the fsync()-rate
into the IO controller, but it sounds like a dirty workaround...

> 
> CFQ includes a vain attempt at boosting the priority of such a low
> priority process if that happens, see the get_fs_excl() stuff in
> lock_super(). reiserfs also marks the process as holding fs exclusive
> resources, but it was never added to any of the other file systems. But
> we could improve that situation. The file system is really the only one
> that can inform us of such an issue.

What about writeback IO? get_fs_excl() only refers to the current
process. At least for the cgroup io-throttle controller we can't delay
writeback requests that hold exclusive access resources. For this reason
encoding this information in the IO request (or better using a flag in
struct bio) seems to me a better solution.

-Andrea
