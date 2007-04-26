Return-Path: <linux-kernel-owner+w=401wt.eu-S932282AbXDZBe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282AbXDZBe1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 21:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932173AbXDZBe1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 21:34:27 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:53406 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932167AbXDZBe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 21:34:26 -0400
Date: Wed, 25 Apr 2007 18:33:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: pwarudkar@aol.com
Cc: Jiri Kosina <jikos@jikos.cz>, dsk6@pitt.edu, linux-kernel@vger.kernel.org
Subject: Re: Sleep during spinlock in TPM driver
Message-Id: <20070425183349.c3f661f4.akpm@linux-foundation.org>
In-Reply-To: <Pine.LNX.4.64.0704230809080.6722@paragw-desktop>
References: <alpine.DEB.0.82.0704221505370.14039@paragw-desktop>
	<Pine.LNX.4.64.0704230941390.20657@twin.jikos.cz>
	<alpine.DEB.0.82.0704230801230.6240@paragw-desktop>
	<Pine.LNX.4.64.0704230809080.6722@paragw-desktop>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2007 08:14:03 -0400 (EDT) Parag Warudkar <pwarudkar@aol.com> wrote:

> --- linux-2.6-us/drivers/char/tpm/tpm.c	2007-04-21 14:55:03.134975360 -0400
> +++ linux-2.6-wk/drivers/char/tpm/tpm.c	2007-04-22 14:58:51.957999963 -0400
> @@ -942,12 +942,12 @@
>  {
>  	struct tpm_chip *chip = file->private_data;
>  
> +	flush_scheduled_work();
>  	spin_lock(&driver_lock);
>  	file->private_data = NULL;
> -	chip->num_opens--;
>  	del_singleshot_timer_sync(&chip->user_read_timer);
> -	flush_scheduled_work();
>  	atomic_set(&chip->data_pending, 0);

btw, this driver has a timer handler which does:

static void user_reader_timeout(unsigned long ptr)
{
        struct tpm_chip *chip = (struct tpm_chip *) ptr;

        schedule_work(&chip->work);
}

which appears to duplicate schedule_delayed_work()'s functionality.
