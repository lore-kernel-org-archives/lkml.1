Return-Path: <linux-kernel-owner+w=401wt.eu-S1754670AbYGKXnI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670AbYGKXnI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 19:43:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757526AbYGKXmx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 19:42:53 -0400
Received: from rv-out-0506.google.com ([209.85.198.229]:31767 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757104AbYGKXmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 19:42:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=IQoAg2nvd7Ub5X0Egv8lFUPwLq91DAvzaqow6hkyGHi0A2kKN2up/H7oYzKdmxFpQQ
         Z/dwmQf/49MWdP9u1U2iqQuAR3rx2nUfb7YqJwc9QWd5H7YAc2pum1oNCb/8tJklGWMq
         vukbaIJJ407L0MTIkpYytcFmqQ+iqfE8JVjOY=
Message-ID: <b647ffbd0807111642v4e8edf87t62c4ee82d86e332b@mail.gmail.com>
Date: Sat, 12 Jul 2008 01:42:51 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Subject: Re: v2.6.26-rc9: kernel BUG at kernel/sched.c:5858!
Cc: Yanmin <yanmin_zhang@linux.intel.com>,
       "Rusty Russell" <rusty@rustcorp.com.au>, "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Gautham R Shenoy" <ego@in.ibm.com>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>, miaox@cn.fujitsu.com,
       "Lai Jiangshan" <laijs@cn.fujitsu.com>, "Avi Kivity" <avi@qumranet.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <19f34abd0807111051q7b4a42b1l1f9ee05d45601ac3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080710115954.GA3639@damson.getinternet.no>
	 <19f34abd0807100604p70c2fec6geca65b2ba772dea@mail.gmail.com>
	 <b647ffbd0807100703q442a9825hb857c321452027e7@mail.gmail.com>
	 <19f34abd0807100716k35e937batb4059f99fe46731b@mail.gmail.com>
	 <19f34abd0807101249y24632b50h769a7af2c9514864@mail.gmail.com>
	 <b647ffbd0807101316o97fe6d4p5b2cbcda472f2ae1@mail.gmail.com>
	 <19f34abd0807102249t6b2e9e97l97bc5b22cc7709ef@mail.gmail.com>
	 <b647ffbd0807110202o10ca65c7yf93d8b2146a05e33@mail.gmail.com>
	 <19f34abd0807110404p5c588debu681aa466cc98ad08@mail.gmail.com>
	 <19f34abd0807111051q7b4a42b1l1f9ee05d45601ac3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/7/11 Vegard Nossum <vegard.nossum@gmail.com>:
> On Fri, Jul 11, 2008 at 1:04 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
>> On Fri, Jul 11, 2008 at 11:02 AM, Dmitry Adamushko
>> <dmitry.adamushko@gmail.com> wrote:
>>> Vegard,
>>>
>>>
>>> regarding the first crash. Would you please run your test with the
>>> following debugging patch and let me know its output?
>>>
>>> The apperance of " * [ pid ] comm (name), orig_cpu() ... " means we
>>> hit a problematic case (with Miao Xie's patch it shouldn't crash).
>>>
>>> I see that you have CONFIG_SCHED_DEBUG=y so I'm also interested in
>>> messages from sched_domain_debug() - "CPU# attaching ...". IOW, all
>>> the kernel messages appearing while a cpu is going down and up.
> [...]
>
>> Ok, now I tested it on my laptop (sorry, no serial console :-)) and I
>
> Now I tested using serial console, but nothing new:
>
> CPU0 attaching NULL sched-domain.
> CPU1 attaching NULL sched-domain.
> CPU0 attaching sched-domain:
>  domain 0: span 0-1
>  groups: 0 1
>  domain 1: span 0-1
>   groups: 0-1
> CPU1 attaching sched-domain:
>  domain 0: span 0-1
>  groups: 1 0
>  domain 1: span 0-1
>   groups: 0-1

hmm, sched-domains have been rebuilt too early. The soon-to-be-offline
cpu #1 is included (as it's still in cpu_online_map presumably).

>  * [ 7 ] comm (ksoftirqd/1), orig_cpu (1), dst_cpu (1), cpu (1)

Have you removed "__migrate_dead ... " printk messages? This one
should be printed after __stop_machine_run(take_cpu_down, ...) and
before migrate_live_tasks() takes place... so we would have seen
"__migrate_dead..." message for ksoftirqd/1 a bit later, I guess.

> CPU 1 is now offline

migrate_live_tasks() should take place here...

>  * [ 1228 ] comm (kjournald), orig_cpu (0), dst_cpu (0), cpu (0)
>  * [ 3113 ] comm (klogd), orig_cpu (0), dst_cpu (0), cpu (0)

I guess, these were migrated onto cpu#0 by migrate_live_tasks() but
now try_to_wake_up() has been called for them. Due to the fact that
cpu#1 is visible on the sched-domains, the load-balancer
(select_task_rq()) picks it up erronneusly... bum.




>
> Vegard
>

-- 
Best regards,
Dmitry Adamushko
