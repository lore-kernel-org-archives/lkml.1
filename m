Return-Path: <linux-kernel-owner+w=401wt.eu-S1754050AbXDWMEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050AbXDWMEp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 08:04:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754107AbXDWMEp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 08:04:45 -0400
Received: from wx-out-0506.google.com ([66.249.82.236]:61831 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050AbXDWMEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 08:04:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:x-x-sender:reply-to:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type:from;
        b=YDSaqHN06H2HRDMOLQJrHPQhTKI2J+ZZCCARm1plT9hqAtRr8AcIq7NvvCkzrS1/FpC8DbYlf2Fki7bbACjEz12MOrday2mCYTMyi4NWT9lr7UtVOQ49op+sH51pAbrEYs8KWZ2SiVNUhYBa7odnY6Bwxbg3pGz+qOcmAfAOpN8=
Date: Mon, 23 Apr 2007 08:04:04 -0400 (EDT)
X-X-Sender: paragw@paragw-desktop
Reply-To: pwarudkar@aol.com
To: Jiri Kosina <jikos@jikos.cz>
cc: Andrew Morton <akpm@linux-foundation.org>, dsk6@pitt.edu,
       pwarudkar@aol.com, linux-kernel@vger.kernel.org
Subject: Re: Sleep during spinlock in TPM driver
In-Reply-To: <Pine.LNX.4.64.0704230941390.20657@twin.jikos.cz>
Message-ID: <alpine.DEB.0.82.0704230801230.6240@paragw-desktop>
References: <alpine.DEB.0.82.0704221505370.14039@paragw-desktop>
 <Pine.LNX.4.64.0704230941390.20657@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
From: Parag Warudkar <parag.warudkar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 23 Apr 2007, Jiri Kosina wrote:

> On Sun, 22 Apr 2007, Parag Warudkar wrote:
>
>> @@ -1097,8 +1097,13 @@
>>
>>       /* Driver specific per-device data */
>>       chip = kzalloc(sizeof(*chip), GFP_KERNEL);
>> - if (chip == NULL)
>> + devname = kmalloc(DEVNAME_SIZE, GFP_KERNEL);
>> + +   if (chip == NULL || devname == NULL) {
>
> Hi,
>
> this line looks bogus to me.
>

Hi - Yep, thanks for catching. Really not sure how that extra + got in 
there - I diffed the exact same file this morning and it isn't there - new 
diff attached.

--- linux-2.6-us/drivers/char/tpm/tpm.c	2007-04-21 14:55:03.134975360 -0400
+++ linux-2.6-wk/drivers/char/tpm/tpm.c	2007-04-22 14:58:51.957999963 -0400
@@ -942,12 +942,12 @@
  {
  	struct tpm_chip *chip = file->private_data;

+	flush_scheduled_work();
  	spin_lock(&driver_lock);
  	file->private_data = NULL;
-	chip->num_opens--;
  	del_singleshot_timer_sync(&chip->user_read_timer);
-	flush_scheduled_work();
  	atomic_set(&chip->data_pending, 0);
+	chip->num_opens--;
  	put_device(chip->dev);
  	kfree(chip->data_buffer);
  	spin_unlock(&driver_lock);
@@ -1097,8 +1097,13 @@

  	/* Driver specific per-device data */
  	chip = kzalloc(sizeof(*chip), GFP_KERNEL);
-	if (chip == NULL)
+	devname = kmalloc(DEVNAME_SIZE, GFP_KERNEL);
+ 
+	if (chip == NULL || devname == NULL) {
+		kfree(chip);
+		kfree(devname);
  		return NULL;
+	}

  	init_MUTEX(&chip->buffer_mutex);
  	init_MUTEX(&chip->tpm_mutex);
@@ -1124,7 +1129,6 @@

  	set_bit(chip->dev_num, dev_mask);

-	devname = kmalloc(DEVNAME_SIZE, GFP_KERNEL);
  	scnprintf(devname, DEVNAME_SIZE, "%s%d", "tpm", chip->dev_num);
  	chip->vendor.miscdev.name = devname;

