Return-Path: <linux-kernel-owner+w=401wt.eu-S1751847AbZGXIsz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbZGXIsz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 04:48:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750826AbZGXIsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 04:48:55 -0400
Received: from mail.valinux.co.jp ([210.128.90.3]:49839 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759AbZGXIsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 04:48:54 -0400
Date: Fri, 24 Jul 2009 17:48:53 +0900 (JST)
Message-Id: <20090724.174853.193712105.ryov@valinux.co.jp>
To: kamezawa.hiroyu@jp.fujitsu.com
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       dm-devel@redhat.com, agk@redhat.com
Subject: Re: [Xen-devel] Re: [PATCH 7/9] blkio-cgroup-v9: Page tracking
 hooks
From: Ryo Tsuruta <ryov@valinux.co.jp>
In-Reply-To: <20090724151923.986dd932.kamezawa.hiroyu@jp.fujitsu.com>
References: <5971c26b399a97f51dd10ea497617733.squirrel@webmail-b.css.fujitsu.com>
	<20090724.144416.71112906.ryov@valinux.co.jp>
	<20090724151923.986dd932.kamezawa.hiroyu@jp.fujitsu.com>
X-Mailer: Mew version 5.2.52 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Fri, 24 Jul 2009 14:44:16 +0900 (JST)
> Ryo Tsuruta <ryov@valinux.co.jp> wrote:
>  good solution to resolve such problem.
> > 
> > > My point is "don't allow anyone to use bandwidth of others."
> > > Considering job isolation, a thread who requests swap-out should be charg=
> > > ed
> > > against bandwidth.
> > 
> > From another perspective, the swap-out is caused since the buggy
> > process uses a large amount of memory, so it can be considered as 
> > the bandwidth of logging process is used due to the buggy process.
> > 
> > Please consider the following case. If a thread who requests swap-out
> > is charged, the thread is charged other threads' I/O.
> > 
> >    (1)                          --------      (2)
> >    Process A                   |        |     Process B
> >    mmaps a large area in   --> | memory | <-- tries to allocate a page.
> >    the memory and writes       |        |
> >    data to there.               --------     (3)
> >                                    |         To get a free page,
> >                                    |         the data written by Proc.A
> >                                    |         is written out to the disk.
> >                                    V         The I/O is done by using
> >                                 ---------    Proc.B's bandwidth.
> >                                |  disk   |   
> >                                 ---------
> > 
> > Thus I think that page owners should be charged against bandwidth.
> > 
> Ok, no good way. yours is wrong, mine is wrong, too.
> plz find 3rd way, reasonable.
> 
> Below is brief thinking.
> 
> "Why process A should be charged to I/O when it just maps anon memory ?"
> I can't answer this.
> 
> Even in yorr case, Process B requests memory and get penalty. It's
> very natural, I think.
> 
> In usual case, 
>  - if process A maps ANON, there will be no I/O.
>  - if process A maps FILE, it will be charged to process A.
> ok ?
> 
> Under memory pressure,
>  - if process A maps ANON, swap I/O should be charged to process B.
>  - if process A maps FILE, I/O should be charged to process A.
> maybe. 

I think that even process A maps ANON, it should be charged to process A
because the memory pressure is caused by process A. It seems natual
for me that a process which consumes more resources is more likely to
get penalty.

> Anyway, there will be ineraction with dirty_ratio of memcg (not implemeted yet)
> and _Owner should be charged_ issue will be handled in this dirty_ratio layer.
> More consideration is necessary, I think.

I'll keep thinking how it should be done.

Thanks,
Ryo Tsuruta
