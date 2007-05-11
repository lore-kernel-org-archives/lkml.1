Return-Path: <linux-kernel-owner+w=401wt.eu-S1759694AbXEKOTI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759694AbXEKOTI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 10:19:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754937AbXEKOS4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 10:18:56 -0400
Received: from nz-out-0506.google.com ([64.233.162.232]:5280 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754835AbXEKOS4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 10:18:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=sh9e1YNhHbi0L5gkPGrg0OMRvSfaVtU/GFRX9cB2j3dx8MAiU3Gh2io27bSsUAGQBznAChr/k/QCcQK0AcJq2y0b0+EOKGuz3UW3IUSazASttpzV+Ps+4LfTSPjPV3pQyjcfXlOxy/Iec+cOY9c4zeo6ULg/IMvekavVSVXv+UY=
Message-ID: <46447B42.3020302@gmail.com>
Date: Fri, 11 May 2007 16:18:42 +0200
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Oleg Nesterov <oleg@tv-sign.ru>
CC: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, Jeff Garzik <jeff@garzik.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] libata-core: convert to use cancel_rearming_delayed_work()
References: <20070505221709.GA3955@tv-sign.ru>
In-Reply-To: <20070505221709.GA3955@tv-sign.ru>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Oleg Nesterov wrote:
>  void ata_port_queue_task(struct ata_port *ap, work_func_t fn, void *data,
>  			 unsigned long delay)
>  {
> -	int rc;
> -
> -	if (ap->pflags & ATA_PFLAG_FLUSH_PORT_TASK)
> -		return;
> -
>  	PREPARE_DELAYED_WORK(&ap->port_task, fn);
>  	ap->port_task_data = data;
>  
> -	rc = queue_delayed_work(ata_wq, &ap->port_task, delay);
> -
> -	/* rc == 0 means that another user is using port task */
> -	WARN_ON(rc == 0);
> +	/* may fail if ata_port_flush_task() in progress */
> +	queue_delayed_work(ata_wq, &ap->port_task, delay);
>  }

I don't really think ata_port_queue_task() deserves to live after this.
 Feel free to kill it.

>  void ata_port_flush_task(struct ata_port *ap)
>  {
> -	unsigned long flags;
> -
>  	DPRINTK("ENTER\n");
>  
> -	spin_lock_irqsave(ap->lock, flags);
> -	ap->pflags |= ATA_PFLAG_FLUSH_PORT_TASK;
> -	spin_unlock_irqrestore(ap->lock, flags);
> -
> -	DPRINTK("flush #1\n");
> -	cancel_work_sync(&ap->port_task.work); /* akpm: seems unneeded */
> -
> -	/*
> -	 * At this point, if a task is running, it's guaranteed to see
> -	 * the FLUSH flag; thus, it will never queue pio tasks again.
> -	 * Cancel and flush.
> -	 */
> -	if (!cancel_delayed_work(&ap->port_task)) {
> -		if (ata_msg_ctl(ap))
> -			ata_port_printk(ap, KERN_DEBUG, "%s: flush #2\n",
> -					__FUNCTION__);
> -		cancel_work_sync(&ap->port_task.work);
> -	}
> -
> -	spin_lock_irqsave(ap->lock, flags);
> -	ap->pflags &= ~ATA_PFLAG_FLUSH_PORT_TASK;
> -	spin_unlock_irqrestore(ap->lock, flags);
> +	cancel_rearming_delayed_work(&ap->port_task);

Nor does ata_port_flush_task().

> @@ -6094,13 +6064,7 @@ void ata_port_detach(struct ata_port *ap
>  	spin_unlock_irqrestore(ap->lock, flags);
>  
>  	ata_port_wait_eh(ap);
> -
> -	/* Flush hotplug task.  The sequence is similar to
> -	 * ata_port_flush_task().
> -	 */
> -	cancel_work_sync(&ap->hotplug_task.work); /* akpm: why? */
> -	cancel_delayed_work(&ap->hotplug_task);
> -	cancel_work_sync(&ap->hotplug_task.work);
> +	cancel_rearming_delayed_work(&ap->hotplug_task);

Yay, I've always wanted to do that.  :-)

Thanks.

-- 
tejun
