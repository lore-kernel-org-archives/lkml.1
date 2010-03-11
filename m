Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555Ab0CKJ61 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 04:58:27 -0500
Received: from mtagate6.uk.ibm.com ([194.196.100.166]:35819 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755724Ab0CKJ6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 04:58:25 -0500
Message-ID: <4B98BEB0.6020800@linux.vnet.ibm.com>
Date: Thu, 11 Mar 2010 10:58:08 +0100
From: Christian Ehrhardt <ehrhardt@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Jens Axboe <jens.axboe@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Hisashi Hifumi <hifumi.hisashi@oss.ntt.co.jp>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ronald <intercommit@gmail.com>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Vladislav Bolkhovitin <vst@vlnb.net>,
       Randy Dunlap <randy.dunlap@oracle.com>, Nick Piggin <npiggin@suse.de>
Subject: Re: [RFC PATCH] Fix Readahead stalling by plugged device queues
References: <4B979104.6010907@linux.vnet.ibm.com> <20100310130932.GB18509@localhost> <4B97AD52.7080201@linux.vnet.ibm.com> <20100311014542.GA8134@localhost>
In-Reply-To: <20100311014542.GA8134@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wu Fengguang wrote:
> On Wed, Mar 10, 2010 at 10:31:46PM +0800, Christian Ehrhardt wrote:
>>
>> Wu Fengguang wrote:
>> [...]
>>> Christian, did you notice this commit for 2.6.33?
>>>
>>> commit 65a80b4c61f5b5f6eb0f5669c8fb120893bfb388
>> [...]
>>
>> I didn't see that particular one, due to the fact that whatever the 
>> result is it needs to work .32
>>
>> Anyway I'll test it tomorrow and if that already accepted one fixes my 
>> issue as well I'll recommend distros older than 2.6.33 picking that one 
>> up in their on top patches.
> 
> OK, thanks!

That patch fixes my issue completely and is as we discussed less 
aggressive which is fine - thanks for pointing it out - Now I have 
something already upstream accepted to fix the issue, thats much better!

>>> It should at least improve performance between .32 and .33, because
>>> once two readahead requests are merged into one single IO request,
>>> the PageUptodate() will be true at next readahead, and hence
>>> blk_run_backing_dev() get called to break out of the suboptimal
>>> situation.
>> As you saw from my blktrace thats already the case without that patch.
>> Once the second readahead comes in and merged it gets unplugged in 
>> 2.6.32 too - but still that is bad behavior as it denies my things like 
>> 68% throughput improvement :-).
> 
> I mean, when readahead windows A and B are submitted in one IO --
> let's call it AB -- commit 65a80b4c61 will explicitly unplug on doing
> readahead C.  While in your trace, the unplug appears on AB.
> 
> The 68% improvement is very impressive. Wondering if commit 65a80b4c61
> (the _conditional_ unplug) can achieve the same level of improvement :)

Yep it can !
We can post update the patch description to bigger numbers :-)

>>> Your patch does reduce the possible readahead submit latency to 0.
>> yeah and I think/hope that is fine, because as I stated:
>> - low utilized disk -> not an issue
>> - high utilized disk -> unplug is an noop
>>
>> At least personally I consider a case where merging of a readahead 
>> window with anything except its own sibling very rare - and therefore 
>> fair to unplug after and RA is submitted.
> 
> They are reasonable assumptions. However I'm not sure if this
> unconditional unplug will defeat CFQ's anticipatory logic -- if there
> are any. You know commit 65a80b4c61 is more about a *defensive*
> protection against the rare case that two readahead windows get
> merged.
> 
>>> Is your workload a simple dd on a single disk? If so, it sounds like
>>> something illogical hidden in the block layer.
>> It might still be illogical hidden as e.g. 2.6.27 unplugged after the 
>> first readahead as well :-)
>> But no my load is iozone running with different numbers of processes 
>> with one disk per process.
>> That neatly resembles e.g. nightly backup jobs which tend to take longer 
>> and longer in all time increasing customer scenarios. Such an 
>> improvement might banish the backups back to the night were they belong :-)
> 
> Exactly one process per disk? Are they doing sequential reads or more
> complicated access patterns?

Just sequential read where I see the win, but I also had sequential 
write, and random read/write as well as some mixed stuff like dbench.
It improved sequential read and did not impact the others which is fine.

Thank you for you quick replies!

> Thanks,
> Fengguang

-- 

Grüsse / regards, Christian Ehrhardt
IBM Linux Technology Center, System z Linux Performance
