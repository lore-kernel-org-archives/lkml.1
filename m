Return-Path: <linux-kernel-owner+w=401wt.eu-S965104AbXDVTGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965104AbXDVTGR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2007 15:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965661AbXDVTGR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Apr 2007 15:06:17 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:23039 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965104AbXDVTGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2007 15:06:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:x-x-sender:reply-to:to:cc:subject:message-id:mime-version:content-type:from;
        b=P+P39YoakrOBP4zhhsJ1SQKeXzx2kcxLvGH6E9QrA2isRBF+isomzrE+DV48+9JgidEYsVtzk6oHfIF5coWtSWCq6ZWHX08SOZ9QI1txOPusQQzevvKlposC6b0NTPg/40o8ZXI6gzFzepraTsQgGEglviP3XDsfhQah0xF3JmI=
Date: Sun, 22 Apr 2007 15:06:10 -0400 (EDT)
X-X-Sender: paragw@paragw-desktop
Reply-To: pwarudkar@aol.com
To: akpm@linux-foundation.org
cc: dsk6@pitt.edu, linux-kernel@vger.kernel.org
Subject: Re: Sleep during spinlock in TPM driver
Message-ID: <alpine.DEB.0.82.0704221505370.14039@paragw-desktop>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
From: Parag Warudkar <parag.warudkar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm <at> linux-foundation.org> writes:

>
> On Fri, 20 Apr 2007 18:11:10 -0400 "David Kyle" <dsk6 <at> pitt.edu> 
wrote:
>
> > int tpm_release(struct inode *inode, struct file *file)
> > {
> >         struct tpm_chip *chip = file->private_data;
> >         spin_lock(&driver_lock);
> >         file->private_data = NULL;
> >         chip->num_opens--;
> >         del_singleshot_timer_sync(&chip->user_read_timer);
> >         flush_scheduled_work();
> >         atomic_set(&chip->data_pending, 0);
> >         put_device(chip->dev);
> >         kfree(chip->data_buffer);
> >         spin_unlock(&driver_lock);
> >         return 0;
> > }
> > EXPORT_SYMBOL_GPL(tpm_release);
> >
> > I believe that flush_scheduled_work can sleep, correct?  Does anyone
> > know why this function is called while the spinlock is held?
> >
>
> yup, that's a bug.  It's not immediately clear to e what driver_lock is
> protecting.  Some global things, some per-device things, it appears.
>
> A suitable fix might be to make driver_lock a mutex.
>

AFAICS, moving flush_scheduled_work before spin_lock() should 
not cause any problems.

Reason being - The only thing that can race against tpm_release is 
tpm_open (tpm_release is called when last reference to the file is closed 
and only thing that can happen after that is tpm_open??) and tpm_open 
acquires driver_lock and more over it bails out with EBUSY if 
chip->num_opens is greater than 0.

I also moved chip->num_pending-- to after deleting timer and setting data 
pending as it looks more correct for the paranoid although it probably 
doesn't matter as it is guarded by driver_lock. None the less this change 
should not cause problems.

While I was at it I noticed a missing NULL check in tpm_register_hardware 
which is fixed with this patch as well.

David - could you please try the below patch and see if it works? Thanks.

Signed-off-by: Parag Warudkar <parag.warudkar@gmail.com>

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

