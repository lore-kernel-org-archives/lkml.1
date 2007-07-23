Return-Path: <linux-kernel-owner+w=401wt.eu-S934588AbXGWTkv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934588AbXGWTkv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 15:40:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765377AbXGWTkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 15:40:42 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46247 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1763191AbXGWTkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 15:40:41 -0400
Date: Mon, 23 Jul 2007 12:40:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fengguang Wu <fengguang.wu@gmail.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Rusty Russell <rusty@rustcorp.com.au>, Dave Jones <davej@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel <linux-kernel@vger.kernel.org>, riel <riel@redhat.com>,
       Tim Pepper <lnxninja@us.ibm.com>, Chris Snook <csnook@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 0/3] readahead drop behind and size adjustment
Message-Id: <20070723124009.5fcf4fef.akpm@linux-foundation.org>
In-Reply-To: <385201377.00678@ustc.edu.cn>
References: <20070721210005.000228000@chello.nl>
	<20070722023923.GA6438@mail.ustc.edu.cn>
	<20070722024428.GA724@redhat.com>
	<20070722081010.GA6317@mail.ustc.edu.cn>
	<1185093236.6344.87.camel@localhost.localdomain>
	<46A46E4B.7050007@yahoo.com.au>
	<385201377.00678@ustc.edu.cn>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2007 22:24:57 +0800
Fengguang Wu <fengguang.wu@gmail.com> wrote:

> On Mon, Jul 23, 2007 at 07:00:59PM +1000, Nick Piggin wrote:
> > Rusty Russell wrote:
> > >On Sun, 2007-07-22 at 16:10 +0800, Fengguang Wu wrote:
> > 
> > >>So I opt for it being made tunable, safe, and turned off by default.
> > 
> > I hate tunables :) Unless we have workload A that gets a reasonable
> > benefit from something and workload B that gets a significant regression,
> > and no clear way to reconcile them...
> 
> Me too ;)
> 
> But sometimes we really want to avoid flushing the cache.
> Andrew's user space LD_PRELOAD+fadvise based tool fit nicely here.

It's the only way to go in some situations.  Sometimes the kernel just
cannot predict the future sufficiently well, and the costs of making a
mistake are terribly high.  We need human help.  And it should be
administration-time help, not programming-time help.

> > >I'd like to see it turned on by default in -mm, and try to come up with
> > >some server-like workload to measure the effect.  Should be easy to
> > >simulate something (eg. apache server, where clients grab some files in
> > >preference, and apache server where clients grab different files).
> > 
> > I don't like this kind of conditional information going from something
> > like readahead into page reclaim. Unless it is for readahead _specific_
> > data such as "I got these all wrong, so you can reclaim them" (which
> > this isn't).
> > 
> > Possibly it makes sense to realise that the given pages are cheaper
> > to read back in as they are apparently being read-ahead very nicely.
> 
> In fact I have talked to Jens about it in last year's kernel summit.
> The patch below explains itself.
> ---
> Subject: cost based page reclaim
> 
> Cost based page reclaim - a minimalist implementation.
> 
> Suppose we cached 32 small files each with 1 page, and one 32-page chunk from a
> large file.  Should we first drop the 32-pages which are read in one I/O, or
> drop the 32 distinct pages, each costs one I/O? (Given that the files are of
> equal hotness.)
> 
> Page replacement algorithms should be designed to minimize the number of I/Os,
> instead of the number of page faults. Dividing the cost of I/O by the number of
> pages it bring in, we get the cost of the page. The bigger page cost, the more
> 'lives/bloods' the page should have.
> 
> This patch adds life to costly pages by pretending that they are
> referenced more times. Possible downsides:
> - burdens the pressure of vmscan
> - active pages are no longer that 'active'
> 

This is all fun stuff, but how do we find out that changes like this are
good ones, apart from shipping it and seeing who gets hurt 12 months later?

> +#define log2(n) fls(n)

<look at include/linux/log2.h>

