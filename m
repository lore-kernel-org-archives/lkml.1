Return-Path: <linux-kernel-owner+w=401wt.eu-S1758209AbZDOC75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758209AbZDOC75 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 22:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752364AbZDOC7r
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 22:59:47 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60373 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752796AbZDOC7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 22:59:46 -0400
Date: Wed, 15 Apr 2009 11:58:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Dan Malek <dan@embeddedalley.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Paul Menage <menage@google.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH] Memory usage limit notification addition to memcg
Message-Id: <20090415115811.0d609e52.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <70C851F4-3BEA-4DF0-943E-4740A2E5A844@embeddedalley.com>
References: <1239660512-25468-1-git-send-email-dan@embeddedalley.com>
	<20090415093555.d84b6655.kamezawa.hiroyu@jp.fujitsu.com>
	<70C851F4-3BEA-4DF0-943E-4740A2E5A844@embeddedalley.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Apr 2009 19:34:04 -0700
Dan Malek <dan@embeddedalley.com> wrote:

> 
> Hi Kame.
> 
> On Apr 14, 2009, at 5:35 PM, KAMEZAWA Hiroyuki wrote:
> 
> > Welcome to memory cgroup world :)
> 
> Thanks.  I think it's a great feature that will be realized
> over time.
> 
> I was just about to resend the patch, so I'll incorporate
> your comments.  I'll reply to some below as well.
> 
> > As Andrew pointed out, "percent" is not good.
> 
> I updated this to add more granularity, to xx.yy
> I can't comprehend why this is a problem.  Conceptually,
> it works very well with the applications I have used.  If
> you guys really want to use an absolute number for a
> notification limit,  we can change it, but I really don't
> want to :-)
> 
Memory cgroup is a feature both for very-small-system and very-large-system.

XXMB(KB) for limit is an idea.
# echo 100MB > memory.limit_in_bytes.
# echo 5MB > memory.notify_triger_thresh_in_bytes.

Notify will be generated at 95MB of usage.


> >> +The memory.notify_limit_lowait is a blocking read file.  The read  
> >> will
> >> +block until one of four conditions occurs:
> >> +
> >> +    - The usage reaches or exceeds the memory.notify_limit_percent
> >> +    - The memory.notify_limit_lowait file is written with any  
> >> value (debug)
> >> +    - A thread is moved to another controller group
> >
> > Why don't you check "moved from other cgroup" case ?
> > And why "moved to" case should be catched ?
> 
> Sorry, badly worded.  The test is actually when a task moves from
> a cgroup.  If a task is moved from one cgroup to another, the threads
> waiting for notification in the "from" group are poked to wake up.
> I didn't see the need to wake up anyone in the cgroup it may move into.
> 
> > I think it's better to remove this CONFIG.
> 
> OK.  Should I just add the documentation to
> Documentation/cgroups/memory.txt or leave it stand alone?

Both are ok to me  Please do as you want.

> BTW, all of the ifdefs are removed even with the CONFIG
> option.  I just thought if someone was really counting cycles,
> wanted memcg without notify, it was easy to do that.
> 
> > I don't think this it is sane manner to check this limit  
> > always...If this mem_notify is
> > not required to as "hard limit", please reduce # of checks.
> > How about once per 1MBytes ?
> > One notified, the applications can keep observation for a while.
> 
> The overhead is small, and this kind of contradicts Andrew's
> comment about wanting finer granularity.  Also, the test would have
> to be scaled to match the size of the cgroup, on some of the
> embedded systems 1M could be a measurable percentage.

maybe. But this kind of overhead is tend to increase gradually and implicitly.
Doing our best here will help us in future, I think.

> But, let me think of some other way to do the math.  I think I'll turn
> it around, do the percentage computation only to the application,
> not internally.
> 
Thanks.

> > Hmm, I think this "lim" can be calculated when the user does "set  
> > limit" or
> > "set notify_percent".
> 
> Yeah, probably.
> 
> > And...please wake up all waiting thread at rmdir(). If not, rmdir()  
> > will return
> > -EBUSY always.
> 
> OK, I'll check to make sure this still works.  An empty cgroup causes  
> the
> notification thread to not sleep and returns zero.
> 
Sure, thanks.


> >> +#ifdef CONFIG_CGROUP_MEM_NOTIFY
> >> +	init_waitqueue_head(&mem->notify_limit_wait);
> >> +	mem->notify_limit_percent = 100;
> >> +#endif
> >> +
> >
> > I think this means notify is triggerred at every "reach limit"...
> > mem->notify_limit_percent = 101 or some is better.
> 
> I just didn't want it to be zero :-)  I think I'll leave it at 100  
> because
> that's a legal value.  Although, maybe we should allow setting up
> to 101 as a way of a preventing notification even if threads are
> waiting.
> 
> > Hmm. I'll add follwing interface if you necessary. (Or it's ok to  
> > add in your set."
> >
> >   - memory.shirnk_usage_in_bytes
> >   example)
> >   #echo 1G > memory.limit_in_bytes.
> >   use up to 999MB.
> >   #echo 100M > memory.shrink_usage_to_bytes.
> >         try to reduce 100M of memory usage of this cgroup. and make  
> > memory usage to be 899MB.
> 
> I understand the idea, but what happens if you can't?
returns -BUSY. (or timeout) following is example in my mind.

The VM monitor application will work like
==
    while () {
         poll(or read) event notify.
         check the usage

         if (usage is enough small)
               continue;

         if (the most of usage is file cache)
               try-to-reduce-usage-only-file-cache.  #need support in the kernel
 
         if (usage is enough small)
               continue;

         if (hierarchy is used)
               check bad children.

         ret = try-to-reduce-usage-general()  #need support in the kernel.
         if (ret == -EBUSY && usage is too much) {
             show warning to users. 
             kill/freeze or move tasks. or check locked shmem/tmpfs.
         }
    }
==
Of course, this monitor process should be out of limited memcg ;)

> Of course, the proper way is to do this automatically
> when the task is moved out :-)
> 
> I'll think about all of this for a bit and then submit an
> updated patch.
> 

Regards,
-Kame

> Thanks.
> 
> 	-- Dan
> 
> 

