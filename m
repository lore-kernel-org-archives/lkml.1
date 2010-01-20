Return-Path: <linux-kernel-owner+w=401wt.eu-S1756125Ab0ATAKT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125Ab0ATAKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 19:10:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755442Ab0ATAKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 19:10:19 -0500
Received: from hera.kernel.org ([140.211.167.34]:52663 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447Ab0ATAKS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 19:10:18 -0500
Message-ID: <4B564B12.7020909@kernel.org>
Date: Wed, 20 Jan 2010 09:15:14 +0900
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
Subject: Re: [PATCH 38/40] cifs: use workqueue instead of slow-work
References: <1263776272-382-1-git-send-email-tj@kernel.org>	<1263776272-382-39-git-send-email-tj@kernel.org> <20100119072000.247ac894@tlielax.poochiereds.net>
In-Reply-To: <20100119072000.247ac894@tlielax.poochiereds.net>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 20 Jan 2010 00:09:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 01/19/2010 09:20 PM, Jeff Layton wrote:
>> @@ -584,13 +583,13 @@ is_valid_oplock_break(struct smb_hdr *buf, struct TCP_Server_Info *srv)
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
>> +				cifs_oplock_break_get(netfile);
>> +				if (!queue_work(system_single_wq,
>> +						&netfile->oplock_break))
>> +					cifs_oplock_break_put(netfile);
>> +				netfile->oplock_break_cancelled = false;
>> +
>>  				read_unlock(&GlobalSMBSeslock);
>>  				read_unlock(&cifs_tcp_ses_lock);
>>  				return true;
> 
> This block of code looks problematic. This code is run by the
> cifs_demultiplex_thread (cifsd). We can't do an oplock_break_put in
> this context, since it might trigger a blocking SMB and cause a
> deadlock.

Okay, thanks for pointing it out.

> A while back, I backported this code to earlier kernels and used a
> standard workqueue there. What I did there was to only do the "get" if
> the queue_work succeeded, and then had the queued work take and
> immediately drop the GlobalSMBSeslock first thing. Yes, it's ugly, but
> it prevented the possible deadlock and didn't require adding anything
> like completion vars to the struct.

Hmmm... Why is locking GlobalSMBSeslock necessary?
cifs_oplock_break_get() can never fail and it seems that
is_valid_oplock_break() should be holding valid reference by the time
it enqueues the work, so wouldn't the following be sufficient?

	if (queue_work(system_single_wq, &netfile->oplock_break))
		cifs_oplock_break_get(netfile);

> Also, this change seems to have changed the logic a bit. The
> oplock_break_cancelled flag is being set to false unconditionally, and
> the printk was dropped. Not a big deal on the last part, but we can't
> really do much with errors in this codepath so it might be helpful to
> have some indication that there are problems here.

The thing is that slow_work_enqueue() can only fail if getting a
reference fails.  In cifs' case, it always succeeds so there's no
failure case to handle there.

> Other than the above problems (which are easily fixable), this patch
> seems fine.

Thanks.

-- 
tejun
