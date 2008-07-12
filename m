Return-Path: <linux-kernel-owner+w=401wt.eu-S1755319AbYGLU1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbYGLU1S (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jul 2008 16:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752919AbYGLU1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 12 Jul 2008 16:27:07 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:4658 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbYGLU1E convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jul 2008 16:27:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=oAeeEogdEKUJDM1ntVYeIUT5PxTNWC6dniCM51C+xCPbFRI7/Cyyj+e+YwYlb+wify
         03VNJI0hutNJW6/y9rfKAml685W0TsKpxBTsMiw+jb2sgnwlkgdRfe/+A7VXlyfSdXtL
         S1dio/Js+hDXIKocUlot1VEMkaLLm32S3uIXM=
Message-ID: <48791393.1020107@gmail.com>
Date: Sat, 12 Jul 2008 23:26:59 +0300
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.14 (X11/20080509)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@elte.hu>, Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Elias Oltmanns <eo@nebensachen.de>,
       Arjan van de Ven <arjan@infradead.org>, Oleg Nesterov <oleg@tv-sign.ru>
Subject: Re: [PATCH] x86_64: fix delayed signals
References: <20080710215039.2A143154218@magilla.localdomain> <20080711054605.GA17851@elte.hu> <alpine.LFD.1.10.0807111031310.2936@woody.linux-foundation.org> <alpine.LFD.1.10.0807111102450.2936@woody.linux-foundation.org> <alpine.LFD.1.10.0807111337060.2873@woody.linux-foundation.org> <alpine.LFD.1.10.0807111617470.3459@woody.linux-foundation.org> <4878883F.10004@gmail.com> <alpine.LFD.1.10.0807121011470.2875@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0807121011470.2875@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2008-07-12 20:29, Linus Torvalds wrote:
> On Sat, 12 Jul 2008, Török Edwin wrote:
>   
>> On my 32-bit box (slow disks, SMP, XFS filesystem) 2.6.26-rc9 behaves
>> the same as 2.6.26-rc8, I can reliably reproduce a 2-3 second latency
>> [1] between pressing ^C the first time, and the shell returning (on the
>> text console too).
>> Using ftrace available from tip/master, I see up to 3 seconds of delay
>> between kill_pgrp and detach_pid (and during that time I can press ^C
>> again, leading to 2-3 kill_pgrp calls)
>>     
>
> The thing is, it's important to see what happens in between. 
>
> In particular, 2-3 second latencies can be entirely _normal_ (although 
> obviously very annoying) with most log-based filesystems when they decide 
> they have to flush the log.

A bit off-topic, but something I noticed during the tests:
In my original test I have rm-ed the files right after launching dd in
the background, yet it still continued to write to the disk.
I can understand that if the file is opened O_RDWR, you might seek back
and read what you wrote, so Linux needs to actually do the write,
but why does it insist on writing to the disk, on a file opened with
O_WRONLY, after the file itself got unlinked?

>  A lot of filesystems are not designed for 
> latency - every single filesystem test I have ever seen has always been 
> either a throughput test, or a "average random-seek latency" kind of test.
>
> The exact behavior will depend on the filesystem, for example. It will 
> also easily depend on things like whether you update 'atime' or not. Many 
> ostensibly read-only loads end up writing some data, especially inode 
> atimes, and that's when they can get caught up in having to wait for a log 
> to flush (to make up for that atime thing).
>   

I have my filesystems mounted as noatime already.
But yes, I am using different filesystems, the x86-64 box has reiserfs,
and the x86-32 box has xfs.

> You can try to limit the amount of dirty data in flight by tweaking 
> /proc/sys/vm/dirty*ratio

I have these in my /etc/rc.local:
echo 5 > /proc/sys/vm/dirty_background_ratio
echo 10 >/proc/sys/vm/dirty_ratio


> , but from a latency standpoint the thing that 
> actually matters more is often not the amount of dirty data, but the size 
> of the requests queues - because you often care about read latency, but if 
> you have big requests and especially if you have a load that does lots of 
> big _contiguous_ writes (like your 'dd's would do), then what can easily 
> happen is that the read ends up being behind a really big write in the 
> request queues. 
>   

I will try tweaking these (and /sys/block/sda/queue/nr_requests that
Arjan suggested).

> And 2-3 second latencies by no means means that each individual IO is 2-3 
> seconds long. No - it just means that you ended up having to do multiple 
> reads synchronously, and since the reads depended on each other (think a 
> pathname lookup - reading each directory entry -> inode -> data), you can 
> easily have a single system call causing 5-10 reads (bad cases are _much_ 
> more, but 5-10 are perfectly normal for even well-behaved things), and now 
> if each of those reads end up being behind a fairly big write...
>   

I'll try blktrace tomorrow, it should tell me when I/Os are queued /
completed.

>   
>> On my 64-bit box (2 disks in raid-0, UP, reiserfs filesystem) 2.6.25 and
>> 2.6.26-rc9 behave the same, and most of the time (10-20 times in a row)
>> find responds to ^C instantly.
>>
>> However in _some_ cases find doesn't respond to ^C for a very long time 
>> (~30 seconds), and when this happens I can't do anything else but switch 
>> consoles, starting another process (latencytop -d) hangs, and so does 
>> any other external command.
>>     
>
> Ok, that is definitel not related to signals at all. You're simply stuck 
> waiting for IO - or perhaps some fundamental filesystem semaphore which is 
> held while some IO needs to be flushed.

AFAICT reiserfs still uses the BKL, could that explain why one I/O
delays another?

>  That's why _unrelated_ processes 
> hang: they're all waiting for a global resource.
>
> And it may be worse on your other box for any number of reasons: raid 
> means, for example, that you have two different levels of queueing, and 
> thus effectively your queues are longer. And while raid-0 is better for 
> throughput, it's not necessarily at all better for latency. The filesystem 
> also makes a difference, as does the amount of dirty data under write-back 
> (do you also have more memory in your x86-64 box, for example? That makes 
> the kernel do bigger writeback buffers by default)
>
>   

Yes, I have more memory on x86-64 (2G), and x86-32 has 1G.
>> I haven't yet tried ftrace on this box, and neither did I try Roland's
>> patch yet. I will try that now, and hopefuly come back with some numbers
>> shortly.
>>     
>
> Trust me, roland's patch will make no difference what-so-ever. It's purely 
> a per-thread thing, and your behaviour is clearly not per-thread.
>   

Indeed.
[Roland's patch is included in tip/master so I actually tried it even if
I didn't know I did]

> Signals are _always_ delayed until non-blocking system calls are done, and 
> that means until the end of IO. 
>
> This is also why your trace on just 'kill_pgrp' and 'detach_pid' is not 
> interesting. It's _normal_ to have a delay between them. It can happen 
> because the process blocks (or catches) signals, but it will also happen 
> if some system call waits for disk.
>   

Is there a way to trace what happens between those 2 functions?
Maybe if I don't use the trace filter (and thus trace all functions),
and modify the kernel sources to start tracing on kill_pgrp, and stop
tracing on detach_pid.
Would that provide useful info?


Best regards,
--Edwin

