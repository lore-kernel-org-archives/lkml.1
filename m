Return-Path: <linux-kernel-owner+w=401wt.eu-S1753819AbYK0Rrc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753819AbYK0Rrc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 12:47:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752280AbYK0RrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 12:47:22 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:49939 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751944AbYK0RrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 12:47:21 -0500
Message-ID: <492EDCFB.7080302@vlnb.net>
Date: Thu, 27 Nov 2008 20:46:35 +0300
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Wu Fengguang <wfg@linux.intel.com>
CC: Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>,
       "Vitaly V. Bursov" <vitalyb@telenet.dn.ua>,
       linux-kernel@vger.kernel.org
Subject: Re: Slow file transfer speeds with CFQ IO scheduler in some cases
References: <20081110135618.GI26778@kernel.dk> <x491vxgkd61.fsf@segfault.boston.devel.redhat.com> <20081112190227.GS26778@kernel.dk> <1226566313.199910.29888@de> <492BDAA9.4090405@vlnb.net> <20081125113048.GB16422@localhost> <492BE47B.3010802@vlnb.net> <20081125114908.GA16545@localhost> <492BE97A.3050606@vlnb.net> <492BEAE8.9050809@vlnb.net> <20081125121534.GA16778@localhost>
In-Reply-To: <20081125121534.GA16778@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX1/FMZMEQezBbfNqvBl0eGhHYhx7PqMsVUu0udt
 Xgv5gLLg1WD931JHKU25DHYJLYIzxfaDCn+N2IKqb885p4ZKiT
 0vcgXHmjIf2fThG8qNrDg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Wu Fengguang wrote:
