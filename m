Return-Path: <linux-kernel-owner+w=401wt.eu-S1755601AbYHYKWb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601AbYHYKWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 06:22:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753566AbYHYKWW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 06:22:22 -0400
Received: from gv-out-0910.google.com ([216.239.58.189]:13820 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753030AbYHYKWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 06:22:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=vHdU34Sy8VVr6h4o2JBy02RPW5YOF91cAoBXOAPS/lXADZDE/0dVPFopiYzbBSNdba
         6lIsc25CnSloAF1gl8MNypiYUy0WBdWOA1T0diHZ+981osBn5xaZCJeu/1s6GJ4JlCoK
         galrd+9w6T9YtXj/Zv85Sb77I1vpNyubpNDZs=
Message-ID: <48B287D8.1000000@gmail.com>
Date: Mon, 25 Aug 2008 13:22:16 +0300
From: =?UTF-8?B?VMO2csO2ayBFZHdpbg==?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, rml@tech9.net,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner mingo@redhat.com" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Quad core CPUs loaded at only 50% when running a CPU and mmap
 intensive multi-threaded task
References: <48B1CC15.2040006@gmail.com> <1219643476.20732.1.camel@twins>	 <48B25988.8040302@gmail.com> <1219656190.8515.7.camel@twins>	 <48B28015.3040602@gmail.com> <1219658527.8515.16.camel@twins>
In-Reply-To: <1219658527.8515.16.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-08-25 13:02, Peter Zijlstra wrote:
> On Mon, 2008-08-25 at 12:49 +0300, Török Edwin wrote:
>   
>> On 2008-08-25 12:23, Peter Zijlstra wrote:
>>     
>>> On Mon, 2008-08-25 at 10:04 +0300, edwin wrote:
>>>   
>>>       
>>>> Peter Zijlstra wrote:
>>>>     
>>>>         
>>>>> On Mon, 2008-08-25 at 00:01 +0300, Török Edwin wrote:
>>>>>   
>>>>>       
>>>>>           
>>>>>> Hi Ingo,
>>>>>>
>>>>>> When I run clamd (www.clamav.net), I can only get to load my CPU 50% 
>>>>>> (according to top), and disks at 30% (according to iostat -x 3), 
>>>>>> regardless how many threads I set (I tried 4, 8, 16, 32).
>>>>>>     
>>>>>>         
>>>>>>             
>>>>> Can you share your .config, and prehaps tell what kernel version did
>>>>> work for you?
>>>>>       
>>>>>           
>>>> Sorry, I forgot to include the .config, its at the end of this mail (the 
>>>> cfs debug info output included the .config though)
>>>>
>>>> Well, I just bought this new box, so there isn't a kernel version that I 
>>>> know that worked on this hardware (but I am trying to boot some older 
>>>> versions now).
>>>> However on my previous box (Athlon64, non-SMP) I have never seen such a 
>>>> problem (that the CPU is loaded only 50% with clamd) and I've been
>>>> running 2.6.26 and 2.6.27-rc4 there too.
>>>>
>>>> Details below, short summary here:
>>>> 2.6.24: WORKS, clamd 400% CPU, testprogram runs in 27.4 seconds, 67% CPU 
>>>> load; and 28.5 seconds w/o setting affinity
>>>> 2.6.25+: DOES NOT WORK, clamd 200%-300% CPU, testprogram runs in 38-40 
>>>> seconds, 48-48% CPU load, and 47-56 seconds w/o setting affinity
>>>>
>>>> Debian has 2.6.18, 2.6.22, 2.6.24, 2.6.25, 2.6.26.
>>>> 2.6.22 won't work with my lvm, so I can't boot that, so I tried 2.6.24:
>>>>
>>>> 2.6.24 doesn't have sched_debug enabled in the stock kernel 
>>>> unfortunately, but the output of cfs-debug-info.sh is available here, 
>>>> maybe it contains some useful info:
>>>> http://edwintorok.googlepages.com/testrun-1219645937.tar.gz
>>>>
>>>> Is this enough info for you to reproduce the problem, or do you want me 
>>>> to try and bisect?
>>>>     
>>>>         
>>> No, I think I know what's going on..
>>>
>>> mmap() and munmap() need to take the mmap_sem for writing (since they
>>> modify the memory map) and you let each thread (one for each cpu) take
>>> that process wide lock, twice, for a million times.
>>>   
>>>       
>> Are you referring to the mmap_sem lock, or my mutex lock around 
>> all_thread_time?
>>     
>
> mmap_sem, its process wide, and your test prog bangs on it like there's
> no tomorrow.
>   

Well, the real program (clamd) that this testprogram tries to simulate 
does an mmap for almost every file, and I have lots of small files.
6.5G, 114122 files, average size 57k.

I'll run latencytop again, last time it has showed 100ms - 500ms latency 
for clamd, and it was about mmap, I'll provide you with the exact output.

>>> Guess what happens ;-)
>>>       
>> So the problem is that doing mmap() doesn't scale well with multiple 
>> threads, because there is contention on mmap_sem?
>>     
>
> Indeed.
>
>   
>> Why did 2.6.24 seem to work better?
>>     
>
> Perhaps the scheduler overhead did increase, can you try:
>
> echo NO_HRTICK > /debug/sched_features
>
> (after mounting debugfs on /debug, or adjusting the path to where you do
> have it mounted)
>
> That might cause some overhead on very high context switch rates.

No difference, and turning off the other features from sched_features 
doesn't seem to help either.

Best regards,
--Edwin
