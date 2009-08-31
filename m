Return-Path: <linux-kernel-owner+w=401wt.eu-S1752046AbZHaKne@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046AbZHaKne (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 06:43:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbZHaKnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 06:43:33 -0400
Received: from mga14.intel.com ([143.182.124.37]:39277 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751884AbZHaKnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 06:43:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,271,1249282800"; 
   d="scan'208";a="182301503"
Message-Id: <20090831102640.092092954@intel.com>
User-Agent: quilt/0.46-1
Date: Mon, 31 Aug 2009 18:26:40 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
CC: Andi Kleen <andi@firstfloor.org>
cc: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Rik van Riel <riel@redhat.com>
CC: Mel Gorman <mel@csn.ul.ie>
CC: lizf@cn.fujitsu.com
CC: nishimura@mxp.nes.nec.co.jp
cc: menage@google.com
CC: linux-mm <linux-mm@kvack.org>
Subject: [RFC][PATCH 0/4] memcg: add support for hwpoison testing
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

In hardware poison testing, we want to inject hwpoison errors to pages
of a collection of selected tasks, so that random tasks (eg. init) won't
be killed in stress tests and lead to test failure.

Memory cgroup provides an ideal tool for tracking and testing these target
process pages. All we have to do is to
- export the memory cgroup id via cgroupfs
- export two functions/structs for hwpoison_inject.c

This might be an unexpected usage of memory cgroup. The last patch and this
script demonstrates how the exported interfaces are to be used to limit the
scope of hwpoison injection.

	test -d /cgroup/hwpoison && rmdir /cgroup/hwpoison
	mkdir /cgroup/hwpoison

	usemem -m 100 -s 100 &   # eat 100MB and sleep 100s
	echo `pidof usemem` > /cgroup/hwpoison/tasks

==>     memcg_id=$(</cgroup/hwpoison/memory.id)
==>     echo $memcg_id > /debug/hwpoison/corrupt-filter-memcg

	# hwpoison all pfn
	pfn=0
	while true
	do      
		let pfn=pfn+1
		echo $pfn > /debug/hwpoison/corrupt-pfn
		if [ $? -ne 0 ]; then
			break
		fi
	done

Comments are welcome, thanks!

Cheers,
Fengguang
-- 

