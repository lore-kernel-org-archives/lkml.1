Return-Path: <linux-kernel-owner+w=401wt.eu-S1751530AbZIIFBR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530AbZIIFBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Sep 2009 01:01:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750839AbZIIFBQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Sep 2009 01:01:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32615 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbZIIFBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Sep 2009 01:01:16 -0400
Message-ID: <4AA73632.2020309@redhat.com>
Date: Wed, 09 Sep 2009 00:59:30 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 2.0.0.17 (X11/20080915)
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: linux-kernel@vger.kernel.org, jens.axboe@oracle.com,
       containers@lists.linux-foundation.org, dm-devel@redhat.com,
       nauman@google.com, dpshah@google.com, lizf@cn.fujitsu.com,
       mikew@google.com, fchecconi@gmail.com, paolo.valente@unimore.it,
       ryov@valinux.co.jp, fernando@oss.ntt.co.jp, s-uchida@ap.jp.nec.com,
       taka@valinux.co.jp, guijianfeng@cn.fujitsu.com, jmoyer@redhat.com,
       dhaval@linux.vnet.ibm.com, balbir@linux.vnet.ibm.com,
       righi.andrea@gmail.com, m-ikeda@ds.jp.nec.com, agk@redhat.com,
       akpm@linux-foundation.org, peterz@infradead.org, jmarchan@redhat.com,
       torvalds@linux-foundation.org, mingo@elte.hu
Subject: Re: [PATCH 26/23] io-controller: fix writer preemption with in a
 group
References: <1251495072-7780-1-git-send-email-vgoyal@redhat.com> <20090908222835.GD3558@redhat.com>
In-Reply-To: <20090908222835.GD3558@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal wrote:
> o Found another issue during testing. Consider following hierarchy.
> 
> 			root
> 			/ \
> 		       R1  G1
> 			  /\
> 			 R2 W
> 
>   Generally in CFQ when readers and writers are running, reader immediately
>   preempts writers and hence reader gets the better bandwidth. In case of
>   hierarchical setup, it becomes little more tricky. In above diagram, G1
>   is a group and R1, R2 are readers and W is writer tasks.
> 
>   Now assume W runs and then R1 runs and then R2 runs. After R2 has used its
>   time slice, if R1 is schedule in, after couple of ms, R1 will get backlogged
>   again in group G1, (streaming reader). But it will not preempt R1 as R1 is
>   also a reader and also because preemption across group is not allowed for
>   isolation reasons. Hence R2 will get backlogged in G1 and will get a 
>   vdisktime much higher than W. So when G2 gets scheduled again, W will get
>   to run its full slice length despite the fact R2 is queue on same service
>   tree.
> 
>   The core issue here is that apart from regular preemptions (preemption 
>   across classes), CFQ also has this special notion of preemption with-in
>   class and that can lead to issues active task is running in a differnt
>   group than where new queue gets backlogged.
> 
>   To solve the issue keep a track of this event (I am calling it late
>   preemption). When a group becomes eligible to run again, if late_preemption
>   is set, check if there are sync readers backlogged, and if yes, expire the
>   writer after one round of dispatch.
> 
>   This solves the issue of reader not getting enough bandwidth in hierarchical
>   setups.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Conceptually a nice solution.  The code gets a little tricky,
but I guess any code dealing with these situations would end
up that way :)

Acked-by: Rik van Riel <riel@redhat.com>

-- 
All rights reversed.
