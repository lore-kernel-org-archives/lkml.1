Return-Path: <linux-kernel-owner+w=401wt.eu-S1763182AbYBUJjW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763182AbYBUJjW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 04:39:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753004AbYBUJiz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 04:38:55 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:24554 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071AbYBUJiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 04:38:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=tMHtL7z+J/tK/AkuHE9FLHKMsfLmn2VfT1CDZCMcD25tzBJCEOjBkWe7bXlrqZ2Wpnns8cXkNF5VVKMD+xfWIh6Wt/3mP5DAbUOSGUBmKmmwwqWds8tLRMvnosfaqsO7ntE3zLov50K3PTnD4aXA/VXZp+gqx6tOtJhOS83pAKM=
Message-ID: <44c63dc40802210138s100e921ekde01b30bae13beb1@mail.gmail.com>
Date: Thu, 21 Feb 2008 18:38:51 +0900
From: "minchan Kim" <barrioskmc@gmail.com>
To: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC][PATCH] the proposal of improve page reclaim by throttle
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "Balbir Singh" <balbir@linux.vnet.ibm.com>,
       "Rik van Riel" <riel@redhat.com>,
       "Lee Schermerhorn" <Lee.Schermerhorn@hp.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080220185648.6447.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080220181447.6444.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <44c63dc40802200149r6b03d970g2fbde74b85ad5443@mail.gmail.com>
	 <20080220185648.6447.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I miss CC's. so I resend.


First of all, I tried test it in embedded board.

---
<test machine>
      CPU:  200MHz(ARM926EJ-S)
      MEM:  32M
      SWAP: none
      KERNEL : 2.6.25-rc1

<test 1> - NO SWAP

before :

Running with 5*40 (== 200) tasks.

Time: 12.591
       Command being timed: "./hackbench.arm 5 process 100"
       User time (seconds): 0.78
       System time(seconds): 13.39
       Percent of CPU this job got: 99%
       Elapsed (wall clock) time (h:mm:ss or m:ss): 0m 14.22s
       Major (requiring I/O) page faults: 20
       max parallel reclaim tasks:     30
       max consumption time of
        try_to_free_pages():           789

after:

Running with 5*40 (== 200) tasks.
Time: 11.535
       Command being timed: "./hackbench.arm 5 process 100"
       User time (seconds): 0.69
       System time (seconds): 12.42
       Percent of CPU this job got: 99%
       Elapsed (wall clock) time (h:mm:ss or m:ss): 0m 13.16s
       Major (requiring I/O) page faults: 18
       max parallel reclaim tasks:     4
       max consumption time of
       try_to_free_pages():           740

<test 2> - SWAP
before:
Running with 6*40 (== 240) tasks.
Time: 121.686
       Command being timed: "./hackbench.arm 6 process 100"
       User time (seconds): 1.89
       System time (seconds): 44.95
       Percent of CPU this job got: 37%
       Elapsed (wall clock) time (h:mm:ss or m:ss): 2m 3.79s
       Major (requiring I/O) page faults: 230
       max parallel reclaim tasks:     56
       max consumption time of
       try_to_free_pages():           10811


after :
Running with 6*40 (== 240) tasks.
Time: 67.757
       Command being timed: "./hackbench.arm 6 process 100"
       User time (seconds): 1.56
       System time (seconds): 35.41
       Percent of CPU this job got: 52%
       Elapsed (wall clock) time (h:mm:ss or m:ss): 1m 9.87s
       Major (requiring I/O) page faults: 16
       max parallel reclaim tasks:     4
       max consumption time of
         try_to_free_pages():           6419

<test 3> NO_SWAP

before:

' OOM killer kill hackbench!!!'

after :
Time: 16.578
       Command being timed: "./hackbench.arm 6 process 100"
       User time (seconds): 0.71
       System time (seconds): 17.92
       Percent of CPU this job got: 99%
       Elapsed (wall clock) time (h:mm:ss or m:ss): 0m 18.69s
       Major (requiring I/O) page faults: 22
       max parallel reclaim tasks:     4
       max consumption time of
        try_to_free_pages():           1785

===============================

It was a very interesting result.
In embedded system, your patch improve performance a little in case
without noswap(normal case in embedded system).
But, more important thing is OOM occured when I made 240 process
without swap device and vanilla kernel.
Then, I applied your patch, it worked very well without OOM.

I think that's why zone's page_scanned was six times greater than
number of lru pages.
At result, OOM happened.

So, I think your patch also improves performance in embedded system.

In case OOM didn't occur, reclaiming performance without swap device
was better than one with swap device.
Now, I think we need to improve reclaiming procedure in embedded
system(UP and NO swap).

On Wed, Feb 20, 2008 at 7:09 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> Hi
>
>
>  > > >  * max parallel reclaim tasks:
>  > > >  *  max consumption time of
>  > > >         try_to_free_pages():
>  > >
>  > > sorry, I inserted debug code to my patch at that time.
>  >
>  > Could you send me that debug code ?
>  > If you will send it to me, I will test it my environment (ARM-920T, Core2Duo).
>  > And I will report test result.
>
>  attached it.
>  but it is very messy ;-)
>
>  usage:
>  ./benchloop.sh
>
>  sample output
>  =========================================================
>  max reclaim 2
>  Running with 120*40 (== 4800) tasks.
>  Time: 34.177
>  14.17user 284.38system 1:43.85elapsed 287%CPU (0avgtext+0avgdata 0maxresident)k
>  0inputs+0outputs (3813major+148922minor)pagefaults 0swaps
>  max prepare time: 4599 0
>  max reclaim time: 2350 5781
>  total
>  8271
>  max reclaimer
>  4
>  max overkill
>  62131
>  max saved overkill
>  9740
>
>
>  max reclaimer represent to max parallel reclaim tasks.
>  total represetnto max consumption time of try_to_free_pages().
>
>  Thanks
>
>



-- 
Thanks,
barrios
