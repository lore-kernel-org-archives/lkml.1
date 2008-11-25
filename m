Return-Path: <linux-kernel-owner+w=401wt.eu-S1753030AbYKYMQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbYKYMQ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 07:16:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751304AbYKYMQR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 07:16:17 -0500
Received: from mga07.intel.com ([143.182.124.22]:44000 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750958AbYKYMQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 07:16:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,664,1220252400"; 
   d="scan'208";a="82398026"
Date: Tue, 25 Nov 2008 20:15:35 +0800
From: Wu Fengguang <wfg@linux.intel.com>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Jens Axboe <jens.axboe@oracle.com>, Jeff Moyer <jmoyer@redhat.com>,
       "Vitaly V. Bursov" <vitalyb@telenet.dn.ua>,
       linux-kernel@vger.kernel.org
Subject: Re: Slow file transfer speeds with CFQ IO scheduler in some cases
Message-ID: <20081125121534.GA16778@localhost>
References: <20081110135618.GI26778@kernel.dk> <x491vxgkd61.fsf@segfault.boston.devel.redhat.com> <20081112190227.GS26778@kernel.dk> <1226566313.199910.29888@de> <492BDAA9.4090405@vlnb.net> <20081125113048.GB16422@localhost> <492BE47B.3010802@vlnb.net> <20081125114908.GA16545@localhost> <492BE97A.3050606@vlnb.net> <492BEAE8.9050809@vlnb.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <492BEAE8.9050809@vlnb.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 25, 2008 at 03:09:12PM +0300, Vladislav Bolkhovitin wrote:
> Vladislav Bolkhovitin wrote:
>> Wu Fengguang wrote:
>>> On Tue, Nov 25, 2008 at 02:41:47PM +0300, Vladislav Bolkhovitin wrote:
>>>> Wu Fengguang wrote:
>>>>> On Tue, Nov 25, 2008 at 01:59:53PM +0300, Vladislav Bolkhovitin wrote:
>>>>>> Wu Fengguang wrote:
>>>>>>> Hi all,
>>>>>>>
>>>>>>> //Sorry for being late. 
>>>>>>>
>>>>>>> On Wed, Nov 12, 2008 at 08:02:28PM +0100, Jens Axboe wrote:
>>>>>>> [...]
>>>>>>>> I already talked about this with Jeff on irc, but I guess should post it
>>>>>>>> here as well.
>>>>>>>>
>>>>>>>> nfsd aside (which does seem to have some different behaviour skewing the
>>>>>>>> results), the original patch came about because dump(8) has a really
>>>>>>>> stupid design that offloads IO to a number of processes. This basically
>>>>>>>> makes fairly sequential IO more random with CFQ, since each process gets
>>>>>>>> its own io context. My feeling is that we should fix dump instead of
>>>>>>>> introducing a fair bit of complexity (and slowdown) in CFQ. I'm not
>>>>>>>> aware of any other good programs out there that would do something
>>>>>>>> similar, so I don't think there's a lot of merrit to spending cycles on
>>>>>>>> detecting cooperating processes.
>>>>>>>>
>>>>>>>> Jeff will take a look at fixing dump instead, and I may have promised
>>>>>>>> him that santa will bring him something nice this year if he does (since
>>>>>>>> I'm sure it'll be painful on the eyes).
>>>>>>> This could also be fixed at the VFS readahead level.
>>>>>>>
>>>>>>> In fact I've seen many kinds of interleaved accesses:
>>>>>>> - concurrently reading 40 files that are in fact hard links of one single file
>>>>>>> - a backup tool that splits a big file into 8k chunks, and serve the
>>>>>>>   {1, 3, 5, 7, ...} chunks in one process and the {0, 2, 4, 6, ...}
>>>>>>>   chunks in another one
>>>>>>> - a pool of NFSDs randomly serving some originally sequential 
>>>>>>> read  requests - now dump(8) seems to have some similar 
>>>>>>> problem.
>>>>>>>
>>>>>>> In summary there have been all kinds of efforts on trying to
>>>>>>> parallelize I/O tasks, but unfortunately they can easily screw up the
>>>>>>> sequential pattern. It may not be easily fixable for many of them.
>>>>>>>
>>>>>>> It is however possible to detect most of these patterns at the
>>>>>>> readahead layer and restore sequential I/Os, before they propagate
>>>>>>> into the block layer and hurt performance.
>>>>>> I believe this would be the most effective way to go, 
>>>>>> especially in case  if data delivery path to the original 
>>>>>> client has its own latency  depended from the amount of 
>>>>>> transferred data as it is in the case of  remote NFS mount, 
>>>>>> which does synchronous sequential reads. In this case  it is 
>>>>>> essential for performance to make both links (local to the 
>>>>>> storage  and network to the client) be always busy and  
>>>>>> transfer data  simultaneously. Since the reads are synchronous, 
>>>>>> the only way to achieve  that is perform read ahead on the 
>>>>>> server sufficient to cover the network  link latency. Otherwise 
>>>>>> you would end up with only half of possible  throughput.
>>>>>>
>>>>>> However, from one side, server has to have a pool of  
>>>>>> threads/processes  to perform well, but, from other side, 
>>>>>> current read ahead code doesn't  detect too well that those 
>>>>>> threads/processes are doing joint sequential  read, so the read 
>>>>>> ahead window gets smaller, hence the overall read  performance 
>>>>>> gets considerably smaller too.
>>>>>>
>>>>>>> Vitaly, if that's what you need, I can try to prepare a patch for testing out.
>>>>>> I can test it with SCST SCSI target sybsystem 
>>>>>> (http://scst.sf.net). SCST  needs such feature very much, 
>>>>>> otherwise it can't get full backstorage  read speed. The 
>>>>>> maximum I can see is about ~80MB/s from ~130MB/s 15K RPM  disk 
>>>>>> over 1Gbps iSCSI link (maximum possible is ~110MB/s).
>>>>> Thank you very much!
>>>>>
>>>>> BTW, do you implicate that the SCSI system (or its applications) has
>>>>> similar behaviors that the current readahead code cannot handle well?
>>>> No. SCSI target subsystem is not the same as SCSI initiator 
>>>> subsystem,  which usually called simply SCSI (sub)system. SCSI 
>>>> target is a SCSI  server. It has the same amount of common with 
>>>> SCSI initiator as there  is, e.g., between Apache (HTTP server) and 
>>>> Firefox (HTTP client).
>>> Got it. So the SCSI server will split&spread sequential IO of one
>>> single file to cooperative threads?
>>
>> Yes. It has to do so, because Linux doesn't have async. cached IO and a 
>> client can queue several tens of commands at time. Then, on the  
>> sequential IO with 1 command at time, CPU scheduler comes to play and  
>> spreads those commands over those threads, so read ahead gets too small 
>> to cover the external link latency and fill both links with data, so  
>> that uncovered latency kills throughput.
>
> Additionally, if the uncovered external link latency is too large, one  
> more factor is getting noticeable: storage rotation latency. If the next  
> unread sector is missed to be read at time, server has to wait a full  
> rotation to start receiving data for the next block, which even more  
> decreases the resulting throughput.

Thank you for the details. I've been working slowly on the idea, and
should be able to send you a patch in the next one or two days.

Thanks,
Fengguang
