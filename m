Return-Path: <linux-kernel-owner+w=401wt.eu-S1755077AbYHYLam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077AbYHYLam (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2008 07:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753653AbYHYLae
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Aug 2008 07:30:34 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:43030 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497AbYHYLad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2008 07:30:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=nvDpYJ3ZNeODTZFsHcIsR1iw+xxmcbDjBLzBeEfWOwtdEnGauGHfbHR2DW+n76gFJB
         UA0Cv9NlZOPZe60juAkQzERi9lSmXvLQRdTsQ5JsIaoC5DuOeEvM9u1aps+V7zdaYou4
         62GJYXkfEQCe6d/Y8BjvLeIVo24tC8/odg5ZM=
Message-ID: <48B297D5.8020402@gmail.com>
Date: Mon, 25 Aug 2008 14:30:29 +0300
From: edwin <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.16 (X11/20080724)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, rml@tech9.net,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Thomas Gleixner mingo@redhat.com" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Quad core CPUs loaded at only 50% when running a CPU and mmap
 intensive multi-threaded task
References: <48B1CC15.2040006@gmail.com> <1219643476.20732.1.camel@twins>	 <48B25988.8040302@gmail.com> <1219656190.8515.7.camel@twins>	 <48B28015.3040602@gmail.com> <1219658527.8515.16.camel@twins>	 <48B287D8.1000000@gmail.com> <1219660582.8515.24.camel@twins> <48B290E7.4070805@gmail.com>
In-Reply-To: <48B290E7.4070805@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

edwin wrote:
> Peter Zijlstra wrote:
>> On Mon, 2008-08-25 at 13:22 +0300, Török Edwin wrote:
>>
>>  
>>> Well, the real program (clamd) that this testprogram tries to 
>>> simulate does an mmap for almost every file, and I have lots of 
>>> small files.
>>> 6.5G, 114122 files, average size 57k.
>>>
>>> I'll run latencytop again, last time it has showed 100ms - 500ms 
>>> latency     
>
> Latencytop output attached.
> There is 4 - 60 ms latency for mmap/munmap, and the more threads there 
> are the total latency gets higher (latencytop says sum was ~480ms).
>
> Running with MaxThreads 4 gets me 300-400% CPU usage, but with 
> MaxThreads 8 CPU usage drops to around 120-250%.
> Now, maxthreads 4 looks like a good choice from a CPU usage point of 
> view, but is actually bad because it means that threads gets stuck in 
> iowait, and the CPU won't have anything to do. MaxThreads 8 looked 
> like a good alternative to fill the iowait gaps, but we run into the 
> mmap_sem issue.
> In a real world environment MaxThreads influences how many mails you 
> can process in parallel with your MTA, so generally it should be as 
> high as possible.
>
> On 2.6.27-rc4:
>
> MaxThreads 4 time, empty database (all cached, almost no I/O):
> 1m9s
>
> MaxThreads 4 time, after echo 3>/proc/sys/vm/drop_caches:
> 1m29s
>
> MaxThreads 8 time, empty database (all cached, almost no I/O):
> 2m16s
>
> MaxThreads 8 time, after echo 3>/proc/sys/vm/drop_caches:
> 2m15s
>

MaxThreads 8, full DB (13 % slower than 2.6.24)
4m42s

MaxThreads 4, full DB (8% faster than 2.6.24)
2m35s

MaxThreads 8, full DB, 2.6.24:
4m3s

MaxThreads 4, full DB, 2.6.24:
2m50s

I have run an echo 3>/proc/sys/vm/drop_caches before each, I hope that 
clears all caches,
I have xfs on top of lvm, on top of raid10, and iostat shows only 0 - 
20% activity (%util).
That could also mean of course that the disks can provide data fast 
enough for clamd.

>
> Of course running with a full database will give different results, so 
> I'll do some timing with that too (will take a little longer though).
>
>>> for clamd, and it was about mmap, I'll provide you with the exact 
>>> output.
>>>     
>>
>> Right - does it make sense to teach clamav about pread() ?
>
> If it is preferred over mmap, then maybe yes.
>
> Peter Zijlstra wrote:
> Best regards,
> --Edwin
>> OK, I'll poke a little more at is later today to see if I can spot
>> something
>
> Thanks!


Still, if I have more threads, performance *decreases* almost linearly 
with 2.6.27 (and probably with 2.6.25+ if clamd behaves the same as my 
test proggie),  however with 2.6.24

With Debian etch having 2.6.24 (etchnhalf actually), and lenny shipping 
with 2.6.25 or 2.6.26, users upgrading from etch to lenny could see a 
performance decrease.

Best regards,
--Edwin
