Return-Path: <linux-kernel-owner+w=401wt.eu-S1758891AbYEHJdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758891AbYEHJdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 05:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751850AbYEHJdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 05:33:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:39018 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbYEHJc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 05:32:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,453,1204531200"; 
   d="scan'208";a="325827457"
Subject: Re: AIM7 40% regression with 2.6.26-rc1
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Matthew Wilcox <matthew@wil.cx>,
       LKML <linux-kernel@vger.kernel.org>,
       Alexander Viro <viro@ftp.linux.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080508092102.GA32164@elte.hu>
References: <87lk2mbcqp.fsf@basil.nowhere.org>
	 <20080507114643.GR19219@parisc-linux.org>
	 <87hcdab8zp.fsf@basil.nowhere.org>
	 <alpine.LFD.1.10.0805070728280.32269@woody.linux-foundation.org>
	 <alpine.LFD.1.10.0805070817060.3024@woody.linux-foundation.org>
	 <1210214696.3453.87.camel@ymzhang> <20080508064340.GA27452@elte.hu>
	 <1210230883.3453.127.camel@ymzhang> <20080508073924.GA30356@elte.hu>
	 <1210236254.3453.137.camel@ymzhang>  <20080508092102.GA32164@elte.hu>
Content-Type: text/plain
Date: Thu, 08 May 2008 17:30:54 +0800
Message-Id: <1210239054.3453.149.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.5 (2.21.5-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Thu, 2008-05-08 at 11:21 +0200, Ingo Molnar wrote:
> * Zhang, Yanmin <yanmin_zhang@linux.intel.com> wrote:
> 
> > >           disk_cp /mnt/shm
> > >   disk_cp (1): cannot open /mnt/shm/tmpa.common
> > >   disk1.c: No such file or directory
> > > 
> > >   [.. etc. a large stream of them .. ]
> > > 
> > > system has 2GB of RAM and tmpfs mounted to the place where aim7 puts its 
> > > work files.
> 
> > My machine has 8GB. To simulate your environment, I reserve 6GB for 
> > hugetlb, then reran the testing and didn't see any failure except: AIM 
> > Multiuser Benchmark - Suite VII Run Beginning
> > 
> > Tasks    jobs/min  jti  jobs/min/task      real       cpu
> >  2000create_shared_memory(): can't create semaphore, pausing...
> > create_shared_memory(): can't create semaphore, pausing...
> 
> that failure message you got worries me - it indicates that your test 
> ran out of IPC semaphores. You can fix it via upping the semaphore 
> limits via:
> 
>    echo "500 32000 128 512" > /proc/sys/kernel/sem
A quick test showed it does work.

Thanks. I need to take shuttle bus or I need walk to home for 2 hours if missing it. :)

> 
> could you check that you still get similar results with this limit 
> fixed?
> 
> note that once i've fixed the semaphore limits it started running fine 
> here. And i see zero idle time during the run on a quad core box.
> 
> here are my numbers:
> 
>   # on v2.6.26-rc1-166-gc0a1811
> 
>   Tasks   Jobs/Min        JTI     Real    CPU     Jobs/sec/task
>   2000    55851.4         93      208.4   793.6   0.4654   # BKL: sleep
>   2000    55402.2         79      210.1   800.1   0.4617
> 
>   2000    55728.4         93      208.9   795.5   0.4644   # BKL: spin
>   2000    55787.2         93      208.7   794.5   0.4649   #
> 
> so the results are the same within noise.
> 
> I'll also check this workload on an 8-way box to make sure it's OK on 
> larger CPU counts too.
> 
> could you double-check your test?
> 
> plus a tty tidbit as well, during the test i saw a few of these:
> 
>  Warning: dev (tty1) tty->count(639) != #fd's(638) in release_dev
>  Warning: dev (tty1) tty->count(462) != #fd's(463) in release_dev
>  Warning: dev (tty1) tty->count(274) != #fd's(275) in release_dev
>  Warning: dev (tty1) tty->count(4) != #fd's(3) in release_dev
>  Warning: dev (tty1) tty->count(164) != #fd's(163) in release_dev
> 
> 	Ingo

