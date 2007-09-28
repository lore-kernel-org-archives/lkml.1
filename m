Return-Path: <linux-kernel-owner+w=401wt.eu-S1755607AbXI1TSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755607AbXI1TSG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 15:18:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752292AbXI1TR4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 15:17:56 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:53745 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752226AbXI1TRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 15:17:55 -0400
Date: Fri, 28 Sep 2007 12:16:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Trond Myklebust <trond.myklebust@fys.uio.no>,
       Chakri n <chakriin5@gmail.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, nfs@lists.sourceforge.net
Subject: Re: A unresponsive file system can hang all I/O in the system on
 linux-2.6.23-rc6 (dirty_thresh problem?)
Message-Id: <20070928121642.56a380ce.akpm@linux-foundation.org>
In-Reply-To: <1191005339.18147.89.camel@lappy>
References: <92cbf19b0709272332s25684643odaade0e98cb3a1f4@mail.gmail.com>
	<20070927235034.ae7bd73d.akpm@linux-foundation.org>
	<1190998853.6702.17.camel@heimdal.trondhjem.org>
	<20070928114930.2c201324.akpm@linux-foundation.org>
	<1191005339.18147.89.camel@lappy>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2007 20:48:59 +0200 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> 
> On Fri, 2007-09-28 at 11:49 -0700, Andrew Morton wrote:
> 
> > Do you know where the stalls are occurring?  throttle_vm_writeout(), or via
> > direct calls to congestion_wait() from page_alloc.c and vmscan.c?  (running
> > sysrq-w five or ten times will probably be enough to determine this)
> 
> would it make sense to instrument congestion_wait() callsites with
> vmstats?

Better than nothing, but it isn't a great fit: we'd need one vmstat counter
per congestion_wait() callsite, and it's all rather specific to the
kernel-of-the-day.

taskstats delay accounting isn't useful either - it will aggregate all the
schedule() callsites.

profile=sleep is just about ideal for this, isn't it?  I suspect that most
people don't know it's there, or forgot about it.

It could be that profile=sleep just tells us "you're spending a lot of time
in io_schedule()" or congestion_wait(), so perhaps we need to teach it to
go for walk up the stack somehow.

But lockdep knows how to do that already so perhaps we (ie: you ;)) can
bolt sleep instrumentation onto lockdep as we (ie you ;)) did with the
lockstat stuff?

(Searches for the lockstat documentation)

Did we forget to do that?
