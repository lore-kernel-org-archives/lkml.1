Return-Path: <linux-kernel-owner+w=401wt.eu-S932771AbXCUHcm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771AbXCUHcm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 03:32:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932910AbXCUHcm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 03:32:42 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:54946 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932771AbXCUHck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 03:32:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=JdoE3wo0J+2stl9rS4ETFDdhRLGxbDw3GL8CoHKBdcWJh9DTEZVRT4WyqZrbd5XwN8SJolLxnLwm9+PWBATkYiXQkXqoVGswI3klxf1RGhK2FK2KTPKFypZ6xWkK5hAlEEQVG0H/MSYbUrE5+sW+UCSSUUlYvSVdnKUmDGURMVw=
Message-ID: <4600DF90.3030902@gmail.com>
Date: Wed, 21 Mar 2007 16:32:32 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>, Jens Axboe <jens.axboe@oracle.com>,
       "Eric D. Mudama" <edmudama@gmail.com>, Mathieu.Berard@crans.org
Subject: Re: [PATCH] libata: add NCQ blacklist entries from Silicon Image
 Windows driver
References: <45DD2EC9.4050403@shaw.ca> <45DF67C4.8090802@garzik.org>
In-Reply-To: <45DF67C4.8090802@garzik.org>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> Robert Hancock wrote:
>> This patch adds in some NCQ blacklist entries taken from the Silicon
>> Image Windows drivers' .inf files for the 3124 and 3132 controllers.
>> These entries were marked as ""DisableSataQueueing". Assume these are
>> in their blacklist for a reason and disable NCQ on these drives.
>>
>> Signed-off-by: Robert Hancock <hancockr@shaw.ca>
>>
>> --- linux-2.6.21-rc1edit/drivers/ata/libata-core.c.prev    2007-02-21
>> 22:23:05.000000000 -0600
>> +++ linux-2.6.21-rc1edit/drivers/ata/libata-core.c    2007-02-21
>> 22:25:44.000000000 -0600
>> @@ -3269,6 +3269,13 @@ static const struct ata_blacklist_entry
>>     /* Devices with NCQ limits */
>>
>> +    /* The following blacklist entries are taken from the Windows
>> +       driver .inf files for the Silicon Image 3124 and 3132. */
>> +    { "Maxtor 7B250S0",    "BANC1B70",    ATA_HORKAGE_NONCQ, },
>> +    { "HTS541060G9SA00",    "MB3OC60D",    ATA_HORKAGE_NONCQ, },
>> +    { "HTS541080G9SA00",    "MB4OC60D",    ATA_HORKAGE_NONCQ, },
>> +    { "HTS541010G9SA00",    "MBZOC60D",    ATA_HORKAGE_NONCQ, },

There was a recent regression report on ahci + HTS541010G9SA00 from
Mathieu Berard (cc'd).  NCQ + device initiated link power saving (which,
BTW, got activated by executing _GTF.  surprise!) combination seems
broken.  I know that ahci controllers (at least ich6m, ich7 and ich8)
work with device initiated PS, so it's most likely the disk that's
malfunctioning.

This and the fact sata_sil24 windows driver blacklists them make me
think those HTS5410s should be added to our blacklist too.  What do you
think?

Mathieu, just to be sure, can you post the result of 'hdparm -I
/dev/sdX' and 'lspci -nn'?

Thanks.

-- 
tejun
