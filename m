Return-Path: <linux-kernel-owner+w=401wt.eu-S1759197AbZAVXE6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759197AbZAVXE6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 18:04:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754688AbZAVXEu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 18:04:50 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:59706 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754255AbZAVXEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 18:04:49 -0500
Date: Fri, 23 Jan 2009 00:04:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>, hpa@zytor.com,
       jeremy@xensource.com, chrisw@sous-sol.org, zach@vmware.com,
       rusty@rustcorp.com.au
Subject: Re: lmbench lat_mmap slowdown with CONFIG_PARAVIRT
Message-ID: <20090122230423.GA19569@elte.hu>
References: <20090120110542.GE19505@wotan.suse.de> <20090120112634.GA20858@elte.hu> <4978F2A4.8010807@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4978F2A4.8010807@goop.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> Ingo Molnar wrote:
>> Ouch, that looks unacceptably expensive. All the major distros turn  
>> CONFIG_PARAVIRT on. paravirt_ops was introduced in x86 with the express 
>> promise to have no measurable runtime overhead.
>>
>> ( And i suspect the real life mmap cost is probably even more expensive,
>>   as on a Barcelona all of lmbench fits into the cache hence we dont see
>>   any real $cache overhead. )
>>
>> Jeremy, any ideas where this slowdown comes from and how it could be  
>> fixed?
>>   
>
> I just posted a couple of patches to pick some low-hanging fruit.  It 
> turns out that we don't need to do any pvops calls to do pte flag 
> manipulations.  I'd be interested to see how much of a difference it 
> makes (it reduces the static code size by a few k).

I've tried your patches - but can see no significant reduction in 
overhead. I've updated my table with numbers from your patches:

 -----------------------------------------------
 | Performance counter stats for './mmap-perf' |
 -----------------------------------------------
 |            |            |
 | defconfig  | PARAVIRT=y |    +Jeremy
 |-----------------------------------------------------------------------
 |
 | 1311.55452 | 1360.62493 | 1378.94464  task clock (msecs)        +3.74%
 |            |            |
 |          1 |          1 |          0  CPU migrations
 |         91 |         79 |         77  context switches
 |      55945 |      55943 |      55980  pagefaults
 |.......................................................................
 | 3781392474 | 3918777174 | 3907189795  CPU cycles                +3.63%
 | 1957153827 | 2161280486 | 2161741689  instructions             +10.43%
 |   50234816 |   51303520 |   50619593  cache references          +2.12%
 |    5428258 |    5583728 |    5575808  cache misses              +2.86%
 |
 |  437983499 |  478967061 |  479053595  branches                  +9.36%
 |   32486067 |   32336874 |   32377710  branch-misses             -0.46%
 |            |
 | 1314.78246 | 1363.69444 | 1357.58161  time elapsed (msecs)       +3.72%
 |            |
 ------------------------------------------------------------------------

'+Jeremy' is a CONFIG_PARAVIRT=y run done with your patches.

The most stable count is the instruction count:

 | 1957153827 | 2161280486 | 2161741689  instructions             +10.43%

But your two patches did not reduce the instruction count in any 
measurable way.

In any case, it is rather inefficient of me proxy-testing your patches, 
you can do these measurements yourself too on any Core2 or later Intel 
CPU, by running tip/master plus picking up these two utilities:

    http://people.redhat.com/mingo/perfcounters/perfstat.c
    http://redhat.com/~mingo/misc/mmap-perf.c

building them and running this (as root):

    taskset 1 ./perfstat ./mmap-perf 1

it will give you numbers like the ones above.

	Ingo
