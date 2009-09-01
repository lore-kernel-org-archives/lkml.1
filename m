Return-Path: <linux-kernel-owner+w=401wt.eu-S1754892AbZIAOOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754892AbZIAOOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Sep 2009 10:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754293AbZIAOOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Sep 2009 10:14:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754360AbZIAOOQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Sep 2009 10:14:16 -0400
Date: Tue, 1 Sep 2009 10:11:42 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: nauman@google.com, riel@redhat.com, linux-kernel@vger.kernel.org,
       jens.axboe@oracle.com, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH 18/23] io-controller: blkio_cgroup patches from Ryo to
	track async bios.
Message-ID: <20090901141142.GA13709@redhat.com>
References: <4A9C09BE.4060404@redhat.com> <20090831185640.GF3758@redhat.com> <e98e18940908311651s26de5b70ye6f4a82402956309@mail.gmail.com> <20090901.160004.226800357.ryov@valinux.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090901.160004.226800357.ryov@valinux.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 01, 2009 at 04:00:04PM +0900, Ryo Tsuruta wrote:
> Hi,
> 
> > > Hi Rik,
> > >
> > > Thanks for reviewing the patches. I wanted to have better understanding of
> > > where all does it help to associate a bio to the group of process who
> > > created/owned the page. Hence few thoughts.
> > >
> > > When a bio is submitted to IO scheduler, it needs to determine the group
> > > bio belongs to and group which should be charged to. There seem to be two
> > > methods.
> > >
> > > - Attribute the bio to cgroup submitting process belongs to.
> > > - For async requests, track the original owner hence cgroup of the page
> > >  and charge that group for the bio.
> > >
> > > One can think of pros/cons of both the approaches.
> > >
> > > - The primary use case of tracking async context seems be that if a
> > >  process T1 in group G1 mmaps a big file and then another process T2 in
> > >  group G2, asks for memory and triggers reclaim and generates writes of
> > >  the file pages mapped by T1, then these writes should not be charged to
> > >  T2, hence blkio_cgroup pages.
> > >
> > >  But the flip side of this might be that group G2 is a low weight group
> > >  and probably too busy also right now, which will delay the write out
> > >  and possibly T2 will wait longer for memory to be allocated.
> 
> In order to avoid this wait, dm-ioband issues IO which has a page with
> PG_Reclaim as early as possible.
> 

So in above case IO is still charged to G2 but you keep a track if page is
PG_Reclaim then releae the this bio before other bios queued up in the
group?

> > > - At one point of time Andrew mentioned that buffered writes are generally a
> > >  big problem and one needs to map these to owner's group. Though I am not
> > >  very sure what specific problem he was referring to. Can we attribute
> > >  buffered writes to pdflush threads and move all pdflush threads in a
> > >  cgroup to limit system wide write out activity?
> 
> I think that buffered writes also should be controlled per cgroup as
> well as synchronous writes.
> 

But it is hard to achieve fairness for buffered writes becase we don't
create complete parallel IO paths and not necessarily higher weight
process dispatches more buffered writes to IO scheduler. (Due to page
cache buffered write logic).

So in some cases we might see buffered write fairness and in other cases
not. For example, run two dd processes in two groups doing buffered writes
and it is hard to achieve fairness between these.

That's why the idea that if we can't ensure Buffered write vs Buffered
write fairness in all the cases, then does it make sense to attribute
buffered writes to pdflush and put pdflush threads into a separate group
to limit system wide write out activity. 

> > > - Somebody also gave an example where there is a memory hogging process and
> > >  possibly pushes out some processes to swap. It does not sound fair to
> > >  charge those proccess for that swap writeout. These processes never
> > >  requested swap IO.
> 
> I think that swap writeouts should be charged to the memory hogging
> process, because the process consumes more resources and it should get
> a penalty.
> 

A process requesting memory gets IO penalty? IMHO, swapping is a kernel 
mechanism and kernel's way of providing extended RAM. If we want to solve
the issue of memory hogging by a process then right way to solve is to use
memory controller and not by charging the process for IO activity.
Instead, proabably a more suitable way is to charge swap activity to root
group (where by default all the kernel related activity goes).   

> > > - If there are multiple buffered writers in the system, then those writers
> > >  can also be forced to writeout some pages to disk before they are
> > >  allowed to dirty more pages. As per the page cache design, any writer
> > >  can pick any inode and start writing out pages. So it can happen a
> > >  weight group task is writting out pages dirtied by a lower weight group
> > >  task. If, async bio is mapped to owner's group, it might happen that
> > >  higher weight group task might be made to sleep on lower weight group
> > >  task because request descriptors are all consumed up.
> 
> As mentioned above, in dm-ioband, the bio is charged to the page owner
> and issued immediately.

But you are doing it only for selected pages and not for all buffered
writes?

> 
> > > It looks like there does not seem to be a clean way which covers all the
> > > cases without issues. I am just trying to think, what is a simple way
> > > which covers most of the cases. Can we just stick to using submitting task
> > > context to determine a bio's group (as cfq does). Which can result in
> > > following.
> > >
> > > - Less code and reduced complexity.
> > >
> > > - Buffered writes will be charged to pdflush and its group. If one wish to
> > >  limit buffered write activity for pdflush, one can move all the pdflush
> > >  threads into a group and assign desired weight. Writes submitted in
> > >  process context will continue to be charged to that process irrespective
> > >  of the fact who dirtied that page.
> > 
> > What if we wanted to control buffered write activity per group? If a
> > group keeps dirtying pages, we wouldn't want it to dominate the disk
> > IO capacity at the expense of other cgroups (by dominating the writes
> > sent down by pdflush).
> 
> Yes, I think that is true.
> 

But anyway we are not able to gurantee this isolation in all the cases.
Again I go back to example of two dd threads doing buffered writes in two
groups.

I don't mind keeping it. Just wanted to make sure that we agree and
understand that keeping it does not mean that we get buffered write vs
buffered write isolation/fairness in all the cases.

> > > - swap activity will be charged to kswapd and its group. If swap writes
> > >  are coming from process context, it gets charged to process and its
> > >  group.
> > >
> > > - If one is worried about the case of one process being charged for write
> > >  out of file mapped by another process during reclaim, then we can
> > >  probably make use of memory controller and mount memory controller and
> > >  io controller together on same hierarchy. I am told that with memory
> > >  controller, group's memory will be reclaimed by the process requesting
> > >  more memory. If that's the case, then IO will automatically be charged
> > >  to right group if we use submitting task context.
> > >
> > > I just wanted to bring this point forward for more discussions to know
> > > what is the right thing to do? Use bio tracking or not.
> 
> Thanks for bringing it forward.
> 

Thanks
Vivek
