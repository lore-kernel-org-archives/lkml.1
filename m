Return-Path: <linux-kernel-owner+w=401wt.eu-S1752277AbZIBN7K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277AbZIBN7K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 09:59:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752014AbZIBN7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 09:59:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574AbZIBN7I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 09:59:08 -0400
Date: Wed, 2 Sep 2009 09:58:21 -0400
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
Message-ID: <20090902135821.GB5012@redhat.com>
References: <e98e18940908311651s26de5b70ye6f4a82402956309@mail.gmail.com> <20090901.160004.226800357.ryov@valinux.co.jp> <20090901141142.GA13709@redhat.com> <20090902.185251.193693849.ryov@valinux.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090902.185251.193693849.ryov@valinux.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 02, 2009 at 06:52:51PM +0900, Ryo Tsuruta wrote:
> Hi Vivek,
> 
> > > > > - The primary use case of tracking async context seems be that if a
> > > > >  process T1 in group G1 mmaps a big file and then another process T2 in
> > > > >  group G2, asks for memory and triggers reclaim and generates writes of
> > > > >  the file pages mapped by T1, then these writes should not be charged to
> > > > >  T2, hence blkio_cgroup pages.
> > > > >
> > > > >  But the flip side of this might be that group G2 is a low weight group
> > > > >  and probably too busy also right now, which will delay the write out
> > > > >  and possibly T2 will wait longer for memory to be allocated.
> > > 
> > > In order to avoid this wait, dm-ioband issues IO which has a page with
> > > PG_Reclaim as early as possible.
> > > 
> > 
> > So in above case IO is still charged to G2 but you keep a track if page is
> > PG_Reclaim then releae the this bio before other bios queued up in the
> > group?
> 
> Yes, the bio with PG_Reclaim page is given priority over the other bios.
> 
> > > > > - At one point of time Andrew mentioned that buffered writes are generally a
> > > > >  big problem and one needs to map these to owner's group. Though I am not
> > > > >  very sure what specific problem he was referring to. Can we attribute
> > > > >  buffered writes to pdflush threads and move all pdflush threads in a
> > > > >  cgroup to limit system wide write out activity?
> > > 
> > > I think that buffered writes also should be controlled per cgroup as
> > > well as synchronous writes.
> > > 
> > 
> > But it is hard to achieve fairness for buffered writes becase we don't
> > create complete parallel IO paths and not necessarily higher weight
> > process dispatches more buffered writes to IO scheduler. (Due to page
> > cache buffered write logic).
> > 
> > So in some cases we might see buffered write fairness and in other cases
> > not. For example, run two dd processes in two groups doing buffered writes
> > and it is hard to achieve fairness between these.
> > 
> > That's why the idea that if we can't ensure Buffered write vs Buffered
> > write fairness in all the cases, then does it make sense to attribute
> > buffered writes to pdflush and put pdflush threads into a separate group
> > to limit system wide write out activity. 
> 
> If all buffered writes are treated as system wide activities, it does
> not mean that bandwidth is being controlled. It is true that pdflush
> doesn't do I/O according to weight, but bandwidth (including for
> bufferd writes) should be reserved for each cgroup.
> 
> > > > > - Somebody also gave an example where there is a memory hogging process and
> > > > >  possibly pushes out some processes to swap. It does not sound fair to
> > > > >  charge those proccess for that swap writeout. These processes never
> > > > >  requested swap IO.
> > > 
> > > I think that swap writeouts should be charged to the memory hogging
> > > process, because the process consumes more resources and it should get
> > > a penalty.
> > > 
> > 
> > A process requesting memory gets IO penalty? IMHO, swapping is a kernel 
> > mechanism and kernel's way of providing extended RAM. If we want to solve
> > the issue of memory hogging by a process then right way to solve is to use
> > memory controller and not by charging the process for IO activity.
> > Instead, proabably a more suitable way is to charge swap activity to root
> > group (where by default all the kernel related activity goes).   
> 
> No. In the current blkio-cgroup, a process which uses a large amount
> of memory gets penalty, not a memory requester.
> 

At ioband level you just get to see bio and page. How do you decide wheter
this bio is being issued by a process which is a memory hog?

In fact requester of memory could be anybody. It could be memory hog or a
different process. So are you saying that you got a mechanism where you 
can detect that a process is memory hog and charge swap activity to it.
IOW, if there are two processes A and B and assume A is the memory hog and
then B requests for memory which triggers lot of swap IO, then you can
charge all that IO to memory hog A?

Can you please point me to the relevant code in dm-ioband?

IMHO, to keep things simple, all swapping activity should be charged to
root group and be considered as kernel activity and user space not be
charged for that.

Thanks
Vivek

> As you wrote, using both io-controller and memory controller are
> required to prevent swap-out caused by memory consumption on another
> cgroup.
> 
> > > > > - If there are multiple buffered writers in the system, then those writers
> > > > >  can also be forced to writeout some pages to disk before they are
> > > > >  allowed to dirty more pages. As per the page cache design, any writer
> > > > >  can pick any inode and start writing out pages. So it can happen a
> > > > >  weight group task is writting out pages dirtied by a lower weight group
> > > > >  task. If, async bio is mapped to owner's group, it might happen that
> > > > >  higher weight group task might be made to sleep on lower weight group
> > > > >  task because request descriptors are all consumed up.
> > > 
> > > As mentioned above, in dm-ioband, the bio is charged to the page owner
> > > and issued immediately.
> > 
> > But you are doing it only for selected pages and not for all buffered
> > writes?
> 
> I'm sorry, I wrote wrong on the previous mail, IO for writing out
> page-cache pages is not issued immediately, it is throttled by
> dm-ioband.
> 
> Anyway, there is a case where a higher weight group task is made
> to sleep, but if we reserve the memory for each cgroup by memory
> controller in advance, we can avoid the task put to sleep.
> 
> Thanks,
> Ryo Tsuruta
