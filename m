Return-Path: <linux-kernel-owner+w=401wt.eu-S1755421AbZGFN1n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421AbZGFN1n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 09:27:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753561AbZGFN1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 09:27:34 -0400
Received: from smtp.nokia.com ([192.100.122.230]:51555 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245AbZGFN1d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 09:27:33 -0400
Message-ID: <4A51FB84.3020400@gmail.com>
Date: Mon, 06 Jul 2009 16:26:28 +0300
From: Artem Bityutskiy <dedekind1@gmail.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chris.mason@oracle.com, david@fromorbit.com, hch@infradead.org,
       akpm@linux-foundation.org, jack@suse.cz, yanmin_zhang@linux.intel.com,
       richard@rsk.demon.co.uk, damien.wyart@free.fr, fweisbec@gmail.com,
       Alan.Brunelle@hp.com
Subject: Re: [PATCH 02/10] writeback: switch to per-bdi threads for flushing
  data
References: <1245926523-21959-1-git-send-email-jens.axboe@oracle.com> <1245926523-21959-3-git-send-email-jens.axboe@oracle.com> <4A51F443.8070402@gmail.com> <20090706131313.GR23611@kernel.dk>
In-Reply-To: <20090706131313.GR23611@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 06 Jul 2009 13:26:31.0484 (UTC) FILETIME=[600F37C0:01C9FE3D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
>> ATM we have one timer for both data and super-block synchronization.
>> With per-bdi write-back we have:
>>
>> 1. one timer for super blocks
>> 2. many per-bdi timers for data (schedule_timeout() is essentially
>>   using timers).
> 
> That is correct. Note that these exit when they have been idle for a
> while, for embedded and such you could make it more aggressive by
> exiting quicker. The sync_supers should be directly fixable by your
> sb_dirty() stuff.
> 
> So I don't think it's a huge change from what we currently have.
> 
>> This is not nice, because each timer is an additional source of
>> power-savings killers. I mean, it is more power management (PM)
>> friendly to have less timers and disturb CPU less, make CPU wake
>> up from retention less frequently.
>>
>> I do not challange the per-bdi idea at all, but is it possible to
>> think about a more PM-friendly desing and have one source of
>> periodic write-back, not many. I mean, could there be one timer
>> which periodically syncs supers and wakes up the BDI write-back
>> tasks?
> 
> You could replace the schedule_timeout() by a schedule(), and instead
> have a single timer running that would scan the bdi_list and issue the
> kupdated() timed writeback that is the reason it uses schedule_timeout()
> now. Explicitly issued work will manually wake up the per-bdi thread(s).
> That single timer could easily handle waking up bdi_sync_supers() as
> well.

Right. May be the way you decomposed stuff will actually make it easier
to to optimize periodic write-back and teach it not to wake up if
there is no dirt.

And we could as well use rang hrtimers to optimize events grouping.
I'll keep looking at this.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)
