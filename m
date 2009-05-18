Return-Path: <linux-kernel-owner+w=401wt.eu-S1755899AbZERQBg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755899AbZERQBg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 12:01:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752349AbZERQB3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 12:01:29 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34742 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbZERQB2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 12:01:28 -0400
Message-ID: <9d894a3625cacae5733b77853b9f0a21.squirrel@webmail-b.css.fujitsu.com>
In-Reply-To: <20090518104552.GB5156@balbir.in.ibm.com>
References: <b7dd123f0a15fff62150bc560747d7f0.squirrel@webmail-b.css.fujitsu.com>
    <20090515181639.GH4451@balbir.in.ibm.com>
    <20090518191107.8a7cc990.kamezawa.hiroyu@jp.fujitsu.com>
    <20090518104552.GB5156@balbir.in.ibm.com>
Date: Tue, 19 May 2009 01:01:00 +0900 (JST)
Subject: Re: [RFC] Low overhead patches for the memory cgroup controller
 (v2)
From: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "menage@google.com" <menage@google.com>,
       "KOSAKI Motohiro" <m-kosaki@ceres.dti.ne.jp>
User-Agent: SquirrelMail/1.4.16
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-2022-jp
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-05-18
> 19:11:07]:
>
>> On Fri, 15 May 2009 23:46:39 +0530
>> Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
>>
>> > * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-05-16
>> 02:45:03]:
>> >
>> > > Balbir Singh wrote:
>> > > > Feature: Remove the overhead associated with the root cgroup
>> > > >
>> > > > From: Balbir Singh <balbir@linux.vnet.ibm.com>
>> > > >
>> > > > This patch changes the memory cgroup and removes the overhead
>> associated
>> > > > with LRU maintenance of all pages in the root cgroup. As a
>> side-effect, we
>> > > > can
>> > > > no longer set a memory hard limit in the root cgroup.
>> > > >
>> > > > A new flag is used to track page_cgroup associated with the root
>> cgroup
>> > > > pages. A new flag to track whether the page has been accounted or
>> not
>> > > > has been added as well.
>> > > >
>> > > > Review comments higly appreciated
>> > > >
>> > > > Tests
>> > > >
>> > > > 1. Tested with allocate, touch and limit test case for a non-root
>> cgroup
>> > > > 2. For the root cgroup tested performance impact with reaim
>> > > >
>> > > >
>> > > > 		+patch		mmtom-08-may-2009
>> > > > AIM9		1362.93		1338.17
>> > > > Dbase		17457.75	16021.58
>> > > > New Dbase	18070.18	16518.54
>> > > > Shared		9681.85		8882.11
>> > > > Compute		16197.79	15226.13
>> > > >
>> > > Hmm, at first impression, I can't convice the numbers...
>> > > Just avoiding list_add/del makes programs _10%_ faster ?
>> > > Could you show changes in cpu cache-miss late if you can ?
>> > > (And why Aim9 goes bad ?)
>> >
>> > OK... I'll try but I am away on travel for 3 weeks :( you can try and
>> run
>> > this as well
>> >
>> tested aim7 with some config.
>>
>> CPU: Xeon 3.1GHz/4Core x2 (8cpu)
>> Memory: 32G
>> HDD: Usual? Scsi disk (just 1 disk)
>> (try_to_free_pages() etc...will never be called.)
>>
>> Multiuser config. #of tasks 1100 (near to peak on my host)
>>
>> 10runs.
>> rc6mm1 score(Jobs/min)
>> 44009.1 44844.5 44691.1 43981.9 44992.6
>> 44544.9 44179.1 44283.0 44442.9 45033.8  average=44500
>>
>> +patch
>> 44656.8 44270.8 44706.7 44106.1 44467.6
>> 44585.3 44167.0 44756.7 44853.9 44249.4  average=44482
>>
>> Dbase config. #of tasks 25
>> rc6mm1 score (jobs/min)
>> 11022.7 11018.9 11037.9 11003.8 11087.5
>> 11145.2 11133.6 11068.3 11091.3 11106.6 average=11071
>>
>> +patch
>> 10888.0 10973.7 10913.9 11000.0 10984.9
>> 10996.2 10969.9 10921.3 10921.3 11053.1 average=10962
>>
>> Hmm, 1% improvement ?
>> (I think this is reasonable score of the effect of this patch)
>>
>
> Thanks for the test, I have a 4 CPU system and I create 80 users,
> larger config shows larger difference at my end.
Sorry, above Dbase test was on 54 threads. I'll try 20*8=160 threads.

> I think even 1% is
> quite reasonable as you mentioned. If the patch looks fine, should we
> ask for larger testing by Andrew?
>
Hmm, as you like. My interest is bugfix for swap leaking now.
Because this change adds big special case, we need much tests, anyway.
And please show _environment_ where benchmarks run.
BTW, I wonder whetere we can have more improvements in this special case...

>> Anyway, I'm afraid of difference between mine and your kernel config.
>> plz enjoy your travel for now :)
>
> Sorry, I did not send you my .config, why do you think .config makes a
> difference?
I wanted to know what kind of DEBUG/TRACE config is on. and some others.

> I think loading AIM makes the difference and I also made
> one other change to the aim tests. I run with "sync" linked to
> /bin/true and use tmpfs for temporary partition and 20*numnber of cpus
> for number of users.
>
Is it usual method at using AIM ? (Sorry, I'm not sure).
It seems to break AIM7's purpose of "measuring typical workload"...

> If required, I can still send out my .config to you.
>
If you can, plz. (just for my interest ;)

Thanks,
-Kame


