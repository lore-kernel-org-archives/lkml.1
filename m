Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbZF3RPM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbZF3RPM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 13:15:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754038AbZF3ROz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 13:14:55 -0400
Received: from smtp-out.google.com ([216.239.45.13]:14868 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbZF3ROy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 13:14:54 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=B5uo+1bPBSfm5jS6nXAvV+O7eegK6xkN9PnEs0K8aQ7m8BfLuJp6onPWc1bozhDrc
	iF7clDjIYIF0ikYyfLhwQ==
MIME-Version: 1.0
In-Reply-To: <20090629140631.GA4622@redhat.com>
References: <1245443858-8487-1-git-send-email-vgoyal@redhat.com>
	 <1245443858-8487-6-git-send-email-vgoyal@redhat.com>
	 <4A4850D3.3000700@cn.fujitsu.com> <20090629140631.GA4622@redhat.com>
Date: Tue, 30 Jun 2009 10:14:48 -0700
Message-ID: <e98e18940906301014n146e7146vb5a73c2f33c9e819@mail.gmail.com>
Subject: Re: [PATCH] io-controller: optimization for iog deletion when 
	elevator exiting
From: Nauman Rafique <nauman@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Gui Jianfeng <guijianfeng@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
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

On Mon, Jun 29, 2009 at 7:06 AM, Vivek Goyal<vgoyal@redhat.com> wrote:
> On Mon, Jun 29, 2009 at 01:27:47PM +0800, Gui Jianfeng wrote:
>> Hi Vivek,
>>
>> There's no need to travel the iocg->group_data for each iog
>> when exiting a elevator, that costs too much. An alternative
>> solution is reseting iocg_id as soon as an io group unlinking
>> from a iocg. Make a decision that whether it's need to carry
>> out deleting action by checking iocg_id.
>>
>
> Thanks Gui. This makes sense to me. We can check iog->iocg_id to determine
> wheter group is still on iocg list or not instead of traversing the list.
>
> Nauman, do you see any issues with the patch?

Looks like this should work. The only iog with zero id is associated
with root group, which gets deleted outside of this function anyways.

>
> Thanks
> Vivek
>
>> Signed-off-by: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
>> ---
>>  block/elevator-fq.c |   29 ++++++++++-------------------
>>  1 files changed, 10 insertions(+), 19 deletions(-)
>>
>> diff --git a/block/elevator-fq.c b/block/elevator-fq.c
>> index d779282..b26fe0f 100644
>> --- a/block/elevator-fq.c
>> +++ b/block/elevator-fq.c
>> @@ -2218,8 +2218,6 @@ void io_group_cleanup(struct io_group *iog)
>>       BUG_ON(iog->sched_data.active_entity != NULL);
>>       BUG_ON(entity != NULL && entity->tree != NULL);
>>
>> -     iog->iocg_id = 0;
>> -
>>       /*
>>        * Wait for any rcu readers to exit before freeing up the group.
>>        * Primarily useful when io_get_io_group() is called without queue
>> @@ -2376,6 +2374,7 @@ remove_entry:
>>                         group_node);
>>       efqd = rcu_dereference(iog->key);
>>       hlist_del_rcu(&iog->group_node);
>> +     iog->iocg_id = 0;
>>       spin_unlock_irqrestore(&iocg->lock, flags);
>>
>>       spin_lock_irqsave(efqd->queue->queue_lock, flags);
>> @@ -2403,35 +2402,27 @@ done:
>>  void io_group_check_and_destroy(struct elv_fq_data *efqd, struct io_group *iog)
>>  {
>>       struct io_cgroup *iocg;
>> -     unsigned short id = iog->iocg_id;
>> -     struct hlist_node *n;
>> -     struct io_group *__iog;
>>       unsigned long flags;
>>       struct cgroup_subsys_state *css;
>>
>>       rcu_read_lock();
>>
>> -     BUG_ON(!id);
>> -     css = css_lookup(&io_subsys, id);
>> +     css = css_lookup(&io_subsys, iog->iocg_id);
>>
>> -     /* css can't go away as associated io group is still around */
>> -     BUG_ON(!css);
>> +     if (!css)
>> +             goto out;
>>
>>       iocg = container_of(css, struct io_cgroup, css);
>>
>>       spin_lock_irqsave(&iocg->lock, flags);
>> -     hlist_for_each_entry_rcu(__iog, n, &iocg->group_data, group_node) {
>> -             /*
>> -              * Remove iog only if it is still in iocg list. Cgroup
>> -              * deletion could have deleted it already.
>> -              */
>> -             if (__iog == iog) {
>> -                     hlist_del_rcu(&iog->group_node);
>> -                     __io_destroy_group(efqd, iog);
>> -                     break;
>> -             }
>> +
>> +     if (iog->iocg_id) {
>> +             hlist_del_rcu(&iog->group_node);
>> +             __io_destroy_group(efqd, iog);
>>       }
>> +
>>       spin_unlock_irqrestore(&iocg->lock, flags);
>> +out:
>>       rcu_read_unlock();
>>  }
>>
>> -- 1.5.4.rc3
>
