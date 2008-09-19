Return-Path: <linux-kernel-owner+w=401wt.eu-S1755824AbYISPCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824AbYISPCd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 11:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755146AbYISPB2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 11:01:28 -0400
Received: from nebensachen.de ([195.34.83.29]:56559 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752897AbYISPB0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 11:01:26 -0400
X-Hashcash: 1:20:080919:htejun@gmail.com::YpBcxFv/s+bRBmyf:05HK0
X-Hashcash: 1:20:080919:bzolnier@gmail.com::GPVQPrWU4ZJMA3pJ:00000000000000000000000000000000000000000003bx+
X-Hashcash: 1:20:080919:jeff@garzik.org::Xsn8QNFXjQHgMtjs:001rtS
X-Hashcash: 1:20:080919:randy.dunlap@oracle.com::xk5tbX8UOOMk6xT0:000000000000000000000000000000000000001wCn
X-Hashcash: 1:20:080919:linux-ide@vger.kernel.org::PPeZSsDHUq8Y648H:000000000000000000000000000000000000A3A3
X-Hashcash: 1:20:080919:linux-kernel@vger.kernel.org::OIEQnNqfs0VhS0Pz:0000000000000000000000000000000006oNi
From: Elias Oltmanns <eo@nebensachen.de>
To: Tejun Heo <htejun@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4 v2] libata: Implement disk shock protection support
References: <87d4j2n3dn.fsf@denkblock.local>
	<20080917163144.9870.97008.stgit@denkblock.local>
	<48D147E2.3020601@gmail.com> <87skrwmpng.fsf@denkblock.local>
	<48D3979F.10305@gmail.com> <87ljxokz67.fsf@denkblock.local>
	<48D3B3EE.70702@gmail.com>
Date: Fri, 19 Sep 2008 17:00:16 +0200
In-Reply-To: <48D3B3EE.70702@gmail.com> (Tejun Heo's message of "Fri, 19 Sep
	2008 07:15:10 -0700")
Message-ID: <87fxnwkwov.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <htejun@gmail.com> wrote:
> Elias Oltmanns wrote:
>>> This should basically work but completion isn't really designed for
>
>>> this type of continuous events where single consumption should clear
>>> all pending events.  INIT_COMPLETION comes close but it doesn't lock,
>>> so can't guarantee anything.  What's necessary is the counterpart for
>>> complete_all() for the wait.
>> 
>> You are right that it isn't designed for this use case and my approach
>> is somewhat hackish. Still, it really does exactly what we want. Please
>> note that ap->park_req_pending is protected by the host lock; the call
>> to complete() is atomic wrt the setting of ATA_EH_PARK for one of the
>> devices on the port and so is the call to INIT_COMPLETION() wrt clearing
>> ATA_EH_PARK requests for *all* devices on the port.
>> 
>>> Well, anyways, I think the issue is slightly out of scope for this
>>> patch and the only side effect is possibly looping over the do {}
>>> while () block several times unnecessarily on certain cases, so I
>>> think just noting about it should be enough for now.
>>>
>>> Can you please add explanation above wait_for_complete_timeout() that
>>> all done counts should be cleared here but aren't and as a result the
>>> loop might repeat determinate number of times unnecessarily and resend
>>> as proper patch?
>> 
>> Well, we don't really care about the done count after
>> wait_for_completion_timeout() has returned. All that matters is that the
>> done counter is cleared when all ATA_EH_PARK actions have been pulled in
>> which happens at the start of each cycle over the loop.
>> 
>> Perhaps I should add comments to this effect before
>> wait_for_completion_timeout() as well as INIT_COMPLETION()?
>
> Ah... I missed the pull_park_action part.  Yes, in that case, it's
> correct now but I would really appreciate you explain amply what's
> going on inside the pull function and why it's needed.

Will do. By the way, it's just occurred to me that we really need to
call complete_all() in ata_scsi_park_store(). So, thanks for making me
think it all through once more.

Regards,

Elias
