Return-Path: <linux-kernel-owner+w=401wt.eu-S1757211AbZDRIOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757211AbZDRIOI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Apr 2009 04:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753947AbZDRINv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Apr 2009 04:13:51 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:5889 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561AbZDRINt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Apr 2009 04:13:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=WfzMj0LvuKGrJjXYtrtZB0ef3V4hVUbPUOVOnmBXx6TPqJj+WO2LvovDGzYKa00WlB
         GMQZFSJx5hq7GVhnXZA0RxSPU/ORAAbBkqRb0eujQqWuFLlC1lvrfWobUzJ+EL40HmRp
         YsciOOXvVXzft6u5XdXgeazLM/cIv1sm1WRJQ=
Date: Sat, 18 Apr 2009 10:13:44 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: Nauman Rafique <nauman@google.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, axboe@kernel.dk,
       ryov@valinux.co.jp, fernando@intellilink.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, arozansk@redhat.com,
       jmoyer@redhat.com, oz-kernel@redhat.com, dhaval@linux.vnet.ibm.com,
       balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, menage@google.com,
       peterz@infradead.org, matt@bluehost.com, dradford@bluehost.com
Subject: Re: IO controller discussion (Was: Re: [PATCH 01/10] Documentation)
Message-ID: <20090418081343.GB5566@linux>
Mail-Followup-To: Nauman Rafique <nauman@google.com>,
	Vivek Goyal <vgoyal@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>, dpshah@google.com,
	lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
	paolo.valente@unimore.it, axboe@kernel.dk, ryov@valinux.co.jp,
	fernando@intellilink.co.jp, s-uchida@ap.jp.nec.com,
	taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, arozansk@redhat.com,
	jmoyer@redhat.com, oz-kernel@redhat.com, dhaval@linux.vnet.ibm.com,
	balbir@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
	containers@lists.linux-foundation.org, menage@google.com,
	peterz@infradead.org, matt@bluehost.com, dradford@bluehost.com
References: <1236823015-4183-2-git-send-email-vgoyal@redhat.com> <20090312001146.74591b9d.akpm@linux-foundation.org> <20090312180126.GI10919@redhat.com> <49D8CB17.7040501@gmail.com> <20090407064046.GB20498@redhat.com> <20090408203756.GB10077@linux> <20090416183753.GE8896@redhat.com> <20090417093656.GA5246@linux> <20090417141358.GD29086@redhat.com> <e98e18940904171109r17ccb054kb7879f8d02ac26b5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e98e18940904171109r17ccb054kb7879f8d02ac26b5@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 17, 2009 at 11:09:51AM -0700, Nauman Rafique wrote:
> > Thinking more about it. Memory controller can probably enforce the higher
> > limit but it would not easily translate into a fixed upper async write
> > rate. Till the process hits the page cache limit or is slowed down by
> > dirty page writeout, it can get a very high async write BW.
> >
> > So memory controller page cache limit will help but it would not direclty
> > translate into what max bw limit patches are doing.
> >
> > Even if we do max bw control at IO scheduler level, async writes are
> > problematic again. IO controller will not be able to throttle the process
> > until it sees actuall write request. In big memory systems, writeout might
> > not happen for some time and till then it will see a high throughput.
> >
> > So doing async write throttling at higher layer and not at IO scheduler
> > layer gives us the opprotunity to produce more accurate results.
> 
> Wouldn't 'doing control on writes at a higher layer' have the same
> problems as the ones we talk about in dm-ioband? What if the cgroup
> being throttled for dirtying pages has a high weight assigned to it at
> the IO scheduler level? What if there are threads of different classes
> within that cgroup, and we would want to let RT task dirty the pages
> before BE tasks? I am not sure all these questions make sense, but
> just wanted to raise issues that might pop up.

To a large degree, this seems to be related to provide "fair throttling"
at higher level. I mean, throttle equally the tasks belongin to a cgroup
that exceeded the limits. With equally I mean proportionally to the IO
traffic previously generated _and_ the IO priority.

Otherwise a low priority task doing a lot of IO can consumes all the
available cgroup BW and other high priority tasks in the same cgroup may
be blocked when they try to write to disk, even if they try to write a
small amount of bytes.

> 
> If the whole system is designed with cgroups in mind, then throttling
> at IO scheduler layer should lead to backlog, that could be seen at
> higher level. For example, if a cgroup is not getting service at IO
> scheduler level, it should run out of request descriptors, and thus
> the thread writing back dirty pages should notice it (if its pdflush,
> blocking it is probably not the best idea). And that should mean the
> cgroup should hit the dirty threshold, and disallow the task to dirty
> further pages. There is a possibility though that getting all this
> right might be an overkill and we can get away with a simpler
> solution. One possibility seems to be that we provide some feedback
> from IO scheduling layer to higher layers, that cgroup is hitting its
> write bandwith limit, and should not be allowed to dirty any more
> pages.
> 

IMHO accounting the IO activity in the IO scheduler and blocking the
offending application at the higher level is a good solution.

Throttle dirty page ratio could be a nice feature, but probably it's
enough to provide a max amount of dirty pages per cgroup and force the
tasks to directly writeback those pages when the cgroup exceeded the
dirty limit. In this way the dirty page ratio will be automatically
throttled by the underlying IO controller.

-Andrea
