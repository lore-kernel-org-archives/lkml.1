Return-Path: <linux-kernel-owner+w=401wt.eu-S1753750AbZFAA4S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbZFAA4S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 20:56:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752637AbZFAA4J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 20:56:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:63036 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbZFAA4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 20:56:08 -0400
Message-ID: <4A232662.5030308@cn.fujitsu.com>
Date: Mon, 01 Jun 2009 08:52:50 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>, rusty@rustcorp.com.au,
       mingo@elte.hu, paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Gautham R Shenoy <ego@in.ibm.com>
Subject: Re: [PATCH 1/2] cpuhotplug: use rw_semaphore for cpu_hotplug
References: <4A1F9CEA.1070705@cn.fujitsu.com> <20090529132328.99e7cae3.akpm@linux-foundation.org> <20090529210748.GA13449@redhat.com>
In-Reply-To: <20090529210748.GA13449@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov wrote:
> On 05/29, Andrew Morton wrote:
>> On Fri, 29 May 2009 16:29:30 +0800
>> Lai Jiangshan <laijs@cn.fujitsu.com> wrote:
>>
>>> Current get_online_cpus()/put_online_cpus() re-implement
>>> a rw_semaphore,
>>> so it is converted to a real rw_semaphore in this fix.
>>> It simplifies codes, and is good for read.
>>>  static struct {
>>> -	struct task_struct *active_writer;
>>> -	struct mutex lock; /* Synchronizes accesses to refcount, */
>>>  	/*
>>> -	 * Also blocks the new readers during
>>> -	 * an ongoing cpu hotplug operation.
>>> +	 * active_writer makes get_online_cpus()/put_online_cpus() are allowd
>>> +	 * to be nested in cpu_hotplug_begin()/cpu_hotplug_done().
>>> +	 *
>>> +	 * Thus, get_online_cpus()/put_online_cpus() can be called in
>>> +	 * CPU notifiers.
>>>  	 */
>>> -	int refcount;
>>> +	struct task_struct *active_writer;
>>> +	struct rw_semaphore rwlock;
>>>  } cpu_hotplug;
> 
> But, afaics, down_write() blocks new readers.
> 
> This means that with this patch get_online_cpus() is not recursive, no?
> 

down_read()/up_read() can be nested within down_read()/up_read(),
so get_online_cpus() is recursive.

And thanks to cpu_hotplug.active_writer, get_online_cpus()/put_online_cpus()
are allowd to be nested in cpu_hotplug_begin()/cpu_hotplug_done().
So cpu_hotplug_begin() DO NOT blocks readers who are in CPU notifiers.

