Return-Path: <linux-kernel-owner+w=401wt.eu-S1755913AbYACRAk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913AbYACRAk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 12:00:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932AbYACRAd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 12:00:33 -0500
Received: from mx1.redhat.com ([66.187.233.31]:36137 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146AbYACRAc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 12:00:32 -0500
Date: Thu, 3 Jan 2008 12:00:00 -0500
From: Rik van Riel <riel@redhat.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Eric Whitney <eric.whitney@hp.com>
Subject: Re: [patch 00/19] VM pageout scalability improvements
Message-ID: <20080103120000.1768f220@cuia.boston.redhat.com>
In-Reply-To: <1199379128.5295.21.camel@localhost>
References: <20080102224144.885671949@redhat.com>
	<1199379128.5295.21.camel@localhost>
Organization: Red Hat, Inc
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.14; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Jan 2008 11:52:08 -0500
Lee Schermerhorn <Lee.Schermerhorn@hp.com> wrote:

> Also, I should point out that the full noreclaim series includes a
> couple of other patches NOT posted here by Rik:
> 
> 1) treat swap backed pages as nonreclaimable when no swap space is
> available.  This addresses a problem we've seen in real life, with
> vmscan spending a lot of time trying to reclaim anon/shmem/tmpfs/...
> pages only to find that there is no swap space--add_to_swap() fails.
> Maybe not a problem with Rik's new anon page handling.

If there is no swap space, my VM code will not bother scanning
any anon pages.  This has the same effect as moving the pages
to the no-reclaim list, with the extra benefit of being able to
resume scanning the anon lists once swap space is freed.

> 2) treat anon pages with "excessively long" anon_vma lists as
> nonreclaimable.   "excessively long" here is a sysctl tunable parameter.
> This also addresses problems we've seen with benchmarks and stress
> tests--all cpus spinning on some anon_vma lock.  In "real life", we've
> seen this behavior with file backed pages--spinning on the
> i_mmap_lock--running Oracle workloads with user counts in the few
> thousands.  Again, something we may not need with Rik's vmscan rework.
> If we did want to do this, we'd probably want to address file backed
> pages and add support to bring the pages back from the noreclaim list
> when the number of "mappers" drops below the threshold.  My current
> patch leaves anon pages as non-reclaimable until they're freed, or
> manually scanned via the mechanism introduced by patch 12.

I can see some issues with that patch.  Specifically, if the threshold
is set too high no pages will be affected, and if the threshold is too
low all pages will become non-reclaimable, leading to a false OOM kill.

Not only is it a very big hammer, it's also a rather awkward one...

-- 
All Rights Reversed
