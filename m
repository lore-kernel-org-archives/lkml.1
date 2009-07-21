Return-Path: <linux-kernel-owner+w=401wt.eu-S1754885AbZGUFzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754885AbZGUFzl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 01:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754833AbZGUFzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 01:55:40 -0400
Received: from smtp-out.google.com ([216.239.33.17]:31795 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754558AbZGUFzj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 01:55:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=M6WYKiZqrGzZGUVuiiCfq3KeYN+RhXkCd7Huk6iVT8DFwgAZriBm7Y3CEtVvKqUj1
	/WdFHVXu2ygHpPRa8OetA==
MIME-Version: 1.0
In-Reply-To: <4A655434.5060404@cn.fujitsu.com>
References: <1246564917-19603-1-git-send-email-vgoyal@redhat.com>
	 <1246564917-19603-22-git-send-email-vgoyal@redhat.com>
	 <4A655434.5060404@cn.fujitsu.com>
Date: Mon, 20 Jul 2009 22:55:31 -0700
Message-ID: <e98e18940907202255y5c7c546ei95d87e5a451ad0c2@mail.gmail.com>
Subject: Re: [PATCH 21/25] io-controller: Per cgroup request descriptor 
	support
From: Nauman Rafique <nauman@google.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       jens.axboe@oracle.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, jmoyer@redhat.com, dhaval@linux.vnet.ibm.com,
       balbir@linux.vnet.ibm.com, righi.andrea@gmail.com,
       m-ikeda@ds.jp.nec.com, jbaron@redhat.com, agk@redhat.com,
       snitzer@redhat.com, akpm@linux-foundation.org, peterz@infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 20, 2009 at 10:37 PM, Gui
Jianfeng<guijianfeng@cn.fujitsu.com> wrote:
> Vivek Goyal wrote:
>> o Currently a request queue has got fixed number of request descriptors for
>>   sync and async requests. Once the request descriptors are consumed, new
>>   processes are put to sleep and they effectively become serialized. Because
>>   sync and async queues are separate, async requests don't impact sync ones
>>   but if one is looking for fairness between async requests, that is not
>>   achievable if request queue descriptors become bottleneck.
>>
>> o Make request descriptor's per io group so that if there is lots of IO
>>   going on in one cgroup, it does not impact the IO of other group.
>>
>> o This is just one relatively simple way of doing things. This patch will
>>   probably change after the feedback. Folks have raised concerns that in
>>   hierchical setup, child's request descriptors should be capped by parent's
>>   request descriptors. May be we need to have per cgroup per device files
>>   in cgroups where one can specify the upper limit of request descriptors
>>   and whenever a cgroup is created one needs to assign request descritor
>>   limit making sure total sum of child's request descriptor is not more than
>>   of parent.
>>
>>   I guess something like memory controller. Anyway, that would be the next
>>   step. For the time being, we have implemented something simpler as follows.
>>
>> o This patch implements the per cgroup request descriptors. request pool per
>>   queue is still common but every group will have its own wait list and its
>>   own count of request descriptors allocated to that group for sync and async
>>   queues. So effectively request_list becomes per io group property and not a
>>   global request queue feature.
>>
>> o Currently one can define q->nr_requests to limit request descriptors
>>   allocated for the queue. Now there is another tunable q->nr_group_requests
>>   which controls the requests descriptr limit per group. q->nr_requests
>>   supercedes q->nr_group_requests to make sure if there are lots of groups
>>   present, we don't end up allocating too many request descriptors on the
>>   queue.
>>
>
>  Hi Vivek,
>
>  In order to prevent q->nr_requests from becoming the bottle-neck of allocating
>  requests, whether we can update nr_requests accordingly when allocating or removing
>  a cgroup?

Vivek,
I agree with Gui here. In fact, it does not make much sense to keep
the nr_requests limit if we already have per cgroup limit in place.
This change also simplifies code quite a bit, as we can get rid of all
that sleep_on_global logic.

>
> --
> Regards
> Gui Jianfeng
>
>
