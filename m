Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab0BXJuW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 04:50:22 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53238 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755706Ab0BXJuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 04:50:21 -0500
Message-ID: <4B84F645.6030404@cn.fujitsu.com>
Date: Wed, 24 Feb 2010 17:49:57 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Lee Schermerhorn <lee.schermerhorn@hp.com>
Subject: Re: [regression] cpuset,mm: update tasks' mems_allowed in time (58568d2)
References: <20100218134921.GF9738@laptop> <alpine.DEB.2.00.1002181302430.13707@chino.kir.corp.google.com> <20100219033126.GI9738@laptop> <alpine.DEB.2.00.1002190143040.6293@chino.kir.corp.google.com> <20100222121222.GV9738@laptop> <alpine.DEB.2.00.1002221400060.23881@chino.kir.corp.google.com> <4B839103.2060901@cn.fujitsu.com> <alpine.DEB.2.00.1002230041240.12015@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1002230041240.12015@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on 2010-2-23 16:44, David Rientjes wrote:
> On Tue, 23 Feb 2010, Miao Xie wrote:
> 
>> Sorry, Could you explain what you advised?
>> I think it is hard to fix this problem by adding a variant, because it is
>> hard to avoid loading a word of the mask before
>>
>> 	nodes_or(tsk->mems_allowed, tsk->mems_allowed, *newmems);
>>
>> and then loading another word of the mask after
>>
>> 	tsk->mems_allowed = *newmems;
>>
>> unless we use lock.
>>
>> Maybe we need a rw-lock to protect task->mems_allowed.
>>
> 
> I meant that we need to define synchronization only for configurations 
> that do not do atomic nodemask_t stores, it's otherwise unnecessary.  
> We'll need to load and store tsk->mems_allowed via a helper function that 
> is defined to take the rwlock for such configs and only read/write the 
> nodemask for others.
> 

By investigating, we found that it is hard to guarantee the consistent between
mempolicy and mems_allowed because mempolicy was designed as a self-update function.
it just can be changed by one's self. Maybe we must change the implement of mempolicy.

