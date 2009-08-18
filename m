Return-Path: <linux-kernel-owner+w=401wt.eu-S1752001AbZHRW1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbZHRW1F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 18:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751392AbZHRW1E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 18:27:04 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:30047 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbZHRW1D convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 18:27:03 -0400
From: "Altobelli, David" <david.altobelli@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "gregkh@suse.de" <gregkh@suse.de>
Date: Tue, 18 Aug 2009 22:25:25 +0000
Subject: RE: [PATCH 2/3] hpilo: add interrupt handler
Thread-Topic: [PATCH 2/3] hpilo: add interrupt handler
Thread-Index: AcogSw8jBcNg9rllTuSsysVZrDN9MgAAP7Vw
Message-ID: <92D64232F2316045B18937D5C9996B1522CAE2F71E@GVW1144EXB.americas.hpqcorp.net>
References: <20090810195735.GA29372@ldl.fc.hp.com>
	<20090810200005.GB29404@ldl.fc.hp.com>
 <20090818143003.4924d26a.akpm@linux-foundation.org>
In-Reply-To: <20090818143003.4924d26a.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andrew Morton
> It would be very helpful if there were comments in hpilo.h which fully
> describe the roles of each lock.

Okay, thanks.  I'll put something together.

>>
>> ...
>>
>> @@ -496,27 +491,28 @@ static int ilo_close(struct inode *ip, s
>>  	int slot;
>>  	struct ccb_data *data;
>>  	struct ilo_hwinfo *hw;
>> +	unsigned long flags;
>>  
>>  	slot = iminor(ip) % MAX_CCB;
>>  	hw = container_of(ip->i_cdev, struct ilo_hwinfo, cdev);
>>  
>> -	spin_lock(&hw->alloc_lock);
>> -
>> -	if (is_device_reset(hw))
>> -		ilo_locked_reset(hw);
>> +	spin_lock(&hw->open_lock);
>>  
>>  	if (hw->ccb_alloc[slot]->ccb_cnt == 1) {
>>  
>>  		data = fp->private_data;
>>  
>> +		spin_lock_irqsave(&hw->alloc_lock, flags);
>> +		hw->ccb_alloc[slot] = NULL;
>> +		spin_unlock_irqrestore(&hw->alloc_lock, flags);
>> +
>>  		ilo_ccb_close(hw->ilo_dev, data);
>>  
>>  		kfree(data);
>> -		hw->ccb_alloc[slot] = NULL;
>>  	} else
>>  		hw->ccb_alloc[slot]->ccb_cnt--;
>>  
>> -	spin_unlock(&hw->alloc_lock);
>> +	spin_unlock(&hw->open_lock);
>>  
>>  	return 0;
>>  }

> Here I'd have expected that alloc_lock would provide the protection for
> ->ccb_cnt.  But the code doesn't do that - it instead appears to use
> ->open_lock.

Yes.  My intention is to use open_lock to serialize access by open and close,
and alloc_lock to serialize pointers being added to or deleted from hw->ccb_alloc[]
(list add/remove in ilo_open/close, and run list in ilo_isr).

I wanted a lock for open/close in order to keep the reference counts and 
manage ccb allocation.  I wanted to separate this from actually 
adding/removing a list element, because the list was searched by the interrupt 
handler, and I didn't want open/close to spend a long time with irqs disabled.

Perhaps my naming/logic needs improvement, I'm open to suggestions.

> The code doesn't tell us what open_lock's role is intended to be so
> this reviewer can't really tell whether or not this was a mistake.

> From this function I infer that the designed lock nesting is
>
>	open_lock
>	->alloc_lock
>	  ->fifo_lock
>
> yes?  It would be useful to document that also.

Yes, that is the design, although taking fifo_lock doesn't require 
holding alloc_lock.

> Have these changes been runtime tested with lockdep enabled?

CONFIG_LOCKDEP=y (along with the list in SubmitChecklist #12).
