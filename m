Return-Path: <linux-kernel-owner+w=401wt.eu-S1755330AbYDTXmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755330AbYDTXmR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 19:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbYDTXmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 19:42:06 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:47328 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931AbYDTXmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 19:42:05 -0400
Date: Mon, 21 Apr 2008 00:51:30 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: Paul Menage <menage@google.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Pavel Emelianov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Shi Weihua <shiwh@cn.fujitsu.com>, Mel Gorman <mel@csn.ul.ie>,
       linux-kernel@vger.kernel.org
Subject: Re: -mm merge plans for 2.6.26 (memcgroup)
In-Reply-To: <20080420072053.6bcb7884.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0804210004470.1630@blonde.site>
References: <20080420072053.6bcb7884.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Apr 2008, Andrew Morton wrote:
> 
> These can be found at
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25/2.6.25-mm1

A couple of comments on memcgroup patches in your
high-priority initial section (I've not studied further yet)
> Merge, and backport to 2.6.25.x

>  disable-the-memory-controller-by-default-v3.patch
>  disable-the-memory-controller-by-default-v3-fix.patch

If those are to go in, then the sooner the better, yes.

But though I argued for cgroup_disable=memory (or some such),
I think myself that taking it even further now (requiring an
additional cgroup_enable=memory at boottime to get the memcg
stuff you chose with CGROUP_MEM_RES_CTLR=y at build time) is
confusing overkill, just messing around.

Others think differently.  A compromise would be to improve the
helptext for CGROUP_MEM_RES_CTLR (some of it is presently nonsense,
isn't it?  Certainly there's a significant overhead, but it's the
32-bit struct page not the 64-bit which then suffers from crossing
cacheline boundaries).  Not much point in mentioning
cgroup_disable=memory if those patches go in, but needs to say
cgroup_enable=memory bootoption also needed.

>  memcgroup-check-and-initialize-page-cgroup-in-memmap_init_zone.patch

No, it was a good find from Shi, but you were right to think the patch
fishy, and Kame put in lots of work (thank you!) to identify the actual
culprit: he and Mel are discussing what the actual fix should be; and
we might want to choose a different fix for stable than for 2.6.26.

I think you should drop that memmap_init_zone patch: the cgroup
pointer is not the only field we assume is zeroed, both flags and
mapping can cause trouble if they were not originally zeroed.
Re-zero the whole struct page?  No, far better to fix the
root of the corruption, that Kame and Mel are working on.

Hugh
