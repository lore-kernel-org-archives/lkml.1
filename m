Return-Path: <linux-kernel-owner+w=401wt.eu-S1753226AbYISOQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbYISOQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 10:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751235AbYISOQv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 10:16:51 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:51187 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbYISOQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 10:16:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=GFVtIgQlT40Kn7U0oONUTLr4zVhm6K3xOlP8/3DFsBYdcEFiMHjidRd93xtZ0D9zB8
         h2OVS29nR+PbXxzqR5X82hBGZFVEJwhrpKZ1zPyudoSHWLzcsX12eYQ3a8rEzBUUfR/D
         DK+/XqIZCdDasEiaqsiaTgx90lKsgpk8viNGs=
Message-ID: <48D3B3EE.70702@gmail.com>
Date: Fri, 19 Sep 2008 07:15:10 -0700
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Elias Oltmanns <eo@nebensachen.de>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4 v2] libata: Implement disk shock protection support
References: <87d4j2n3dn.fsf@denkblock.local>	<20080917163144.9870.97008.stgit@denkblock.local>	<48D147E2.3020601@gmail.com> <87skrwmpng.fsf@denkblock.local>	<48D3979F.10305@gmail.com> <87ljxokz67.fsf@denkblock.local>
In-Reply-To: <87ljxokz67.fsf@denkblock.local>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elias Oltmanns wrote:
>> This should basically work but completion isn't really designed for
>> this type of continuous events where single consumption should clear
>> all pending events.  INIT_COMPLETION comes close but it doesn't lock,
>> so can't guarantee anything.  What's necessary is the counterpart for
>> complete_all() for the wait.
> 
> You are right that it isn't designed for this use case and my approach
> is somewhat hackish. Still, it really does exactly what we want. Please
> note that ap->park_req_pending is protected by the host lock; the call
> to complete() is atomic wrt the setting of ATA_EH_PARK for one of the
> devices on the port and so is the call to INIT_COMPLETION() wrt clearing
> ATA_EH_PARK requests for *all* devices on the port.
> 
>> Well, anyways, I think the issue is slightly out of scope for this
>> patch and the only side effect is possibly looping over the do {}
>> while () block several times unnecessarily on certain cases, so I
>> think just noting about it should be enough for now.
>>
>> Can you please add explanation above wait_for_complete_timeout() that
>> all done counts should be cleared here but aren't and as a result the
>> loop might repeat determinate number of times unnecessarily and resend
>> as proper patch?
> 
> Well, we don't really care about the done count after
> wait_for_completion_timeout() has returned. All that matters is that the
> done counter is cleared when all ATA_EH_PARK actions have been pulled in
> which happens at the start of each cycle over the loop.
> 
> Perhaps I should add comments to this effect before
> wait_for_completion_timeout() as well as INIT_COMPLETION()?

Ah... I missed the pull_park_action part.  Yes, in that case, it's
correct now but I would really appreciate you explain amply what's
going on inside the pull function and why it's needed.

Thanks.

-- 
tejun
