Return-Path: <linux-kernel-owner+w=401wt.eu-S1764300AbXIXQsW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764300AbXIXQsW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 12:48:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763342AbXIXQnU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 12:43:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:15700 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763382AbXIXQnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 12:43:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,292,1186383600"; 
   d="scan'208";a="320727940"
Date: Mon, 24 Sep 2007 09:43:17 -0700 (PDT)
From: Tong Li <tong.n.li@intel.com>
X-X-Sender: tongli@tongli.jf.intel.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Mike Galbraith <efault@gmx.de>, Ingo Molnar <mingo@elte.hu>,
       dimm <dmitry.adamushko@gmail.com>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Subject: Re: [git] CFS-devel, group scheduler, fixes
In-Reply-To: <20070924135158.1359013b@twins>
Message-ID: <Pine.LNX.4.64.0709240935170.25564@tongli.jf.intel.com>
References: <1190144190.5204.24.camel@earth> <20070918201622.GA1632@elte.hu>
 <Pine.LNX.4.64.0709182250120.9990@tongli.jf.intel.com>
 <1190183324.9737.7.camel@Homer.simpson.net> <1190188261.9185.21.camel@Homer.simpson.net>
 <1190191368.8687.5.camel@Homer.simpson.net> <Pine.LNX.4.64.0709190944560.11561@tongli.jf.intel.com>
 <1190264114.6411.4.camel@Homer.simpson.net> <1190272507.27867.20.camel@Homer.simpson.net>
 <20070920075155.GA31641@elte.hu> <1190275870.9232.6.camel@Homer.simpson.net>
 <Pine.LNX.4.64.0709212018480.16240@tongli.jf.intel.com>
 <1190455308.7404.19.camel@Homer.simpson.net> <1190531662.11524.15.camel@Homer.simpson.net>
 <Pine.LNX.4.64.0709232259150.23861@tongli.jf.intel.com>
 <1190628609.6389.14.camel@Homer.simpson.net> <20070924122422.75562c41@twins>
 <1190630535.7406.2.camel@Homer.simpson.net> <1190632934.7853.1.camel@Homer.simpson.net>
 <20070924135158.1359013b@twins>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Sep 2007, Peter Zijlstra wrote:

> On Mon, 24 Sep 2007 13:22:14 +0200 Mike Galbraith <efault@gmx.de> wrote:
>
>> On Mon, 2007-09-24 at 12:42 +0200, Mike Galbraith wrote:
>>> On Mon, 2007-09-24 at 12:24 +0200, Peter Zijlstra wrote:
>>>
>>>> how about something like:
>>>>
>>>>  s64 delta = (s64)(vruntime - min_vruntime);
>>>>  if (delta > 0)
>>>>   min_vruntime += delta;
>>>>
>>>> That would rid us of most of the funny conditionals there.
>>>
>>> That still left me with negative min_vruntimes.  The pinned hogs didn't
>>> lock my box up, but I quickly got the below, so hastily killed it.
>>
>> Shouldn't the max() in place_entity() be the max_vruntime() that my
>> lysdexia told me it was when I looked at it earlier? ;-)
>>
>
> probably, my tree doesn't have that max anymore so I'm not sure.
>

Last time I looked, I thought the max() in place_entity() was fine and the 
problem seemed to be in set_task_cpu() that was causing the negative 
vruntimes:

         if (likely(new_rq->cfs.min_vruntime))
                 p->se.vruntime -= old_rq->cfs.min_vruntime -
                                                 new_rq->cfs.min_vruntime;

I think it's fine we get rid of sync_vruntime(). I need to think more 
about how to make global fairness work based on this--it seems to be more 
complicated than if we had sync_vruntime().

   tong
