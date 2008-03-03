Return-Path: <linux-kernel-owner+w=401wt.eu-S1756778AbYCCQpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778AbYCCQpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 11:45:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754435AbYCCQpo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 11:45:44 -0500
Received: from ug-out-1314.google.com ([66.249.92.169]:47403 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754358AbYCCQpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 11:45:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=tayCVg5RDhb2XvqPf2LI/ViJhXYch3L9XuBaRtJFGf1bzYyyJQThVcLUHZ6n4sodGtcWdNOTrjTJikJO3BJBIF2Cj+EtmoGG0umTp0Rv25Vo/hlgnF1F0Zx67wy4f3E3ImiPPAKwfGFAwkI5XeOsDz6rmkxrQCnEo/1nr4D/sRw=
Message-ID: <59ad55d30803030845n419ac813kaa99e5ee7657dc52@mail.gmail.com>
Date: Mon, 3 Mar 2008 11:45:41 -0500
From: "=?UTF-8?Q?Kristian_H=C3=B8gsberg?=" <krh@bitplanet.net>
To: "Stefan Richter" <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 2/5] firewire: fix crash in automatic module unloading
Cc: linux1394-devel@lists.sourceforge.net, "Jarod Wilson" <jwilson@redhat.com>,
       linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.ce9862ad477be41e@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <tkrat.5dc141579386d159@s5r6.in-berlin.de>
	 <tkrat.ce9862ad477be41e@s5r6.in-berlin.de>
X-Google-Sender-Auth: 7752f5539a55a2f9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2008 at 12:59 PM, Stefan Richter
<stefanr@s5r6.in-berlin.de> wrote:
...
>  Note that this crash happened _after_ firewire-core was unloaded.  The
>  shared workqueue tried to run firewire-core's device initialization jobs
>  or similar jobs.

Yeah, those pesky workqueue jobs :)

>  The fix makes sure that firewire-ohci and hence firewire-core is not
>  unloaded before all device shutdown jobs have been completed.  This is
>  determined by the count of device initializations minus device releases.

That's probably fine; I thought about this approach when I did the
dummy stuff, but I wanted something that would let me unload the
module immediately.  I guess in practice it doesn't make a big
difference, and this certainly is simpler.

I would want to use a kref and a completion for tracking this though
instead of the atomic.  Just use kref_get() instead of incrementing
the atomic and use kref_put() instead of decrementing it.  The release
function for kref_put() should complete the completion struct and
instead of the busy loop in fw_core_remove_card() we just wait for the
completion.  And I'm not sure I agree that it's a device_count, it
really just is a ref-count.  The core should also hold a reference to
the card and release it in fw_core_remove_card(), just before waiting
on the completion.  I do like how you moved the kfree() of the fw_ohci
struct back into fw-ohci.c where it balances the kzalloc() in
pci_probe().

