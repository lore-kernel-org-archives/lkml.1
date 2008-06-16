Return-Path: <linux-kernel-owner+w=401wt.eu-S1760873AbYFPI3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760873AbYFPI3A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 04:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754453AbYFPI2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 04:28:53 -0400
Received: from sacred.ru ([62.205.161.221]:52242 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754292AbYFPI2w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 04:28:52 -0400
Message-ID: <4856231B.9050704@openvz.org>
Date: Mon, 16 Jun 2008 12:23:55 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: kamezawa.hiroyu@jp.fujitsu.com
CC: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>, menage@google.com,
       balbir@linux.vnet.ibm.com, yamamoto@valinux.co.jp,
       nishimura@mxp.nes.nec.co.jp, lizf@cn.fujitsu.com
Subject: Re: [PATCH 1/6] res_counter:  handle limit change
References: <48561B68.6060503@openvz.org> <48560A7C.9050501@openvz.org> <20080613182714.265fe6d2.kamezawa.hiroyu@jp.fujitsu.com> <20080613182924.c73fe9eb.kamezawa.hiroyu@jp.fujitsu.com> <33011576.1213601977563.kamezawa.hiroyu@jp.fujitsu.com> <11930674.1213604250738.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <11930674.1213604250738.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Mon, 16 Jun 2008 12:26:18 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

kamezawa.hiroyu@jp.fujitsu.com wrote:
> ----- Original Message -----
> 
>>> I think when I did all in memcg, someone will comment that "why do that
>>> all in memcg ? please implement generic one to avoid code duplication"
>> Hm... But we're choosing between
>>
>> sys_write->xxx_cgroup_write->res_counter_set_limit->xxx_cgroup_call
>>
>> and
>>
>> sys_write->xxx_cgroup_write->res_counter_set_limit
>>                           ->xxx_cgroup_call
>>
>> With the sizeof(void *)-bytes difference in res_counter, nNo?
>>
> I can't catch what you mean. What is res_counter_set_limit here ?

It's res_counter_resize_limit from your patch, sorry for the confusion.

> (my patche's ?) and what is sizeof(void *)-bytes ?

I meant, that we have to add 4 bytes (8 on 64-bit arches) on the
struct res_counter to store the pointer on the res_counter_ops.

> Is it so strange to add following algorithm in res_counter?
> ==
> set_limit -> fail -> shrink -> set limit -> fail ->shrink
> -> success -> return 0
> ==
> I think this is enough generic.

It is, but my point is - we're calling the set_limit (this is a
res_counter_resize_limit from your patch, sorry for the confusion again)
routine right from the cgroup's write callback and thus can call
the desired "ops->shrink_usage" directly, w/o additional level of
indirection.

> Thanks,
> -Kame
> 
> 
> 
> 