> On Tue, Nov 25, 2008 at 03:09:12PM +0300, Vladislav Bolkhovitin wrote:
>> Vladislav Bolkhovitin wrote:
>>> Wu Fengguang wrote:
>>>> On Tue, Nov 25, 2008 at 02:41:47PM +0300, Vladislav Bolkhovitin wrote:
>>>>> Wu Fengguang wrote:
>>>>>> On Tue, Nov 25, 2008 at 01:59:53PM +0300, Vladislav Bolkhovitin wrote:
>>>>>>> Wu Fengguang wrote:
>>>>>>>> Hi all,
>>>>>>>>
>>>>>>>> //Sorry for being late. 
>>>>>>>>
>>>>>>>> On Wed, Nov 12, 2008 at 08:02:28PM +0100, Jens Axboe wrote:
>>>>>>>> [...]
>>>>>>>>> I already talked about this with Jeff on irc, but I guess should post it
>>>>>>>>> here as well.
>>>>>>>>>
>>>>>>>>> nfsd aside (which does seem to have some different behaviour skewing the
>>>>>>>>> results), the original patch came about because dump(8) has a really
>>>>>>>>> stupid design that offloads IO to a number of processes. This basically
>>>>>>>>> makes fairly sequential IO more random with CFQ, since each process gets
>>>>>>>>> its own io context. My feeling is that we should fix dump instead of
>>>>>>>>> introducing a fair bit of complexity (and slowdown) in CFQ. I'm not
>>>>>>>>> aware of any other good programs out there that would do something
>>>>>>>>> similar, so I don't think there's a lot of merrit to spending cycles on
>>>>>>>>> detecting cooperating processes.
>>>>>>>>>
>>>>>>>>> Jeff will take a look at fixing dump instead, and I may have promised
>>>>>>>>> him that santa will bring him something nice this year if he does (since
>>>>>>>>> I'm sure it'll be painful on the eyes).
>>>>>>>> This could also be fixed at the VFS readahead level.
>>>>>>>>
>>>>>>>> In fact I've seen many kinds of interleaved accesses:
>>>>>>>> - concurrently reading 40 files that are in fact hard links of one single file
>>>>>>>> - a backup tool that splits a big file into 8k chunks, and serve the
>>>>>>>>   {1, 3, 5, 7, ...} chunks in one process and the {0, 2, 4, 6, ...}
>>>>>>>>   chunks in another one
>>>>>>>> - a pool of NFSDs randomly serving some originally sequential 
>>>>>>>> read  requests - now dump(8) seems to have some similar 
>>>>>>>> problem.
>>>>>>>>
>>>>>>>> In summary there have been all kinds of efforts on trying to
>>>>>>>> parallelize I/O tasks, but unfortunately they can easily screw up the
>>>>>>>> sequential pattern. It may not be easily fixable for many of them.
>>>>>>>>
>>>>>>>> It is however possible to detect most of these patterns at the
>>>>>>>> readahead layer and restore sequential I/Os, before they propagate
>>>>>>>> into the block layer and hurt performance.
>>>>>>> I believe this would be the most effective way to go, 
>>>>>>> especially in case  if data delivery path to the original 
>>>>>>> client has its own latency  depended from the amount of 
>>>>>>> transferred data as it is in the case of  remote NFS mount, 
>>>>>>> which does synchronous sequential reads. In this case  it is 
>>>>>>> essential for performance to make both links (local to the 
>>>>>>> storage  and network to the client) be always busy and  
>>>>>>> transfer data  simultaneously. Since the reads are synchronous, 
>>>>>>> the only way to achieve  that is perform read ahead on the 
>>>>>>> server sufficient to cover the network  link latency. Otherwise 
>>>>>>> you would end up with only half of possible  throughput.
>>>>>>>
>>>>>>> However, from one side, server has to have a pool of  
>>>>>>> threads/processes  to perform well, but, from other side, 
>>>>>>> current read ahead code doesn't  detect too well that those 
>>>>>>> threads/processes are doing joint sequential  read, so the read 
>>>>>>> ahead window gets smaller, hence the overall read  performance 
>>>>>>> gets considerably smaller too.
>>>>>>>
>>>>>>>> Vitaly, if that's what you need, I can try to prepare a patch for testing out.
>>>>>>> I can test it with SCST SCSI target sybsystem 
>>>>>>> (http://scst.sf.net). SCST  needs such feature very much, 
>>>>>>> otherwise it can't get full backstorage  read speed. The 
>>>>>>> maximum I can see is about ~80MB/s from ~130MB/s 15K RPM  disk 
>>>>>>> over 1Gbps iSCSI link (maximum possible is ~110MB/s).
>>>>>> Thank you very much!
>>>>>>
>>>>>> BTW, do you implicate that the SCSI system (or its applications) has
>>>>>> similar behaviors that the current readahead code cannot handle well?
>>>>> No. SCSI target subsystem is not the same as SCSI initiator 
>>>>> subsystem,  which usually called simply SCSI (sub)system. SCSI 
>>>>> target is a SCSI  server. It has the same amount of common with 
>>>>> SCSI initiator as there  is, e.g., between Apache (HTTP server) and 
>>>>> Firefox (HTTP client).
>>>> Got it. So the SCSI server will split&spread sequential IO of one
>>>> single file to cooperative threads?
>>> Yes. It has to do so, because Linux doesn't have async. cached IO and a 
>>> client can queue several tens of commands at time. Then, on the  
>>> sequential IO with 1 command at time, CPU scheduler comes to play and  
>>> spreads those commands over those threads, so read ahead gets too small 
>>> to cover the external link latency and fill both links with data, so  
>>> that uncovered latency kills throughput.
>> Additionally, if the uncovered external link latency is too large, one  
>> more factor is getting noticeable: storage rotation latency. If the next  
>> unread sector is missed to be read at time, server has to wait a full  
>> rotation to start receiving data for the next block, which even more  
>> decreases the resulting throughput.
> 
> Thank you for the details. I've been working slowly on the idea, and
> should be able to send you a patch in the next one or two days.

Actually, there's one more thing, which should have been mentioned. It 
is possible that remote clients have several sequential read streams at 
time together with some "noise" of random requests. A good read-ahead 
subsystem should handle such case by keeping big read-ahead windows for 
the sequential streams and don't do any read ahead for the random 
requests. And all at the same time.

Currently on such workloads read ahead will be completely disabled for 
all the requests. Hence, there is a possibility here to improve 
performance in 3-5 times or even more by making the workload more linear.

I guess, such functionality can be done by keeping several read-ahead 
contexts not in file handle as now, but in inode, or ever in task_struct 
similarly to io_context. Or even as a part of struct io_context. Then 
those contexts would be rotated in, e.g., round robin manner. I have 
some basic thoughts in this area and would be glad to share them, if you 
are interested.

Going further, ultimately, it would be great to provide somehow a 
capability to allow to assign for each read-ahead stream own IO context, 
because on the remote side in most cases such streams would correspond 
to different programs reading data in parallel. This should allow to 
increase performance even more.

> Thanks,
> Fengguang
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
