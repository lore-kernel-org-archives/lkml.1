Return-Path: <linux-kernel-owner+w=401wt.eu-S1753348Ab0AXIUN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab0AXIUN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 03:20:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165Ab0AXIUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 03:20:12 -0500
Received: from hera.kernel.org ([140.211.167.34]:34799 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752994Ab0AXIUL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 03:20:11 -0500
Message-ID: <4B5C03EE.3000007@kernel.org>
Date: Sun, 24 Jan 2010 17:25:18 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Jeff Layton <jlayton@redhat.com>
CC: torvalds@linux-foundation.org, mingo@elte.hu, peterz@infradead.org,
       awalls@radix.net, linux-kernel@vger.kernel.org, jeff@garzik.org,
       akpm@linux-foundation.org, jens.axboe@oracle.com, rusty@rustcorp.com.au,
       cl@linux-foundation.org, dhowells@redhat.com, arjan@linux.intel.com,
       avi@redhat.com, johannes@sipsolutions.net, andi@firstfloor.org,
       Steve French <sfrench@samba.org>
Subject: Re: [PATCH UPDATED 38/40] cifs: use workqueue instead of slow-work
References: <1263776272-382-1-git-send-email-tj@kernel.org>	<1263776272-382-39-git-send-email-tj@kernel.org>	<20100119072000.247ac894@tlielax.poochiereds.net>	<4B564B12.7020909@kernel.org>	<20100119195641.7b6a17e4@tlielax.poochiereds.net>	<4B565B26.3060709@kernel.org>	<4B59889D.7050903@kernel.org> <20100122064528.0223d708@tlielax.poochiereds.net>
In-Reply-To: <20100122064528.0223d708@tlielax.poochiereds.net>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sun, 24 Jan 2010 08:19:03 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 01/22/2010 08:45 PM, Jeff Layton wrote:
>> @@ -584,13 +583,18 @@ is_valid_oplock_break(struct smb_hdr *bu
>>  				pCifsInode->clientCanCacheAll = false;
>>  				if (pSMB->OplockLevel == 0)
>>  					pCifsInode->clientCanCacheRead = false;
>> -				rc = slow_work_enqueue(&netfile->oplock_break);
>> -				if (rc) {
>> -					cERROR(1, ("failed to enqueue oplock "
>> -						   "break: %d\n", rc));
>> -				} else {
>> -					netfile->oplock_break_cancelled = false;
>> -				}
>> +
>> +				/*
>> +				 * cifs_oplock_break_put() can't be called
>> +				 * from here.  Get reference after queueing
>> +				 * succeeded.  cifs_oplock_break() will
>> +				 * synchronize using GlobalSMSSeslock.
>> +				 */
>> +				if (queue_work(system_single_wq,
>> +					       &netfile->oplock_break))
>> +					cifs_oplock_break_get(netfile);
>> +				netfile->oplock_break_cancelled = false;
>> +
> 
> I think we want to move the setting of netfile->oplock_break_cancelled
> inside of the if above it.
> 
> If the work is already queued, I don't think we want to set the flag to
> false. Doing so might be problematic if we somehow end up processing
> this oplock break after a previous oplock break/reconnect/reopen
> sequence, but while the initial oplock break is still running.

Hmmm.... I can surely do that but that would be different from the
original code.  slow_work_enqueue() doesn't distinguish between
successful enqueue and the one which got ignored because the work was
already queued.  With conversion to queue_work(), there's no failure
case there so setting oplock_break_cancelled always is equivalent to
the original code.  Even if changing it is the right thing to do, it
should probably be done with a separate patch as it changes the logic.
Are you sure it needs to be changed?

Thanks.

-- 
tejun
