Return-Path: <linux-kernel-owner+w=401wt.eu-S1753479AbZI2HOp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbZI2HOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 03:14:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753362AbZI2HOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 03:14:45 -0400
Received: from an-out-0708.google.com ([209.85.132.246]:12443 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbZI2HOo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 03:14:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=P7SHmY/uXTjR5H7Nop+FVnHpzEOX+O9q+ZDmY+XOgSFxcvWScvfP88KHhfw/AeVEch
         sKTeOOSs8RJ8IutzdF71+ZFw5gonC+I16J/SCKRd0DdO0NJP/W6LzWjZsGiSEl6bYkKu
         JZ07gyog36mtm7H1KRRqxp3KNrNGsIVoByhDw=
MIME-Version: 1.0
In-Reply-To: <1254164034.9820.81.camel@marge.simson.net>
References: <1253820332-10246-1-git-send-email-vgoyal@redhat.com>
	 <4ABC28DE.7050809@datenparkplatz.de>
	 <20090925202636.GC15007@redhat.com>
	 <4e5e476b0909271000u69d79346s27cccad219e49902@mail.gmail.com>
	 <20090928145655.GB8192@redhat.com>
	 <4e5e476b0909280835w3410d58aod93a29d1dcda8909@mail.gmail.com>
	 <1254160274.9820.25.camel@marge.simson.net>
	 <20090928181846.GC3643@redhat.com>
	 <1254164034.9820.81.camel@marge.simson.net>
Date: Tue, 29 Sep 2009 09:14:48 +0200
Message-ID: <4e5e476b0909290014u1374e65an859528441373510f@mail.gmail.com>
Subject: Re: IO scheduler based IO controller V10
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Vivek Goyal <vgoyal@redhat.com>,
       Ulrich Lukas <stellplatz-nr.13a@datenparkplatz.de>,
       linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       dm-devel@redhat.com, nauman@google.com, dpshah@google.com,
       lizf@cn.fujitsu.com, mikew@google.com, fchecconi@gmail.com,
       paolo.valente@unimore.it, ryov@valinux.co.jp, fernando@oss.ntt.co.jp,
       jmoyer@redhat.com, dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu, riel@redhat.com,
       jens.axboe@oracle.com, Tobias Oetiker <tobi@oetiker.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,
On Mon, Sep 28, 2009 at 8:53 PM, Mike Galbraith <efault@gmx.de> wrote:
> On Mon, 2009-09-28 at 14:18 -0400, Vivek Goyal wrote:
>> On Mon, Sep 28, 2009 at 07:51:14PM +0200, Mike Galbraith wrote:
>
>> I guess changing class to IDLE should have helped a bit as now this is
>> equivalent to setting the quantum to 1 and after dispatching one request
>> to disk, CFQ will always expire the writer once. So it might happen that
>> by the the reader preempted writer, we have less number of requests in
>> disk and lesser latency for this reader.
>
> I expected SCHED_IDLE to be better than setting quantum to 1, because
> max is quantum*4 if you aren't IDLE.  But that's not what happened.  I
> just retested with all knobs set back to stock, fairness off, and
> quantum set to 1 with everything running nice 0.  2.8 seconds avg :-/

Idle doesn't work very well for async writes, since the writer process
will just send its writes to the page cache.
The real writeback will happen in the context of a kernel thread, with
best effort scheduling class.

>
>> > I saw
>> > the reference to Vivek's patch, and gave it a shot.  Makes a large
>> > difference.
>> >                                                            Avg
>> > perf stat     12.82     7.19     8.49     5.76     9.32    8.7     anticipatory
>> >               16.24   175.82   154.38   228.97   147.16  144.5     noop
>> >               43.23    57.39    96.13   148.25   180.09  105.0     deadline
>> >                9.15    14.51     9.39    15.06     9.90   11.6     cfq fairness=0 dd=nice 0
>> >               12.22     9.85    12.55     9.88    15.06   11.9     cfq fairness=0 dd=nice 19
>> >                9.77    13.19    11.78    17.40     9.51   11.9     cfq fairness=0 dd=SCHED_IDLE
>> >                4.59     2.74     4.70     3.45     4.69    4.0     cfq fairness=1 dd=nice 0
>> >                3.79     4.66     2.66     5.15     3.03    3.8     cfq fairness=1 dd=nice 19
>> >                2.79     4.73     2.79     4.02     2.50    3.3     cfq fairness=1 dd=SCHED_IDLE
>> >
>>
>> Hmm.., looks like average latency went down only in  case of fairness=1
>> and not in case of fairness=0. (Looking at previous mail, average vanilla
>> cfq latencies were around 12 seconds).
>
> Yup.
>
>> Are you running all this in root group or have you put writers and readers
>> into separate cgroups?
>
> No cgroups here.
>
>> If everything is running in root group, then I am curious why latency went
>> down in case of fairness=1. The only thing fairness=1 parameter does is
>> that it lets complete all the requests from previous queue before start
>> dispatching from next queue. On top of this is valid only if no preemption
>> took place. In your test case, konsole should preempt the writer so
>> practically fairness=1 might not make much difference.
>
> fairness=1 very definitely makes a very large difference.  All of those
> cfq numbers were logged in back to back runs.
>
>> In fact now Jens has committed a patch which achieves the similar effect as
>> fairness=1 for async queues.
>
> Yeah, I was there yesterday.  I speculated that that would hurt my
> reader, but rearranging things didn't help one bit.  Playing with merge,
> I managed to give dd ~7% more throughput, and injured poor reader even
> more.  (problem analysis via hammer/axe not always most effective;)
>
>> commit 5ad531db6e0f3c3c985666e83d3c1c4d53acccf9
>> Author: Jens Axboe <jens.axboe@oracle.com>
>> Date:   Fri Jul 3 12:57:48 2009 +0200
>>
>>     cfq-iosched: drain device queue before switching to a sync queue
>>
>>     To lessen the impact of async IO on sync IO, let the device drain of
>>     any async IO in progress when switching to a sync cfqq that has idling
>>     enabled.
>>
>>
>> If everything is in separate cgroups, then we should have seen latency
>> improvements in case of fairness=0 case also. I am little perplexed here..
>>
>> Thanks
>> Vivek
>
>

Thanks,
Corrado


-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
The self-confidence of a warrior is not the self-confidence of the average
man. The average man seeks certainty in the eyes of the onlooker and calls
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
                               Tales of Power - C. Castaneda
