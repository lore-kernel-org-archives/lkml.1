Return-Path: <linux-kernel-owner+w=401wt.eu-S1755707AbYGKRvp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbYGKRvp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 13:51:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753295AbYGKRvh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 13:51:37 -0400
Received: from qb-out-0506.google.com ([72.14.204.238]:29750 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113AbYGKRvg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 13:51:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=dhlVR05YonDtlnJNSVvHa5eGoryJBOzxH8+Q67KUWf5+vT+nb+7HnbNDf+PErdFSD/
         d7dM89ZHQDxL1W1kMUGkq42q66TW5XsTt3YxKqsqzGPaGpx4xJCC/I29q7thziU5yd0f
         YG72Hd6eCdmh6dhr9BUfe+NFlJFOAyamKsX5Q=
Message-ID: <19f34abd0807111051q7b4a42b1l1f9ee05d45601ac3@mail.gmail.com>
Date: Fri, 11 Jul 2008 19:51:34 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
Subject: Re: v2.6.26-rc9: kernel BUG at kernel/sched.c:5858!
Cc: Yanmin <yanmin_zhang@linux.intel.com>,
       "Rusty Russell" <rusty@rustcorp.com.au>, "Ingo Molnar" <mingo@elte.hu>,
       "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
       "Dhaval Giani" <dhaval@linux.vnet.ibm.com>,
       "Gautham R Shenoy" <ego@in.ibm.com>,
       "Heiko Carstens" <heiko.carstens@de.ibm.com>, miaox@cn.fujitsu.com,
       "Lai Jiangshan" <laijs@cn.fujitsu.com>, "Avi Kivity" <avi@qumranet.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <19f34abd0807110404p5c588debu681aa466cc98ad08@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080710115954.GA3639@damson.getinternet.no>
	 <b647ffbd0807100550l44fae9fate511dafbf87564a4@mail.gmail.com>
	 <19f34abd0807100604p70c2fec6geca65b2ba772dea@mail.gmail.com>
	 <b647ffbd0807100703q442a9825hb857c321452027e7@mail.gmail.com>
	 <19f34abd0807100716k35e937batb4059f99fe46731b@mail.gmail.com>
	 <19f34abd0807101249y24632b50h769a7af2c9514864@mail.gmail.com>
	 <b647ffbd0807101316o97fe6d4p5b2cbcda472f2ae1@mail.gmail.com>
	 <19f34abd0807102249t6b2e9e97l97bc5b22cc7709ef@mail.gmail.com>
	 <b647ffbd0807110202o10ca65c7yf93d8b2146a05e33@mail.gmail.com>
	 <19f34abd0807110404p5c588debu681aa466cc98ad08@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2008 at 1:04 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> On Fri, Jul 11, 2008 at 11:02 AM, Dmitry Adamushko
> <dmitry.adamushko@gmail.com> wrote:
>> Vegard,
>>
>>
>> regarding the first crash. Would you please run your test with the
>> following debugging patch and let me know its output?
>>
>> The apperance of " * [ pid ] comm (name), orig_cpu() ... " means we
>> hit a problematic case (with Miao Xie's patch it shouldn't crash).
>>
>> I see that you have CONFIG_SCHED_DEBUG=y so I'm also interested in
>> messages from sched_domain_debug() - "CPU# attaching ...". IOW, all
>> the kernel messages appearing while a cpu is going down and up.
[...]

> Ok, now I tested it on my laptop (sorry, no serial console :-)) and I

Now I tested using serial console, but nothing new:

CPU0 attaching NULL sched-domain.
CPU1 attaching NULL sched-domain.
CPU0 attaching sched-domain:
 domain 0: span 0-1
  groups: 0 1
  domain 1: span 0-1
   groups: 0-1
CPU1 attaching sched-domain:
 domain 0: span 0-1
  groups: 1 0
  domain 1: span 0-1
   groups: 0-1
 * [ 7 ] comm (ksoftirqd/1), orig_cpu (1), dst_cpu (1), cpu (1)
CPU 1 is now offline
 * [ 1228 ] comm (kjournald), orig_cpu (0), dst_cpu (0), cpu (0)
 * [ 3113 ] comm (klogd), orig_cpu (0), dst_cpu (0), cpu (0)
BUG: spinlock recursion on CPU#0, syslogd/3110

and here the output stops. I find this REALLY strange, look at the
spinlock recursion code:

        printk(KERN_EMERG "BUG: spinlock %s on CPU#%d, %s/%d\n",
                msg, raw_smp_processor_id(),
                current->comm, task_pid_nr(current));
        printk(KERN_EMERG " lock: %p, .magic: %08x, .owner: %s/%d, "
                        ".owner_cpu: %d\n",
                lock, lock->magic,
                owner ? owner->comm : "<none>",
                owner ? task_pid_nr(owner) : -1,
                lock->owner_cpu);

why would it not be able to print the second line?


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
