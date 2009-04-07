Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbZDGHCV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbZDGHCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 03:02:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754250AbZDGHBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 03:01:52 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55691 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbZDGHBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 03:01:47 -0400
Date: Tue, 7 Apr 2009 16:00:14 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       Rik van Riel <riel@surriel.com>, Bharata B Rao <bharata.rao@in.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFI] Shared accounting for memory resource controller
Message-Id: <20090407160014.8c545c3c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090407063722.GQ7082@balbir.in.ibm.com>
References: <20090407063722.GQ7082@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Apr 2009 12:07:22 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> Hi, All,
> 
> This is a request for input for the design of shared page accounting for
> the memory resource controller, here is what I have so far
> 

In my first impression, I think simple counting is impossible.
IOW, "usage count" and "shared or not" is very different problem.

Assume a page and its page_cgroup.

Case 1)
  1. a page is mapped by process-X under group-A
  2. its mapped by process-Y in group-B (now, shared and charged under group-A)
  3. move process-X to group-B
  4. now the page is not shared.

Case 2)
  swap is an object which can be shared.

Case 3)
  1. a page known as "A" is mapped by process-X under group-A.
  2. its mapped by process-Y under group-B(now, shared and charged under group-A)
  3. Do copy-on-write by process-X.
     Now, "A" is mapped only by B but accoutned under group-A.
     This case is ignored intentionally, now.
     Do you want to call try_charge() both against group-A and group-B
     under process-X's page fault ?

There will be many many corner case.


> Motivation for shared page accounting
> -------------------------------------
> 1. Memory cgroup administrators will benefit from the knowledge of how
>    much of the data is shared, it helps size the groups correctly.
> 2. We currently report only the pages brought in by the cgroup, knowledge
>    of shared data will give a complete picture of the actual usage.
> 

Motivation sounds good. But counting this in generic rmap will have tons of
troubles and slow-down.

I bet we should prepare a file as
  /proc/<pid>/cgroup_maps

And show RSS/RSS-owned-by-us per process. Maybe this feature will be able to be
implemented in 3 days.

Thanks,
-Kame

