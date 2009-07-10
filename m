Return-Path: <linux-kernel-owner+w=401wt.eu-S1755424AbZGJSC2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424AbZGJSC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 14:02:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbZGJSCC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 14:02:02 -0400
Received: from easi.embeddedalley.com ([71.6.201.124]:50416 "HELO
	easi.embeddedalley.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752043AbZGJSCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 14:02:00 -0400
Message-ID: <4A57820B.9070409@embeddedalley.com>
Date: Fri, 10 Jul 2009 11:01:47 -0700
From: "Vladislav D. Buzov" <vbuzov@embeddedalley.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090608)
MIME-Version: 1.0
To: balbir@linux.vnet.ibm.com
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers Mailing List 
	<containers@lists.linux-foundation.org>,
       Dan Malek <dan@embeddedalley.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 1/1] Memory usage limit notification addition to memcg
References: <1239660512-25468-1-git-send-email-dan@embeddedalley.com> <1246998310-16764-1-git-send-email-vbuzov@embeddedalley.com> <1246998310-16764-2-git-send-email-vbuzov@embeddedalley.com> <20090708035252.GA3215@balbir.in.ibm.com>
In-Reply-To: <20090708035252.GA3215@balbir.in.ibm.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh wrote:
> Polling is never good (from the power consumption and efficiency
> view point), unless by poll you mean select() and wait on events.
>   
Currently poll()/select() on a file descriptor are not supported by
cgroups. So now, it's up to user application to decide whether it's
going to periodically check memory usage or use blocking read to wait
for notification.
> Blocked read requires a dedicated thread, adding a select or some
> other notification mechanism allows the software to wait on several
> events at the same time.
>   
That's true. This is the next step to be implemented. For now I just
don't want to complicate this notification feature. There is a parallel
discussion about proper threshold implementation, which I'd like to
finish first and then look at possible options for a better notification
mechanism.

> Could you clarify the meaning of "not in use"
>   
The threshold represents the minimal number of bytes that should be
available under the memory controller limit before notification occurs.
For example:

limit=10M
threshold=1M
Notification fires when memory usage reaches 9M

> Could you please elaborate further, why would other mechanisms not
> work? Hint: please see cgroupstats.
>   
I'm not saying that other mechanisms (other than the cgroup files) are
not going to work. The cgroup files was chosen to communicate
notifications and the blocking read is the only useful method there.

>> +	/*
>> +	 * We check on the way in so we don't have to duplicate code
>> +	 * in both the normal and error exit path.
>> +	 */
>> +	mem_cgroup_notify_test_and_wakeup(mem, mem->res.usage + PAGE_SIZE,
>> +							mem->res.limit);
>> +
>>     
>
> I don't think it is a good idea to directly read out mem->res.*
> without any protection
>   
Why do I need to protect it here? I'm just reading values, not modifying
them. I don't have to worry if the values change after I read them, the
awaken thread will figure it out. Also, if I use res_counter interface
to read fields (res_counter_read_u64()) then it still doesn't provide
any protection.

However, I understand your concerns about data protection here and
below. In my previous email there was a discussion about moving
threshold support to the res_counter rather than keeping it in the
memory controller cgroup. I like that idea and currently working on
another patch that adds threshold support into the res_counter. It will
address all concerns about mutual exclusive access.

> Could you please use mem or memcg, since we've been using that as a
> standard convention in our code.
>   
Ok.
>   
>> +				       unsigned long long usage,
>> +				       unsigned long long limit)
>> +{
>> +	if (unlikely(usage == RESOURCE_MAX))
>>     
>
> I don't think it is a good idea to use unlikely since it is always
> likely for root to be at RESOURCE_MAX. Using likely/unlikely on user
> parameters IMHO is not a good idea.
>   
I agree.

> Again, I am confused about the mutual exclusion, what protects the new
> values being added.
>   
Ditto.

> Please use res_counter abstractions to read mem->res values
>   
Ok.

