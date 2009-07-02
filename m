Return-Path: <linux-kernel-owner+w=401wt.eu-S1753193AbZGBIpO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbZGBIpO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 04:45:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752887AbZGBIox
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 04:44:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51423 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752551AbZGBIov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 04:44:51 -0400
Message-ID: <4A4C7385.4030609@suse.de>
Date: Thu, 02 Jul 2009 10:44:53 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
Cc: scameron@beardog.cca.cpqcorp.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cciss: Ignore stale commands after reboot
References: <20090702082313.F3754D340B@pentland.suse.de> <20090702082804.GP23611@kernel.dk>
In-Reply-To: <20090702082804.GP23611@kernel.dk>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Thu, Jul 02 2009, Hannes Reinecke wrote:
>> When doing an unexpected shutdown like kexec the cciss
>> firmware might still have some commands in flight, which
>> it is trying to complete.
>> The driver is doing it's best on resetting the HBA,
>> but sadly there's a firmware issue causing the firmware
>> _not_ to abort or drop old commands.
>> So the firmware will send us commands which we haven't
>> accounted for, causing the driver to panic.
>>
>> With this patch we're just ignoring these commands as
>> there is nothing we could be doing with them anyway.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/block/cciss.c     |   14 ++++++++++++--
>>  drivers/block/cciss_cmd.h |    1 +
>>  2 files changed, 13 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
>> index c7a527c..8dd4c0d 100644
>> --- a/drivers/block/cciss.c
>> +++ b/drivers/block/cciss.c
>> @@ -226,7 +226,16 @@ static inline void addQ(struct hlist_head *list, CommandList_struct *c)
>>  
>>  static inline void removeQ(CommandList_struct *c)
>>  {
>> -	if (WARN_ON(hlist_unhashed(&c->list)))
>> +	/*
>> +	 * After kexec/dump some commands might still
>> +	 * be in flight, which the firmware will try
>> +	 * to complete. Resetting the firmware doesn't work
>> +	 * with old fw revisions, so we have to mark
>> +	 * them off as 'stale' to prevent the driver from
>> +	 * falling over.
>> +	 */
>> +	if (unlikely(hlist_unhashed(&c->list))) {
>> +		c->cmd_type = CMD_MSG_STALE;
>>  		return;
>>
>>       hlist_del_init(&c->list);
> 
> Ehm, that looks rather dangerous. What's the level of testing this patch
> received?
> 
Where is the danger here?

With the original code we would be issuing a warning
and return.
But then we hit this codepath:

 	while (!hlist_empty(&h->cmpQ)) {
 		c = hlist_entry(h->cmpQ.first, CommandList_struct, list);
 		removeQ(c);
		c->err_info->CommandStatus = CMD_HARDWARE_ERR;

and the driver goes boom as c->err_info is not initialized.

This frequently happens if you're trying to do a kdump
while the system is doing I/O.
If you object to the removed WARN() I can easily put this
in, but without the fix there is a good chance that
kdump fails on cciss machines.

And note we can't do anything with the stale commands anyway,
as the context having sent the commands originally is long gone.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Markus Rex, HRB 16746 (AG Nürnberg)
