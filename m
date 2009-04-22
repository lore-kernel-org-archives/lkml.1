Return-Path: <linux-kernel-owner+w=401wt.eu-S1753930AbZDVTJ3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753930AbZDVTJ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 15:09:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756213AbZDVTIu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 15:08:50 -0400
Received: from smtp-out.google.com ([216.239.33.17]:31965 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbZDVTIp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 15:08:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=p9doyuH+2Ls5/C7menGwN8AdrXeZGQmUpBxVp8J3EvggQVc0RGCQOv17A4SEDfNPZ
	0veq4PF0IohLRk9LK2dgg==
MIME-Version: 1.0
In-Reply-To: <20090422090929.GA14928@havoc.gtf.org>
References: <20090422090929.GA14928@havoc.gtf.org>
Date: Wed, 22 Apr 2009 12:08:38 -0700
Message-ID: <da824cf30904221208l42e41d38g5af52b1b3b5ea9a1@mail.gmail.com>
Subject: Re: [PATCH] libata: rewrite SCSI host scheme to be one per ATA host
From: Grant Grundler <grundler@google.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 2:09 AM, Jeff Garzik <jeff@garzik.org> wrote:
>
> Currently, libata creates a Scsi_Host per port.  This was originally
> done to leverage SCSI's infrastructure to arbitrate among master/slave
> devices, but is not needed for most modern SATA controllers.   And I
> _think_ it is not needed for master/slave if done properly, either.
>
> The patch below converts libata such that there is now a 1:1
> correspondence between struct Scsi_Host and struct ata_host.  ATA ports
> are represented as SCSI layer 'channels', which is more natural.

Jeff,
So far in reading this, the only reasons I gather for changing this
mapping are "not needed" and "is more natural". Data Center
environments (not just Google's) like to track disks in many different
ways, including the SCSI identifiers since this one "key" for physical
location. Breaking the current mappings is going to cause some people
a world of pain since they will need to manually build (and integrate)
old->new maps of the SCSI identifiers. Can you propose some real,
tangible benefit to making this change? (e.g. enables some other
feature)

Mark already pointed out this might cause issues with Error Handling
(forcing a review of all that code). So before triggering other
developers (e.g. HW vendors) do that kind of work I'd like to hear
what the reward is going to be at the end.

thanks,
grant

>
> This patch is an experiment, and not meant for upstream anytime soon.
> I just wanted to see what kind of effort would be required to get it
> to work.
>
> I was able to successfully boot the following patch on
> AHCI/x86-64/Fedora.
>
> It may work with other controllers -- TRY AT YOUR OWN RISK.  It will
> probably fail for master/slave configurations, and SAS & PMP also
> need looking at.  It yielded this lsscsi output on my AHCI box:
>
> [0:0:0:0]    disk    ATA      ST3500320AS      SD15  /dev/sda
> [0:2:0:0]    disk    ATA      G.SKILL 128GB SS 02.1  /dev/sdb
> [0:5:0:0]    cd/dvd  PIONEER  BD-ROM  BDC-202  1.04  /dev/sr0
>
> NOT-signed-off-by: me
>
>  drivers/ata/ahci.c            |    4
>  drivers/ata/libata-core.c     |   17 +--
>  drivers/ata/libata-eh.c       |   47 ++++++--
>  drivers/ata/libata-scsi.c     |  237 +++++++++++++++++++++---------------------
>  drivers/ata/libata.h          |    3
>  drivers/scsi/libsas/sas_ata.c |    2
>  include/linux/libata.h        |    9 -
>  7 files changed, 184 insertions(+), 135 deletions(-)
>
> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
> index 08186ec..b0468a8 100644
> --- a/drivers/ata/ahci.c
> +++ b/drivers/ata/ahci.c
> @@ -326,14 +326,18 @@ static ssize_t ahci_activity_store(struct ata_device *dev,
>  static void ahci_init_sw_activity(struct ata_link *link);
>
>  static struct device_attribute *ahci_shost_attrs[] = {
> +#if 0
>        &dev_attr_link_power_management_policy,
>        &dev_attr_em_message_type,
>        &dev_attr_em_message,
> +#endif
>        NULL
>  };
>
>  static struct device_attribute *ahci_sdev_attrs[] = {
> +#if 0
>        &dev_attr_sw_activity,
> +#endif
>        &dev_attr_unload_heads,
>        NULL
>  };
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 17c5d48..71f32dc 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -95,6 +95,7 @@ static void ata_dev_xfermask(struct ata_device *dev);
>  static unsigned long ata_dev_blacklisted(const struct ata_device *dev);
>
>  unsigned int ata_print_id = 1;
> +unsigned int ata_host_print_id = 1;
>  static struct workqueue_struct *ata_wq;
>
>  struct workqueue_struct *ata_aux_wq;
> @@ -2308,7 +2309,7 @@ static void ata_dev_config_ncq(struct ata_device *dev,
>                return;
>        }
>        if (ap->flags & ATA_FLAG_NCQ) {
> -               hdepth = min(ap->scsi_host->can_queue, ATA_MAX_QUEUE - 1);
> +               hdepth = min(ap->host->scsi_host->can_queue, ATA_MAX_QUEUE - 1);
>                dev->flags |= ATA_DFLAG_NCQ;
>        }
>
> @@ -5635,15 +5636,15 @@ static void ata_host_release(struct device *gendev, void *res)
>                if (!ap)
>                        continue;
>
> -               if (ap->scsi_host)
> -                       scsi_host_put(ap->scsi_host);
> -
>                kfree(ap->pmp_link);
>                kfree(ap->slave_link);
>                kfree(ap);
>                host->ports[i] = NULL;
>        }
>
> +       if (host->scsi_host)
> +               scsi_host_put(host->scsi_host);
> +
>        dev_set_drvdata(gendev, NULL);
>  }
>
> @@ -6089,6 +6090,8 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
>        for (i = 0; i < host->n_ports; i++)
>                host->ports[i]->print_id = ata_print_id++;
>
> +       host->print_id = ata_host_print_id++;
> +
>        rc = ata_scsi_add_hosts(host, sht);
>        if (rc)
>                return rc;
> @@ -6222,8 +6225,7 @@ static void ata_port_detach(struct ata_port *ap)
>        cancel_rearming_delayed_work(&ap->hotplug_task);
>
>  skip_eh:
> -       /* remove the associated SCSI host */
> -       scsi_remove_host(ap->scsi_host);
> +       return;
>  }
>
>  /**
> @@ -6242,6 +6244,9 @@ void ata_host_detach(struct ata_host *host)
>        for (i = 0; i < host->n_ports; i++)
>                ata_port_detach(host->ports[i]);
>
> +       /* remove the associated SCSI host */
> +       scsi_remove_host(host->scsi_host);
> +
>        /* the host is dead now, dissociate ACPI */
>        ata_acpi_dissociate(host);
>  }
> diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
> index 0183131..db8a66f 100644
> --- a/drivers/ata/libata-eh.c
> +++ b/drivers/ata/libata-eh.c
> @@ -466,14 +466,22 @@ static void ata_eh_clear_action(struct ata_link *link, struct ata_device *dev,
>  */
>  enum blk_eh_timer_return ata_scsi_timed_out(struct scsi_cmnd *cmd)
>  {
> -       struct Scsi_Host *host = cmd->device->host;
> -       struct ata_port *ap = ata_shost_to_port(host);
> +       struct Scsi_Host *shost = cmd->device->host;
> +       struct ata_port *ap;
> +       struct ata_host *host;
> +       struct ata_device *atadev;
>        unsigned long flags;
>        struct ata_queued_cmd *qc;
> -       enum blk_eh_timer_return ret;
> +       enum blk_eh_timer_return ret = BLK_EH_NOT_HANDLED;
>
>        DPRINTK("ENTER\n");
>
> +       host = ata_shost_to_host(shost);
> +       atadev = ata_scsi_find_dev(host, cmd->device);
> +       if (!atadev)
> +               goto out;
> +       ap = atadev->link->ap;
> +
>        if (ap->ops->error_handler) {
>                ret = BLK_EH_NOT_HANDLED;
>                goto out;
> @@ -532,13 +540,12 @@ static void ata_eh_unload(struct ata_port *ap)
>  *     RETURNS:
>  *     Zero.
>  */
> -void ata_scsi_error(struct Scsi_Host *host)
> +static void __ata_scsi_error(struct Scsi_Host *shost, struct ata_port *ap)
>  {
> -       struct ata_port *ap = ata_shost_to_port(host);
>        int i;
>        unsigned long flags;
>
> -       DPRINTK("ENTER\n");
> +       DPRINTK("ENTER, port_no %u\n", ap->port_no);
>
>        /* synchronize with port task */
>        ata_port_flush_task(ap);
> @@ -575,7 +582,7 @@ void ata_scsi_error(struct Scsi_Host *host)
>                if (ap->ops->lost_interrupt)
>                        ap->ops->lost_interrupt(ap);
>
> -               list_for_each_entry_safe(scmd, tmp, &host->eh_cmd_q, eh_entry) {
> +               list_for_each_entry_safe(scmd, tmp, &shost->eh_cmd_q, eh_entry) {
>                        struct ata_queued_cmd *qc;
>
>                        for (i = 0; i < ATA_MAX_QUEUE; i++) {
> @@ -698,7 +705,7 @@ void ata_scsi_error(struct Scsi_Host *host)
>                 * before EH completion, SCSI midlayer will
>                 * re-initiate EH.
>                 */
> -               host->host_eh_scheduled = 0;
> +               shost->host_eh_scheduled = 0;
>
>                spin_unlock_irqrestore(ap->lock, flags);
>        } else {
> @@ -707,7 +714,7 @@ void ata_scsi_error(struct Scsi_Host *host)
>        }
>
>        /* finish or retry handled scmd's and clean up */
> -       WARN_ON(host->host_failed || !list_empty(&host->eh_cmd_q));
> +       WARN_ON(shost->host_failed || !list_empty(&shost->eh_cmd_q));
>
>        scsi_eh_flush_done_q(&ap->eh_done_q);
>
> @@ -733,6 +740,24 @@ void ata_scsi_error(struct Scsi_Host *host)
>        DPRINTK("EXIT\n");
>  }
>
> +void ata_scsi_error(struct Scsi_Host *shost)
> +{
> +       struct ata_host *host = ata_shost_to_host(shost);
> +       unsigned int i;
> +
> +       DPRINTK("ENTER\n");
> +
> +       for (i = 0; i < host->n_ports; i++) {
> +               struct ata_port *ap = host->ports[i];
> +
> +               if (ap->pflags & ATA_PFLAG_EH_PENDING)
> +                       __ata_scsi_error(shost, ap);
> +       }
> +
> +       DPRINTK("EXIT\n");
> +}
> +
> +
>  /**
>  *     ata_port_wait_eh - Wait for the currently pending EH to complete
>  *     @ap: Port to wait EH for
> @@ -761,7 +786,7 @@ void ata_port_wait_eh(struct ata_port *ap)
>        spin_unlock_irqrestore(ap->lock, flags);
>
>        /* make sure SCSI EH is complete */
> -       if (scsi_host_in_recovery(ap->scsi_host)) {
> +       if (scsi_host_in_recovery(ap->host->scsi_host)) {
>                msleep(10);
>                goto retry;
>        }
> @@ -901,7 +926,7 @@ void ata_port_schedule_eh(struct ata_port *ap)
>                return;
>
>        ata_eh_set_pending(ap, 1);
> -       scsi_schedule_eh(ap->scsi_host);
> +       scsi_schedule_eh(ap->host->scsi_host);
>
>        DPRINTK("port EH scheduled\n");
>  }
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 2733b0c..7aa6aa6 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -58,10 +58,8 @@ static u8 ata_scsi_rbuf[ATA_SCSI_RBUF_SIZE];
>
>  typedef unsigned int (*ata_xlat_func_t)(struct ata_queued_cmd *qc);
>
> -static struct ata_device *__ata_scsi_find_dev(struct ata_port *ap,
> +static struct ata_device *__ata_scsi_find_dev(struct ata_host *,
>                                        const struct scsi_device *scsidev);
> -static struct ata_device *ata_scsi_find_dev(struct ata_port *ap,
> -                                           const struct scsi_device *scsidev);
>  static int ata_scsi_user_scan(struct Scsi_Host *shost, unsigned int channel,
>                              unsigned int id, unsigned int lun);
>
> @@ -136,6 +134,7 @@ static const char *ata_scsi_lpm_get(enum link_pm policy)
>        return NULL;
>  }
>
> +#if 0
>  static ssize_t ata_scsi_lpm_put(struct device *dev,
>                                struct device_attribute *attr,
>                                const char *buf, size_t count)
> @@ -183,6 +182,7 @@ ata_scsi_lpm_show(struct device *dev, struct device_attribute *attr, char *buf)
>  DEVICE_ATTR(link_power_management_policy, S_IRUGO | S_IWUSR,
>                ata_scsi_lpm_show, ata_scsi_lpm_put);
>  EXPORT_SYMBOL_GPL(dev_attr_link_power_management_policy);
> +#endif
>
>  static ssize_t ata_scsi_park_show(struct device *device,
>                                  struct device_attribute *attr, char *buf)
> @@ -190,19 +190,21 @@ static ssize_t ata_scsi_park_show(struct device *device,
>        struct scsi_device *sdev = to_scsi_device(device);
>        struct ata_port *ap;
>        struct ata_link *link;
> +       struct ata_host *host;
>        struct ata_device *dev;
>        unsigned long flags, now;
>        unsigned int uninitialized_var(msecs);
>        int rc = 0;
>
> -       ap = ata_shost_to_port(sdev->host);
> +       host = ata_shost_to_host(sdev->host);
>
> -       spin_lock_irqsave(ap->lock, flags);
> -       dev = ata_scsi_find_dev(ap, sdev);
> +       spin_lock_irqsave(&host->lock, flags);
> +       dev = ata_scsi_find_dev(host, sdev);
>        if (!dev) {
>                rc = -ENODEV;
>                goto unlock;
>        }
> +       ap = dev->link->ap;
>        if (dev->flags & ATA_DFLAG_NO_UNLOAD) {
>                rc = -EOPNOTSUPP;
>                goto unlock;
> @@ -218,7 +220,7 @@ static ssize_t ata_scsi_park_show(struct device *device,
>                msecs = 0;
>
>  unlock:
> -       spin_unlock_irq(ap->lock);
> +       spin_unlock_irq(&host->lock);
>
>        return rc ? rc : snprintf(buf, 20, "%u\n", msecs);
>  }
> @@ -230,6 +232,7 @@ static ssize_t ata_scsi_park_store(struct device *device,
>        struct scsi_device *sdev = to_scsi_device(device);
>        struct ata_port *ap;
>        struct ata_device *dev;
> +       struct ata_host *host;
>        long int input;
>        unsigned long flags;
>        int rc;
> @@ -242,14 +245,15 @@ static ssize_t ata_scsi_park_store(struct device *device,
>                input = ATA_TMOUT_MAX_PARK;
>        }
>
> -       ap = ata_shost_to_port(sdev->host);
> +       host = ata_shost_to_host(sdev->host);
>
> -       spin_lock_irqsave(ap->lock, flags);
> -       dev = ata_scsi_find_dev(ap, sdev);
> +       spin_lock_irqsave(&host->lock, flags);
> +       dev = ata_scsi_find_dev(host, sdev);
>        if (unlikely(!dev)) {
>                rc = -ENODEV;
>                goto unlock;
>        }
> +       ap = dev->link->ap;
>        if (dev->class != ATA_DEV_ATA) {
>                rc = -EOPNOTSUPP;
>                goto unlock;
> @@ -276,7 +280,7 @@ static ssize_t ata_scsi_park_store(struct device *device,
>                }
>        }
>  unlock:
> -       spin_unlock_irqrestore(ap->lock, flags);
> +       spin_unlock_irqrestore(&host->lock, flags);
>
>        return rc ? rc : len;
>  }
> @@ -291,6 +295,7 @@ static void ata_scsi_set_sense(struct scsi_cmnd *cmd, u8 sk, u8 asc, u8 ascq)
>        scsi_build_sense_buffer(0, cmd->sense_buffer, sk, asc, ascq);
>  }
>
> +#if 0
>  static ssize_t
>  ata_scsi_em_message_store(struct device *dev, struct device_attribute *attr,
>                          const char *buf, size_t count)
> @@ -335,8 +340,9 @@ ata_scsi_activity_show(struct device *dev, struct device_attribute *attr,
>                char *buf)
>  {
>        struct scsi_device *sdev = to_scsi_device(dev);
> -       struct ata_port *ap = ata_shost_to_port(sdev->host);
> -       struct ata_device *atadev = ata_scsi_find_dev(ap, sdev);
> +       struct ata_host *host = ata_shost_to_host(sdev->host);
> +       struct ata_device *atadev = ata_scsi_find_dev(host, sdev);
> +       struct ata_port *ap = atadev->ap;
>
>        if (ap->ops->sw_activity_show && (ap->flags & ATA_FLAG_SW_ACTIVITY))
>                return ap->ops->sw_activity_show(atadev, buf);
> @@ -348,8 +354,9 @@ ata_scsi_activity_store(struct device *dev, struct device_attribute *attr,
>        const char *buf, size_t count)
>  {
>        struct scsi_device *sdev = to_scsi_device(dev);
> -       struct ata_port *ap = ata_shost_to_port(sdev->host);
> -       struct ata_device *atadev = ata_scsi_find_dev(ap, sdev);
> +       struct ata_host *host = ata_shost_to_host(sdev->host);
> +       struct ata_device *atadev = ata_scsi_find_dev(host, sdev);
> +       struct ata_port *ap = atadev->ap;
>        enum sw_activity val;
>        int rc;
>
> @@ -369,6 +376,7 @@ ata_scsi_activity_store(struct device *dev, struct device_attribute *attr,
>  DEVICE_ATTR(sw_activity, S_IWUGO | S_IRUGO, ata_scsi_activity_show,
>                        ata_scsi_activity_store);
>  EXPORT_SYMBOL_GPL(dev_attr_sw_activity);
> +#endif
>
>  struct device_attribute *ata_common_sdev_attrs[] = {
>        &dev_attr_unload_heads,
> @@ -425,10 +433,10 @@ int ata_std_bios_param(struct scsi_device *sdev, struct block_device *bdev,
>  *     RETURNS:
>  *     Zero on success, negative errno on error.
>  */
> -static int ata_get_identity(struct ata_port *ap, struct scsi_device *sdev,
> +static int ata_get_identity(struct ata_host *host, struct scsi_device *sdev,
>                            void __user *arg)
>  {
> -       struct ata_device *dev = ata_scsi_find_dev(ap, sdev);
> +       struct ata_device *dev = ata_scsi_find_dev(host, sdev);
>        u16 __user *dst = arg;
>        char buf[40];
>
> @@ -656,11 +664,18 @@ static int ata_ioc32(struct ata_port *ap)
>        return 0;
>  }
>
> -int ata_sas_scsi_ioctl(struct ata_port *ap, struct scsi_device *scsidev,
> +int ata_sas_scsi_ioctl(struct ata_host *host, struct scsi_device *scsidev,
>                     int cmd, void __user *arg)
>  {
>        int val = -EINVAL, rc = -EINVAL;
>        unsigned long flags;
> +       struct ata_port *ap;
> +       struct ata_device *atadev;
> +
> +       atadev = ata_scsi_find_dev(host, scsidev);
> +       if (!atadev)
> +               return -ENOENT;
> +       ap = atadev->link->ap;
>
>        switch (cmd) {
>        case ATA_IOC_GET_IO32:
> @@ -688,7 +703,7 @@ int ata_sas_scsi_ioctl(struct ata_port *ap, struct scsi_device *scsidev,
>                return rc;
>
>        case HDIO_GET_IDENTITY:
> -               return ata_get_identity(ap, scsidev, arg);
> +               return ata_get_identity(host, scsidev, arg);
>
>        case HDIO_DRIVE_CMD:
>                if (!capable(CAP_SYS_ADMIN) || !capable(CAP_SYS_RAWIO))
> @@ -711,7 +726,7 @@ EXPORT_SYMBOL_GPL(ata_sas_scsi_ioctl);
>
>  int ata_scsi_ioctl(struct scsi_device *scsidev, int cmd, void __user *arg)
>  {
> -       return ata_sas_scsi_ioctl(ata_shost_to_port(scsidev->host),
> +       return ata_sas_scsi_ioctl(ata_shost_to_host(scsidev->host),
>                                scsidev, cmd, arg);
>  }
>  EXPORT_SYMBOL_GPL(ata_scsi_ioctl);
> @@ -1157,8 +1172,8 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
>
>  int ata_scsi_slave_config(struct scsi_device *sdev)
>  {
> -       struct ata_port *ap = ata_shost_to_port(sdev->host);
> -       struct ata_device *dev = __ata_scsi_find_dev(ap, sdev);
> +       struct ata_host *host = ata_shost_to_host(sdev->host);
> +       struct ata_device *dev = __ata_scsi_find_dev(host, sdev);
>        int rc = 0;
>
>        ata_scsi_sdev_config(sdev);
> @@ -1185,27 +1200,34 @@ int ata_scsi_slave_config(struct scsi_device *sdev)
>  */
>  void ata_scsi_slave_destroy(struct scsi_device *sdev)
>  {
> -       struct ata_port *ap = ata_shost_to_port(sdev->host);
> +       struct ata_host *host = ata_shost_to_host(sdev->host);
>        struct request_queue *q = sdev->request_queue;
>        unsigned long flags;
>        struct ata_device *dev;
> +       bool new_eh = true;
>
> -       if (!ap->ops->error_handler)
> -               return;
> -
> -       spin_lock_irqsave(ap->lock, flags);
> -       dev = __ata_scsi_find_dev(ap, sdev);
> +       spin_lock_irqsave(&host->lock, flags);
> +       dev = __ata_scsi_find_dev(host, sdev);
>        if (dev && dev->sdev) {
> +               struct ata_port *ap = dev->link->ap;
> +
> +               if (!ap->ops->error_handler)
> +                       new_eh = false;
> +
> +               else {
>                /* SCSI device already in CANCEL state, no need to offline it */
>                dev->sdev = NULL;
>                dev->flags |= ATA_DFLAG_DETACH;
>                ata_port_schedule_eh(ap);
> +               }
>        }
> -       spin_unlock_irqrestore(ap->lock, flags);
> +       spin_unlock_irqrestore(&host->lock, flags);
>
> -       kfree(q->dma_drain_buffer);
> -       q->dma_drain_buffer = NULL;
> -       q->dma_drain_size = 0;
> +       if (new_eh) {
> +               kfree(q->dma_drain_buffer);
> +               q->dma_drain_buffer = NULL;
> +               q->dma_drain_size = 0;
> +       }
>  }
>
>  /**
> @@ -1225,25 +1247,25 @@ void ata_scsi_slave_destroy(struct scsi_device *sdev)
>  */
>  int ata_scsi_change_queue_depth(struct scsi_device *sdev, int queue_depth)
>  {
> -       struct ata_port *ap = ata_shost_to_port(sdev->host);
> +       struct ata_host *host = ata_shost_to_host(sdev->host);
>        struct ata_device *dev;
>        unsigned long flags;
>
>        if (queue_depth < 1 || queue_depth == sdev->queue_depth)
>                return sdev->queue_depth;
>
> -       dev = ata_scsi_find_dev(ap, sdev);
> +       dev = ata_scsi_find_dev(host, sdev);
>        if (!dev || !ata_dev_enabled(dev))
>                return sdev->queue_depth;
>
>        /* NCQ enabled? */
> -       spin_lock_irqsave(ap->lock, flags);
> +       spin_lock_irqsave(&host->lock, flags);
>        dev->flags &= ~ATA_DFLAG_NCQ_OFF;
>        if (queue_depth == 1 || !ata_ncq_enabled(dev)) {
>                dev->flags |= ATA_DFLAG_NCQ_OFF;
>                queue_depth = 1;
>        }
> -       spin_unlock_irqrestore(ap->lock, flags);
> +       spin_unlock_irqrestore(&host->lock, flags);
>
>        /* limit and apply queue depth */
>        queue_depth = min(queue_depth, sdev->host->can_queue);
> @@ -2690,21 +2712,20 @@ static struct ata_device *ata_find_dev(struct ata_port *ap, int devno)
>        return NULL;
>  }
>
> -static struct ata_device *__ata_scsi_find_dev(struct ata_port *ap,
> +static struct ata_device *__ata_scsi_find_dev(struct ata_host *host,
>                                              const struct scsi_device *scsidev)
>  {
>        int devno;
> +       struct ata_port *ap;
>
> -       /* skip commands not addressed to targets we simulate */
> -       if (!sata_pmp_attached(ap)) {
> -               if (unlikely(scsidev->channel || scsidev->lun))
> -                       return NULL;
> -               devno = scsidev->id;
> -       } else {
> -               if (unlikely(scsidev->id || scsidev->lun))
> -                       return NULL;
> -               devno = scsidev->channel;
> -       }
> +       if (scsidev->channel > host->n_ports)
> +               return NULL;
> +
> +       ap = host->ports[scsidev->channel];
> +       if (ata_port_is_dummy(ap))
> +               return NULL;
> +
> +       devno = scsidev->id;
>
>        return ata_find_dev(ap, devno);
>  }
> @@ -2725,10 +2746,10 @@ static struct ata_device *__ata_scsi_find_dev(struct ata_port *ap,
>  *     RETURNS:
>  *     Associated ATA device, or %NULL if not found.
>  */
> -static struct ata_device *
> -ata_scsi_find_dev(struct ata_port *ap, const struct scsi_device *scsidev)
> +struct ata_device *
> +ata_scsi_find_dev(struct ata_host *host, const struct scsi_device *scsidev)
>  {
> -       struct ata_device *dev = __ata_scsi_find_dev(ap, scsidev);
> +       struct ata_device *dev = __ata_scsi_find_dev(host, scsidev);
>
>        if (unlikely(!dev || !ata_dev_enabled(dev)))
>                return NULL;
> @@ -2983,15 +3004,13 @@ static inline ata_xlat_func_t ata_get_xlat_func(struct ata_device *dev, u8 cmd)
>  *     Prints the contents of a SCSI command via printk().
>  */
>
> -static inline void ata_scsi_dump_cdb(struct ata_port *ap,
> -                                    struct scsi_cmnd *cmd)
> +static inline void ata_scsi_dump_cdb(struct scsi_cmnd *cmd)
>  {
>  #ifdef ATA_DEBUG
>        struct scsi_device *scsidev = cmd->device;
>        u8 *scsicmd = cmd->cmnd;
>
> -       DPRINTK("CDB (%u:%d,%d,%d) %02x %02x %02x %02x %02x %02x %02x %02x %02x\n",
> -               ap->print_id,
> +       DPRINTK("CDB (%d,%d,%d) %02x %02x %02x %02x %02x %02x %02x %02x %02x\n",
>                scsidev->channel, scsidev->id, scsidev->lun,
>                scsicmd[0], scsicmd[1], scsicmd[2], scsicmd[3],
>                scsicmd[4], scsicmd[5], scsicmd[6], scsicmd[7],
> @@ -3069,20 +3088,20 @@ static inline int __ata_scsi_queuecmd(struct scsi_cmnd *scmd,
>  */
>  int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
>  {
> -       struct ata_port *ap;
>        struct ata_device *dev;
> +       struct ata_host *host;
>        struct scsi_device *scsidev = cmd->device;
>        struct Scsi_Host *shost = scsidev->host;
>        int rc = 0;
>
> -       ap = ata_shost_to_port(shost);
> +       host = ata_shost_to_host(shost);
>
>        spin_unlock(shost->host_lock);
> -       spin_lock(ap->lock);
> +       spin_lock(&host->lock);
>
> -       ata_scsi_dump_cdb(ap, cmd);
> +       ata_scsi_dump_cdb(cmd);
>
> -       dev = ata_scsi_find_dev(ap, scsidev);
> +       dev = ata_scsi_find_dev(host, scsidev);
>        if (likely(dev))
>                rc = __ata_scsi_queuecmd(cmd, done, dev);
>        else {
> @@ -3090,7 +3109,7 @@ int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *))
>                done(cmd);
>        }
>
> -       spin_unlock(ap->lock);
> +       spin_unlock(&host->lock);
>        spin_lock(shost->host_lock);
>        return rc;
>  }
> @@ -3217,56 +3236,43 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
>
>  int ata_scsi_add_hosts(struct ata_host *host, struct scsi_host_template *sht)
>  {
> -       int i, rc;
> -
> -       for (i = 0; i < host->n_ports; i++) {
> -               struct ata_port *ap = host->ports[i];
> -               struct Scsi_Host *shost;
> +       int rc;
> +       struct Scsi_Host *shost;
>
> -               rc = -ENOMEM;
> -               shost = scsi_host_alloc(sht, sizeof(struct ata_port *));
> -               if (!shost)
> -                       goto err_alloc;
> +       shost = scsi_host_alloc(sht, sizeof(struct ata_host *));
> +       if (!shost)
> +               return -ENOMEM;
>
> -               *(struct ata_port **)&shost->hostdata[0] = ap;
> -               ap->scsi_host = shost;
> +       *(struct ata_host **)&shost->hostdata[0] = host;
> +       host->scsi_host = shost;
>
> -               shost->transportt = &ata_scsi_transport_template;
> -               shost->unique_id = ap->print_id;
> -               shost->max_id = 16;
> -               shost->max_lun = 1;
> -               shost->max_channel = 1;
> -               shost->max_cmd_len = 16;
> +       shost->transportt = &ata_scsi_transport_template;
> +       shost->unique_id = host->print_id;
> +       shost->max_id = 32;
> +       shost->max_lun = 1;
> +       shost->max_channel = 32;
> +       shost->max_cmd_len = 16;
>
> -               /* Schedule policy is determined by ->qc_defer()
> -                * callback and it needs to see every deferred qc.
> -                * Set host_blocked to 1 to prevent SCSI midlayer from
> -                * automatically deferring requests.
> -                */
> -               shost->max_host_blocked = 1;
> +       /* Schedule policy is determined by ->qc_defer()
> +        * callback and it needs to see every deferred qc.
> +        * Set host_blocked to 1 to prevent SCSI midlayer from
> +        * automatically deferring requests.
> +        */
> +       shost->max_host_blocked = 1;
>
> -               rc = scsi_add_host(ap->scsi_host, ap->host->dev);
> -               if (rc)
> -                       goto err_add;
> +       rc = scsi_add_host(shost, host->dev);
> +       if (rc) {
> +               scsi_host_put(shost);
> +               return rc;
>        }
>
>        return 0;
> -
> - err_add:
> -       scsi_host_put(host->ports[i]->scsi_host);
> - err_alloc:
> -       while (--i >= 0) {
> -               struct Scsi_Host *shost = host->ports[i]->scsi_host;
> -
> -               scsi_remove_host(shost);
> -               scsi_host_put(shost);
> -       }
> -       return rc;
>  }
>
>  void ata_scsi_scan_host(struct ata_port *ap, int sync)
>  {
>        int tries = 5;
> +       struct ata_host *host = ap->host;
>        struct ata_device *last_failed_dev = NULL;
>        struct ata_link *link;
>        struct ata_device *dev;
> @@ -3278,7 +3284,7 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
>        ata_for_each_link(link, ap, EDGE) {
>                ata_for_each_dev(dev, link, ENABLED) {
>                        struct scsi_device *sdev;
> -                       int channel = 0, id = 0;
> +                       int id = 0;
>
>                        if (dev->sdev)
>                                continue;
> @@ -3286,9 +3292,10 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
>                        if (ata_is_host_link(link))
>                                id = dev->devno;
>                        else
> -                               channel = link->pmp;
> +                               id = link->pmp;
>
> -                       sdev = __scsi_add_device(ap->scsi_host, channel, id, 0,
> +                       sdev = __scsi_add_device(host->scsi_host,
> +                                                ap->port_no, id, 0,
>                                                 NULL);
>                        if (!IS_ERR(sdev)) {
>                                dev->sdev = sdev;
> @@ -3376,6 +3383,7 @@ int ata_scsi_offline_dev(struct ata_device *dev)
>  static void ata_scsi_remove_dev(struct ata_device *dev)
>  {
>        struct ata_port *ap = dev->link->ap;
> +       struct ata_host *host = ap->host;
>        struct scsi_device *sdev;
>        unsigned long flags;
>
> @@ -3385,7 +3393,7 @@ static void ata_scsi_remove_dev(struct ata_device *dev)
>         * be removed if there is __scsi_device_get() interface which
>         * increments reference counts regardless of device state.
>         */
> -       mutex_lock(&ap->scsi_host->scan_mutex);
> +       mutex_lock(&host->scsi_host->scan_mutex);
>        spin_lock_irqsave(ap->lock, flags);
>
>        /* clearing dev->sdev is protected by host lock */
> @@ -3411,7 +3419,7 @@ static void ata_scsi_remove_dev(struct ata_device *dev)
>        }
>
>        spin_unlock_irqrestore(ap->lock, flags);
> -       mutex_unlock(&ap->scsi_host->scan_mutex);
> +       mutex_unlock(&host->scsi_host->scan_mutex);
>
>        if (sdev) {
>                ata_dev_printk(dev, KERN_INFO, "detaching (SCSI %s)\n",
> @@ -3517,25 +3525,28 @@ void ata_scsi_hotplug(struct work_struct *work)
>  static int ata_scsi_user_scan(struct Scsi_Host *shost, unsigned int channel,
>                              unsigned int id, unsigned int lun)
>  {
> -       struct ata_port *ap = ata_shost_to_port(shost);
> +       struct ata_port *ap;
> +       struct ata_host *host = ata_shost_to_host(shost);
>        unsigned long flags;
>        int devno, rc = 0;
>
> +       if (channel == SCAN_WILD_CARD)
> +               ap = host->ports[0];
> +       else {
> +               if (channel > host->n_ports)
> +                       return -EINVAL;
> +               ap = host->ports[channel];
> +       }
> +
>        if (!ap->ops->error_handler)
>                return -EOPNOTSUPP;
>
>        if (lun != SCAN_WILD_CARD && lun)
>                return -EINVAL;
>
> -       if (!sata_pmp_attached(ap)) {
> -               if (channel != SCAN_WILD_CARD && channel)
> -                       return -EINVAL;
> -               devno = id;
> -       } else {
> -               if (id != SCAN_WILD_CARD && id)
> -                       return -EINVAL;
> -               devno = channel;
> -       }
> +       if (id != SCAN_WILD_CARD && id)
> +               return -EINVAL;
> +       devno = id;
>
>        spin_lock_irqsave(ap->lock, flags);
>
> @@ -3749,7 +3760,7 @@ int ata_sas_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *),
>  {
>        int rc = 0;
>
> -       ata_scsi_dump_cdb(ap, cmd);
> +       ata_scsi_dump_cdb(cmd);
>
>        if (likely(ata_dev_enabled(ap->link.device)))
>                rc = __ata_scsi_queuecmd(cmd, done, ap->link.device);
> diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
> index 89a1e00..af890b4 100644
> --- a/drivers/ata/libata.h
> +++ b/drivers/ata/libata.h
> @@ -205,4 +205,7 @@ extern u8 ata_irq_on(struct ata_port *ap);
>  extern void ata_pio_task(struct work_struct *work);
>  #endif /* CONFIG_ATA_SFF */
>
> +struct ata_device *
> +ata_scsi_find_dev(struct ata_host *host, const struct scsi_device *scsidev);
> +
>  #endif /* __LIBATA_H__ */
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_ata.c
> index e155011..758df0b 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -375,6 +375,7 @@ int sas_ata_init_host_and_port(struct domain_device *found_dev,
>                      ha->dev,
>                      sata_port_info.flags,
>                      &sas_sata_ops);
> +       found_dev->sata_dev.ata_host.scsi_host = shost;
>        ap = ata_sas_port_alloc(&found_dev->sata_dev.ata_host,
>                                &sata_port_info,
>                                shost);
> @@ -385,7 +386,6 @@ int sas_ata_init_host_and_port(struct domain_device *found_dev,
>
>        ap->private_data = found_dev;
>        ap->cbl = ATA_CBL_SATA;
> -       ap->scsi_host = shost;
>        found_dev->sata_dev.ap = ap;
>
>        return 0;
> diff --git a/include/linux/libata.h b/include/linux/libata.h
> index 3d501db..2ea4dce 100644
> --- a/include/linux/libata.h
> +++ b/include/linux/libata.h
> @@ -507,10 +507,12 @@ struct ata_ioports {
>  #endif /* CONFIG_ATA_SFF */
>
>  struct ata_host {
> +       struct Scsi_Host        *scsi_host; /* our co-allocated scsi host */
>        spinlock_t              lock;
>        struct device           *dev;
>        void __iomem * const    *iomap;
>        unsigned int            n_ports;
> +       unsigned int            print_id; /* user visible unique host ID */
>        void                    *private_data;
>        struct ata_port_operations *ops;
>        unsigned long           flags;
> @@ -690,7 +692,6 @@ struct ata_link {
>  };
>
>  struct ata_port {
> -       struct Scsi_Host        *scsi_host; /* our co-allocated scsi host */
>        struct ata_port_operations *ops;
>        spinlock_t              *lock;
>        /* Flags owned by the EH context. Only EH should touch these once the
> @@ -947,7 +948,7 @@ extern void ata_host_init(struct ata_host *, struct device *,
>  extern int ata_scsi_detect(struct scsi_host_template *sht);
>  extern int ata_scsi_ioctl(struct scsi_device *dev, int cmd, void __user *arg);
>  extern int ata_scsi_queuecmd(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *));
> -extern int ata_sas_scsi_ioctl(struct ata_port *ap, struct scsi_device *dev,
> +extern int ata_sas_scsi_ioctl(struct ata_host *, struct scsi_device *dev,
>                            int cmd, void __user *arg);
>  extern void ata_sas_port_destroy(struct ata_port *);
>  extern struct ata_port *ata_sas_port_alloc(struct ata_host *,
> @@ -1472,9 +1473,9 @@ static inline unsigned int __ac_err_mask(u8 status)
>        return mask;
>  }
>
> -static inline struct ata_port *ata_shost_to_port(struct Scsi_Host *host)
> +static inline struct ata_host *ata_shost_to_host(struct Scsi_Host *host)
>  {
> -       return *(struct ata_port **)&host->hostdata[0];
> +       return *(struct ata_host **)&host->hostdata[0];
>  }
>
>  static inline int ata_check_ready(u8 status)
>
