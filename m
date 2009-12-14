Return-Path: <linux-kernel-owner+w=401wt.eu-S1756803AbZLNLBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803AbZLNLBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 06:01:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756790AbZLNLBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 06:01:16 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:51839 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756788AbZLNLBP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 06:01:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=HFEsjrbR3zJn4O4+3vHgRfqT3WbiUUh6jV2nHTED0CSUfgydA1SB8V2BtABhIopzgA
         zloEgShS00nI71FGKGCGMBolfDn9Zouo6i1Bas8WowcyTbwqWiXXCwPO3n38trAC1KsZ
         rshSK2485Wg1BQe1gCMO702eYEovqT0e+p53E=
MIME-Version: 1.0
In-Reply-To: <4B260B72.9020204@cn.fujitsu.com>
References: <4B21D252.1060902@cn.fujitsu.com>
	 <20091211150727.GB2756@redhat.com>
	 <4e5e476b0912111001h3c0b9798u2a2b25c9fcc39504@mail.gmail.com>
	 <20091211184630.GA7066@redhat.com> <4B25A4F0.60407@cn.fujitsu.com>
	 <4e5e476b0912140039s2f802786t84f53ee62b87c04e@mail.gmail.com>
	 <4B260B72.9020204@cn.fujitsu.com>
Date: Mon, 14 Dec 2009 12:01:14 +0100
Message-ID: <4e5e476b0912140301x398ac2b7k5ab7fc5698b9675e@mail.gmail.com>
Subject: Re: [PATCH] cfq: Take whether cfq group is changed into account when 
	choosing service tree
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <jens.axboe@oracle.com>,
       linux kernel mailing list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gui,
On Mon, Dec 14, 2009 at 10:54 AM, Gui Jianfeng
<guijianfeng@cn.fujitsu.com> wrote:
> Corrado Zoccolo wrote:
>> Hi,
> Currently, IIUC, only the workload that didn't use up its slice will be saved, and only
> such workloads are restoring when a group is resumed. So sometimes, we'll still get the
> previous serving_type and workload_expires. Am i missing something?
You are right. cfq_choose_cfqg should set the workload as expired if
!cfqg->saved_workload_slice (just set cfqd->workload_expires = jiffies
- 1), so the workload will be chosen again as the lowest keyed one.
Can you send a patch to fix this?
>
>
>>
>> I have one more concern, though.
>> RT priority has now changed meaning. Before, an RT task would always
>> have priority access to the disk. Now, a BE task in a different group,
>> with lower weight, can steal the disk from the RT task.
>> A way to preserve the old meaning is to consider wheter a group has RT
>> tasks inside when sorting groups tree, and putting those groups at the
>> front.
>> Usually, RT tasks will be put in the root group, and this (if
>> group_isolation=0) will automatically make sure that also the noidle
>> workload gets serviced quickly after RT tasks release the disk. We
>> could even enforce that, with group_isolation=0, all RT tasks are put
>> in the root group.
>>
>> The rationale behind this suggestion is that groups are for user
>> processes, while RT is system wide, since it is only root that can
>> grant it.
>
>  I agree, and one more thing, currently we can't see fairness between different
>  idle tasks in different groups. Because we only allow idle cfqq dispatch one request
>  for its dispatch round even if it's the only task in the cgroup, group always loose it
>  share. So whether we can rely on group_isolation, when group_isolation == 1 we provide
>  isolation for idle tasks.
Agreed.

Thanks,
Corrado

>
> Thanks
> Gui
>
>
>
