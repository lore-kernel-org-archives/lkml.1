Return-Path: <linux-kernel-owner+w=401wt.eu-S1752545AbZH1PVw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbZH1PVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Aug 2009 11:21:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752472AbZH1PVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Aug 2009 11:21:51 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54309 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbZH1PVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Aug 2009 11:21:50 -0400
Message-ID: <b9c52b465bda540da8dbcd434bff55be.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <20090828151011.GS4889@balbir.in.ibm.com>
References: <20090828132015.10a42e40.kamezawa.hiroyu@jp.fujitsu.com>
    <20090828132438.b33828bc.kamezawa.hiroyu@jp.fujitsu.com>
    <20090828151011.GS4889@balbir.in.ibm.com>
Date: Sat, 29 Aug 2009 00:21:50 +0900 (JST)
Subject: Re: [RFC][PATCH 2/5] memcg: uncharge in batched manner
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh さんは書きました：
> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-08-28
> 13:24:38]:
>
>>
>> In massive parallel enviroment, res_counter can be a performance
>> bottleneck.
>> This patch is a trial for reducing lock contention.
>> One strong techinque to reduce lock contention is reducing calls by
>> batching some amount of calls int one.
>>
>> Considering charge/uncharge chatacteristic,
>> 	- charge is done one by one via demand-paging.
>> 	- uncharge is done by
>> 		- in chunk at munmap, truncate, exit, execve...
>> 		- one by one via vmscan/paging.
>>
>> It seems we hace a chance to batched-uncharge.
>> This patch is a base patch for batched uncharge. For avoiding
>> scattering memcg's structure, this patch adds memcg batch uncharge
>> information to the task. please see start/end usage in next patch.
>>
>
> Overall it is a very good idea, can't we do the uncharge at the poin
> tof unmap_vmas, exit_mmap, etc so that we don't have to keep
> additional data structures around.
>
We can't. We uncharge when page->mapcount goes down to 0.
This is unknown until page_remove_rmap() decrement page->mapcount
by "atomic" ops.

My first version allocated memcg_batch_info on stack ...and..
I had to pass an extra argument to page_remove_rmap() etc....
That was very ugly ;(
Now, I adds per-task memcg_batch_info to task struct.
Because it will be always used at exit() and make exit() path
much faster, it's not very costly.

Thanks,
-Kame


