Return-Path: <linux-kernel-owner+w=401wt.eu-S1755778AbZCDHy6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755778AbZCDHy6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 02:54:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753205AbZCDHyr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 02:54:47 -0500
Received: from mail-gx0-f174.google.com ([209.85.217.174]:45061 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036AbZCDHyp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 02:54:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EqwtN4jShLLVsyKX/drpjfE4cykhLaZvYI95MEW99tgH3Z2Aj+/TjXuTOJuvZEMjlG
         OlDHGmzYqgDC2Xb5IgWSaFeSAiVl4texA4Iy/xwbIxZvigZCuKViyHVQcNhG0FfiUWPu
         5Mq/pMMhbQeRSS9Z9OMHeGhXgpqhmyBX0MZ1U=
MIME-Version: 1.0
In-Reply-To: <20090304153245.109eada4.kamezawa.hiroyu@jp.fujitsu.com>
References: <49A65455.4030204@cn.fujitsu.com>
	 <20090227122239.875a3f56.kamezawa.hiroyu@jp.fujitsu.com>
	 <1236005770.5330.583.camel@laptop>
	 <20090303084218.28010267.kamezawa.hiroyu@jp.fujitsu.com>
	 <1236066689.18955.27.camel@twins>
	 <d4132000000381ebc2ba5c2ffe9bb1bd.squirrel@webmail-b.css.fujitsu.com>
	 <1236073236.18955.46.camel@twins>
	 <2d4a44772433903887651c0bfe74c9cc.squirrel@webmail-b.css.fujitsu.com>
	 <1236081288.5330.4105.camel@laptop>
	 <20090304153245.109eada4.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 4 Mar 2009 13:24:43 +0530
Message-ID: <344eb09a0903032354r38d74c48p217d338cba7159e8@mail.gmail.com>
Subject: Re: [PATCH] remove rq->lock from cpuacct cgroup v2
From: Bharata B Rao <bharata.rao@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, paulmck@linux.vnet.ibm.com,
       Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Paul Menage <menage@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>, kenchen@google.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 4, 2009 at 12:02 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> cgroup/cpuacct subsystem counts cpu usage by 64bit coutnter in
> per-cpu object. In read-side (via cpuacct.usage file), for reading 64bit
> value in safe manner, it takes rq->lock of (other) cpus.
>
> In general, taking rq->lock of other cpus from codes not for scheduler
> is not good. This patch tries to remove rq->lock in read-side.
>
> To read 64bit value in atomic, this patch uses seqcounter.
>
> Pros.
>  - rq->lock is not necessary.
> Cons.
>  - When updating counter, sequence number must be updated.
>    (I hope this per-cpu sequence number is on cache...)
>
> Changelog: v1->v2
>  - checking calling context of all calls and avoid unnecessary
>   preempt_disable calls.
>  - use on_each_cpu() instead of workqueue, at reset
>
> Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

So cpuacct->cpuusage is a 64 bit percpu counter and I see that cpuacct
subsystem itself handles the following special cases:
- 32 vs 64 bit update issues
- resetting percpu counters on online and offline cpus

Tomorrow if I add other counters to cpuacct subsystem (like stime and
utime), I need to do what you have done in this patch all over again
for the additional counters.

Instead of subsystems handling all these percpu counter problems
themselves, shouldn't we be using percpu_counter subsytem and let it
handle all the issues transparently for us ? I am not sure if all
these problems have been addressed in percpu_counter, but would like
to know why we are not using percpu_counter for these kinds of things
and enhance percpu_counter if it can't handle some of the issues which
we are solving here specifically for cpuacct subsystem ?

Regards,
Bharata.
-- 
http://bharata.sulekha.com/blog/posts.htm
