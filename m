Return-Path: <linux-kernel-owner+w=401wt.eu-S1751453AbXLAHkF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453AbXLAHkF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 02:40:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751019AbXLAHjs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 02:39:48 -0500
Received: from smtp-out.google.com ([216.239.45.13]:60712 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbXLAHjr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 02:39:47 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=JhjhgSDpDYfjVBF9TC49S88LnlMaD+NIeAcKZw9tLt0vKfmn7P09JbBFfeyjN9JM/
	OV59CtYhL9kpsxiKSmMFg==
Message-ID: <6599ad830711302339v1f92af40v85e89484a8a6575e@mail.gmail.com>
Date: Fri, 30 Nov 2007 23:39:37 -0800
From: "Paul Menage" <menage@google.com>
To: "Nick Piggin" <nickpiggin@yahoo.com.au>
Subject: Re: What can we do to get ready for memory controller merge in 2.6.25
Cc: balbir@linux.vnet.ibm.com,
       "Linux Memory Management List" <linux-mm@kvack.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "linux kernel mailing list" <linux-kernel@vger.kernel.org>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Hugh Dickins" <hugh@veritas.com>,
       "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>,
       "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Pavel Emelianov" <xemul@sw.ru>,
       "YAMAMOTO Takashi" <yamamoto@valinux.co.jp>,
       "Rik van Riel" <riel@redhat.com>,
       "Christoph Lameter" <clameter@sgi.com>,
       "Martin J. Bligh" <mbligh@google.com>,
       "Andy Whitcroft" <andyw@uk.ibm.com>,
       "Srivatsa Vaddagiri" <vatsa@in.ibm.com>
In-Reply-To: <200711301311.48291.nickpiggin@yahoo.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <474ED005.7060300@linux.vnet.ibm.com>
	 <200711301311.48291.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Nov 29, 2007 6:11 PM, Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> And also some
> results or even anecdotes of where this is going to be used would be
> interesting...

We want to be able to run multiple isolated jobs on the same machine.
So being able to limit how much memory each job can consume, in terms
of anonymous memory and page cache, are useful. I've not had much time
to look at the patches in great detail, but they seem to provide a
sensible way to assign and enforce static limits on a bunch of jobs.

Some of our requirements are a bit beyond this, though:

In our experience, users are not good at figuring out how much memory
they really need. In general they tend to massively over-estimate
their requirements. So we want some way to determine how much of its
allocated memory a job is actively using, and how much could be thrown
away or swapped out without bothering the job too much.

Of course, the definition of "actve use" is tricky - one possibility
that we're looking at is "has been accessed within the last N
seconds", where N can be configured appropriately for different jobs
depending on the job's latency requirements. Active use should also be
reported for pages that can't be easily freed quickly, e.g. mlocked or
dirty pages, or anon pages on a swapless system. Inactive pages should
be easily freeable, and be the first ones to go in the event of memory
pressure. (From a scheduling point of view we can treat them as free
memory, and schedule more jobs on the machine)

The existing active/inactive distinction doesn't really capture this,
since it's relative rather than absolute.

We want to be able to overcommit a machine, so the sums of the cgroup
memory limits can add up to more than the total machine memory. So we
need control over what happens when there's global memory pressure,
and a way to ensure that the low-latency jobs don't get bogged down in
reclaim (or OOM) due to the activity of batch jobs.

Paul
