Return-Path: <linux-kernel-owner+w=401wt.eu-S1753883AbYISOH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883AbYISOH3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 10:07:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbYISOG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 10:06:59 -0400
Received: from nebensachen.de ([195.34.83.29]:33817 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751228AbYISOG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 10:06:57 -0400
X-Hashcash: 1:20:080919:htejun@gmail.com::C32T+uxVQmw+667X:008MO
X-Hashcash: 1:20:080919:bzolnier@gmail.com::Qge2SHQ2CQtlBTBS:00000000000000000000000000000000000000000000JE1
X-Hashcash: 1:20:080919:jeff@garzik.org::UU0Ayn2dsk79xQqG:001QuC
X-Hashcash: 1:20:080919:randy.dunlap@oracle.com::JNmu01jTQyKljo5e:000000000000000000000000000000000000003mpO
X-Hashcash: 1:20:080919:linux-ide@vger.kernel.org::rQrKiThe6PCjUCGf:0000000000000000000000000000000000000vUH
X-Hashcash: 1:20:080919:linux-kernel@vger.kernel.org::eRgPQO7uax50jIM3:000000000000000000000000000000000363B
From: Elias Oltmanns <eo@nebensachen.de>
To: Tejun Heo <htejun@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4 v2] libata: Implement disk shock protection support
References: <87d4j2n3dn.fsf@denkblock.local>
	<20080917163144.9870.97008.stgit@denkblock.local>
	<48D147E2.3020601@gmail.com> <87skrwmpng.fsf@denkblock.local>
	<48D3979F.10305@gmail.com>
Date: Fri, 19 Sep 2008 16:06:40 +0200
Message-ID: <87ljxokz67.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <htejun@gmail.com> wrote:
> Hello, Elias.
>
> Elias Oltmanns wrote:
[...]
>> so I'm just resending the whole patch. Please let me know what
>> you think.
>> 
>> @@ -2830,6 +2878,51 @@ int ata_eh_recover(struct ata_port *ap, ata_prereset_fn_t prereset,
>>  		}
>>  	}
>>  
>> +	do {
>> +		unsigned long now;
>> +
>> +		ata_eh_pull_park_action(ap);
>> +		deadline = jiffies;
>> +		ata_port_for_each_link(link, ap) {
>> +			ata_link_for_each_dev(dev, link) {
>> +				struct ata_eh_context *ehc = &link->eh_context;
>> +				unsigned long tmp;
>> +
>> +				if (dev->class != ATA_DEV_ATA)
>> +					continue;
>> +				if (!(ehc->i.dev_action[dev->devno] &
>> +				      ATA_EH_PARK))
>> +					continue;
>> +				tmp = dev->unpark_deadline;
>> +				if (time_before(deadline, tmp))
>> +					deadline = tmp;
>> +				else if (time_before_eq(tmp, jiffies))
>> +					continue;
>> +				if (ehc->unloaded_mask & (1 << dev->devno))
>> +					continue;
>> +
>> +				ata_eh_park_issue_cmd(dev, 1);
>> +			}
>> +		}
>> +
>> +		now = jiffies;
>> +		if (time_before_eq(deadline, now))
>> +			break;
>> +
>> +		deadline = wait_for_completion_timeout(&ap->park_req_pending,
>> +						       deadline - now);
>> +	} while (deadline);
>
> This should basically work but completion isn't really designed for
> this type of continuous events where single consumption should clear
> all pending events.  INIT_COMPLETION comes close but it doesn't lock,
> so can't guarantee anything.  What's necessary is the counterpart for
> complete_all() for the wait.

You are right that it isn't designed for this use case and my approach
is somewhat hackish. Still, it really does exactly what we want. Please
note that ap->park_req_pending is protected by the host lock; the call
to complete() is atomic wrt the setting of ATA_EH_PARK for one of the
devices on the port and so is the call to INIT_COMPLETION() wrt clearing
ATA_EH_PARK requests for *all* devices on the port.

>
> Well, anyways, I think the issue is slightly out of scope for this
> patch and the only side effect is possibly looping over the do {}
> while () block several times unnecessarily on certain cases, so I
> think just noting about it should be enough for now.
>
> Can you please add explanation above wait_for_complete_timeout() that
> all done counts should be cleared here but aren't and as a result the
> loop might repeat determinate number of times unnecessarily and resend
> as proper patch?

Well, we don't really care about the done count after
wait_for_completion_timeout() has returned. All that matters is that the
done counter is cleared when all ATA_EH_PARK actions have been pulled in
which happens at the start of each cycle over the loop.

Perhaps I should add comments to this effect before
wait_for_completion_timeout() as well as INIT_COMPLETION()?

Regards,

Elias
