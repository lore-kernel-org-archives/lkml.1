Return-Path: <linux-kernel-owner+w=401wt.eu-S1755610AbZCDMLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbZCDMLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 07:11:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbZCDMLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 07:11:16 -0500
Received: from yx-out-2324.google.com ([74.125.44.29]:63025 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbZCDMLP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 07:11:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aqdtSXyiiMYA3dqsf1W86eMFaS6dTv/CLqZ9ZoUeAVXhWqfbyUe6CJladYqsqyw2qU
         CSzNzVl3wkynGa9TREf/6QzdylFroTnvSObT0HuFThNht8wldiTI1hmIYurpjzYBDrCs
         KnEP+AuKDcC9o29SLCDEH0FtieLAfWyDYCdTE=
MIME-Version: 1.0
In-Reply-To: <20090304172005.99f5b0a2.kamezawa.hiroyu@jp.fujitsu.com>
References: <49A65455.4030204@cn.fujitsu.com>
	 <20090303084218.28010267.kamezawa.hiroyu@jp.fujitsu.com>
	 <1236066689.18955.27.camel@twins>
	 <d4132000000381ebc2ba5c2ffe9bb1bd.squirrel@webmail-b.css.fujitsu.com>
	 <1236073236.18955.46.camel@twins>
	 <2d4a44772433903887651c0bfe74c9cc.squirrel@webmail-b.css.fujitsu.com>
	 <1236081288.5330.4105.camel@laptop>
	 <20090304153245.109eada4.kamezawa.hiroyu@jp.fujitsu.com>
	 <344eb09a0903032354r38d74c48p217d338cba7159e8@mail.gmail.com>
	 <20090304172005.99f5b0a2.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 4 Mar 2009 17:41:13 +0530
Message-ID: <344eb09a0903040411n12379babjb62d31d28b77d1e6@mail.gmail.com>
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

On Wed, Mar 4, 2009 at 1:50 PM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Wed, 4 Mar 2009 13:24:43 +0530
> Bharata B Rao <bharata.rao@gmail.com> wrote:
>
>> Instead of subsystems handling all these percpu counter problems
>> themselves, shouldn't we be using percpu_counter subsytem and let it
>> handle all the issues transparently for us ? I am not sure if all
>> these problems have been addressed in percpu_counter, but would like
>> to know why we are not using percpu_counter for these kinds of things
>> and enhance percpu_counter if it can't handle some of the issues which
>> we are solving here specifically for cpuacct subsystem ?
>>
> At first, generic per-cpu counter sounds interesting but to be honest,
> some special handling is used for cpuacct based on its characteristic.
>

Just trying to understand this clearly ...

>  - Writer works under non-preemptable context.

Which means the writer is running with preemption disabled.
percpu_counter writes (via percpu_counter_add) don't assume anything
and disable preemption themselves. Is this the problem or is there a
bigger issue here why percpu_counter can't be used ?

>  - There is only one writer.

Not sure how you have optimized for this case in cpuacct.
percpu_counters use spinlocks to serialize writers. Are you saying
using spinlocks for this 1 writer case is too much ? Also note that
they update 32 bit percpu counters without any lock and take spinlocks
only when they do a batch update to the 64bit counter.

Regards,
Bharata.
-- 
http://bharata.sulekha.com/blog/posts.htm
