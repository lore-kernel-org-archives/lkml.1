Return-Path: <linux-kernel-owner+w=401wt.eu-S1755546AbZENKbn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbZENKbn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 06:31:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752510AbZENKbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 06:31:33 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:56596 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752045AbZENKbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 06:31:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=XYwhvTCNqRXEehT4hyil6xXJwuJADH6paC/mLOLl6cJRfthHbAUA4bZ82TchMbOsSI
         BF1xcKvAh2wDmGIafC5uguXzDgleK6Md0Ra48jLl9TsUqOfoD5l/mmEMnENkqYb+UNUD
         6FQ8YFhHxA/nivhsVV+93pyyJuCklavbyqZNg=
Date: Thu, 14 May 2009 12:31:21 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, jens.axboe@oracle.com,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       agk@redhat.com, dm-devel@redhat.com, snitzer@redhat.com,
       m-ikeda@ds.jp.nec.com, peterz@infradead.org
Subject: Re: IO scheduler based IO Controller V2
Message-ID: <20090514103117.GB2828@linux>
References: <20090506213453.GC4282@linux> <20090506215235.GJ8180@redhat.com> <20090507090450.GA4613@linux> <20090507141126.GA9463@redhat.com> <20090507144501.GB9463@redhat.com> <20090507153642.GC9463@redhat.com> <20090507221900.GA29774@linux> <20090508180951.GG7293@redhat.com> <20090508200458.GA3708@linux> <20090508215618.GJ7293@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090508215618.GJ7293@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 08, 2009 at 05:56:18PM -0400, Vivek Goyal wrote:
> On Fri, May 08, 2009 at 10:05:01PM +0200, Andrea Righi wrote:
> 
> [..]
> > > Conclusion
> > > ==========
> > > It just reaffirms that with max BW control, we are not doing a fair job
> > > of throttling hence no more hold the IO scheduler properties with-in
> > > cgroup.
> > > 
> > > With proportional BW controller implemented at IO scheduler level, one
> > > can do very tight integration with IO controller and hence retain 
> > > IO scheduler behavior with-in cgroup.
> > 
> > It is worth to bug you I would say :). Results are interesting,
> > definitely. I'll check if it's possible to merge part of the io-throttle
> > max BW control in this controller and who knows if finally we'll be able
> > to converge to a common proposal...
> 
> Great, Few thoughts though.
> 
> - What are your requirements? Do you strictly need max bw control or
>   proportional BW control will satisfy your needs? Or you need both?

The theoretical advantages of max BW control are that they offer an
immediate action on policy enforcement mitigating the problem before it
happens (a kind of static partitioning I would say) and that you have
probably something that provides a more explicit control to contain
different classes of users in hosted environment (e.g., give BW in
function on how much they pay). And I can say the io-throttle approach
at the moment seems to work fine for a production environment
(http://www.bluehost.com).

Apart the motivations above, I don't have specific requirements to
provide the max BW control.

But it is also true that the io-controller approach is still in a
development stage and needs more testing. The design concepts make
sense, definitely, so maybe only the proportional approach will be
sufficient to satisfy the requirements of the 90% of users out there.

-Andrea

> 
> - With the current algorithm BFQ (modified WF2Q+), we should be able
>   to do proportional BW division while maintaining the properties of
>   IO scheduler with-in cgroup in hiearchical manner.
>  
>   I think it can be simply enhanced to do max bw control also. That is
>   whenever a queue is selected for dispatch (from fairness point of view)
>   also check the IO rate of that group and if IO rate exceeded, expire
>   the queue immediately and fake as if queue consumed its time slice
>   which will be equivalent to throttling.
> 
>   But in this simple scheme, I think throttling is still unfair with-in
>   the class. What I mean is following.
> 
>   if an RT task and an BE task are in same cgroup and cgroup exceeds its
>   max BW, RT task is next to be dispatched from fairness point of view and it
>   will end being throttled. This is still fine because until RT task is
>   finished, BE task will never get to run in that cgroup, so at some point
>   of time, cgroup rate will come down and RT task will get the IO done
>   meeting fairnesss and max bw constraints.
> 
>   But this simple scheme does not work with-in same class. Say prio 0
>   and prio 7 BE class readers. Now we will end up throttling the guy who
>   is scheduled to go next and there is no mechanism that prio0 and prio7
>   tasks are throttled in proportionate manner.
> 
>   So, we shall have to come up with something better, I think Dhaval was
>   implementing upper limit for cpu controller. May be PeterZ and Dhaval can
>   give us some pointers how did they manage to implement both proportional
>   and max bw control with the help of a single tree while maintaining the
>   notion of prio with-in cgroup.
> 
> PeterZ/Dhaval  ^^^^^^^^
> 
> - We should be able to get rid of reader-writer issue even with above
>   simple throttling mechanism for schedulers like deadline and AS, because at
>   elevator we see it as a single queue (for both reads and writes) and we
>   will throttle this queue. With-in queue dispatch are taken care by io
>   scheduler. So as long as IO has been queued in the queue, scheduler
>   will take care of giving advantage to readers even if throttling is
>   taking place on the queue.
> 
> Why am I thinking loud? So that we know what are we trying to achieve at the
> end of the day. So at this point of time what are the advantages/disadvantages
> of doing max bw control along with proportional bw control?
> 
> Advantages
> ==========
> - With a combined code base, total code should be less as compared to if
>   both of them are implemented separately. 
> 
> - There can be few advantages in terms of maintaining the notion of IO
>   scheduler with-in cgroup. (like RT tasks always goes first in presence
>   of BE and IDLE task etc. But simple throttling scheme will not take
>   care of fair throttling with-in class. We need a better algorithm to
>   achive that goal).
> 
> - We probably will get rid of reader writer issue for single queue
>   schedulers like deadline and AS. (Need to run tests and see).
> 
> Disadvantages
> =============
> - Implementation at IO scheduler/elevator layer does not cover higher
>   level logical devices. So one can do max bw control only at leaf nodes
>   where IO scheduler is running and not at intermediate logical nodes.
>    
> I personally think that proportional BW control will meet more people's
> need as compared to max bw contorl. 
> 
> So far nobody has come up with a solution where a single proposal covers
> all the cases without breaking things. So personally, I want to make
> things work at least at IO scheduler level and cover as much ground as
> possible without breaking things (hardware RAID, all the direct attached
> devices etc) and then worry about higher level software devices.
> 
> Thoughts?
> 
> Thanks
> Vivek
