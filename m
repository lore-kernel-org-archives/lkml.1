Return-Path: <linux-kernel-owner+w=401wt.eu-S1753435AbZLIJva@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435AbZLIJva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 04:51:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753239AbZLIJv3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 04:51:29 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:46806 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753229AbZLIJv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 04:51:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=QErtEg4UyrT1S9LnHgHKPcT+RhoIadpPgsdDiGbyYsoa5J5JrD5MGTFRjFgjvui1IQ
         u+wV2BiGUz5l3lWTD5PqPYQ6cZgu6OQRaIWo3a/+REmsZQKkoy1AfJgcEtAqxcJke5Po
         Py6goh/G60ccKooa9Oach9hv7U/1gd5usMSVQ=
Message-ID: <4B1F7324.9000402@gmail.com>
Date: Wed, 09 Dec 2009 10:51:32 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.5) Gecko/20091122 SUSE/3.0.0-9.1 Thunderbird/3.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, scameron@beardog.cce.hp.com,
       James.Bottomley@HansenPartnership.com, achiang@hp.com,
       jens.axboe@oracle.com, mikem@beardog.cce.hp.com
Subject: Re: + hpsa-use-msleep-instead-of-schedule_timeout.patch added to
 -mm tree
References: <200912082204.nB8M48oL027313@imap1.linux-foundation.org>	<4B1ED241.4090803@gmail.com> <20091208144419.af6298ba.akpm@linux-foundation.org>
In-Reply-To: <20091208144419.af6298ba.akpm@linux-foundation.org>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2009 11:44 PM, Andrew Morton wrote:
> On Tue, 08 Dec 2009 23:25:05 +0100
> Jiri Slaby <jirislaby@gmail.com> wrote:
> 
>> On 12/08/2009 11:04 PM, akpm@linux-foundation.org wrote:
>>> Subject: hpsa: use msleep() instead of schedule_timeout
>>> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
>>>
>>> Use msleep() instead of schedule_timeout
>>
>> The patch does more than that and moreover in a wrong manner, see below.
>>
>>> @@ -3262,8 +3262,8 @@ static int hpsa_pci_init(struct ctlr_inf
>>>  		if (!(readl(h->vaddr + SA5_DOORBELL) & CFGTBL_ChangeReq))
>>>  			break;
>>>  		/* delay and try again */
>>> -		set_current_state(TASK_INTERRUPTIBLE);
>>> -		schedule_timeout(10);
>>> +		set_current_state(TASK_UNINTERRUPTIBLE);
>>> +		msleep(10);
>>
>> Why do you change interruptible sleep to uninterruptible?
> 
> Stealth bugfix ;)
> 
> If the calling process (called "modprobe") has signal_pending()
> (someone ^C'ed it) then the TASK_INTERRUPTIBLE sleep will be a no-op
> and the driver will probably go and screw things up.

Ok, then it should have been in the changelog. The changelog was just
"Use msleep() instead of schedule_timeout". Apart it doesn't mention why
it is changed (it might be obvious for some that it's a cleanup), it
doesn't do merely that.

>>> diff -puN drivers/scsi/hpsa.h~hpsa-use-msleep-instead-of-schedule_timeout drivers/scsi/hpsa.h
>>> --- a/drivers/scsi/hpsa.h~hpsa-use-msleep-instead-of-schedule_timeout
>>> +++ a/drivers/scsi/hpsa.h
>> ...
>>> @@ -139,7 +139,7 @@ struct ctlr_info {
>>>  #define HPSA_BOARD_READY_ITERATIONS \
>>>  	((HPSA_BOARD_READY_WAIT_SECS * 1000) / \
>>>  		HPSA_BOARD_READY_POLL_INTERVAL_MSECS)
>>> -#define HPSA_POST_RESET_PAUSE (30 * HZ)
>>> +#define HPSA_POST_RESET_PAUSE_MSECS (3000)
>>
>> Ehm?
> 
> 30 seconds would have sucked anyway ;)

Might be. But again, then it should be explained in the changelog. And
as this is totally separate thing, also in a separate patch.

At least I though this is the politics.

thanks,
-- 
js
