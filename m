Return-Path: <linux-kernel-owner+w=401wt.eu-S1758393AbZFILHU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758393AbZFILHU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 07:07:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755012AbZFILHI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 07:07:08 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:63999 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbZFILHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 07:07:06 -0400
X-Greylist: delayed 327 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Jun 2009 07:07:06 EDT
Message-ID: <4A2E4104.5080509@vlnb.net>
Date: Tue, 09 Jun 2009 15:01:24 +0400
From: Vladislav Bolkhovitin <vst@vlnb.net>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Wu Fengguang <fengguang.wu@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "hifumi.hisashi@oss.ntt.co.jp" <hifumi.hisashi@oss.ntt.co.jp>,
       Bart Van Assche <bart.vanassche@gmail.com>,
       Beheer InterCommIT <intercommit@gmail.com>, linux-nfs@vger.kernel.org,
       scst-devel@lists.sourceforge.net
Subject: Re: mmotm 2009-06-02-16-11 uploaded (readahead)
References: <200906022331.n52NVJhG015117@imap1.linux-foundation.org> <4A25F3FF.5060404@oracle.com> <20090603134739.97d8a461.akpm@linux-foundation.org> <20090609035915.GW11363@kernel.dk> <20090608213817.999143dd.akpm@linux-foundation.org> <20090609045106.GA9370@localhost>
In-Reply-To: <20090609045106.GA9370@localhost>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V01U2FsdGVkX18DIEB2yhAs+l89OrnpH8BqPB8+ok2aZLTC1ge
 kA4atZSn99mPipeWWXUz8QKoQPx0FGBuLmM1I2Fz8CVSP9fzc+
 AoLJI7Y/W5wsYQuuWg8Mw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Wu Fengguang, on 06/09/2009 08:51 AM wrote:
> On Tue, Jun 09, 2009 at 12:38:17PM +0800, Andrew Morton wrote:
>> On Tue, 9 Jun 2009 05:59:16 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
>>
>>> ...
>>>> Doing a block-specific call from inside page_cache_async_readahead() is
>>>> a bit of a layering violation - this may not be a block-backed
>>>> filesystem at all.
>>>>
>>>> otoh, perhaps blk_run_backing_dev() is wrongly named and defined in the
>>>> wrong place.  Perhaps non-block-backed backing_devs want to implement
>>>> an unplug-style function too?  In which case the whole thing should be
>>>> renamed and moved outside blkdev.h.
>>>>
>>>> If we don't want to do that, shouldn't backing_dev_info.unplug* be
>>>> wrapped in #ifdef CONFIG_BLOCK?  And wasn't it a layering violation to
>>>> put block-specific things into the backing_dev_info?
>>>>
>>>> Jens, talk to me!
>>>>
>>>> From the readahead POV: does it make sense to call the backing-dev's
>>>> "unplug" function even if that isn't a block-based device?  Or was this
>>>> just a weird block-device-only performance problem?  Hard to say.
>>> Layering wise, I don't think it's that bad. It would have looked cleaner
>>> to do:
>>>
>>>         blk_run_address_space(mapping);
>>>
>>> instead, but we would still need to make that available outside of
>>> CONFIG_BLOCK as well.
>>>
>>> What I don't like about the patch is that it's a heuristic, a "I poked
>>> this and it made that faster" with nobody really understanding why.
>> Well.  I _think_ we understand it.  I'm not sure that we understand why
>> it made scst faster though.
> 
> Because the NFS/SCST servers are running RAID?
> 
> Also the client side NFS/SCST IO request may be slitted up and served
> by a pool of server processes, which introduces the same disorderness
> as in RAID configuration. But I wonder whether blk_* work for them,
> or NFS/SCST have the "plug" concept at all.

Yes, I agree about the disorderness. In the Beheer's case there are both 
RAID and IO reordering caused by IO submission by a pool of SCST IO 
threads. So, your comment in the patch can well explain why the 
blk_run_backing_dev() patch recovers read-ahead and, hence, improves 
performance in this case.

But I also agree that it would be good to prove that theory by some 
block/RA/SCST traces, because there might be other similar issues in the 
RA code, which could be discovered with better understanding of the 
problem. We can ask Beheer to prepare the necessary traces.

Vlad

