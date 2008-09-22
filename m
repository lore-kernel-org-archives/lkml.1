Return-Path: <linux-kernel-owner+w=401wt.eu-S1753123AbYIVN6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123AbYIVN6Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 09:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752391AbYIVN6P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 09:58:15 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:49256 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222AbYIVN6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 09:58:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=LxQGK5Yyr2p0lLwHYxwu22qfH/M5ZBxZH6h5PK13lgdTog0MVDCfFTA+wT+IORhdRJ
         gHxkzTvnh9VuEWtFpNtLB3iSBhR9D7Eo9meH7nc1Q+hAOsyzLzIwrHYab6zfVFPowYsA
         vQM+FY0E4U758JxpNGv02Gacq+6/Z2LZy4AjA=
Message-ID: <9ea470500809220658v38cd137fl8eb15e257f0e481@mail.gmail.com>
Date: Mon, 22 Sep 2008 15:58:12 +0200
From: "Boris Petkov" <petkovbb@googlemail.com>
Reply-To: petkovbb@gmail.com
To: "Sergei Shtylyov" <sshtylyov@ru.mvista.com>
Subject: Re: [PATCH 06/22] ide-tape: struct idetape_tape_t: remove unused members
Cc: bzolnier@gmail.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
In-Reply-To: <48D79CD5.5000605@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1202132440-26648-1-git-send-email-petkovbb@gmail.com>
	 <1202132440-26648-7-git-send-email-petkovbb@gmail.com>
	 <48D79CD5.5000605@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 3:25 PM, Sergei Shtylyov
<sshtylyov@ru.mvista.com> wrote:
> Hello.
>
> Borislav Petkov wrote:
>
>> - last_frame_position: only being written to once
>> - firmware_revision, product_id, vendor_id: used once, remove from struct
>>  idetape_tape_t and deal with them locally
>> - firmware_revision_num: only written to once
>> - tape_still_time_begin: completely unused
>> - tape_still_time: never written to; remove corresponding code chunk
>> - uncontrolled_last_pipeline_head: only once written to
>> - blocks_in_buffer: only written to
>
>> Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
>
>   Late complaint but anyway... :-)
>
>> diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
>> index e0e8184..126e8a9 100644
>> --- a/drivers/ide/ide-tape.c
>> +++ b/drivers/ide/ide-tape.c
>> @@ -399,11 +397,6 @@ typedef struct ide_tape_obj {
>>        int avg_size;
>>        int avg_speed;
>>  -       char vendor_id[10];
>> -       char product_id[18];
>> -       char firmware_revision[6];
>> -       int firmware_revision_num;
>> -
>>        /* the door is currently locked */
>>        int door_locked;
>>        /* the tape hardware is write protected */
>
> [...]
>
>> @@ -3438,9 +3419,9 @@ static int idetape_identify_device (ide_drive_t
>> *drive)
>>   static void idetape_get_inquiry_results(ide_drive_t *drive)
>>  {
>> -       char *r;
>>        idetape_tape_t *tape = drive->driver_data;
>>        idetape_pc_t pc;
>> +       char fw_rev[6], vendor_id[10], product_id[18];
>>          idetape_create_inquiry_cmd(&pc);
>>        if (idetape_queue_pc_tail(drive, &pc)) {
>> @@ -3448,20 +3429,16 @@ static void
>> idetape_get_inquiry_results(ide_drive_t *drive)
>>                                tape->name);
>>                return;
>>        }
>> -       memcpy(tape->vendor_id, &pc.buffer[8], 8);
>> -       memcpy(tape->product_id, &pc.buffer[16], 16);
>> -       memcpy(tape->firmware_revision, &pc.buffer[32], 4);
>> -
>> -       ide_fixstring(tape->vendor_id, 10, 0);
>> -       ide_fixstring(tape->product_id, 18, 0);
>> -       ide_fixstring(tape->firmware_revision, 6, 0);
>> -       r = tape->firmware_revision;
>> -       if (*(r + 1) == '.')
>> -               tape->firmware_revision_num = (*r - '0') * 100 +
>> -                       (*(r + 2) - '0') * 10 + *(r + 3) - '0';
>> +       memcpy(vendor_id, &pc.buffer[8], 8);
>> +       memcpy(product_id, &pc.buffer[16], 16);
>> +       memcpy(fw_rev, &pc.buffer[32], 4);
>> +
>> +       ide_fixstring(vendor_id, 10, 0);
>> +       ide_fixstring(product_id, 18, 0);
>> +       ide_fixstring(fw_rev, 6, 0);
>
>   It was wrong to call ide_fixstring() on unterminated strings and expecting
> them to become terminated strings after that; plus it was useless to add 2
> characters padding at the end. When these variables were the fields of
> 'struct ide_tape_obj', those bytes were 0 because of the variable of this
> type being a static array. When they became local variables, they got
> garbage bytes at the end which ide_fixdriveid() either honestly copied when
> compressing spaces or just left where they were...

LOL, i just sent out a similar fix :).

>
>> +
>>        printk(KERN_INFO "ide-tape: %s <-> %s: %s %s rev %s\n",
>
>   Should've rather changed the string format to print only N characters
> max...
>
> MBR, Sergei
>



-- 
Regards/Gruss,
Boris
