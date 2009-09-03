Return-Path: <linux-kernel-owner+w=401wt.eu-S1754159AbZICCl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159AbZICCl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 22:41:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754147AbZICCl6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 22:41:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754118AbZICClz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 22:41:55 -0400
Date: Wed, 2 Sep 2009 22:40:14 -0400
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
Message-ID: <20090903024014.GA8644@redhat.com>
References: <20090901141142.GA13709@redhat.com> <20090902.185251.193693849.ryov@valinux.co.jp> <20090902135821.GB5012@redhat.com> <20090903.112423.226782505.ryov@valinux.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20090903.112423.226782505.ryov@valinux.co.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 03, 2009 at 11:24:23AM +0900, Ryo Tsuruta wrote:
> Hi Vivek,
> 
> Vivek Goyal <vgoyal@redhat.com> wrote:
> > > > > > > - Somebody also gave an example where there is a memory hogging process and
> > > > > > >  possibly pushes out some processes to swap. It does not sound fair to
> > > > > > >  charge those proccess for that swap writeout. These processes never
> > > > > > >  requested swap IO.
> > > > > 
> > > > > I think that swap writeouts should be charged to the memory hogging
> > > > > process, because the process consumes more resources and it should get
> > > > > a penalty.
> > > > > 
> > > > 
> > > > A process requesting memory gets IO penalty? IMHO, swapping is a kernel 
> > > > mechanism and kernel's way of providing extended RAM. If we want to solve
> > > > the issue of memory hogging by a process then right way to solve is to use
> > > > memory controller and not by charging the process for IO activity.
> > > > Instead, proabably a more suitable way is to charge swap activity to root
> > > > group (where by default all the kernel related activity goes).   
> > > 
> > > No. In the current blkio-cgroup, a process which uses a large amount
> > > of memory gets penalty, not a memory requester.
> > > 
> > 
> > At ioband level you just get to see bio and page. How do you decide wheter
> > this bio is being issued by a process which is a memory hog?
> > 
> > In fact requester of memory could be anybody. It could be memory hog or a
> > different process. So are you saying that you got a mechanism where you 
> > can detect that a process is memory hog and charge swap activity to it.
> > IOW, if there are two processes A and B and assume A is the memory hog and
> > then B requests for memory which triggers lot of swap IO, then you can
> > charge all that IO to memory hog A?
> 
> When an annoymou page is allocated, blkio-cgroup sets an ID to the
> page. And then when the page is going to swap out, dm-ioband can know
> who the owner of the page is by retrieving ID from the page.
> 
> In the above case, since the pages of the process A are swapped-out, 
> dm-ioband charges swap IO to the process A.
> 

But this does not mean that in all cases memory hog is being charged for
swap IO, as you have said. So if a process A has done some anonymous page
allocations and later a memory hog B comes in and forces swap out of A, 
you will charge A for swap activity which does not seem fair as B is
memory hog here?

Thanks
Vivek

> > Can you please point me to the relevant code in dm-ioband?
> > 
> > IMHO, to keep things simple, all swapping activity should be charged to
> > root group and be considered as kernel activity and user space not be
> > charged for that.
> 
> Thanks,
> Ryo Tsuruta
