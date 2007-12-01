Return-Path: <linux-kernel-owner+w=401wt.eu-S1754792AbXLASig@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754792AbXLASig (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 13:38:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753233AbXLASi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 13:38:27 -0500
Received: from mx1.redhat.com ([66.187.233.31]:35726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686AbXLASi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 13:38:26 -0500
Date: Sat, 1 Dec 2007 13:36:52 -0500
From: Rik van Riel <riel@redhat.com>
To: balbir@linux.vnet.ibm.com
Cc: Paul Menage <menage@google.com>, Nick Piggin <nickpiggin@yahoo.com.au>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Hugh Dickins <hugh@veritas.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Pavel Emelianov <xemul@sw.ru>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Christoph Lameter <clameter@sgi.com>,
       "Martin J. Bligh" <mbligh@google.com>,
       Andy Whitcroft <andyw@uk.ibm.com>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>
Subject: Re: What can we do to get ready for memory controller merge in
 2.6.25
Message-ID: <20071201133652.6888a717@bree.surriel.com>
In-Reply-To: <47512E65.9030803@linux.vnet.ibm.com>
References: <474ED005.7060300@linux.vnet.ibm.com>
	<200711301311.48291.nickpiggin@yahoo.com.au>
	<6599ad830711302339v1f92af40v85e89484a8a6575e@mail.gmail.com>
	<47512E65.9030803@linux.vnet.ibm.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 01 Dec 2007 15:20:29 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> > In our experience, users are not good at figuring out how much memory
> > they really need. In general they tend to massively over-estimate
> > their requirements. So we want some way to determine how much of its
> > allocated memory a job is actively using, and how much could be thrown
> > away or swapped out without bothering the job too much.
> 
> One would prefer the kernel provides the mechanism and user space
> provides the policy. The algorithms to assign limits can exist in user
> space and be supported by a good set of statistics.

With the /proc/refaults info, we can measure how much extra
memory each process group needs, if any.

As for how much memory a process group needs, at pageout time
we can check the fraction of pages that are accessed.  If 60%
of the pages were recently accessed at pageout time and this
process group is spending little or no time waiting for refaults,
40% of the pages are *not* recently accessed and we can probably
reduce the amount of memory assigned to this group.

Page cache that has only been accessed once can also be
counted as "not recently accessed", since streaming file
IO should not increase the working set of the process group.

-- 
"Debugging is twice as hard as writing the code in the first place.
Therefore, if you write the code as cleverly as possible, you are,
by definition, not smart enough to debug it." - Brian W. Kernighan
