Return-Path: <linux-kernel-owner+w=401wt.eu-S1762468AbZDQXM7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762468AbZDQXM7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Apr 2009 19:12:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbZDQXMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Apr 2009 19:12:51 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:44672 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbZDQXMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Apr 2009 19:12:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=MO5WOuJ8E8bg7/e4mz37WMfgquYIC+MTD4PX6OmzJzFfbtNnRH57jAiAkBg8U4Btq4
         bw4CFNCKRcbLP+ugnz21OEsZS9om1FoRsn1WKuFuW0wrbVpyMgnTbfFV59kGQFjcFMyP
         SSMRq1No/fni2VXoEEgaDvpYYTpoeqLmBxzMU=
Date: Sat, 18 Apr 2009 01:12:45 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Paul Menage <menage@google.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, agk@sourceware.org,
       akpm@linux-foundation.org, axboe@kernel.dk, baramsori72@gmail.com,
       Carl Henrik Lunde <chlunde@ping.uio.no>, dave@linux.vnet.ibm.com,
       Divyesh Shah <dpshah@google.com>, eric.rannaud@gmail.com,
       fernando@oss.ntt.co.jp, Hirokazu Takahashi <taka@valinux.co.jp>,
       Li Zefan <lizf@cn.fujitsu.com>, matt@bluehost.com,
       dradford@bluehost.com, ngupta@google.com, randy.dunlap@oracle.com,
       roberto@unbit.it, Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/9] io-throttle documentation
Message-ID: <20090417231244.GB6972@linux>
Mail-Followup-To: Vivek Goyal <vgoyal@redhat.com>,
	Paul Menage <menage@google.com>,
	Balbir Singh <balbir@linux.vnet.ibm.com>,
	Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	agk@sourceware.org, akpm@linux-foundation.org, axboe@kernel.dk,
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
References: <1239740480-28125-1-git-send-email-righi.andrea@gmail.com> <1239740480-28125-2-git-send-email-righi.andrea@gmail.com> <20090417173955.GF29086@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090417173955.GF29086@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 01:39:55PM -0400, Vivek Goyal wrote:
> On Tue, Apr 14, 2009 at 10:21:12PM +0200, Andrea Righi wrote:
> 
> [..]
> > +4.2. Buffered I/O (write-back) tracking
> > +
> > +For buffered writes the scenario is a bit more complex, because the writes in
> > +the page cache are processed asynchronously by kernel threads (pdflush), using
> > +a write-back policy. So the real writes to the underlying block devices occur
> > +in a different I/O context respect to the task that originally generated the
> > +dirty pages.
> > +
> > +The I/O bandwidth controller uses the following solution to resolve this
> > +problem.
> > +
> > +If the operation is a buffered write, we can charge the right cgroup looking at
> > +the owner of the first page involved in the I/O operation, that gives the
> > +context that generated the I/O activity at the source. This information can be
> > +retrieved using the page_cgroup functionality originally provided by the cgroup
> > +memory controller [4], and now provided specifically by the bio-cgroup
> > +controller [5].
> > +
> > +In this way we can correctly account the I/O cost to the right cgroup, but we
> > +cannot throttle the current task in this stage, because, in general, it is a
> > +different task (e.g., pdflush that is processing asynchronously the dirty
> > +page).
> > +
> > +For this reason, all the write-back requests that are not directly submitted by
> > +the real owner and that need to be throttled are not dispatched immediately in
> > +submit_bio(). Instead, they are added into an rbtree and processed
> > +asynchronously by a dedicated kernel thread: kiothrottled.
> > +
> 
> Hi Andrea,

Hi Vivek,

> 
> I am trying to go through your patches now and also planning to test it

thanks for trying to test first of all.

> out. While reading the documentation async write handling interested
> me. IIUC, looks like you are throttling writes once they are being 
> written to the disk (either by pdflush or in the context of the process
> because vm_dirty_ratio crossed etc).

Correct, more exactly in submit_bio().

The difference between synchronous IO and writeback IO is that in the
first case the task itself is throttled via schedule_timeout_killable();
in the second case pdflush is never throttled, the IO requests instead
are simply added into a rbtree and dispatched asynchronously by another
kernel thread (kiothrottled) using a EDF-like scheduling. More exactly,
a deadline is evaluated for each writeback IO request looking at the
cgroup BW and iops/sec limits, then kiothrottled periodically selects
and dispatches the requests with an elapsed deadline.

> 
> If that's the case, will a process not see an increased rate of writes
> till we are not hitting dirty_background_ratio?

Correct. And this is a good behaviour IMHO. At the same time we have a
smooth BW usage (according to the cgroup limits I mean) even in presence
of writeback IO only.

> 
> Secondly, if above is giving acceptable performance resutls, then we
> should be able to provide max bw control at IO scheduler level (along
> with proportional bw control)?
> 
> So instead of doing max bw and proportional bw implementation in two
> places with the help of different controllers, I think we can do it
> with the help of one controller at one place. 
> 
> Please do have a look at my patches also to figure out if that's possible
> or not. I think it should be possible.
> 
> Keeping both at single place should simplify the things.

Absolutely agree to do both proportional and max BW limiting in a single
place. I still need to figure which is the best place, if the IO
scheduler in the elevator, when the IO requests are submitted. A natural
way IMHO is to control the submission of requests, also Andrew seemed to
be convinced about this approach. Anyway, I've already scheduled to test
your patchset and I'd like to see if it's possible to merge our works,
or select the best from ours patchsets.

Thanks!
-Andrea
