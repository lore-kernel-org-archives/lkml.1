Return-Path: <linux-kernel-owner+w=401wt.eu-S1755775AbYIJVFo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775AbYIJVFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 17:05:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755475AbYIJVF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 17:05:29 -0400
Received: from nebensachen.de ([195.34.83.29]:44866 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755444AbYIJVF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 17:05:28 -0400
X-Hashcash: 1:20:080910:htejun@gmail.com::p4MOEY0Albxckjye:00e5H
X-Hashcash: 1:20:080910:alan@lxorguk.ukuu.org.uk::zP1lygJdJ2c957FQ:00000000000000000000000000000000000005cho
X-Hashcash: 1:20:080910:akpm@linux-foundation.org::9LqR84jQ8AXKirYa:0000000000000000000000000000000000001wdZ
X-Hashcash: 1:20:080910:bzolnier@gmail.com::NptOshqE6rZjqZbK:0000000000000000000000000000000000000000000Vq2l
X-Hashcash: 1:20:080910:jeff@garzik.org::IqS64OgXEp1QHnUC:0018e7
X-Hashcash: 1:20:080910:randy.dunlap@oracle.com::AmME62SnX3y6rE6Y:000000000000000000000000000000000000003H8x
X-Hashcash: 1:20:080910:linux-ide@vger.kernel.org::r+JCeFIzVcO/r3zv:0000000000000000000000000000000000003VaA
X-Hashcash: 1:20:080910:linux-kernel@vger.kernel.org::FXQvrNzRiR5f8tNJ:0000000000000000000000000000000002Y32
From: Elias Oltmanns <eo@nebensachen.de>
To: Tejun Heo <htejun@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Jeff Garzik <jeff@garzik.org>, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] libata: Implement disk shock protection support
References: <87wshzplvk.fsf@denkblock.local>
	<20080829211345.4355.89284.stgit@denkblock.local>
	<48B913E6.1000104@gmail.com> <87k5dym5t9.fsf@denkblock.local>
	<48BA638B.2030001@gmail.com> <87ej45mlp3.fsf@denkblock.local>
	<48BA969C.4060207@gmail.com> <87abetmaap.fsf@denkblock.local>
	<48BBA8D1.8020604@gmail.com> <87myirly1p.fsf@denkblock.local>
	<48BC1BB8.2030007@gmail.com> <87fxoh0yil.fsf@denkblock.local>
	<48BFA528.2040305@gmail.com> <87ej3zrf3o.fsf@denkblock.local>
	<48C0F2F8.1040308@gmail.com> <87ej3snm3s.fsf@denkblock.local>
	<48C7DC55.30002@gmail.com> <8763p3ol55.fsf@denkblock.local>
	<48C82CB1.2070308@gmail.com>
Date: Wed, 10 Sep 2008 23:04:23 +0200
In-Reply-To: <48C82CB1.2070308@gmail.com> (Tejun Heo's message of "Wed, 10 Sep
	2008 22:23:13 +0200")
Message-ID: <871vzrogpz.fsf@denkblock.local>
User-Agent: Gnus/5.110007 (No Gnus v0.7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <htejun@gmail.com> wrote:
> Elias Oltmanns wrote:
>>> The correct way to do this is ata_eh_about_to_do().  After that, you
>
>>> can just look at ehc->i.dev_action[].  Also, you'll need to call
>>> ata_eh_done() later.
>> 
>> We have a problem here, I'm afraid, because we may keep looping in EH
>> context and still want to pick up ATA_EH_PARK requests. Imagine that
>> ATA_EH_PARK has been scheduled for device A and the EH thread has
>> reached the call to schedule_timeout_uninterruptible(). Now, ATA_EH_PARK
>> is scheduled for device B on the same port. This will wake up the EH
>> thread, but ATA_EH_PARK is only recorded in link->eh_info, not in
>> link->eh_context.i. ata_eh_about_to_do() will unconditionally clear the
>> flag in eh_info, but checking ehc->i.dev_action afterwards will only
>> tell us whether this flag was set when we entered EH, not whether it had
>> been set since.
>> 
>> Should I change ata_eh_about_to_do() so that it will record the action
>> in link->eh_context before clearing it in link->eh_info?
>
> That's what ata_eh_about_to_do() currently does, exactly.  Actually,
> that's the whole reason it's there as the described problem exists for
> all other actions too.  :-)

Sounds reasonable enough. Much as I regret it, though, I really can't
find that this is what actually happens. Where exactly is the action
propagated from ehi to ehc->i? (Checked next-20080903, v2.6.27-rc5 and
v2.6.26).

On another matter: I don't particularly like the idea that there should
appear an "EH complete" in the logs every time a head unload request has
been processed. Is it safe to set ATA_EHI_QUIET when scheduling unload
requests or is the risk that something important may be missed too high?

>
>>> And it's probably better to have ehc->unloaded_mask instead of
>>> ehc->did_unload_mask and clear it here so that if unload is scheduled
>>> after this point but before EH completes, it does unloading again.
>>> ie. Something like the following.
>>>
>>> 	ata_eh_done(ATA_EH_UNLOAD);
>>> 	ehc->i.unloaded_mask &= ~(1 << dev->devno);
>> 
>> No need for that because link->eh_context is cleared in
>> ata_scsi_error().
>
> No, for example, later steps of EH could fail in which case eh_recover
> will be retried without going out to ata_scsi_error().

Alright then.

Regards,

Elias
