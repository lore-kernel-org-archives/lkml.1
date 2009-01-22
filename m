Return-Path: <linux-kernel-owner+w=401wt.eu-S1757447AbZAVTKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757447AbZAVTKh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 14:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755486AbZAVTK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 14:10:29 -0500
Received: from mtagate5.de.ibm.com ([195.212.29.154]:58275 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457AbZAVTK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 14:10:29 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Subject: Re: [PATCH] HVC: do not request the irq twice.
Date: Thu, 22 Jan 2009 20:09:43 +0100
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Milton Miller <miltonm@bga.com>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Rusty Russell <rusty@rustcorp.com.au>
References: <1232646968-32671-1-git-send-email-Ian.Campbell@citrix.com>
In-Reply-To: <1232646968-32671-1-git-send-email-Ian.Campbell@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901222009.43342.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Thursday 22 January 2009 18:56:08 schrieb Ian Campbell:
> --- a/drivers/char/hvc_irq.c
> +++ b/drivers/char/hvc_irq.c
> @@ -28,6 +28,10 @@ int notifier_add_irq(struct hvc_struct *hp, int irq)
>  		hp->irq_requested = 0;
>  		return 0;
>  	}
> +
> +	if (hp->irq_requested)
> +		return 0;
> +
>  	rc = request_irq(irq, hvc_handle_interrupt, IRQF_DISABLED,
>  			   "hvc_console", hp);
>  	if (!rc)

Unfortunately I have no system with an irq based hvc console - I cannot test 
this patch. Anyway, the patch looks sane:

Reviewed-by: Christian Borntraeger <borntraeger@de.ibm.com>

If this really fixes a problem, I am asking myself, if notifier_del can be 
called several times as well. If yes, it might be better to call free_irq at 
the last notifier_del - which means we need proper refcounting. Otherwise the 
console switches into polling mode....

Christian, blaming Rusty for using hvc_console in virtio_console which made me 
somehow responsible for this code...  ;-)
