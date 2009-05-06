Return-Path: <linux-kernel-owner+w=401wt.eu-S1762020AbZEFWVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762020AbZEFWVa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 18:21:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762486AbZEFWC4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 18:02:56 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:37816 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762474AbZEFWCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 18:02:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=j7zvt1W9uWSn4Evb6QaI1bKO71hwcaFtokUMxOEfFss41DN7TN4156BQ2VjsLpT32E
         cMZRgONyTygJzAFwj/O0opARbTalC9huSgzBvYDHzHU+R9GXbRm1CFhDxUXrICxM8myt
         bHUNIxMECkQcjZo+gwUjWnoVdHE4TW8a3zfMg=
Date: Thu, 7 May 2009 00:02:51 +0200
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
Message-ID: <20090506220250.GD4282@linux>
References: <1241553525-28095-1-git-send-email-vgoyal@redhat.com> <20090505132441.1705bfad.akpm@linux-foundation.org> <20090506023332.GA1212@redhat.com> <20090506200751.GA4282@linux> <20090506212121.GI8180@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506212121.GI8180@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 05:21:21PM -0400, Vivek Goyal wrote:
> > Well, IMHO the big concern is at which level we want to implement the
> > logic of control: IO scheduler, when the IO requests are already
> > submitted and need to be dispatched, or at high level when the
> > applications generates IO requests (or maybe both).
> > 
> > And, as pointed by Andrew, do everything by a cgroup-based controller.
> 
> I am not sure what's the rationale behind that. Why to do it at higher
> layer? Doing it at IO scheduler layer will make sure that one does not
> breaks the IO scheduler's properties with-in cgroup. (See my other mail
> with some io-throttling test results).
> 
> The advantage of higher layer mechanism is that it can also cover software
> RAID devices well. 
> 
> > 
> > The other features, proportional BW, throttling, take the current ioprio
> > model in account, etc. are implementation details and any of the
> > proposed solutions can be extended to support all these features. I
> > mean, io-throttle can be extended to support proportional BW (for a
> > certain perspective it is already provided by the throttling water mark
> > in v16), as well as the IO scheduler based controller can be extended to
> > support absolute BW limits. The same for dm-ioband. I don't think
> > there're huge obstacle to merge the functionalities in this sense.
> 
> Yes, from technical point of view, one can implement a proportional BW
> controller at higher layer also. But that would practically mean almost
> re-implementing the CFQ logic at higher layer. Now why to get into all
> that complexity. Why not simply make CFQ hiearchical to also handle the
> groups?

Make CFQ aware of cgroups is very important also. I could be wrong, but
I don't think we shouldn't re-implement the same exact CFQ logic at
higher layers. CFQ dispatches IO requests, at higher layers applications
submit IO requests. We're talking about different things and applying
different logic doesn't sound too strange IMHO. I mean, at least we
should consider/test also this different approach before deciding drop
it.

This solution also guarantee no changes in the IO schedulers for those
who are not interested in using the cgroup IO controller. What is the
impact of the IO scheduler based controller for those users?

