Return-Path: <linux-kernel-owner+w=401wt.eu-S1754435AbZF2RZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754435AbZF2RZM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 13:25:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753090AbZF2RZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 13:25:01 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60008 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752911AbZF2RZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 13:25:00 -0400
Date: Mon, 29 Jun 2009 13:23:09 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, jens.axboe@oracle.com, nauman@google.com,
       dpshah@google.com, lizf@cn.fujitsu.com, mikew@google.com,
       fchecconi@gmail.com, paolo.valente@unimore.it, ryov@valinux.co.jp,
       fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com, taka@valinux.co.jp,
       guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, jbaron@redhat.com,
       agk@redhat.com, snitzer@redhat.com, akpm@linux-foundation.org,
       peterz@infradead.org
Subject: Re: [RFC] IO scheduler based io controller (V5)
Message-ID: <20090629172309.GB4622@redhat.com>
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com> <4A48E601.2050203@vlnb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A48E601.2050203@vlnb.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 29, 2009 at 08:04:17PM +0400, Vladislav Bolkhovitin wrote:
> Hi,
>
> Vivek Goyal, on 06/20/2009 12:37 AM wrote:
>> Hi All,
>>
>> Here is the V5 of the IO controller patches generated on top of 2.6.30.
>>
>> Previous versions of the patches was posted here.
>>
>> (V1) http://lkml.org/lkml/2009/3/11/486
>> (V2) http://lkml.org/lkml/2009/5/5/275
>> (V3) http://lkml.org/lkml/2009/5/26/472
>> (V4) http://lkml.org/lkml/2009/6/8/580
>>
>> This patchset is still work in progress but I want to keep on getting the
>> snapshot of my tree out at regular intervals to get the feedback hence V5.
>
> [..]
>
>> Testing
>> =======
>>
>> I have been able to do only very basic testing of reads and writes.
>>
>> Test1 (Fairness for synchronous reads)
>> ======================================
>> - Two dd in two cgroups with cgrop weights 1000 and 500. Ran two "dd" in those
>>   cgroups (With CFQ scheduler and /sys/block/<device>/queue/fairness = 1)
>>
>> dd if=/mnt/$BLOCKDEV/zerofile1 of=/dev/null &
>> dd if=/mnt/$BLOCKDEV/zerofile2 of=/dev/null &
>>
>> 234179072 bytes (234 MB) copied, 3.9065 s, 59.9 MB/s
>> 234179072 bytes (234 MB) copied, 5.19232 s, 45.1 MB/s
>
> Sorry, but the above isn't a correct way to test proportional fairness  
> for synchronous reads. You need throughput only when *both* dd's  
> running, don't you?
>

Hi Vladislav,

Actually the focus here is following two lines.

group1 time=8 16 2471 group1 sectors=8 16 457840
group2 time=8 16 1220 group2 sectors=8 16 225736

I have pasted the output of dd completion output but as you pointed out
it does not mean much as higher weight dd finishes first and after that
second dd will get 100% of disk.

What I have done is that launch two dd jobs. The moment first dd finishes,
my scripts go and read up "io.disk_time" and "io.disk_sectors" files in two
cgroups.

disk_time keeps track of how much disk time a cgroup has got on a
particular disk and disk_sector keeps track of how many sector of IO a
cgroup has done on a particular disk.

Please notice above that once first dd (higher weight dd) finished, at
that point group1 got 2471 ms of disk time and group2 got 1220 ms of disk
time.

Similarly, by the time first dd finished, group1 has transferred 457840
sectors and group 2 has transferred 225736 sectors.

Here disk time of group1 is almost double of disk time received by group2.
(group1 weight=1000 and group2 weight=500). Currently like CFQ, we provide
fairness in terms of disk time.

So I think test should be fine. Just that output of "dd" is confusing and
probably I did not explain the testing procedure well. In next posting
will make the procedure more clear.

> Considering both transfers started simultaneously (which isn't obvious  
> too) in the way you test the throughput value only for the first  
> finished dd is correct, because after it finished, the second dd started  
> transferring data *alone*, hence the result throughput value for it got  
> partially for simultaneous, partially for alone reads, i.e. screwed.
>
> I'd suggest you instead test as 2 runs of:
>
> 1. while true; do dd if=/mnt/$BLOCKDEV/zerofile1 of=/dev/null; done
>    dd if=/mnt/$BLOCKDEV/zerofile2 of=/dev/null
>
> 2. while true; do dd if=/mnt/$BLOCKDEV/zerofile2 of=/dev/null; done
>    dd if=/mnt/$BLOCKDEV/zerofile1 of=/dev/null
>
> and take results from the standalone dd's.
>
> Vlad
