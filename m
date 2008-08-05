Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbYHEGQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbYHEGQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 02:16:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752568AbYHEGQs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 02:16:48 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:52235 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751287AbYHEGQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 02:16:47 -0400
Date: Tue, 05 Aug 2008 15:16:42 +0900 (JST)
Message-Id: <20080805.151642.31467169.taka@valinux.co.jp>
To: righi.andrea@gmail.com
Cc: dave@linux.vnet.ibm.com, xen-devel@lists.xensource.com,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       virtualization@lists.linux-foundation.org, dm-devel@redhat.com,
       agk@sourceware.org
Subject: Re: Too many I/O controller patches
From: Hirokazu Takahashi <taka@valinux.co.jp>
In-Reply-To: <48976A2A.9060600@gmail.com>
References: <489748E6.5080106@gmail.com>
	<1217876521.20260.123.camel@nimitz>
	<48976A2A.9060600@gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andrea,

I'm working with Ryo on dm-ioband and other stuff.

> > On Mon, 2008-08-04 at 20:22 +0200, Andrea Righi wrote:
> >> But I'm not yet convinced that limiting the IO writes at the device
> >> mapper layer is the best solution. IMHO it would be better to throttle
> >> applications' writes when they're dirtying pages in the page cache (the
> >> io-throttle way), because when the IO requests arrive to the device
> >> mapper it's too late (we would only have a lot of dirty pages that are
> >> waiting to be flushed to the limited block devices, and maybe this could
> >> lead to OOM conditions). IOW dm-ioband is doing this at the wrong level
> >> (at least for my requirements). Ryo, correct me if I'm wrong or if I've
> >> not understood the dm-ioband approach.
> > 
> > The avoid-lots-of-page-dirtying problem sounds like a hard one.  But, if
> > you look at this in combination with the memory controller, they would
> > make a great team.
> > 
> > The memory controller keeps you from dirtying more than your limit of
> > pages (and pinning too much memory) even if the dm layer is doing the
> > throttling and itself can't throttle the memory usage.
> 
> mmh... but in this way we would just move the OOM inside the cgroup,
> that is a nice improvement, but the main problem is not resolved...

The concept of dm-ioband includes it should be used with cgroup memory
controller as well as the bio cgroup. The memory controller is supposed
to control memory allocation and dirty-page ratio inside each cgroup.

Some guys of cgroup memory controller team just started to implement
the latter mechanism. They try to make each cgroup have a threshold
to limit the number of dirty pages in the group.

I feel this is good approach since each functions can work independently.

> A safer approach IMHO is to force the tasks to wait synchronously on
> each operation that directly or indirectly generates i/o.
> 
> In particular the solution used by the io-throttle controller to limit
> the dirty-ratio in memory is to impose a sleep via
> schedule_timeout_killable() in balance_dirty_pages() when a generic
> process exceeds the limits defined for the belonging cgroup.

I guess it would make the memory controller team guys happier if you
can help them design their dirty-page ratio controlling functionality
much cooler and more generic. I think their goal is almost the same
as yours.

> Limiting read operations is a lot more easy, because they're always
> synchronized with i/o requests.
> 
> -Andrea

Thank you,
Hirokazu Takahashi.
