Return-Path: <linux-kernel-owner+w=401wt.eu-S1753135AbYJ1E2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbYJ1E2T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 00:28:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbYJ1E2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 00:28:06 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:53019 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648AbYJ1E2F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 00:28:05 -0400
Message-ID: <490694D0.2060804@pobox.com>
Date: Tue, 28 Oct 2008 00:28:00 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] ata: ata_id_is_ssd() bugfix
References: <200810182222.13281.bzolnier@gmail.com> <20081019180545.GT19428@kernel.dk> <200810192052.47819.bzolnier@gmail.com> <20081019191202.GW19428@kernel.dk>
In-Reply-To: <20081019191202.GW19428@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -3.7 (---)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-3.7 points, 5.0 required)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> On Sun, Oct 19 2008, Bartlomiej Zolnierkiewicz wrote:
>> On Sunday 19 October 2008, Jens Axboe wrote:
>>> On Sat, Oct 18 2008, Bartlomiej Zolnierkiewicz wrote:
>>>> We need to explicitly check for major and minor version
>>>> of supported ATA spec as earlier revisions used word 217
>>>> for different purposes.
>>> What did they use to put in that word? Just curious if it does any harm,
>>>
>>> because as it stands, this patch will prevent ANY ssd from being
>>> correctly flagged as such. So I'm inclined to file this as too much spec
>>> fiddling, it'll do more harm than good.
>> IIRC it was marked as Reserved for < ATA8 (however I didn't go through
>> all previous specs) and some ATA8 minor versions (i.e. 3f) put "NV Cache
>> Read Transfer Speed in MB/s" there.
>>
>> Well, we may also drop minor versions checking assuming that no NV Cache
>> actually will have 1MB/s speed and major version checking assuming that
>> no vendor put anything special there but this would need an ACK from Alan
>> and maybe a comment on why we do it...
> 
> OK, so it's just NV cache. I'd consider that a non-issue.
> 
>>>> [ The issue was originally spotted by Alan Cox. ]
>>>>
>>>> This patch fixes regression introduced by:
>>>> commit 8bff7c6b0f63c7ee9c5e3a076338d74125b8debb
>>>> ("libata: set queue SSD flag for SSD devices").
>>>>
>>>> Cc: Jeff Garzik <jgarzik@pobox.com>
>>>> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
>>>> Cc: Jens Axboe <jens.axboe@oracle.com>
>>>> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
>>>> ---
>>>> somebody owe me one for going through all these spec drafts... ;)
>>>>
>>>>  include/linux/ata.h |    8 +++++++-
>>>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>>>
>>>> Index: b/include/linux/ata.h
>>>> ===================================================================
>>>> --- a/include/linux/ata.h
>>>> +++ b/include/linux/ata.h
>>>> @@ -75,6 +75,7 @@ enum {
>>>>  	ATA_ID_EIDE_PIO_IORDY	= 68,
>>>>  	ATA_ID_QUEUE_DEPTH	= 75,
>>>>  	ATA_ID_MAJOR_VER	= 80,
>>>> +	ATA_ID_MINOR_VER	= 81,
>>>>  	ATA_ID_COMMAND_SET_1	= 82,
>>>>  	ATA_ID_COMMAND_SET_2	= 83,
>>>>  	ATA_ID_CFSSE		= 84,
>>>> @@ -743,7 +744,12 @@ static inline int ata_id_is_cfa(const u1
>>>>  
>>>>  static inline int ata_id_is_ssd(const u16 *id)
>>>>  {
>>>> -	return id[ATA_ID_ROT_SPEED] == 0x01;
>>>> +	/* ATA8-ACS version 4c or higher (=> 4c or 6 at the moment) */
>>>> +	if (ata_id_major_version(id) >= 8 &&
>>>> +	    (id[ATA_ID_MINOR_VER] == 0x39 || id[ATA_ID_MINOR_VER] == 0x28) &&
>>>> +	    id[ATA_ID_ROT_SPEED] == 0x01)
>>>> +		return 1;
>>>> +	return 0;
>>> Is the check even correct? It'll match version 8 AND the currently
>>> listed minor version, not newer.
>> Checking minor versions is a non-trivial bussiness and improvements
>> are welcomed (though ATA8-ACS version 6 is the newest revision ATM).
>>
>> It could also be that the we should be checking something else than
>> the ATA_ID_ROT_SPEED to detect SSDs reliably but I don't know and don't
>> have time currently to look into it.  In the future please post ATA
> 
> Rotation speed == 1 is THE way to check for an SSD. The problem is just
> that lots of drives are out there and don't claim ATA8 compliance, since
> it was finalized until last month. Most of them SHOULD use word 217
> though, the ones I looked at sure do.

It seems highly unlikely that any drive that claims ATA8 would repurpose 
word 217, therefore upstream logic IMO should look like

	if (id[ATA_ID_ROT_SPEED] == 0x01 &&
	    ((ata_id_major_version(id) >= 8) ||
	     (a list of ATA6/7 exceptions that Jens wishes to supply)))

Regards,

	Jeff


