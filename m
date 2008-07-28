Return-Path: <linux-kernel-owner+w=401wt.eu-S1753621AbYG1Xm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621AbYG1Xm5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 19:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752826AbYG1Xml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 19:42:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60401 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752503AbYG1Xmk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 19:42:40 -0400
Date: Mon, 28 Jul 2008 16:41:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: PERF: performance tests with the split LRU VM in -mm
Message-Id: <20080728164124.8240eabe.akpm@linux-foundation.org>
In-Reply-To: <20080728105742.50d6514e@cuia.bos.redhat.com>
References: <20080724222510.3bbbbedc@bree.surriel.com>
	<20080728105742.50d6514e@cuia.bos.redhat.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Jul 2008 10:57:42 -0400
Rik van Riel <riel@redhat.com> wrote:

> On Thu, 24 Jul 2008 22:25:10 -0400
> Rik van Riel <riel@redhat.com> wrote:
> 
> >   TEST 1: dd if=/dev/sda of=/dev/null bs=1M
> > 
> > kernel  speed    swap used
> > 
> > 2.6.26  111MB/s  500kB
> > -mm     110MB/s  59MB     (ouch, system noticably slower)
> > noforce	111MB/s  128kB
> > stream  108MB/s  0        (slight regression, not sure why yet)
> > 
> > This patch shows that the split LRU VM in -mm has a problem
> > with large streaming IOs: the working set gets pushed out of
> > memory, which makes doing anything else during the big streaming
> > IO kind of painful.
> > 
> > However, either of the two patches posted fixes that problem,
> > though at a slight performance penalty for the "stream" patch.
> 
> OK, the throughput number with this test turns out not to mean
> nearly as much as I thought.
> 
> Switching off CPU frequency scaling, pinning the CPUs at the
> highest speed, resulted in a throughput of only 102MB/s.
> 
> My suspicion is that faster running code on the CPU results
> in IOs being sent down to the device faster, resulting in
> smaller IOs and lower throughput.
> 
> This would be promising for the "stream" patch, which makes
> choosing between the two patches harder :)
> 
> Andrew, what is your preference between:
> 	http://lkml.org/lkml/2008/7/15/465
> and
> 	http://marc.info/?l=linux-mm&m=121683855132630&w=2
> 

Boy.  They both seem rather hacky special-cases.  But that doesn't mean
that they're undesirable hacky special-cases.  I guess the second one
looks a bit more "algorithmic" and a bit less hacky-special-case.  But
it all depends on testing..

On a different topic, these:

vmscan-give-referenced-active-and-unmapped-pages-a-second-trip-around-the-lru.patch
vm-dont-run-touch_buffer-during-buffercache-lookups.patch

have been floating about in -mm for ages, awaiting demonstration that
they're a net benefit.  But all of this new page-reclaim rework was
built on top of those two patches and incorporates and retains them.

I could toss them out, but that would require some rework and would
partially invalidate previous testing and who knows, they _might_ be
good patches.  Or they might not be.

What are your thoughts?
