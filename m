Return-Path: <linux-kernel-owner+w=401wt.eu-S1758282AbYG2OUz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758282AbYG2OUz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 10:20:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758850AbYG2OUb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 10:20:31 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:51620 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758792AbYG2OUa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 10:20:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fj/UybP55mE4cv5wlKRm6fI15hq2LnOVM7stRonyA6ruSCWM5G0byxCz5oSVSoNA67
         nU1Td97oco3i8fD5aPprAhd59TX1M+5SCIqIda1OD6AKUgKzyK1J8aLwx8ctPFBvvSqy
         rqOt9eU3k2X+M/gNZ0x7oFi9gdForWbMMNvYc=
Message-ID: <b647ffbd0807290720r3223461dt9d4f7f248e5e3c37@mail.gmail.com>
Date: Tue, 29 Jul 2008 16:20:28 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Oleg Nesterov" <oleg@tv-sign.ru>
Subject: Re: [patch, minor] workqueue: consistently use 'err' in __create_workqueue_key()
Cc: linux-kernel@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <20080729134456.GA355@tv-sign.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1217277694.20627.9.camel@earth> <20080729110250.GA177@tv-sign.ru>
	 <b647ffbd0807290458n23dbe79et45cb27273e4fc2ae@mail.gmail.com>
	 <20080729125201.GC177@tv-sign.ru> <20080729134456.GA355@tv-sign.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/29 Oleg Nesterov <oleg@tv-sign.ru>:
> On 07/29, Oleg Nesterov wrote:
>>
>> On 07/29, Dmitry Adamushko wrote:
>> >
>> > And I'd say this behavior (of having a partially-created object
>> > visible to the outside world) is not that robust. e.g. the
>> > aforementioned race would be eliminated if we place a wq on the global
>> > list only when it's been successfully initialized.
>>
>> Yes, we can change __create_workqueue_key() to check err == 0 before
>> list_add(),
>
> Well no, we can't do even this.
>
> Then we have another race with cpu-hotplug. Suppose we have CPUs 0, 1, 2.
> create_workqueue() fails to create cwq->thread for CPU 2 and calls
> destroy_workqueue(). Before it takes the cpu_add_remove_lock, _cpu_down()
> removes CPU 1 from cpu_populated_map, but since we didn't add this wq
> on the global list, cwq[1]->thread remains alive.
>
> destroy_workqueue() takes cpu_add_remove_lock, and calls
> cleanup_workqueue_thread() for CPUs 0 and 2. cwq[1]->thread is lost.

Yes, I've actually seen this case and that's why I said "the cleanup
path in __create_workqueue_key() would need
to be altered" :-) likely, to the extent that it would not be a call
to destroy_workqueue() anymore.

either something that only does

for_each_cpu_mask_nr(cpu, *cpu_map)
          cleanup_workqueue_thread(per_cpu_ptr(wq->cpu_wq, cpu));


and from the _same_ 'cpu_add_remove_lock' section which is used to
create a wq (so we don't drop a lock);

_or_ do it outside of the locked section _but_ don't rely on
for_each_cpu_mask_nr(cpu, *cpu_map)... e.g. just delete all per-cpu
wq->cpu_wq structures that have been initialized (that's no matter if
their respective cpus are online/offline now).


yes, maybe this cleanup path would not look all that fancy (but I
didn't try) but I do think that by not exposing "partially-initialized
object to the outside world" (e.g. cpu-hotplug events won't see them)
this code would become more straightforward and less prone to possible
errors/races.

e.g. all these "create_workqueue_key() may race with cpu-hotplug" would be gone.


-- 
Best regards,
Dmitry Adamushko
