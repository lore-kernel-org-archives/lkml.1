Return-Path: <linux-kernel-owner+w=401wt.eu-S1751999AbZGXGVN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751999AbZGXGVN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jul 2009 02:21:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbZGXGVM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Jul 2009 02:21:12 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:59830 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736AbZGXGVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jul 2009 02:21:11 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 24 Jul 2009 15:19:23 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Ryo Tsuruta <ryov@valinux.co.jp>
Cc: xen-devel@lists.xensource.com, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       dm-devel@redhat.com, agk@redhat.com
Subject: Re: [Xen-devel] Re: [PATCH 7/9] blkio-cgroup-v9: Page tracking
 hooks
Message-Id: <20090724151923.986dd932.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090724.144416.71112906.ryov@valinux.co.jp>
References: <20090723164935.e97a3ccf.kamezawa.hiroyu@jp.fujitsu.com>
	<20090723.190253.226783703.ryov@valinux.co.jp>
	<5971c26b399a97f51dd10ea497617733.squirrel@webmail-b.css.fujitsu.com>
	<20090724.144416.71112906.ryov@valinux.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 24 Jul 2009 14:44:16 +0900 (JST)
Ryo Tsuruta <ryov@valinux.co.jp> wrote:
 good solution to resolve such problem.
> 
> > My point is "don't allow anyone to use bandwidth of others."
> > Considering job isolation, a thread who requests swap-out should be charg=
> > ed
> > against bandwidth.
> 
> From another perspective, the swap-out is caused since the buggy
> process uses a large amount of memory, so it can be considered as 
> the bandwidth of logging process is used due to the buggy process.
> 
> Please consider the following case. If a thread who requests swap-out
> is charged, the thread is charged other threads' I/O.
> 
>    (1)                          --------      (2)
>    Process A                   |        |     Process B
>    mmaps a large area in   --> | memory | <-- tries to allocate a page.
>    the memory and writes       |        |
>    data to there.               --------     (3)
>                                    |         To get a free page,
>                                    |         the data written by Proc.A
>                                    |         is written out to the disk.
>                                    V         The I/O is done by using
>                                 ---------    Proc.B's bandwidth.
>                                |  disk   |   
>                                 ---------
> 
> Thus I think that page owners should be charged against bandwidth.
> 
Ok, no good way. yours is wrong, mine is wrong, too.
plz find 3rd way, reasonable.

Below is brief thinking.

"Why process A should be charged to I/O when it just maps anon memory ?"
I can't answer this.

Even in yorr case, Process B requests memory and get penalty. It's
very natural, I think.

In usual case, 
 - if process A maps ANON, there will be no I/O.
 - if process A maps FILE, it will be charged to process A.
ok ?

Under memory pressure,
 - if process A maps ANON, swap I/O should be charged to process B.
 - if process A maps FILE, I/O should be charged to process A.
maybe. 


Anyway, there will be ineraction with dirty_ratio of memcg (not implemeted yet)
and _Owner should be charged_ issue will be handled in this dirty_ratio layer.
More consideration is necessary, I think.


Bye,
-Kame


