Return-Path: <linux-kernel-owner+w=401wt.eu-S1752041AbZJLFp6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbZJLFp6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Oct 2009 01:45:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbZJLFp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Oct 2009 01:45:57 -0400
Received: from gate.crashing.org ([63.228.1.57]:46512 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbZJLFp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Oct 2009 01:45:56 -0400
Subject: Re: USB serial regression 2.6.31.1 -> 2.6.31.2 [PATCH]
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ben Efros <ben@pc-doctor.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Josua Dietze <digidietze@draisberghof.de>,
       fangxiaozhi <huananhu@huawei.com>, Greg KH <greg@kroah.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Hugh Blemings <hugh@blemings.org>
In-Reply-To: <7550119.564321255277798089.JavaMail.root@mail.pc-doctor.com>
References: <7550119.564321255277798089.JavaMail.root@mail.pc-doctor.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 12 Oct 2009 16:44:12 +1100
Message-Id: <1255326252.2192.110.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-10-11 at 09:16 -0700, Ben Efros wrote:

> No I don't think its a good idea to turn off SANE_SENSE in this situation.
> Here is a patch similar to Ben Herrenschmidt's but will not turn off SANE_SENSE
> just because a transport failure.
>
> Retry with short sense when SANE_SENSE fails.

Works for me too.

Alan, what do you think ? I definitely don't like Ben E's most recent
patch with a quirk for all devices, it's simply a lot more code for
something that will come back and bite again when somebody does the
same mistake again. I'd rather have the request sense code be more
robust. But this patch is fine, as was my previous one.

So it boils down on clearing SANE_SENSE vs. not clearing it. If we
clear it, we probably want to keep it cleared (via an INSANE_SENSE
flag ?). But on the other hand, I don't think that always going
for a retry when a SANE_SENSE fails is going to hurt and sounds
like the robust thing to do, so I don't mind that simple patch
from Ben. So up to you :-)

Cheers,
Ben.

>  Signed-off-by: Ben Efros <ben@pc-doctor.com>

Tested-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>

> --- linux-2.6.31.1/drivers/usb/storage/transport.c        2009-09-24 08:45:25.000000000 -0700
> +++ linux-2.6.31.1.new/drivers/usb/storage/transport.c        2009-10-11 08:06:26.000000000 -0700
> @@ -696,7 +696,7 @@ void usb_stor_invoke_transport(struct sc
>                  /* device supports and needs bigger sense buffer */
>                  if (us->fflags & US_FL_SANE_SENSE)
>                          sense_size = ~0;
> -
> +Retry_Sense:
>                  US_DEBUGP("Issuing auto-REQUEST_SENSE\n");
>  
>                  scsi_eh_prep_cmnd(srb, &ses, NULL, 0, sense_size);
> @@ -723,6 +723,12 @@ void usb_stor_invoke_transport(struct sc
>                  if (temp_result != USB_STOR_TRANSPORT_GOOD) {
>                          US_DEBUGP("-- auto-sense failure\n");
>  
> +                        if ((us->fflags & US_FL_SANE_SENSE) &&
> +                            sense_size != US_SENSE_SIZE) {
> +                                sense_size = US_SENSE_SIZE;
> +                                US_DEBUGP("-- retry without SANE_SENSE\n");
> +                                goto Retry_Sense;
> +                        }
>                          /* we skip the reset if this happens to be a
>                           * multi-target device, since failure of an
>                           * auto-sense is perfectly valid
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


