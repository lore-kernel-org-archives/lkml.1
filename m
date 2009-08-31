Return-Path: <linux-kernel-owner+w=401wt.eu-S1753086AbZHaM76@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086AbZHaM76 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 08:59:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbZHaM75
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 08:59:57 -0400
Received: from mga14.intel.com ([143.182.124.37]:32551 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752642AbZHaM7z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 08:59:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="182333842"
Date: Mon, 31 Aug 2009 20:59:41 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "menage@google.com" <menage@google.com>, linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH 0/4] memcg: add support for hwpoison testing
Message-ID: <20090831125941.GA20982@localhost>
References: <20090831102640.092092954@intel.com> <20090831124920.GN4770@balbir.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090831124920.GN4770@balbir.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 31, 2009 at 08:49:20PM +0800, Balbir Singh wrote:
> * Wu Fengguang <fengguang.wu@intel.com> [2009-08-31 18:26:40]:
> 
> > Hi all,
> > 
> > In hardware poison testing, we want to inject hwpoison errors to pages
> > of a collection of selected tasks, so that random tasks (eg. init) won't
> > be killed in stress tests and lead to test failure.
> > 
> > Memory cgroup provides an ideal tool for tracking and testing these target
> > process pages. All we have to do is to
> > - export the memory cgroup id via cgroupfs
> > - export two functions/structs for hwpoison_inject.c
> > 
> > This might be an unexpected usage of memory cgroup. The last patch and this
> > script demonstrates how the exported interfaces are to be used to limit the
> > scope of hwpoison injection.
> > 
> > 	test -d /cgroup/hwpoison && rmdir /cgroup/hwpoison
> > 	mkdir /cgroup/hwpoison
> > 
> > 	usemem -m 100 -s 100 &   # eat 100MB and sleep 100s
> > 	echo `pidof usemem` > /cgroup/hwpoison/tasks
> > 
> > ==>     memcg_id=$(</cgroup/hwpoison/memory.id)
> > ==>     echo $memcg_id > /debug/hwpoison/corrupt-filter-memcg
> > 
> > 	# hwpoison all pfn
> > 	pfn=0
> > 	while true
> > 	do      
> > 		let pfn=pfn+1
> > 		echo $pfn > /debug/hwpoison/corrupt-pfn
> > 		if [ $? -ne 0 ]; then
> > 			break
> > 		fi
> > 	done
> > 
> > Comments are welcome, thanks!
> >
> 
> I took a quick look and the patches seem OKAY to me, but I have
> question, can't we do all of this from user space? The bits about
> id export and import the ids look like they can be replaced by names
> in user space.

You mean to match by cgrp->dentry->d_name.name in kernel hwpoison_inject.c
and do this in user space?

        DIR_NAME=hwpoison
        mkdir /cgroup/$DIR_NAME
        echo $DIR_NAME > /debug/hwpoison/corrupt-filter-memcg

Looks like a good idea!

Thanks,
Fengguang
