Return-Path: <linux-kernel-owner+w=401wt.eu-S1754651AbYBSIEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754651AbYBSIEB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 03:04:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750798AbYBSIDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 03:03:53 -0500
Received: from n19.bullet.mail.mud.yahoo.com ([68.142.200.46]:32126 "HELO
	n19.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750774AbYBSIDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 03:03:52 -0500
X-Yahoo-Newman-Id: 238041.43690.bm@omp412.mail.mud.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=Ypsff5wg3ZZBr8LcOEabsYxOysoA1nr2tyo1WCz5vrr/9nh5vJGBDodvOTRiGIQVRcUlJ9tvi/DED5PJYNk3KvQgkgMP1cu24fwjfHHeSurI6XHe4k9H7W0BuIE66KfVmwAZEcIHPTqhs0w6hpoCXgDRaz7tfYXxJl6d8soZF44=  ;
X-YMail-OSG: 38IbXeoVM1mm2TBRqfaXydjGOx_tOKzoO3t.fcIa_uiHTCs4y3P6a1tBOLJAK3eYxkESpr91MyUPgtYMp4G6kBJzr72OBShvGWj_hiiw1gl0h0E4xG5TwXIhsR0Zbg--
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] the proposal of improve page reclaim by throttle
Date: Tue, 19 Feb 2008 17:34:59 +1100
User-Agent: KMail/1.9.5
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
References: <20080219134715.7E90.KOSAKI.MOTOHIRO@jp.fujitsu.com>
In-Reply-To: <20080219134715.7E90.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802191735.00222.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 February 2008 16:44, KOSAKI Motohiro wrote:
> background
> ========================================
> current VM implementation doesn't has limit of # of parallel reclaim.
> when heavy workload, it bring to 2 bad things
>   - heavy lock contention
>   - unnecessary swap out
>
> abount 2 month ago, KAMEZA Hiroyuki proposed the patch of page
> reclaim throttle and explain it improve reclaim time.
> 	http://marc.info/?l=linux-mm&m=119667465917215&w=2
>
> but unfortunately it works only memcgroup reclaim.
> Today, I implement it again for support global reclaim and mesure it.
>
>
> test machine, method and result
> ==================================================
> <test machine>
> 	CPU:  IA64 x8
> 	MEM:  8GB
> 	SWAP: 2GB
>
> <test method>
> 	got hackbench from
> 		http://people.redhat.com/mingo/cfs-scheduler/tools/hackbench.c
>
> 	$ /usr/bin/time hackbench 120 process 1000
>
> 	this parameter mean consume all physical memory and
> 	1GB swap space on my test environment.
>
> <test result (average of 3 times measurement)>
>
> before:
> 	hackbench result:		282.30
> 	/usr/bin/time result
> 		user:			14.16
> 		sys:			1248.47
> 		elapse:			432.93
> 		major fault:		29026
> 	max parallel reclaim tasks:	1298
> 	max consumption time of
> 	 try_to_free_pages():		70394
>
> after:
> 	hackbench result:		30.36
> 	/usr/bin/time result
> 		user:			14.26
> 		sys:			294.44
> 		elapse:			118.01
> 		major fault:		3064
> 	max parallel reclaim tasks:	4
> 	max consumption time of
> 	 try_to_free_pages():		12234
>
>
> conclusion
> =========================================
> this patch improve 3 things.
> 1. reduce unnecessary swap
>    (see above major fault. about 90% reduced)
> 2. improve throughput performance
>    (see above hackbench result. about 90% reduced)
> 3. improve interactive performance.
>    (see above max consumption of try_to_free_pages.
>     about 80% reduced)
> 4. reduce lock contention.
>    (see above sys time. about 80% reduced)
>
>
> Now, we got about 1000% performance improvement of hackbench :)
>
>
>
> foture works
> ==========================================================
>  - more discussion with memory controller guys.

Hi,

Yeah this is definitely needed and a nice result.

I'm worried about a) placing a global limit on parallelism, and b)
placing a limit on parallelism at all.

I think it should maybe be a per-zone thing...

What happens if you make it a per-zone mutex, and allow just a single
process to reclaim pages from a given zone at a time? I guess that is
going to slow down throughput a little bit in some cases though...

