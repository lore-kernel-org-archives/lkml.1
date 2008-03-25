Return-Path: <linux-kernel-owner+w=401wt.eu-S1758117AbYCYQBT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117AbYCYQBT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 12:01:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755705AbYCYQBF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 12:01:05 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:47420 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755427AbYCYQBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 12:01:03 -0400
Message-ID: <47E9219A.2030601@bull.net>
Date: Tue, 25 Mar 2008 17:00:26 +0100
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: Scalability requirements for sysv ipc
References: <47E382DB.70503@colorfullife.com> <47E3ADE3.4030304@bull.net> <47E3B924.3000304@colorfullife.com>
In-Reply-To: <47E3B924.3000304@colorfullife.com>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Manfred Spraul wrote:
> Nadia Derbey wrote:
> 
>> Manfred Spraul wrote:
>>
>>>
>>> A microbenchmark on a single-cpu system doesn't help much (except 
>>> that 2.6.25 is around factor 2 slower for sysv msg ping-pong between 
>>> two tasks compared to the numbers I remember from older kernels....)
>>>
>>
>> If I remember well, at that time I had used ctxbench and I wrote some 
>> other small scripts.
>> And the results I had were around 2 or 3% slowdown, but I have to 
>> confirm that by checking in my archives.
>>
> Do you have access to multi-core systems? The "best case" for the rcu 
> code would be
> - 8 or 16 cores
> - one instance of ctxbench running on each core, bound to that core.
> 
> I'd expect a significant slowdown. The big question is if it matters.
> 
> -- 
>    Manfred
> 
> 

Hi,

Here is what I could find on my side:

=============================================================

lkernel@akt$ cat tst3/res_new/output
[root@akt tests]# echo 32768 > /proc/sys/kernel/msgmni
[root@akt tests]# ./msgbench_std_dev_plot -n
32768000 msgget iterations in 21.469724 seconds = 1526294/sec

32768000 msgsnd iterations in 18.891328 seconds = 1734583/sec

32768000 msgctl(ipc_stat) iterations in 15.359802 seconds = 2133472/sec

32768000 msgctl(msg_stat) iterations in 15.296114 seconds = 2142260/sec

32768000 msgctl(ipc_rmid) iterations in 32.981277 seconds = 993542/sec

             AVERAGE        STD_DEV      MIN     MAX
GET:        21469.724000   566.024657   19880   23607
SEND:       18891.328000   515.542311   18433   21962
IPC_STAT:   15359.802000   274.918673   15147   17166
MSG_STAT:   15296.114000   155.775508   15138   16790
RM:         32981.277000   675.621060   32141   35433


lkernel@akt$ cat tst3/res_ref/output
[root@akt tests]# echo 32768 > /proc/sys/kernel/msgmni
[root@akt tests]# ./msgbench_std_dev_plot -r
32768000 msgget iterations in 665.842852 seconds = 49213/sec

32768000 msgsnd iterations in 18.363853 seconds = 1784458/sec

32768000 msgctl(ipc_stat) iterations in 14.609669 seconds = 2243001/sec

32768000 msgctl(msg_stat) iterations in 14.774829 seconds = 2217950/sec

32768000 msgctl(ipc_rmid) iterations in 31.134984 seconds = 1052483/sec

             AVERAGE        STD_DEV      MIN     MAX
GET:        665842.852000   946.697555   654049   672208
SEND:       18363.853000   107.514954   18295   19563
IPC_STAT:   14609.669000   43.100272   14529   14881
MSG_STAT:   14774.829000   97.174924   14516   15436
RM:         31134.984000   444.612055   30521   33523


==================================================================

Unfortunately, I haven't kept the exact kernel release numbers, but the 
testing method was:
res_ref = unpatched kernel
res_new = same kernel release with my patches applied.

What I'll try to do is to re-run your tests (pmsg and psem) with this 
method (from my what I saw, the patches applied on a 2.6.23-rc4-mm1), 
but I can't do it before Thursday.

Regards,
Nadia