> 
> Secondly, think of following odd scenarios if we implement a higher level
> proportional BW controller which can offer the same feature as CFQ and
> also can handle group scheduling.
> 
> Case1:
> ======	 
>            (Higher level proportional BW controller)
> 			/dev/sda (CFQ)
> 
> So if somebody wants a group scheduling, we will be doing same IO control
> at two places (with-in group). Once at higher level and second time at CFQ
> level. Does not sound too logical to me.
> 
> Case2:
> ======
> 
>            (Higher level proportional BW controller)
> 			/dev/sda (NOOP)
> 	
> This is other extrememt. Lower level IO scheduler does not offer any kind
> of notion of class or prio with-in class and higher level scheduler will
> still be maintaining all the infrastructure unnecessarily.
> 
> That's why I get back to this simple question again, why not extend the
> IO schedulers to handle group scheduling and do both proportional BW and
> max bw control there.
> 
> > 
> > > 
> > > Andrea, last time you were planning to have a look at my patches and see
> > > if max bw controller can be implemented there. I got a feeling that it
> > > should not be too difficult to implement it there. We already have the
> > > hierarchical tree of io queues and groups in elevator layer and we run
> > > BFQ (WF2Q+) algorithm to select next queue to dispatch the IO from. It is
> > > just a matter of also keeping track of IO rate per queue/group and we should
> > > be easily be able to delay the dispatch of IO from a queue if its group has
> > > crossed the specified max bw.
> > 
> > Yes, sorry for my late, I quickly tested your patchset, but I still need
> > to understand many details of your solution. In the next days I'll
> > re-read everything carefully and I'll try to do a detailed review of
> > your patchset (just re-building the kernel with your patchset applied).
> > 
> 
> Sure. My patchset is still in the infancy stage. So don't expect great
> results. But it does highlight the idea and design very well.
> 
> > > 
> > > This should lead to less code and reduced complextiy (compared with the
> > > case where we do max bw control with io-throttling patches and proportional
> > > BW control using IO scheduler based control patches).
> > 
> > mmmh... changing the logic at the elevator and all IO schedulers doesn't
> > sound like reduced complexity and less code changed. With io-throttle we
> > just need to place the cgroup_io_throttle() hook in the right functions
> > where we want to apply throttling. This is a quite easy approach to
> > extend the IO control also to logical devices (more in general devices
> > that use their own make_request_fn) or even network-attached devices, as
> > well as networking filesystems, etc.
> > 
> > But I may be wrong. As I said I still need to review in the details your
> > solution.
> 
> Well I meant reduced code in the sense if we implement both max bw and
> proportional bw at IO scheduler level instead of proportional BW at
> IO scheduler and max bw at higher level.

OK.

> 
> I agree that doing max bw control at higher level has this advantage that
> it covers all the kind of deivces (higher level logical devices) and IO
> scheduler level solution does not do that. But this comes at the price
> of broken IO scheduler properties with-in cgroup.
> 
> Maybe we can then implement both. A higher level max bw controller and a
> max bw feature implemented along side proportional BW controller at IO
> scheduler level. Folks who use hardware RAID, or single disk devices can
> use max bw control of IO scheduler and those using software RAID devices
> can use higher level max bw controller.

OK, maybe.

> 
> > 
> > >  
> > > So do you think that it would make sense to do max BW control along with
> > > proportional weight IO controller at IO scheduler? If yes, then we can
> > > work together and continue to develop this patchset to also support max
> > > bw control and meet your requirements and drop the io-throttling patches.
> > 
> > It is surely worth to be explored. Honestly, I don't know if it would be
> > a better solution or not. Probably comparing some results with different
> > IO workloads is the best way to proceed and decide which is the right
> > way to go. This is necessary IMHO, before totally dropping one solution
> > or another.
> 
> Sure. My patches have started giving some basic results but because there
> is lot of work remaining before a fair comparison can be done on the
> basis of performance under various work loads. So some more time to
> go before we can do a fair comparison based on numbers.
>  
> > 
> > > 
> > > The only thing which concerns me is the fact that IO scheduler does not
> > > have the view of higher level logical device. So if somebody has setup a
> > > software RAID and wants to put max BW limit on software raid device, this
> > > solution will not work. One shall have to live with max bw limits on 
> > > individual disks (where io scheduler is actually running). Do your patches
> > > allow to put limit on software RAID devices also? 
> > 
> > No, but as said above my patchset provides the interfaces to apply the
> > IO control and accounting wherever we want. At the moment there's just
> > one interface, cgroup_io_throttle().
> 
> Sorry, I did not get it clearly. I guess I did not ask the question right.
> So lets say I got a setup where there are two phyical devices /dev/sda and
> /dev/sdb and I create a logical device (say using device mapper facilities)
> on top of these two physical disks. And some application is generating
> the IO for logical device lv0.
> 
> 				Appl
> 				 |
> 				lv0
> 			       /  \
> 			    sda	   sdb
> 
> 
> Where should I put the bandwidth limiting rules now for io-throtle. I 
> specify these for lv0 device or for sda and sdb devices?

The BW limiting rules would be applied into the make_request_fn provided
by the lv0 device. If it's not provided, before calling
generic_make_request(). A problem could be that the driver must be aware
of the particular lv0 device at that point.

> 
> Thanks
> Vivek

OK. I definitely need to look at your patchset before saying any other
opinion... :)

Thanks,
-Andrea
