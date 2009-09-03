Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbZICCYW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbZICCYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Sep 2009 22:24:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbZICCYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Sep 2009 22:24:22 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:33232 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbZICCYV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Sep 2009 22:24:21 -0400
Date: Thu, 03 Sep 2009 11:24:23 +0900 (JST)
Message-Id: <20090903.112423.226782505.ryov@valinux.co.jp>
To: vgoyal@redhat.com
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
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090902135821.GB5012@redhat.com>
References: <20090901141142.GA13709@redhat.com>
	<20090902.185251.193693849.ryov@valinux.co.jp>
	<20090902135821.GB5012@redhat.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

Vivek Goyal <vgoyal@redhat.com> wrote:
> > > > > > - Somebody also gave an example where there is a memory hogging process and
> > > > > >  possibly pushes out some processes to swap. It does not sound fair to
> > > > > >  charge those proccess for that swap writeout. These processes never
> > > > > >  requested swap IO.
> > > > 
> > > > I think that swap writeouts should be charged to the memory hogging
> > > > process, because the process consumes more resources and it should get
> > > > a penalty.
> > > > 
> > > 
> > > A process requesting memory gets IO penalty? IMHO, swapping is a kernel 
> > > mechanism and kernel's way of providing extended RAM. If we want to solve
> > > the issue of memory hogging by a process then right way to solve is to use
> > > memory controller and not by charging the process for IO activity.
> > > Instead, proabably a more suitable way is to charge swap activity to root
> > > group (where by default all the kernel related activity goes).   
> > 
> > No. In the current blkio-cgroup, a process which uses a large amount
> > of memory gets penalty, not a memory requester.
> > 
> 
> At ioband level you just get to see bio and page. How do you decide wheter
> this bio is being issued by a process which is a memory hog?
> 
> In fact requester of memory could be anybody. It could be memory hog or a
> different process. So are you saying that you got a mechanism where you 
> can detect that a process is memory hog and charge swap activity to it.
> IOW, if there are two processes A and B and assume A is the memory hog and
> then B requests for memory which triggers lot of swap IO, then you can
> charge all that IO to memory hog A?

When an annoymou page is allocated, blkio-cgroup sets an ID to the
page. And then when the page is going to swap out, dm-ioband can know
who the owner of the page is by retrieving ID from the page.

In the above case, since the pages of the process A are swapped-out, 
dm-ioband charges swap IO to the process A.

> Can you please point me to the relevant code in dm-ioband?
> 
> IMHO, to keep things simple, all swapping activity should be charged to
> root group and be considered as kernel activity and user space not be
> charged for that.

Thanks,
Ryo Tsuruta
