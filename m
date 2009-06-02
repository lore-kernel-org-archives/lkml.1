Return-Path: <linux-kernel-owner+w=401wt.eu-S1754364AbZFBNIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364AbZFBNIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 09:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752491AbZFBNI1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 09:08:27 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:43724 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753145AbZFBNI0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 09:08:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lbX67lQa2y9kwlhnIyIxreVQWZJ+tWjqgEM5pRI8Iidl1c3Y+RVEwoNpzk3zbK2+vP
         eON/bdX1sRIMftop61iq4GwxftxjOEPE6NhUDFsWYROM1i2BMD7SFQdWg3ZRT+R18PSZ
         honWLrBFEd4gSFzJkouHqd04lcL7XsFa8bwVA=
MIME-Version: 1.0
In-Reply-To: <200906021218.33787.bzolnier@gmail.com>
References: <1243926308-32385-1-git-send-email-petkovbb@gmail.com>
	 <1243926308-32385-2-git-send-email-petkovbb@gmail.com>
	 <200906021218.33787.bzolnier@gmail.com>
Date: Tue, 2 Jun 2009 15:08:27 +0200
Message-ID: <9ea470500906020608o14f8bc8dwaedabff70c1cb707@mail.gmail.com>
Subject: Re: [PATCH 1/2] ide-tape: change IDE_AFLAG_IGNORE_DSC non-atomically
From: Borislav Petkov <petkovbb@googlemail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jun 2, 2009 at 12:18 PM, Bartlomiej Zolnierkiewicz
<bzolnier@gmail.com> wrote:

..

>> --- a/drivers/ide/ide-tape.c
>> +++ b/drivers/ide/ide-tape.c
>> @@ -656,15 +656,24 @@ static ide_startstop_t idetape_do_request(ide_drive_t *drive,
>>
>>       if ((drive->dev_flags & IDE_DFLAG_DSC_OVERLAP) == 0 &&
>>           (rq->cmd[13] & REQ_IDETAPE_PC2) == 0)
>> -             set_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags);
>> +             drive->atapi_flags |= IDE_AFLAG_IGNORE_DSC;
>>
>>       if (drive->dev_flags & IDE_DFLAG_POST_RESET) {
>> -             set_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags);
>> +             drive->atapi_flags |= IDE_AFLAG_IGNORE_DSC;
>>               drive->dev_flags &= ~IDE_DFLAG_POST_RESET;
>>       }
>>
>> -     if (!test_and_clear_bit(IDE_AFLAG_IGNORE_DSC, &drive->atapi_flags) &&
>> -         (stat & ATA_DSC) == 0) {
>> +     /*
>> +      * This is a precaution for IDE_AFLAG_IGNORE_DSC being conditionally set
>> +      * above. We don't need a stronger enforcement of ordering because the
>> +      * read below cannot precede the earlier write out-of-order since it is
>> +      * to the same location. Also, since we have the ide port locked during
>> +      * the ->do_request(), we only have to be aware of gcc reordering stuff.
>> +      */
>> +     barrier();
>
> Are you seeing a real problem with gcc here?  No sane compiler should need
> a barrier() here (we would probably need zillions of them in kernel if it
> really does).

No, this is just a precaution. The asm I checked looked fine but since
the flag is set and right afterwards checked, it will be bad if this
somehow got reordered. I actually haven't checked whether anything like
that would be possible, at all.

-- 
Regards/Gruss,
Boris
