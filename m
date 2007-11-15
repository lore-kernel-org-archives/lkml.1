Return-Path: <linux-kernel-owner+w=401wt.eu-S1760533AbXKOBn5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760533AbXKOBn5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 20:43:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754310AbXKOBnp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 20:43:45 -0500
Received: from wa-out-1112.google.com ([209.85.146.180]:17694 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753078AbXKOBno (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 20:43:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=cAhCJEW5baDJh8veemw3GdHp8ahZO/oNeYEZgTACLeznXYHEpnJrnb34vf7SpOpBGMkd8u8MGYonHhL/DOtzO/MbiCP3CcdvieJqzfzlLh/YOTqxQcTVfGVR3NgKDcIhxH904uX+XfTJsp96q+EoIKXUghs4DzVgBDxEsBFQncI=
Message-ID: <473BA447.6090909@gmail.com>
Date: Thu, 15 Nov 2007 10:43:35 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Robert Hancock <hancockr@shaw.ca>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
       ide <linux-ide@vger.kernel.org>, Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 1/2] sata_nv: don't use legacy DMA in ADMA mode
References: <473A7628.3010907@shaw.ca>
In-Reply-To: <473A7628.3010907@shaw.ca>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Robert Hancock wrote:
> We need to run any DMA command with result taskfile requested in ADMA mode
> when the port is in ADMA mode, otherwise it may try to use the legacy DMA engine
> in ADMA mode which is not allowed. Enforce this with BUG_ON() since data
> corruption could potentially result if this happened.
> 
> Signed-off-by: Robert Hancock <hancockr@shaw.ca>
> 
> --- linux-2.6.24-rc1-git10/drivers/ata/sata_nv.c	2007-11-01 20:01:32.000000000 -0600
> +++ linux-2.6.24-rc1-git10edit/drivers/ata/sata_nv.c	2007-11-13 19:01:09.000000000 -0600
> @@ -791,11 +797,13 @@
>  
>  static void nv_adma_tf_read(struct ata_port *ap, struct ata_taskfile *tf)
>  {
> -	/* Since commands where a result TF is requested are not
> -	   executed in ADMA mode, the only time this function will be called
> -	   in ADMA mode will be if a command fails. In this case we
> -	   don't care about going into register mode with ADMA commands
> -	   pending, as the commands will all shortly be aborted anyway. */
> +	/* Other than when internal or pass-through commands are executed,
> +	   the only time this function will be called in ADMA mode will be
> +	   if a command fails. In the failure case we don't care about going
> +	   into register mode with ADMA commands pending, as the commands will
> +	   all shortly be aborted anyway. We assume that NCQ commands are not
> +	   issued via passthrough and so this will not abort any commands in
> +	   that case. */
>  	nv_adma_register_mode(ap);

So, now if an ATA DMA command is issued w/ RESULT_TF set, it's issued
using ADMA.  Then when nv_adma_tf_read() is called on success path, it
switches into register mode and read TF which is okay as long as there's
no other ADMA commands in flight and that's why you wrote about not
issuing NCQ commands via NCQ.  Am I understanding it correctly?

If so, can you please add that switching into register mode is okay as
long as there's no other ADMA commands in flight and add
WARN_ON((qc->flags & ATA_QCFLAG_RESULT_TF) && link->sactive)?

Thanks.

-- 
tejun
