Return-Path: <linux-kernel-owner+w=401wt.eu-S1760117AbYDDPEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760117AbYDDPEB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2008 11:04:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757088AbYDDPDx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Apr 2008 11:03:53 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:59907 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326AbYDDPDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2008 11:03:52 -0400
Message-ID: <47F6433D.8050206@bull.net>
Date: Fri, 04 Apr 2008 17:03:25 +0200
From: Nadia Derbey <Nadia.Derbey@bull.net>
Organization: BULL/DT/OSwR&D/Linux
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.6) Gecko/20040115
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Mike Galbraith <efault@gmx.de>, Manfred Spraul <manfred@colorfullife.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       paulmck@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Pavel Emelianov <xemul@openvz.org>,
       NADIA DERBEY <Nadia.Derbey@bull.net>
Subject: Re: Scalability requirements for sysv ipc (+namespaces broken with
 SEM_UNDO)
References: <47E382DB.70503@colorfullife.com> <47E3ADE3.4030304@bull.net>	 <47E3B924.3000304@colorfullife.com>	 <20080321141339.GB9618@linux.vnet.ibm.com>	 <47E3DD8C.4000904@colorfullife.com>	 <1206164608.3659.11.camel@marge.simson.net>	 <47E4DB06.3020003@colorfullife.com>	 <1206186832.4545.1.camel@marge.simson.net>	 <47E51637.8060102@colorfullife.com>  <47E55945.10109@colorfullife.com>	 <1206460206.4414.21.camel@marge.simson.net>	 <47EF9FC2.3050901@colorfullife.com> <1206897488.4593.11.camel@marge.simson.net> <47F6424F.9010405@bull.net>
In-Reply-To: <47F6424F.9010405@bull.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nadia Derbey wrote:
> Mike Galbraith wrote:
> 
>> On Sun, 2008-03-30 at 16:12 +0200, Manfred Spraul wrote:
>>
>>> Mike Galbraith wrote:
>>>
>>>> On Sat, 2008-03-22 at 20:08 +0100, Manfred Spraul wrote:
>>>>
>>>>  
>>>>
>>>>> just the normal performance of 2.6.25-rc3 is abyssimal, 55 to 60% 
>>>>> slower than 2.6.18.8:
>>>>>    
>>>>
>>>>
>>>> After manually reverting 3e148c79938aa39035669c1cfa3ff60722134535,
>>>> 2.6.25.git scaled linearly
>>>
>>>
>>> We can't just revert that patch: with IDR, a global lock is mandatory 
>>> :-(
>>> We must either revert the whole idea of using IDR or live with the 
>>> reduced scalability.
>>
>>
>>
>> Yeah, I looked at the problem, but didn't know what the heck to do about
>> it, so just grabbed my axe to verify/quantify.
>>
>>
>>> Actually, there are further bugs: the undo structures are not 
>>> namespace-aware, thus semop with SEM_UNDO, unshare, create new array 
>>> with same id, but more semaphores, another semop with SEM_UNDO will 
>>> corrupt kernel memory :-(
>>> I'll try to clean up the bugs first, then I'll look at the 
>>> scalability again.
>>
>>
>>
>> Great!
>>
>>     -Mike
>>
>>
>>
>>
> 
> I could get better results with the following solution:
> wrote an RCU-based idr api (layers allocation is managed similarly to 
> the radix-tree one)
> 
> Using it in the ipc code makes me get rid of the read lock taken in 
> ipc_lock() (the one introduced in 
> 3e148c79938aa39035669c1cfa3ff60722134535).
> 
> You'll find the results in attachment (kernel is 2.6.25-rc3-mm1).
> output.25_rc3_mm1.ref.8  --> pmsg output for the 2.6.25-rc3-mm1
> plot.25_rc3_mm1.ref.8    --> previous file results for use by gnuplot
> output.25_rc3_mm1.ridr.8 --> pmsg output for the 2.6.25-rc3-mm1
>                              + rcu-based idrs
> plot.25_rc3_mm1.ridr.8   --> previous file results for use by gnuplot
> 
> 
> I think I should be able to send a patch next week. It is presently an 
> uggly code: I copied idr.c and idr.h into ridr.c and ridr.h to go fast, 
> so didn't do any code factorization.
> 
> Regards
> Nadia
> 
> 
> 

Sorry forgot the command:

for i in 1 2 3 4 5 6 7 8;do ./pmsg $i 5;done > output.25_rc3_mm1.ref.8


Regards,
Nadia

