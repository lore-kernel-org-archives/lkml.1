Return-Path: <linux-kernel-owner+w=401wt.eu-S1754024AbYIWHtD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024AbYIWHtD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 03:49:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751911AbYIWHsw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 03:48:52 -0400
Received: from ug-out-1314.google.com ([66.249.92.169]:24684 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166AbYIWHsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 03:48:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:to:cc:subject:message-id:reply-to:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent:from;
        b=lZbUQEFUO+yhcXP6c9sZEgzHJWpQElCBnxacABDwdj5MiwSpFt3L/pwP7FS5ic3dyI
         4ONmVpbVxARi9FlesK2FoWf9PqtFOFxruKzkMXcR4NGH+ew5aKu6rPmYer04V/jGsRq3
         adtZy9r8qOfXv6bUwwYkTmoKQyA4m1Wouo4Xw=
Date: Tue, 23 Sep 2008 09:48:45 +0200
To: Sergei Shtylyov <sshtylyov@ru.mvista.com>
Cc: Mark de Wever <koraq@xs4all.nl>, Gadi Oxman <gadio@netvision.net.il>,
       Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] IDE-TAPE NULL terminate strings.
Message-ID: <20080923074845.GB5656@gollum.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com,
	Sergei Shtylyov <sshtylyov@ru.mvista.com>,
	Mark de Wever <koraq@xs4all.nl>,
	Gadi Oxman <gadio@netvision.net.il>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20080921185138.GA16310@localhost> <48D79ABD.8060805@ru.mvista.com> <9ea470500809220656j6dfcf4c9q7a5a4185481ec994@mail.gmail.com> <20080922204129.GA3495@localhost> <48D80949.4080901@ru.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48D80949.4080901@ru.mvista.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
From: Borislav Petkov <petkovbb@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2008 at 01:08:25AM +0400, Sergei Shtylyov wrote:
> Hello.
>
> Mark de Wever wrote:
>
>>> .. and I know why :). Those ide_tape_obj members (char fw_rev[6], vendor_id[10],
>>> product_id[18]) were used only once in idetape_get_inquiry_results() so I moved
>>> them there as local stack variables. Originally, they were kzalloc'ed as part of
>>> struct ide_tape_obj and now they contain stack garbage therefore the funny
>>> values. The simple solution would be to zero them out or:
>>>
>>>
>>> Does the following patch help?
>>>     
>>
>> Yes feel free to add my tested-by.
>>   
>
>   And my NAK too. :-)
>
>> Only not sure whether the static is the best solution, the following
>> patch also works, by zeroing the memory as you suggested.
>>
>> Signed-off-by: Mark de Wever <koraq@xs4all.nl>
>>
>> diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
>> index 1bce84b..c41f5b1 100644
>> --- a/drivers/ide/ide-tape.c
>> +++ b/drivers/ide/ide-tape.c
>> @@ -2338,7 +2338,7 @@ static void idetape_get_inquiry_results(ide_drive_t *drive)
>>  {
>>  	idetape_tape_t *tape = drive->driver_data;
>>  	struct ide_atapi_pc pc;
>> -	char fw_rev[6], vendor_id[10], product_id[18];
>> +	char fw_rev[6] = {'\0'}, vendor_id[10] = {'\0'}, product_id[18] = {'\0'};
>>   
>
>   Do you realize how much *absolutely unnecessary* code will this bring  
> in? This is certainly worse than your initial patch (if it was correct).

Yep, Sergei's right. Both of our patches are dumb.

> Ugh, looks like I'll have t submit the patch myself to stop this ugliness...

Is this what you had in mind?

---
diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 1bce84b..3833189 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -2338,7 +2338,7 @@ static void idetape_get_inquiry_results(ide_drive_t *drive)
 {
 	idetape_tape_t *tape = drive->driver_data;
 	struct ide_atapi_pc pc;
-	char fw_rev[6], vendor_id[10], product_id[18];
+	char fw_rev[4], vendor_id[8], product_id[16];
 
 	idetape_create_inquiry_cmd(&pc);
 	if (idetape_queue_pc_tail(drive, &pc)) {
@@ -2350,11 +2350,11 @@ static void idetape_get_inquiry_results(ide_drive_t *drive)
 	memcpy(product_id, &pc.buf[16], 16);
 	memcpy(fw_rev, &pc.buf[32], 4);
 
-	ide_fixstring(vendor_id, 10, 0);
-	ide_fixstring(product_id, 18, 0);
-	ide_fixstring(fw_rev, 6, 0);
+	ide_fixstring(vendor_id, 8, 0);
+	ide_fixstring(product_id, 16, 0);
+	ide_fixstring(fw_rev, 4, 0);
 
-	printk(KERN_INFO "ide-tape: %s <-> %s: %s %s rev %s\n",
+	printk(KERN_INFO "ide-tape: %s <-> %s: %.8s %.16s rev %.4s\n",
 			drive->name, tape->name, vendor_id, product_id, fw_rev);
 }
 


-- 
Regards/Gruss,
    Boris.
