Return-Path: <linux-kernel-owner+w=401wt.eu-S1754511AbXDTWLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754511AbXDTWLM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 18:11:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754512AbXDTWLM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 18:11:12 -0400
Received: from an-out-0708.google.com ([209.85.132.243]:57451 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754511AbXDTWLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 18:11:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=TpIIGYWmGaGcq00n0c1rLj9WL+hkyEB/x6HK/Uy0QVsMlwg6bWKz/xi9s95iPvTnpSPwheaUHY2If1dK+FzHCGqAcmhJ+aVfS6FdJWe8tHfGQo/OtNy1WOmgPnv684rk7uHY7XhHWwYdiZDMdtcXB9jzIOfbtcGMITA6rEA/lzY=
Message-ID: <361d23520704201511j6d345d57u9f6dd6658c78d178@mail.gmail.com>
Date: Fri, 20 Apr 2007 18:11:10 -0400
From: "David Kyle" <dsk6@pitt.edu>
To: linux-kernel@vger.kernel.org
Subject: Sleep during spinlock in TPM driver
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: 70cbe69c4e2c783b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've been working with the TPM driver, and I found that if I opened,
used, then closed the TPM char device very frequently, I would get a
kernel BUG message saying that the kernel tried to sleep while holding
a spinlock.  I think I've isolated the problem to this function, in
drivers/char/tpm/tpm.c:

int tpm_release(struct inode *inode, struct file *file)
{
        struct tpm_chip *chip = file->private_data;
        spin_lock(&driver_lock);
        file->private_data = NULL;
        chip->num_opens--;
        del_singleshot_timer_sync(&chip->user_read_timer);
        flush_scheduled_work();
        atomic_set(&chip->data_pending, 0);
        put_device(chip->dev);
        kfree(chip->data_buffer);
        spin_unlock(&driver_lock);
        return 0;
}
EXPORT_SYMBOL_GPL(tpm_release);

I believe that flush_scheduled_work can sleep, correct?  Does anyone
know why this function is called while the spinlock is held?

-David
