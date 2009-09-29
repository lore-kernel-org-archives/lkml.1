Return-Path: <linux-kernel-owner+w=401wt.eu-S1754128AbZI2M46@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbZI2M46 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 08:56:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751609AbZI2M45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 08:56:57 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:33247 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434AbZI2M45 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 08:56:57 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
Organization: IBM
To: Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH] virtio_console: Add support for multiple ports for generic guest and host communication
Date: Tue, 29 Sep 2009 14:56:56 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.31-release; KDE/4.3.1; i686; ; )
Cc: Rusty Russell <rusty@rustcorp.com.au>, Alan Cox <alan@linux.intel.com>,
       virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <1252678386-17404-1-git-send-email-amit.shah@redhat.com> <200909291403.08547.borntraeger@de.ibm.com> <20090929122006.GB3766@amit-x200.redhat.com>
In-Reply-To: <20090929122006.GB3766@amit-x200.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200909291456.56723.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 29 September 2009 14:20:06 schrieb Amit Shah:
> Christian tested the patch on s390 and found that the output was
> very slow. He tracked it down to put_chars never getting init'ed
> to the final value.
> 
> Signed-off-by: Amit Shah <amit.shah@redhat.com>

Thanks. This fix is 
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com>
Tested-by: Christian Borntraeger <borntraeger@de.ibm.com> 

I am a bit reluctant to Ack the whole change, since my preference would have
been to not merge virtio serial/console and instead keeping both separate.
We have already managed to clutter all other virtio drivers with tons of 
configuration stuff and feature bits - and every driver uses a different model
for configuration and commands (feature bits, config space, config_change 
indication, extra config virtqueue, commands embedded into the data....).
Using a different device ID for a different use seem like a better way to me.

On the other hand, this patch allows more than one console (I have not tested
this feature) and with this fix applied I dont see any obvious problems.

For the console part I can give a 
Acked-by: Christian Borntraeger <borntraeger@de.ibm.com> (console)

Ignoring my preference for having a separate driver and devids, I have no 
opinion about the generic communication stuff - no ack or nack.

> ---
>  drivers/char/virtio_console.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
> index 37513e8..598bc0d 100644
> --- a/drivers/char/virtio_console.c
> +++ b/drivers/char/virtio_console.c
> @@ -571,6 +571,14 @@ int init_port_console(struct virtio_console_port
>  *port) * The Host's telling us this port is a console port. Hook it
>  	 * up with an hvc console.
>  	 *
> +	 * We had set the virtio_cons put_chars implementation to
> +	 * put_chars for early_init. Now that we're done with the
> +	 * early init phase, replace it with our cons_put_chars
> +	 * implementation.
> +	 */
> +	virtio_cons.put_chars = cons_put_chars;
> +
> +	/*
>  	 * To set up and manage our virtual console, we call
>  	 * hvc_alloc().
>  	 *

