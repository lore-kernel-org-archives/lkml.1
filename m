Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbZAHE0S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbZAHE0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 23:26:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752117AbZAHE0D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 23:26:03 -0500
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:45766 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427AbZAHE0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 23:26:01 -0500
Date: Thu, 8 Jan 2009 09:55:58 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>
Subject: Re: [RFC][PATCH 3/4] Memory controller soft limit organize cgroups
Message-ID: <20090108042558.GC7294@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090107184110.18062.41459.sendpatchset@localhost.localdomain> <20090107184128.18062.96016.sendpatchset@localhost.localdomain> <20090108101148.96e688f4.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090108101148.96e688f4.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-01-08 10:11:48]:

> On Thu, 08 Jan 2009 00:11:28 +0530
> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> 
> > From: Balbir Singh <balbir@linux.vnet.ibm.com>
> > 
> > This patch introduces a RB-Tree for storing memory cgroups that are over their
> > soft limit. The overall goal is to
> > 
> > 1. Add a memory cgroup to the RB-Tree when the soft limit is exceeded.
> >    We are careful about updates, updates take place only after a particular
> >    time interval has passed
> > 2. We remove the node from the RB-Tree when the usage goes below the soft
> >    limit
> > 
> > The next set of patches will exploit the RB-Tree to get the group that is
> > over its soft limit by the largest amount and reclaim from it, when we
> > face memory contention.
> > 
> 
> Hmm,  Could you clarify following ?
>   
>   - Usage of memory at insertsion and usage of memory at reclaim is different.
>     So, this *sorted* order by RB-tree isn't the best order in general.

True, but we frequently update the tree at an interval of HZ/4.
Updating at every page fault sounded like an overkill and building the
entire tree at reclaim is an overkill too.

>     Why don't you sort this at memory-reclaim dynamically ?
>   - Considering above, the look of RB tree can be
> 
>                 +30M (an amount over soft limit is 30M)
>                 /  \
>              -15M   +60M

We don't have elements below their soft limit in the tree

>      ?
> 
>     At least, pleease remove the node at uncharge() when the usage goes down.
>

We do remove the tree if it goes under its soft limit at commit_charge,
I thought I had the same code in uncharge(), but clearly that is
missing. Thanks, I'll add it there.


> Thanks,
> -Kame

-- 
	Balbir
