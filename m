Return-Path: <linux-kernel-owner+w=401wt.eu-S1754110AbYK0KB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110AbYK0KB6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 05:01:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752730AbYK0KBq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 05:01:46 -0500
Received: from gw1.cosmosbay.com ([86.65.150.130]:35991 "EHLO
	gw1.cosmosbay.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbYK0KBp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 05:01:45 -0500
Message-ID: <492E6FEA.70307@cosmosbay.com>
Date: Thu, 27 Nov 2008 11:01:14 +0100
From: Eric Dumazet <dada1@cosmosbay.com>
User-Agent: Thunderbird 2.0.0.18 (Windows/20081105)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, David Miller <davem@davemloft.net>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       kernel-testers@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
       Linux Netdev List <netdev@vger.kernel.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, travis <travis@sgi.com>
Subject: Re: [PATCH 4/6] fs: Introduce a per_cpu nr_inodes
References: <Pine.LNX.4.64.0811201727070.9089@quilx.com>	 <20081121083044.GL16242@elte.hu> <49267694.1030506@cosmosbay.com>	 <20081121.010508.40225532.davem@davemloft.net>	 <4926AEDB.10007@cosmosbay.com> <4926D022.5060008@cosmosbay.com>	 <20081121152148.GA20388@elte.hu> <4926D39D.9050603@cosmosbay.com>	 <20081121153453.GA23713@elte.hu>  <492DDC91.3020503@cosmosbay.com> <1227778377.4454.1299.camel@twins>
In-Reply-To: <1227778377.4454.1299.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-1.6 (gw1.cosmosbay.com [0.0.0.0]); Thu, 27 Nov 2008 11:01:15 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra a écrit :
> On Thu, 2008-11-27 at 00:32 +0100, Eric Dumazet wrote:
>> Avoids cache line ping pongs between cpus and prepare next patch,
>> because updates of nr_inodes metric dont need inode_lock anymore.
>>
>> (socket8 bench result : 25s to 20.5s)
>>
>> Signed-off-by: Eric Dumazet <dada1@cosmosbay.com>
>> ---
> 
>> @@ -96,9 +96,40 @@ static DEFINE_MUTEX(iprune_mutex);
>>   * Statistics gathering..
>>   */
>>  struct inodes_stat_t inodes_stat;
>> +static DEFINE_PER_CPU(int, nr_inodes);
>>  
>>  static struct kmem_cache * inode_cachep __read_mostly;
>>  
>> +int get_nr_inodes(void)
>> +{
>> +	int cpu;
>> +	int counter = 0;
>> +
>> +	for_each_possible_cpu(cpu)
>> +	    counter += per_cpu(nr_inodes, cpu);
>> +	if (counter < 0)
>> +		counter = 0;
>> +	return counter;
>> +}
> 
> It would be good to get a cpu hotplug handler here and move to
> for_each_online_cpu(). People are wanting distro's to be build with
> NR_CPUS=4096.

Hum, I guess we can use regular percpu_counter for this...


