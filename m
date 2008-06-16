Return-Path: <linux-kernel-owner+w=401wt.eu-S1760649AbYFPHzL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760649AbYFPHzL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 03:55:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706AbYFPHyy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 03:54:54 -0400
Received: from sacred.ru ([62.205.161.221]:54640 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752607AbYFPHyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 03:54:54 -0400
Message-ID: <48561B68.6060503@openvz.org>
Date: Mon, 16 Jun 2008 11:51:04 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: kamezawa.hiroyu@jp.fujitsu.com
CC: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, menage@google.com,
       balbir@linux.vnet.ibm.com, yamamoto@valinux.co.jp,
       nishimura@mxp.nes.nec.co.jp, lizf@cn.fujitsu.com
Subject: Re: [PATCH 1/6] res_counter:  handle limit change
References: <48560A7C.9050501@openvz.org> <20080613182714.265fe6d2.kamezawa.hiroyu@jp.fujitsu.com> <20080613182924.c73fe9eb.kamezawa.hiroyu@jp.fujitsu.com> <33011576.1213601977563.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <33011576.1213601977563.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 16 Jun 2008 11:53:24 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kamezawa.hiroyu@jp.fujitsu.com wrote:
> ----- Original Message -----
>>> +	 * registered callbacks etc...for res_counter.
>>> +	 */
>>> +	struct res_counter_ops ops;
>>> +	/*
> Now, write to limit is done in following path.
> sys_write() -> write_func of subsys -> write in res_counter -> 
> strategy callback -> set limit -> return
> 
> Because stragety callback is called in res_counter, we can only do 
> something after set-limit without callback. So res_counter should call
> another callback before set-limit if it can fail.
> 
>> Why would we need such? All res_counter.limit update comes via the appropiate
>> cgroup's files, so it can do whatever it needs w/o any callbacks?
>>
> 
> First reason is that this allows us to implement generic algorithm to
> handle limit change. Second is that generic algorithm can be a stack of
> functions. I don't like to pass function pointers through several stack
> of functions. (And this design allow the code to be much easier to read.
> My first version used an argument of function pointer but it was verrry ugly.)
> 
> I think when I did all in memcg, someone will comment that "why do that
> all in memcg ? please implement generic one to avoid code duplication"

Hm... But we're choosing between

sys_write->xxx_cgroup_write->res_counter_set_limit->xxx_cgroup_call

and

sys_write->xxx_cgroup_write->res_counter_set_limit
                           ->xxx_cgroup_call

With the sizeof(void *)-bytes difference in res_counter, nNo?

>> And (if we definitely need one) isn't it better to make it a
>> 	struct res_counter_ops *ops;
>> pointer?
>>
> My first version did that. When I added hierarchy_model to ops(see later patch
> ), I made use of copy of ops. But maybe you're right. Keeping 
> res_counter small is important. I'll use pointer in v5.  
> 
> Thanks,
> -Kame-
> 
> 

