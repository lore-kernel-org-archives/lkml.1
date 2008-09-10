Return-Path: <linux-kernel-owner+w=401wt.eu-S1755217AbYIJUYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217AbYIJUYy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 16:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbYIJUYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 16:24:45 -0400
Received: from ti-out-0910.google.com ([209.85.142.184]:22137 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbYIJUYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 16:24:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ApnlzJAUu/rbZ0bmV41qjBrF/MdlBycE7wntRWn7QLbRQ1dgNrvykDdXh7swd0nhUI
         hbrVSDZXXijurRTalc8l2GKBhUQAGRC354v4o4IV8G2s7aFxDSU9ogS0q26NTpON76q+
         XygP2LyE7ena4ppkRoR8zaqeRn28343N9doHM=
Message-ID: <48C82CB1.2070308@gmail.com>
Date: Wed, 10 Sep 2008 22:23:13 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Elias Oltmanns <eo@nebensachen.de>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] libata: Implement disk shock protection support
References: <87wshzplvk.fsf@denkblock.local>	<20080829211345.4355.89284.stgit@denkblock.local>	<48B913E6.1000104@gmail.com> <87k5dym5t9.fsf@denkblock.local>	<48BA638B.2030001@gmail.com> <87ej45mlp3.fsf@denkblock.local>	<48BA969C.4060207@gmail.com> <87abetmaap.fsf@denkblock.local>	<48BBA8D1.8020604@gmail.com> <87myirly1p.fsf@denkblock.local>	<48BC1BB8.2030007@gmail.com> <87fxoh0yil.fsf@denkblock.local>	<48BFA528.2040305@gmail.com> <87ej3zrf3o.fsf@denkblock.local>	<48C0F2F8.1040308@gmail.com> <87ej3snm3s.fsf@denkblock.local>	<48C7DC55.30002@gmail.com> <8763p3ol55.fsf@denkblock.local>
In-Reply-To: <8763p3ol55.fsf@denkblock.local>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Elias Oltmanns wrote:
>> The correct way to do this is ata_eh_about_to_do().  After that, you
>> can just look at ehc->i.dev_action[].  Also, you'll need to call
>> ata_eh_done() later.
> 
> We have a problem here, I'm afraid, because we may keep looping in EH
> context and still want to pick up ATA_EH_PARK requests. Imagine that
> ATA_EH_PARK has been scheduled for device A and the EH thread has
> reached the call to schedule_timeout_uninterruptible(). Now, ATA_EH_PARK
> is scheduled for device B on the same port. This will wake up the EH
> thread, but ATA_EH_PARK is only recorded in link->eh_info, not in
> link->eh_context.i. ata_eh_about_to_do() will unconditionally clear the
> flag in eh_info, but checking ehc->i.dev_action afterwards will only
> tell us whether this flag was set when we entered EH, not whether it had
> been set since.
> 
> Should I change ata_eh_about_to_do() so that it will record the action
> in link->eh_context before clearing it in link->eh_info?

That's what ata_eh_about_to_do() currently does, exactly.  Actually,
that's the whole reason it's there as the described problem exists for
all other actions too.  :-)

>> And it's probably better to have ehc->unloaded_mask instead of
>> ehc->did_unload_mask and clear it here so that if unload is scheduled
>> after this point but before EH completes, it does unloading again.
>> ie. Something like the following.
>>
>> 	ata_eh_done(ATA_EH_UNLOAD);
>> 	ehc->i.unloaded_mask &= ~(1 << dev->devno);
> 
> No need for that because link->eh_context is cleared in
> ata_scsi_error().

No, for example, later steps of EH could fail in which case eh_recover
will be retried without going out to ata_scsi_error().

>> Can't we just drop ATA_DFLAG_NO_UNLOAD?  It doesn't provide any real
>> functionality anymore.
> 
> I was afraid you'd say something like that in the end ;-). Well, we
> can't. We really should only issue the unload command if we know that
> it's safe, i.e., the device supports that feature. We assume it to be
> safe if ata_id_has_unload() returns true or if the user told us that the
> device does support the command. ATA_DFLAG_NO_UNLOAD is initialised
> during device setup by ata_id_has_unload(). For pre-ATA-7 devices (like
> mine), the user can manually clear that flag afterwards.

Oh I see, so it's initialized during dev_configure (I missed that) and
the user needs to be able to override it.  Alright, no objection then.

Thanks.

-- 
tejun
