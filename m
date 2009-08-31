Return-Path: <linux-kernel-owner+w=401wt.eu-S1752218AbZHaXsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218AbZHaXsZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Aug 2009 19:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752100AbZHaXsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Aug 2009 19:48:25 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:56764 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751556AbZHaXsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Aug 2009 19:48:24 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 1 Sep 2009 08:46:26 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
       lizf@cn.fujitsu.com, nishimura@mxp.nes.nec.co.jp, menage@google.com,
       linux-mm <linux-mm@kvack.org>
Subject: Re: [RFC][PATCH 0/4] memcg: add support for hwpoison testing
Message-Id: <20090901084626.ac4c8879.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20090831102640.092092954@intel.com>
References: <20090831102640.092092954@intel.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Aug 2009 18:26:40 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> Hi all,
> 
> In hardware poison testing, we want to inject hwpoison errors to pages
> of a collection of selected tasks, so that random tasks (eg. init) won't
> be killed in stress tests and lead to test failure.
> 
> Memory cgroup provides an ideal tool for tracking and testing these target
> process pages. All we have to do is to
> - export the memory cgroup id via cgroupfs
> - export two functions/structs for hwpoison_inject.c
> 
> This might be an unexpected usage of memory cgroup. The last patch and this
> script demonstrates how the exported interfaces are to be used to limit the
> scope of hwpoison injection.
> 
> 	test -d /cgroup/hwpoison && rmdir /cgroup/hwpoison
> 	mkdir /cgroup/hwpoison
> 
> 	usemem -m 100 -s 100 &   # eat 100MB and sleep 100s
> 	echo `pidof usemem` > /cgroup/hwpoison/tasks
> 
> ==>     memcg_id=$(</cgroup/hwpoison/memory.id)
> ==>     echo $memcg_id > /debug/hwpoison/corrupt-filter-memcg
> 
> 	# hwpoison all pfn
> 	pfn=0
> 	while true
> 	do      
> 		let pfn=pfn+1
> 		echo $pfn > /debug/hwpoison/corrupt-pfn
> 		if [ $? -ne 0 ]; then
> 			break
> 		fi
> 	done
> 

I don't like this.

1. plz put all under CONFIG_DEBUG_HWPOISON or some
2. plz don't export memcg's id. you can do it without it.
3. If I was you, just adds following file

	memory.hwpoison_test
   Then, if you allow test
	#echo 1 >	memory.hwpoison_test

4. I can't understand why you need this. I wonder you can get pfn via
   /proc/<pid>/????. And this may insert HWPOISON to page-cache of shared
   library and "unexpected" process will be poisoned.

Thanks,
-Kame

> Comments are welcome, thanks!
> 
> Cheers,
> Fengguang
> -- 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

