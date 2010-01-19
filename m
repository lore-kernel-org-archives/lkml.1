Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560Ab0ASApn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560Ab0ASApn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 19:45:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753679Ab0ASApm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 19:45:42 -0500
Received: from hera.kernel.org ([140.211.167.34]:34694 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300Ab0ASApk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 19:45:40 -0500
Message-ID: <4B5501A3.2010706@kernel.org>
Date: Tue, 19 Jan 2010 09:49:39 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH 31/40] libata: take advantage of cmwq and remove concurrency
 limitations
References: <1263776272-382-1-git-send-email-tj@kernel.org> <1263776272-382-32-git-send-email-tj@kernel.org> <4B5482D3.305@s5r6.in-berlin.de>
In-Reply-To: <4B5482D3.305@s5r6.in-berlin.de>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 19 Jan 2010 00:43:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 01/19/2010 12:48 AM, Stefan Richter wrote:
>> b. ata_aux_wq which is used for SCSI probing has single thread.  In
>>    cases where SCSI probing is stalled for extended period of time
>>    which is possible for ATAPI devices, this will stall all probing.
> 
> Are things like INQUIRY and possibly motor spin-up performed there?
> If yes, ...

For disks, they are all done by EH.  Responses to INQUIRYs are
constructed by libata from the data it has acquired during parallel
ATA probing, so there's nothing much going on there.  For ATAPI
devices, it's a different story tho.

>> @@ -3408,8 +3408,7 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
>>  				"                  switching to async\n");
>>  	}
>>  
>> -	queue_delayed_work(ata_aux_wq, &ap->hotplug_task,
>> -			   round_jiffies_relative(HZ));
>> +	schedule_delayed_work(&ap->hotplug_task, round_jiffies_relative(HZ));
>>  }
>>  
>>  /**
> [...]
> 
> ... wouldn't queue_delayed_work(system_long_wq, &ap->hotplug_task, ...);
> be more appropriate then?

Hmmm... yeah, right, I'll update it.  I'm thinking about adding a
debug option to trigger a warning if a work queued on the default
workqueue takes longer than, say, 30secs to finish.

Thanks.

-- 
tejun
