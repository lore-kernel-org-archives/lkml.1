Return-Path: <linux-kernel-owner+w=401wt.eu-S1757499AbXIEP4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499AbXIEP4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2007 11:56:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756733AbXIEP4P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Sep 2007 11:56:15 -0400
Received: from mx2.netapp.com ([216.240.18.37]:48743 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756576AbXIEP4O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2007 11:56:14 -0400
X-IronPort-AV: E=Sophos;i="4.20,211,1186383600"; 
   d="scan'208";a="100459037"
Subject: Re: nfs4 hang regression
From: Trond Myklebust <Trond.Myklebust@netapp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bret Towe <magnade@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20070905085120.bc90ffe2.akpm@linux-foundation.org>
References: <dda83e780708221541x4fabd27er64e6ecaa33ddccbf@mail.gmail.com>
	 <20070905085120.bc90ffe2.akpm@linux-foundation.org>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Network Appliance Inc
Date: Wed, 05 Sep 2007 16:55:29 +0100
Message-Id: <1189007729.13235.27.camel@gaula.trondhjem.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
X-OriginalArrivalTime: 05 Sep 2007 15:55:30.0882 (UTC) FILETIME=[2F969A20:01C7EFD5]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-09-05 at 08:51 -0700, Andrew Morton wrote:
> > On Wed, 22 Aug 2007 15:41:18 -0700 "Bret Towe" <magnade@gmail.com> wrote:
> 
> More than two weeks, you've bisected it and there's no sign of any action?
> 
> I don't see this on Michal's list so perhaps it already got fixed in a different
> thread.  Have you tested current mainline?

I believe Bret already declared himself happy with the fix that was
merged into mainline yesterday.

> > as of commit 3d39c691ff486142dd9aaeac12f553f4476b7a62
> > I got a hang on my clients after something around 26 minutes of uptime
> > the keyboard would stop accepting input
> > mouse would work still, plugging in a spare usb keyboard made no difference
> > another couple odd bits is shutting down would hang, below is a trace
> > of that hang
> > also if your logged into that machine via ssh when you log out it would hang
> > and would require a force terminate
> > 
> > I'm seeing this on 2 machines 1 a g4 mac mini and 2 a athlon64
> > both have a home directory mounted via nfs4
> > reverting the commit above found via bisecting on both machines allows me
> > to use the computers for several hours with no issues
> > 
> > and here is the trace from the athlon64 taken during its hang on shutdown
> > as you can tell from the dates in the trace ive been a bit busy and just
> > now got around to sending this email
> > I'm surprised tho I hadn't seen anyone hitting it
> > let me know what else is needed I'll do what I can and get it out quickly
> > 
> > Aug 12 17:06:35 ghoststar kernel: [ 4791.801262] SysRq : Show State
> > Aug 12 17:06:35 ghoststar kernel: [ 4791.801325]   task
> >         PC stack   pid father
> > Aug 12 17:06:35 ghoststar kernel: [ 4791.801327] init          S
> > 00000000ffffffff     0     1      0
> > Aug 12 17:06:35 ghoststar kernel: [ 4791.801331]  ffff81003ff879b8
> > 0000000000000086 0000000000000008 ffff81003ff84000
> 
> I really wish that hadn't been wordwrapped.
> 
> As a random stab-in-the-dark, does this help?
> 
> --- a/fs/nfs/nfs4renewd.c~a
> +++ a/fs/nfs/nfs4renewd.c
> @@ -133,9 +133,7 @@ nfs4_renewd_prepare_shutdown(struct nfs_
>  void
>  nfs4_kill_renewd(struct nfs_client *clp)
>  {
> -	down_read(&clp->cl_sem);
>  	cancel_delayed_work_sync(&clp->cl_renewd);
> -	up_read(&clp->cl_sem);
>  }

Nope. The problem was the cancel_delayed_work_sync(). It turns out that
this may recurse...

Trond
