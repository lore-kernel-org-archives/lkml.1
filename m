Return-Path: <linux-kernel-owner+w=401wt.eu-S1753564AbXDUWv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564AbXDUWv1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 18:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753661AbXDUWv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 18:51:27 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:48927 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753564AbXDUWv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 18:51:26 -0400
Date: Sat, 21 Apr 2007 15:50:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "David Kyle" <dsk6@pitt.edu>
Cc: linux-kernel@vger.kernel.org, Kylene Jo Hall <kjhall@us.ibm.com>,
       tpm@selhorst.net, tpmdd-devel@lists.sourceforge.net
Subject: Re: Sleep during spinlock in TPM driver
Message-Id: <20070421155055.242d22dc.akpm@linux-foundation.org>
In-Reply-To: <361d23520704201511j6d345d57u9f6dd6658c78d178@mail.gmail.com>
References: <361d23520704201511j6d345d57u9f6dd6658c78d178@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 Apr 2007 18:11:10 -0400 "David Kyle" <dsk6@pitt.edu> wrote:

> I've been working with the TPM driver, and I found that if I opened,
> used, then closed the TPM char device very frequently, I would get a
> kernel BUG message saying that the kernel tried to sleep while holding
> a spinlock.  I think I've isolated the problem to this function, in
> drivers/char/tpm/tpm.c:
> 
> int tpm_release(struct inode *inode, struct file *file)
> {
>         struct tpm_chip *chip = file->private_data;
>         spin_lock(&driver_lock);
>         file->private_data = NULL;
>         chip->num_opens--;
>         del_singleshot_timer_sync(&chip->user_read_timer);
>         flush_scheduled_work();
>         atomic_set(&chip->data_pending, 0);
>         put_device(chip->dev);
>         kfree(chip->data_buffer);
>         spin_unlock(&driver_lock);
>         return 0;
> }
> EXPORT_SYMBOL_GPL(tpm_release);
> 
> I believe that flush_scheduled_work can sleep, correct?  Does anyone
> know why this function is called while the spinlock is held?
> 

yup, that's a bug.  It's not immediately clear to e what driver_lock is
protecting.  Some global things, some per-device things, it appears.

A suitable fix might be to make driver_lock a mutex.
