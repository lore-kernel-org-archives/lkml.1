Return-Path: <linux-kernel-owner+w=401wt.eu-S1751054AbXBUF5J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751054AbXBUF5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 00:57:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751130AbXBUF5J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 00:57:09 -0500
Received: from wx-out-0506.google.com ([66.249.82.239]:26347 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054AbXBUF5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 00:57:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=UdRuhKEJ2I9Bruf80pHy1pF+L1mjDX2Sw4HRghw7an+cPd9KwLKhl0VIvP/rFAA+Dxm1uWkoDT85SV9pNjpj2J5gedGU2EdxlMGaaG/5zL9TKo6tb27SHwOhGP/1bYQtL9higSNAzae9ROb4nbIk5/bLT1uCTiJbMbzYg5A4/UU=
Message-ID: <d72aa1340702202157l1932b393k36cb58ecfbe40178@mail.gmail.com>
Date: Wed, 21 Feb 2007 00:57:06 -0500
From: "Marcus Haebler" <haebler@gmail.com>
To: "Tejun Heo" <htejun@gmail.com>
Subject: Re: SATA problems
Cc: "Pablo Sebastian Greco" <lkml@fliagreco.com.ar>,
       linux-kernel@vger.kernel.org
In-Reply-To: <45DBC2CE.6040408@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <459A674B.3060304@fliagreco.com.ar>
	 <459DC2EE.1090307@fliagreco.com.ar> <45A1AB3F.1080408@gmail.com>
	 <45B649BF.5030705@fliagreco.com.ar> <45B6BC6D.8070301@gmail.com>
	 <d72aa1340702170449n1aa61777l6c9c7e525102db00@mail.gmail.com>
	 <45D731A8.90604@fliagreco.com.ar> <45DB0717.90507@gmail.com>
	 <d72aa1340702201655o78975cc7vd67c82eea92bd519@mail.gmail.com>
	 <45DBC2CE.6040408@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun,

thanks. In preparation of your patch I installed a vanilla 2.6.20.1
kernel on my FC6
system. Amazingly the problem went away with the vanilla(!) kernel and NCQ
is enabled at boot time (queue_depth is 31). I guess I should have
tried that kernel
earlier.

The patches you sent earlier apply w/o problems against the 2.6.20.1
vanilla kernel
which is expected. I will test drive those patches tomorrow.

BTW thanks for saving me the 'cat' on the 3 patches. ;)

Thanks,

Marcus

On 2/20/07, Tejun Heo <htejun@gmail.com> wrote:
> Marcus Haebler wrote:
> > thanks for the patches! I am on an Intel P965/ICH8R.
>
> I see.  That can happen too.  There was a race window where in-flight
> r/w command which left SCSI midlayer but pending on libata gets executed
> in the wrong mode.  If possible, please verify that it doesn't happen
> with the patches applied.  I'm attaching combined patch against v2.6.20.
>
> Thanks.
>
> --
> tejun
>
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 667acd2..348cc02 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -308,9 +308,7 @@ int ata_build_rw_tf(struct ata_taskfile *tf, struct ata_device *dev,
>         tf->flags |= ATA_TFLAG_ISADDR | ATA_TFLAG_DEVICE;
>         tf->flags |= tf_flags;
>
> -       if ((dev->flags & (ATA_DFLAG_PIO | ATA_DFLAG_NCQ_OFF |
> -                          ATA_DFLAG_NCQ)) == ATA_DFLAG_NCQ &&
> -           likely(tag != ATA_TAG_INTERNAL)) {
> +       if (ata_ncq_enabled(dev) && likely(tag != ATA_TAG_INTERNAL)) {
>                 /* yay, NCQ */
>                 if (!lba_48_ok(block, n_block))
>                         return -ERANGE;
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 73902d3..ebb9185 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -945,29 +945,32 @@ int ata_scsi_change_queue_depth(struct scsi_device *sdev, int queue_depth)
>         struct ata_port *ap = ata_shost_to_port(sdev->host);
>         struct ata_device *dev;
>         unsigned long flags;
> -       int max_depth;
>
> -       if (queue_depth < 1)
> +       if (queue_depth < 1 || queue_depth == sdev->queue_depth)
>                 return sdev->queue_depth;
>
>         dev = ata_scsi_find_dev(ap, sdev);
>         if (!dev || !ata_dev_enabled(dev))
>                 return sdev->queue_depth;
>
> -       max_depth = min(sdev->host->can_queue, ata_id_queue_depth(dev->id));
> -       max_depth = min(ATA_MAX_QUEUE - 1, max_depth);
> -       if (queue_depth > max_depth)
> -               queue_depth = max_depth;
> -
> -       scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG, queue_depth);
> -
> +       /* NCQ enabled? */
>         spin_lock_irqsave(ap->lock, flags);
> -       if (queue_depth > 1)
> -               dev->flags &= ~ATA_DFLAG_NCQ_OFF;
> -       else
> +       dev->flags &= ~ATA_DFLAG_NCQ_OFF;
> +       if (queue_depth == 1 || !ata_ncq_enabled(dev)) {
>                 dev->flags |= ATA_DFLAG_NCQ_OFF;
> +               queue_depth = 1;
> +       }
>         spin_unlock_irqrestore(ap->lock, flags);
>
> +       /* limit and apply queue depth */
> +       queue_depth = min(queue_depth, sdev->host->can_queue);
> +       queue_depth = min(queue_depth, ata_id_queue_depth(dev->id));
> +       queue_depth = min(queue_depth, ATA_MAX_QUEUE - 1);
> +
> +       if (sdev->queue_depth == queue_depth)
> +               return -EINVAL;
> +
> +       scsi_adjust_queue_depth(sdev, MSG_SIMPLE_TAG, queue_depth);
>         return queue_depth;
>  }
>
> @@ -1454,11 +1457,9 @@ static void ata_scsi_qc_complete(struct ata_queued_cmd *qc)
>  static int ata_scmd_need_defer(struct ata_device *dev, int is_io)
>  {
>         struct ata_port *ap = dev->ap;
> +       int is_ncq = is_io && ata_ncq_enabled(dev);
>
> -       if (!(dev->flags & ATA_DFLAG_NCQ))
> -               return 0;
> -
> -       if (is_io) {
> +       if (is_ncq) {
>                 if (!ata_tag_valid(ap->active_tag))
>                         return 0;
>         } else {
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index 91bb8ce..4e4e365 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -1035,6 +1035,21 @@ static inline u8 ata_chk_status(struct ata_port *ap)
>         return ap->ops->check_status(ap);
>  }
>
> +/**
> + *     ata_ncq_enabled - Test whether NCQ is enabled
> + *     @dev: ATA device to test for
> + *
> + *     LOCKING:
> + *     spin_lock_irqsave(host lock)
> + *
> + *     RETURNS:
> + *     1 if NCQ is enabled for @dev, 0 otherwise.
> + */
> +static inline int ata_ncq_enabled(struct ata_device *dev)
> +{
> +       return (dev->flags & (ATA_DFLAG_PIO | ATA_DFLAG_NCQ_OFF |
> +                             ATA_DFLAG_NCQ)) == ATA_DFLAG_NCQ;
> +}
>
>  /**
>   *     ata_pause - Flush writes and pause 400 nanoseconds.
>
>
