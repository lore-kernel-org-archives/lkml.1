Return-Path: <linux-kernel-owner+w=401wt.eu-S1752701AbXGTEHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752701AbXGTEHR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 00:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750754AbXGTEHE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 00:07:04 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:49611 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbXGTEHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 00:07:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=asrSRkrtJQoDkNyTQs07Hhm78jE43PFFe20CNdbj4HKfbAcFdv7t1UhMMevAAcxedbbyZTvnIrYfg4wKCC63pFZhOzj0ka4iahvVn3g/FDELbZPgiXoBjR94Y/wJoPuxf1wlV/Ra4S8TT/px8cfpDNgxj0CSRpURFJmFrhwRVYQ=
Message-ID: <a781481a0707192107g5bf71891qd289126220ca6189@mail.gmail.com>
Date: Fri, 20 Jul 2007 09:37:00 +0530
From: "Satyam Sharma" <satyam.sharma@gmail.com>
To: "Reiner Sailer" <sailer@us.ibm.com>
Subject: Re: [PATCH] Memory leak in tpm_ascii_bios_measurements_open() fix.
Cc: "Jesper Juhl" <jesper.juhl@gmail.com>, kjhall@linux.vnet.ibm.com,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Seiji Munetoh" <munetoh@jp.ibm.com>,
       "Reiner Sailer" <sailer@watson.ibm.com>, stefanb@us.ibm.com
In-Reply-To: <46A02CED.7000309@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <46A02CED.7000309@us.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/20/07, Reiner Sailer <sailer@us.ibm.com> wrote:
>
> Jesper Juhl <jesper.juhl@gmail.com> wrote on 07/18/2007 07:11:54 PM:
>  >
>  > +++ b/drivers/char/tpm/tpm_bios.c
>  > @@ -427,7 +427,7 @@ static int
>  > tpm_ascii_bios_measurements_open(struct inode *inode,
>  >        return -ENOMEM;
>  >
>  >     if ((err = read_log(log)))
>  > -      return err;
>  > +      goto out_free;
>  >
>  >     /* now register seq file */
>  >     err = seq_open(file, &tpm_ascii_b_measurments_seqops);
>  > @@ -435,10 +435,15 @@ static int
>  > tpm_ascii_bios_measurements_open(struct inode *inode,
>  >        seq = file->private_data;
>  >        seq->private = log;
>  >     } else {
>  > -      kfree(log->bios_event_log);
>  > -      kfree(log);
>  > +      goto out_free;
>  >     }
>  > +
>  > +out:
>  >     return err;
>  > +out_free:
>  > +   kfree(log->bios_event_log);
>  > +   kfree(log);
>  > +   goto out;
>  >  }
>  >
>  >  const struct file_operations tpm_ascii_bios_measurements_ops = {
>  >
>  >
>
> Index: linux-2.6.22-rc7/drivers/char/tpm/tpm_bios.c
> ===================================================================
> --- linux-2.6.22-rc7.orig/drivers/char/tpm/tpm_bios.c
> +++ linux-2.6.22-rc7/drivers/char/tpm/tpm_bios.c
> @@ -426,9 +426,10 @@ static int tpm_ascii_bios_measurements_o
>      if (!log)
>          return -ENOMEM;
>
> -    if ((err = read_log(log)))
> +    if ((err = read_log(log))) {
> +        kfree(log);
>          return err;
> -
> +    }
>      /* now register seq file */
>      err = seq_open(file, &tpm_ascii_b_measurments_seqops);
>      if (!err) {
>
> Do you agree?


Jesper's patch makes  the code conforming to the kernel coding style
(kfree()'s in common error paths, single "return" call, etc). Not a big
issue, just a consistency thing, so feel free to take your pick between
the two alternatives.

BTW please also fix an exactly similar memory leak 30 lines later in the
same file -- in tpm_binary_bios_measurements_open() -- while you're at it.

Thanks,
Satyam