>  Also skip useless retries in the node initialization job if the node is
>  to be shut down.
>
>  Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
>  ---
>   drivers/firewire/fw-card.c        |   10 +++++++++-
>   drivers/firewire/fw-device.c      |   21 ++++++---------------
>   drivers/firewire/fw-device.h      |   16 ++++++++++++++--
>   drivers/firewire/fw-sbp2.c        |    4 ++++
>   drivers/firewire/fw-transaction.h |    2 ++
>   5 files changed, 35 insertions(+), 18 deletions(-)
>
>  Index: linux/drivers/firewire/fw-card.c
>  ===================================================================
>  --- linux.orig/drivers/firewire/fw-card.c
>  +++ linux/drivers/firewire/fw-card.c
>  @@ -18,6 +18,7 @@
>
>   #include <linux/module.h>
>   #include <linux/errno.h>
>  +#include <linux/delay.h>
>   #include <linux/device.h>
>   #include <linux/mutex.h>
>   #include <linux/crc-itu-t.h>
>  @@ -398,6 +399,7 @@ fw_card_initialize(struct fw_card *card,
>         static atomic_t index = ATOMIC_INIT(-1);
>
>         kref_init(&card->kref);
>  +       atomic_set(&card->device_count, 0);
>         card->index = atomic_inc_return(&index);
>         card->driver = driver;
>         card->device = device;
>  @@ -528,8 +530,14 @@ fw_core_remove_card(struct fw_card *card
>         card->driver = &dummy_driver;
>
>         fw_destroy_nodes(card);
>  -       flush_scheduled_work();
>  +       /*
>  +        * Wait for all device workqueue jobs to finish.  Otherwise the
>  +        * firewire-core module could be unloaded before the jobs ran.
>  +        */
>  +       while (atomic_read(&card->device_count) > 0)
>  +               msleep(100);
>
>  +       cancel_delayed_work_sync(&card->work);
>         fw_flush_transactions(card);
>         del_timer_sync(&card->flush_timer);
>
>  Index: linux/drivers/firewire/fw-device.c
>  ===================================================================
>  --- linux.orig/drivers/firewire/fw-device.c
>  +++ linux/drivers/firewire/fw-device.c
>  @@ -150,21 +150,10 @@ struct bus_type fw_bus_type = {
>   };
>   EXPORT_SYMBOL(fw_bus_type);
>
>  -struct fw_device *fw_device_get(struct fw_device *device)
>  -{
>  -       get_device(&device->device);
>  -
>  -       return device;
>  -}
>  -
>  -void fw_device_put(struct fw_device *device)
>  -{
>  -       put_device(&device->device);
>  -}
>  -
>   static void fw_device_release(struct device *dev)
>   {
>         struct fw_device *device = fw_device(dev);
>  +       struct fw_card *card = device->card;
>         unsigned long flags;
>
>         /*
>  @@ -176,9 +165,9 @@ static void fw_device_release(struct dev
>         spin_unlock_irqrestore(&device->card->lock, flags);
>
>         fw_node_put(device->node);
>  -       fw_card_put(device->card);
>         kfree(device->config_rom);
>         kfree(device);
>  +       atomic_dec(&card->device_count);
>   }
>
>   int fw_device_enable_phys_dma(struct fw_device *device)
>  @@ -668,7 +657,8 @@ static void fw_device_init(struct work_s
>          */
>
>         if (read_bus_info_block(device, device->generation) < 0) {
>  -               if (device->config_rom_retries < MAX_RETRIES) {
>  +               if (device->config_rom_retries < MAX_RETRIES &&
>  +                   atomic_read(&device->state) == FW_DEVICE_INITIALIZING) {
>                         device->config_rom_retries++;
>                         schedule_delayed_work(&device->work, RETRY_DELAY);
>                 } else {
>  @@ -805,7 +795,8 @@ void fw_node_event(struct fw_card *card,
>                  */
>                 device_initialize(&device->device);
>                 atomic_set(&device->state, FW_DEVICE_INITIALIZING);
>  -               device->card = fw_card_get(card);
>  +               atomic_inc(&card->device_count);
>  +               device->card = card;
>                 device->node = fw_node_get(node);
>                 device->node_id = node->node_id;
>                 device->generation = card->generation;
>  Index: linux/drivers/firewire/fw-sbp2.c
>  ===================================================================
>  --- linux.orig/drivers/firewire/fw-sbp2.c
>  +++ linux/drivers/firewire/fw-sbp2.c
>  @@ -757,6 +757,7 @@ static void sbp2_release_target(struct k
>         struct sbp2_logical_unit *lu, *next;
>         struct Scsi_Host *shost =
>                 container_of((void *)tgt, struct Scsi_Host, hostdata[0]);
>  +       struct fw_device *device = fw_device(tgt->unit->device.parent);
>
>         /* prevent deadlocks */
>         sbp2_unblock(tgt);
>  @@ -778,6 +779,7 @@ static void sbp2_release_target(struct k
>
>         put_device(&tgt->unit->device);
>         scsi_host_put(shost);
>  +       fw_device_put(device);
>   }
>
>   static struct workqueue_struct *sbp2_wq;
>  @@ -1080,6 +1082,8 @@ static int sbp2_probe(struct device *dev
>         if (scsi_add_host(shost, &unit->device) < 0)
>                 goto fail_shost_put;
>
>  +       fw_device_get(device);
>  +
>         /* Initialize to values that won't match anything in our table. */
>         firmware_revision = 0xff000000;
>         model = 0xff000000;
>  Index: linux/drivers/firewire/fw-transaction.h
>  ===================================================================
>  --- linux.orig/drivers/firewire/fw-transaction.h
>  +++ linux/drivers/firewire/fw-transaction.h
>  @@ -26,6 +26,7 @@
>   #include <linux/fs.h>
>   #include <linux/dma-mapping.h>
>   #include <linux/firewire-constants.h>
>  +#include <asm/atomic.h>
>
>   #define TCODE_IS_READ_REQUEST(tcode)   (((tcode) & ~1) == 4)
>   #define TCODE_IS_BLOCK_PACKET(tcode)   (((tcode) &  1) != 0)
>  @@ -219,6 +220,7 @@ extern struct bus_type fw_bus_type;
>   struct fw_card {
>         const struct fw_card_driver *driver;
>         struct device *device;
>  +       atomic_t device_count;
>         struct kref kref;
>
>         int node_id;
>  Index: linux/drivers/firewire/fw-device.h
>  ===================================================================
>  --- linux.orig/drivers/firewire/fw-device.h
>  +++ linux/drivers/firewire/fw-device.h
>  @@ -76,9 +76,21 @@ fw_device_is_shutdown(struct fw_device *
>         return atomic_read(&device->state) == FW_DEVICE_SHUTDOWN;
>   }
>
>  -struct fw_device *fw_device_get(struct fw_device *device);
>  +static inline struct fw_device *
>  +fw_device_get(struct fw_device *device)
>  +{
>  +       get_device(&device->device);
>  +
>  +       return device;
>  +}
>  +
>  +static inline void
>  +fw_device_put(struct fw_device *device)
>  +{
>  +       put_device(&device->device);
>  +}
>  +
>   struct fw_device *fw_device_get_by_devt(dev_t devt);
>  -void fw_device_put(struct fw_device *device);
>   int fw_device_enable_phys_dma(struct fw_device *device);
>
>   void fw_device_cdev_update(struct fw_device *device);
>
>  --
>  Stefan Richter
>  -=====-==--- --=- ==---
>  http://arcgraph.de/sr/
>
>
