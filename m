Return-Path: <linux-kernel-owner+w=401wt.eu-S1761361AbYGRABV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761361AbYGRABV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 20:01:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761282AbYGRABA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 20:01:00 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:34180 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761277AbYGRAA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 20:00:56 -0400
Date: Thu, 17 Jul 2008 17:00:19 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Marcin Obara <marcin_obara@users.sourceforge.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Intel Management Engine Interface
Message-Id: <20080717170019.52f6730c.randy.dunlap@oracle.com>
In-Reply-To: <alpine.DEB.1.00.0807172021450.26825@ip-195-3-221-75.vnet.pl>
References: <alpine.DEB.1.00.0807172021450.26825@ip-195-3-221-75.vnet.pl>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Jul 2008 20:27:10 +0200 (CEST) Marcin Obara wrote:

Please include diffstat for the entire patch.  See Documentation/SubmittingPatches .

> diff --git a/drivers/char/heci/Kconfig b/drivers/char/heci/Kconfig
> new file mode 100644
> index 0000000..a4d8bf4
> --- /dev/null
> +++ b/drivers/char/heci/Kconfig
> @@ -0,0 +1,12 @@
> +#
> +# HECI device configuration
> +#
> +
> +config INTEL_MEI
> +       tristate "Intel Management Engine Interface (MEI) Support"

The text prompt string usually also includes "(EXPERIMENTAL)", although
I wish that the *config tools did that for us...


> +       depends on EXPERIMENTAL
> +       ---help---
> +         The Intel Management Engine Interface (Intel MEI) driver allows
> +         applications to access the Active Management Technology 
> +         firmware and other Management Engine sub-systems.
> +

> diff --git a/drivers/char/heci/heci.h b/drivers/char/heci/heci.h
> new file mode 100644
> index 0000000..daafbc8
> --- /dev/null
> +++ b/drivers/char/heci/heci.h
> @@ -0,0 +1,176 @@
> +
> +#ifndef _HECI_H_
> +#define _HECI_H_
> +
> +#include <linux/version.h>
> +#include <linux/spinlock.h>
> +#include <linux/list.h>
> +#include <linux/pci.h>
> +#include <linux/timer.h>
> +#include <linux/interrupt.h>
> +#include <linux/workqueue.h>
> +#include <linux/module.h>
> +#include <linux/aio.h>
> +#include <linux/types.h>
> +#include "heci_data_structures.h"
> +
> +extern const struct guid heci_pthi_guid;
> +extern const struct guid heci_wd_guid;
> +extern const __u8 start_wd_params[];
> +extern const __u8 stop_wd_params[];
> +extern const __u8 heci_wd_state_independence_msg[3][4];
> +
> +/**

Oops.   We use /** to flag the beginning of kernel-doc comments, but this (and others
here) is not a kernel-doc comment.  Please just use /* here and other places that are
not kernel-doc comments.  Or feel free to convert to kernel-doc.  :)


> + * heci device ID
> + */
> +#define    HECI_DEV_ID_82946GZ    0x2974  /* 82946GZ/GL */
> +#define    HECI_DEV_ID_82G35      0x2984  /* 82G35 Express */
> +#define    HECI_DEV_ID_82Q965     0x2994  /* 82Q963/Q965 */
> +#define    HECI_DEV_ID_82G965     0x29A4  /* 82P965/G965 */
> +
> +#define    HECI_DEV_ID_82GM965    0x2A04  /* Mobile PM965/GM965 */
> +#define    HECI_DEV_ID_82GME965   0x2A14  /* Mobile GME965/GLE960 */
> +
> +#define    HECI_DEV_ID_ICH9_82Q35 0x29B4  /* 82Q35 Express */
> +#define    HECI_DEV_ID_ICH9_82G33 0x29C4  /* 82G33/G31/P35/P31 Express */
> +#define    HECI_DEV_ID_ICH9_82Q33 0x29D4  /* 82Q33 Express */
> +#define    HECI_DEV_ID_ICH9_82X38 0x29E4  /* 82X38/X48 Express */
> +#define    HECI_DEV_ID_ICH9_3200  0x29F4  /* 3200/3210 Server */
> +
> +#define    HECI_DEV_ID_ICH9_6     0x28B4  /* Bearlake */
> +#define    HECI_DEV_ID_ICH9_7     0x28C4  /* Bearlake */
> +#define    HECI_DEV_ID_ICH9_8     0x28D4  /* Bearlake */
> +#define    HECI_DEV_ID_ICH9_9     0x28E4  /* Bearlake */
> +#define    HECI_DEV_ID_ICH9_10    0x28F4  /* Bearlake */
> +
> +#define    HECI_DEV_ID_ICH9M_1    0x2A44  /* Cantiga */
> +#define    HECI_DEV_ID_ICH9M_2    0x2A54  /* Cantiga */
> +#define    HECI_DEV_ID_ICH9M_3    0x2A64  /* Cantiga */
> +#define    HECI_DEV_ID_ICH9M_4    0x2A74  /* Cantiga */
> +
> +#define    HECI_DEV_ID_ICH10_1    0x2E04  /* Eaglelake */
> +#define    HECI_DEV_ID_ICH10_2    0x2E14  /* Eaglelake */
> +#define    HECI_DEV_ID_ICH10_3    0x2E24  /* Eaglelake */
> +#define    HECI_DEV_ID_ICH10_4    0x2E34  /* Eaglelake */
> +
> +/**
> + * heci init function prototypes
> + */
> +struct iamt_heci_device *init_heci_device(struct pci_dev *pdev);
> +void heci_reset(struct iamt_heci_device *dev, int interrupts);
> +int heci_hw_init(struct iamt_heci_device *dev);
> +int heci_task_initialize_clients(void *data);
> +int heci_initialize_clients(struct iamt_heci_device *dev);
> +struct heci_file_private *heci_alloc_file_private(struct file *file);
> +int heci_disconnect_host_client(struct iamt_heci_device *dev,
> +				struct heci_file_private *file_ext);
> +void heci_initialize_list(struct io_heci_list *list,
> +			  struct iamt_heci_device *dev);
> +void heci_flush_list(struct io_heci_list *list,
> +		     struct heci_file_private *file_ext);
> +void heci_flush_queues(struct iamt_heci_device *dev,
> +		       struct heci_file_private *file_ext);
> +
> +void heci_remove_client_from_file_list(struct iamt_heci_device *dev,
> +				       __u8 host_client_id);
> +
> +/**
> + *  interrupt function prototype
> + */
> +irqreturn_t heci_isr_interrupt(int irq, void *dev_id);
> +
> +void heci_wd_timer(unsigned long data);
> +
> +/**
> + *  input output function prototype
> + */
> +int heci_ioctl_get_version(struct iamt_heci_device *device, int if_num,
> +			   struct heci_message_data *u_msg,
> +			   struct heci_message_data k_msg,
> +			   struct heci_file_private *file_ext);
> +
> +int heci_ioctl_connect_client(struct iamt_heci_device *device, int if_num,
> +			      struct heci_message_data *u_msg,
> +			      struct heci_message_data k_msg,
> +			      struct file *file);
> +
> +int heci_ioctl_wd(struct iamt_heci_device *device, int if_num,
> +		  struct heci_message_data k_msg,
> +		  struct heci_file_private *file_ext);
> +
> +int heci_ioctl_bypass_wd(struct iamt_heci_device *device, int if_num,
> +		  struct heci_message_data k_msg,
> +		  struct heci_file_private *file_ext);
> +
> +int heci_start_read(struct iamt_heci_device *device, int if_num,
> +		    struct heci_file_private *file_ext);
> +
> +int pthi_write(struct iamt_heci_device *device,
> +	       struct heci_cb_private *priv_cb);
> +
> +int pthi_read(struct iamt_heci_device *device, int if_num, struct file *file,
> +	      char *ubuf, size_t length, loff_t *offset);
> +
> +struct heci_cb_private *find_pthi_read_list_entry(
> +			struct iamt_heci_device *device,
> +			struct file *file);
> +
> +void run_next_iamthif_cmd(struct iamt_heci_device *device);
> +
> +void heci_free_cb_private(struct heci_cb_private *priv_cb);
> +
> +/**
> + * heci_fe_same_id - tell if file private data have same id
> + *
> + * @fe1: private data of 1. file object
> + * @fe2: private data of 2. file object
> + *
> + * @return  !=0 - if ids are the same, 0 - if differ.
> + */
> +static inline int heci_fe_same_id(struct heci_file_private *fe1,
> +				  struct heci_file_private *fe2)
> +{
> +	return ((fe1->host_client_id == fe2->host_client_id)
> +		&& (fe1->me_client_id == fe2->me_client_id));
> +}
> +
> +#endif /* _HECI_H_ */

> diff --git a/drivers/char/heci/heci_data_structures.h b/drivers/char/heci/heci_data_structures.h
> new file mode 100644
> index 0000000..f75af25
> --- /dev/null
> +++ b/drivers/char/heci/heci_data_structures.h
> @@ -0,0 +1,524 @@
> +
> +#ifndef _HECI_DATA_STRUCTURES_H_
> +#define _HECI_DATA_STRUCTURES_H_
> +
> +#include <linux/version.h>
> +#include <linux/spinlock.h>
> +#include <linux/list.h>
> +#include <linux/pci.h>
> +#include <linux/timer.h>
> +#include <linux/interrupt.h>
> +#include <linux/workqueue.h>
> +#include <linux/module.h>
> +#include <linux/aio.h>
> +#include <linux/types.h>
> +
> +/**

Same kernel-doc comments.

> + * error code definition
> + */
> +#define     ESLOTS_OVERFLOW              1
> +#define     ECORRUPTED_MESSAGE_HEADER    1000
> +#define     ECOMPLETE_MESSAGE            1001
> +
> +#define     HECI_FC_MESSAGE_RESERVED_LENGTH           5
> +
> +/**
> + * Number of queue lists used by this driver
> + */
> +#define HECI_IO_LISTS_NUMBER        7
> +
> +/**
> + * Maximum transmission unit (MTU) of heci messages
> + */
> +#define IAMTHIF_MTU 4160
> +
> +
> +/**
> + * HECI HW Section
> + */
> +
> +/* HECI registers */
> +/* H_CB_WW - Host Circular Buffer (CB) Write Window register */
> +#define H_CB_WW    0
> +/* H_CSR - Host Control Status register */
> +#define H_CSR      4
> +/* ME_CB_RW - ME Circular Buffer Read Window register (read only) */
> +#define ME_CB_RW   8
> +/* ME_CSR_HA - ME Control Status Host Access register (read only) */
> +#define ME_CSR_HA  0xC
> +
> +
> +/* register bits of H_CSR (Host Control Status register) */
> +/* Host Circular Buffer Depth - maximum number of 32-bit entries in CB */
> +#define H_CBD             0xFF000000
> +/* Host Circular Buffer Write Pointer */
> +#define H_CBWP            0x00FF0000
> +/* Host Circular Buffer Read Pointer */
> +#define H_CBRP            0x0000FF00
> +/* Host Reset */
> +#define H_RST             0x00000010
> +/* Host Ready */
> +#define H_RDY             0x00000008
> +/* Host Interrupt Generate */
> +#define H_IG              0x00000004
> +/* Host Interrupt Status */
> +#define H_IS              0x00000002
> +/* Host Interrupt Enable */
> +#define H_IE              0x00000001
> +
> +
> +/* register bits of ME_CSR_HA (ME Control Status Host Access register) */
> +/* ME CB (Circular Buffer) Depth HRA (Host Read Access)
> + *  - host read only access to ME_CBD */
> +#define ME_CBD_HRA        0xFF000000
> +/* ME CB Write Pointer HRA - host read only access to ME_CBWP */
> +#define ME_CBWP_HRA       0x00FF0000
> +/* ME CB Read Pointer HRA - host read only access to ME_CBRP */
> +#define ME_CBRP_HRA       0x0000FF00
> +/* ME Reset HRA - host read only access to ME_RST */
> +#define ME_RST_HRA        0x00000010
> +/* ME Ready HRA - host read only access to ME_RDY */
> +#define ME_RDY_HRA        0x00000008
> +/* ME Interrupt Generate HRA - host read only access to ME_IG */
> +#define ME_IG_HRA         0x00000004
> +/* ME Interrupt Status HRA - host read only access to ME_IS */
> +#define ME_IS_HRA         0x00000002
> +/* ME Interrupt Enable HRA - host read only access to ME_IE */
> +#define ME_IE_HRA         0x00000001
> +
> +#define HECI_MINORS_BASE	1
> +#define HECI_MINORS_COUNT	1
> +
> +#define  HECI_MINOR_NUMBER	1
> +#define  HECI_MAX_OPEN_HANDLE_COUNT	253
> +
> +/**
> + * debug kernel print macro define
> + */
> +extern int heci_debug;
> +
> +#define DBG(format, arg...) do { \
> +	if (heci_debug) \
> +		printk(KERN_ERR "%s: " format , __func__ , ## arg); \
> +} while (0)

Why KERN_ERR ?

> +
> +
> +/**
> + * time to wait HECI become ready after init
> + */
> +#define HECI_INTEROP_TIMEOUT    (HZ * 7)
> +
> +/**
> + * watch dog definition
> + */
> +#define HECI_WATCHDOG_DATA_SIZE         16
> +#define HECI_START_WD_DATA_SIZE         20
> +#define HECI_WD_PARAMS_SIZE             4
> +#define HECI_WD_STATE_INDEPENDENCE_MSG_SENT       (1 << 0)
> +

...

> +
> +/**
> + * read_heci_register - Read a byte from the heci device
> + *
> + * @device: the device structure
> + * @offset: offset from which to read the data
> + *
> + * @return the byte read.

Drop the @, just Return...

> + */
> +__u32 read_heci_register(struct iamt_heci_device *device,
> +			    unsigned long offset);
> +
> +/**
> + * write_heci_register - Write  4 bytes to the heci device
> + *
> + * @device: the device structure
> + * @offset: offset from which to write the data
> + * @value: the byte to write
> + */
> +void write_heci_register(struct iamt_heci_device *device, unsigned long offset,
> +			 __u32 value);
> +
> +#endif /* _HECI_DATA_STRUCTURES_H_ */

> diff --git a/drivers/char/heci/heci_init.c b/drivers/char/heci/heci_init.c
> new file mode 100644
> index 0000000..8eb42a0
> --- /dev/null
> +++ b/drivers/char/heci/heci_init.c
> @@ -0,0 +1,1085 @@
> +
> +const __u8 watch_dog_data[] = {
> +	1, 1, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
> +};
> +const __u8 start_wd_params[] = { 0x02, 0x12, 0x13, 0x10 };
> +const __u8 stop_wd_params[] = { 0x02, 0x02, 0x14, 0x10 };
> +
> +const __u8 heci_wd_state_independence_msg[3][4] = {
> +	{0x05, 0x02, 0x51, 0x10},
> +	{0x05, 0x02, 0x52, 0x10},
> +	{0x07, 0x02, 0x01, 0x10}
> +};
> +
> +const struct guid heci_asf_guid = {
> +	0x75B30CD6, 0xA29E, 0x4AF7,
> +	{0xA7, 0x12, 0xE6, 0x17, 0x43, 0x93, 0xC8, 0xA6}
> +};
> +const struct guid heci_wd_guid = {
> +	0x05B79A6F, 0x4628, 0x4D7F,
> +	{0x89, 0x9D, 0xA9, 0x15, 0x14, 0xCB, 0x32, 0xAB}
> +};
> +const struct guid heci_pthi_guid = {
> +	0x12f80028, 0xb4b7, 0x4b2d,
> +	{0xac, 0xa8, 0x46, 0xe0, 0xff, 0x65, 0x81, 0x4c}
> +};
> +
> +
> +/**

Bzzt.

> + *  heci init function prototypes
> + */
> +static void heci_check_asf_mode(struct iamt_heci_device *dev);
> +static int host_start_message(struct iamt_heci_device *dev);
> +static int host_enum_clients_message(struct iamt_heci_device *dev);
> +static int allocate_me_clients_storage(struct iamt_heci_device *dev);
> +static void host_init_wd(struct iamt_heci_device *dev);
> +static void host_init_iamthif(struct iamt_heci_device *dev);
> +static int heci_wait_event_int_timeout(struct iamt_heci_device *dev,
> +				       long timeout);
> +
> +
> +/**
> + * heci_initialize_list - Sets up a  queue  list.
> + *
> + * @list: An instance of our list structure
> + * @dev: Device object for our driver
> + */
> +void heci_initialize_list(struct io_heci_list *list,
> +			  struct iamt_heci_device *dev)
> +{
> +	/* initialize our queue list */
> +	INIT_LIST_HEAD(&list->heci_cb.cb_list);
> +	list->status = 0;
> +	list->device_extension = dev;
> +}
> +
> +/**
> + * heci_flush_queues - flush our queues list belong to file_ext.
> + *
> + * @dev: Device object for our driver
> + * @file_ext: private data of the file object
> + *
> + */
> +void heci_flush_queues(struct iamt_heci_device *dev,
> +		       struct heci_file_private *file_ext)
> +{
> +	int i;
> +
> +	if (!dev || !file_ext)
> +		return;
> +
> +	/* flush our queue list belong to file_ext */
> +	for (i = 0; i < HECI_IO_LISTS_NUMBER; i++) {
> +		DBG("remove list entry belong to file_ext\n");
> +		heci_flush_list(dev->io_list_array[i], file_ext);
> +	}
> +}
> +
> +
> +/**
> + * heci_flush_list - remove list entry belong to file_ext.
> + *
> + * @list:  An instance of our list structure
> + * @file_ext: private data of the file object
> + */
> +void heci_flush_list(struct io_heci_list *list,
> +		struct heci_file_private *file_ext)
> +{
> +	struct heci_file_private *file_ext_tmp;
> +	struct heci_cb_private *priv_cb_pos = NULL;
> +	struct heci_cb_private *priv_cb_next = NULL;
> +
> +	if (!list || !file_ext)
> +		return;
> +
> +	if (list->status != 0)
> +		return;
> +
> +	if (list_empty(&list->heci_cb.cb_list))
> +		return;
> +
> +	list_for_each_entry_safe(priv_cb_pos, priv_cb_next,
> +				 &list->heci_cb.cb_list, cb_list) {
> +		if (priv_cb_pos) {
> +			file_ext_tmp = (struct heci_file_private *)
> +				priv_cb_pos->file_private;
> +			if (file_ext_tmp) {
> +				if (heci_fe_same_id(file_ext, file_ext_tmp))
> +					list_del(&priv_cb_pos->cb_list);
> +			}
> +		}
> +	}
> +}
> +
> +/**
> + * heci_reset_iamthif_params - initializes heci device iamthif
> + * @dev: The heci device structure
> + */
> +static void heci_reset_iamthif_params(struct iamt_heci_device *dev)
> +{
> +	/* reset iamthif parameters. */
> +	dev->iamthif_current_cb = NULL;
> +	dev->iamthif_msg_buf_size = 0;
> +	dev->iamthif_msg_buf_index = 0;
> +	dev->iamthif_canceled = 0;
> +	dev->iamthif_file_ext.file = NULL;
> +	dev->iamthif_ioctl = 0;
> +	dev->iamthif_state = HECI_IAMTHIF_IDLE;
> +	dev->iamthif_timer = 0;
> +}
> +
> +/**
> + * init_heci_device - allocates and initializes the heci device structure
> + * @pdev: The pci device structure
> + *
> + * @return The heci_device_device pointer on success, NULL on failure.

Drop @, just Return or Returns ....

> + */
> +struct iamt_heci_device *init_heci_device(struct pci_dev *pdev)
> +{
> +}
> +
> +
> +
> +
> +static int heci_wait_event_int_timeout(struct iamt_heci_device *dev,
> +		long timeout)
> +{
> +	return wait_event_interruptible_timeout(dev->wait_recvd_msg,
> +			(dev->recvd_msg), timeout);
> +}
> +
> +/**
> + * heci_hw_init  - init host and fw to start work.
> + *
> + * @dev: Device object for our driver
> + *
> + * @return 0 on success, <0 on failure.

Not @return....

> + */
> +int heci_hw_init(struct iamt_heci_device *dev)
> +{
> +}
> +
> +/**
> + * heci_hw_reset  - reset fw via heci csr register.
> + *
> + * @dev: Device object for our driver
> + * @interrupts: if interrupt should be enable after reset.
> + */
> +static void heci_hw_reset(struct iamt_heci_device *dev, int interrupts)
> +{
> +	dev->host_hw_state |= (H_RST | H_IG);
> +
> +	if (interrupts)
> +		heci_csr_enable_interrupts(dev);
> +	else
> +		heci_csr_disable_interrupts(dev);
> +
> +	BUG_ON((dev->host_hw_state & H_RST) != H_RST);
> +	BUG_ON((dev->host_hw_state & H_RDY) != 0);
> +}
> +
> +/**
> + * heci_reset  - reset host and fw.
> + *
> + * @dev: Device object for our driver
> + * @interrupts: if interrupt should be enable after reset.
> + */
> +void heci_reset(struct iamt_heci_device *dev, int interrupts)
> +{
> +	dev->num_heci_me_clients = 0;
> +	dev->rd_msg_hdr = 0;
> +	dev->stop = 0;
> +	dev->wd_pending = 0;
> +
> +	/* update the state of the registers after reset */
> +	dev->host_hw_state =  read_heci_register(dev, H_CSR);
> +	dev->me_hw_state =  read_heci_register(dev, ME_CSR_HA);
> +
> +	DBG("after reset host_hw_state = 0x%08x, me_hw_state = 0x%08x.\n",
> +	    dev->host_hw_state, dev->me_hw_state);
> +
> +	if (unexpected)
> +		printk(KERN_WARNING "unexpected heci reset.\n");

printk() strings usually benefit from some common prefix, such as

		printk(KERN_WARNING "heci: unexpected reset\n");

> +
> +	/* Wake up all readings so they can be interrupted */
> +	list_for_each_entry_safe(file_pos, file_next, &dev->file_list, link) {
> +		if (&file_pos->rx_wait &&
> +		    waitqueue_active(&file_pos->rx_wait)) {
> +			printk(KERN_INFO "heci: Waking up client!\n");
> +			wake_up_interruptible(&file_pos->rx_wait);
> +		}
> +	}
> +	/* remove all waiting requests */
> +	if (dev->write_list.status == 0 &&
> +		!list_empty(&dev->write_list.heci_cb.cb_list)) {
> +		list_for_each_entry_safe(priv_cb_pos, priv_cb_next,
> +				&dev->write_list.heci_cb.cb_list, cb_list) {
> +			if (priv_cb_pos) {
> +				list_del(&priv_cb_pos->cb_list);
> +				heci_free_cb_private(priv_cb_pos);
> +			}
> +		}
> +	}
> +}
> +
> +/**
> + * heci_initialize_clients  -  routine.

What routine??

> + *
> + * @dev: Device object for our driver
> + *
> + */
> +int heci_initialize_clients(struct iamt_heci_device *dev)
> +{
> +}
> +
> +/**
> + * heci_task_initialize_clients  -  routine.

What routine??

> + *
> + * @data: Device object for our driver
> + *
> + */
> +int heci_task_initialize_clients(void *data)
> +{
> +}
> +
> +/**
> + * host_start_message - heci host send start message.
> + *
> + * @dev: Device object for our driver
> + *
> + * @return 0 on success, <0 on failure.

Not @return.

> + */
> +static int host_start_message(struct iamt_heci_device *dev)
> +{
> +}
> +
> +/**
> + * host_enum_clients_message - host send enumeration client request message.
> + *
> + * @dev: Device object for our driver
> + * @return 0 on success, <0 on failure.

Not @return ....

> + */
> +static int host_enum_clients_message(struct iamt_heci_device *dev)
> +{
> +}
> +
> +/**
> + * host_client_properties - reads properties for client
> + *
> + * @dev: Device object for our driver
> + * @idx: client index in me client array
> + * @client_id: id of the client
> + *
> + * @return 0 on success, <0 on failure.

Ditto.

> + */
> +static int host_client_properties(struct iamt_heci_device *dev,
> +				  struct heci_me_client *client)
> +{
> +}
> +
> +/**
> + * allocate_me_clients_storage - allocate storage for me clients
> + *
> + * @dev: Device object for our driver
> + *
> + * @return 0 on success, <0 on failure.

Not @return.

> + */
> +static int allocate_me_clients_storage(struct iamt_heci_device *dev)
> +{
> +}
> +
> +/**
> + * heci_init_file_private - initializes private file structure.
> + *
> + * @priv: private file structure to be initialized
> + * @file: the file structure
> + *
> + */
> +static void heci_init_file_private(struct heci_file_private *priv,
> +				   struct file *file)
> +{
> +}
> +
> +/**
> + * heci_find_me_client - search for ME client guid
> + *                       sets client_id in heci_file_private if found
> + * @dev: Device object for our driver
> + * @priv: private file structure to set client_id in
> + * @cguid: searched guid of ME client
> + * @client_id: id of host client to be set in file private structure
> + *
> + * @return ME client index

Not @return ....

> + */
> +static __u8 heci_find_me_client(struct iamt_heci_device *dev,
> +				struct heci_file_private *priv,
> +				const struct guid *cguid, __u8 client_id)
> +{
> +}
> +
> +/**
> + * heci_check_asf_mode - check for ASF client
> + *
> + * @dev: Device object for our driver
> + *
> + */
> +static void heci_check_asf_mode(struct iamt_heci_device *dev)
> +{
> +}
> +
> +/**
> + * heci_connect_me_client - connect ME client
> + * @dev: Device object for our driver
> + * @priv: private file structure
> + * @timeout: connect timeout in seconds
> + *
> + * @return 1 - if connected, 0 - if not

Not @return ....

> + */
> +static __u8 heci_connect_me_client(struct iamt_heci_device *dev,
> +				   struct heci_file_private *priv,
> +				   long timeout)
> +{
> +}
> +
> +/**
> + * host_init_wd - heci initialization wd.
> + *
> + * @dev: Device object for our driver
> + *
> + */
> +static void host_init_wd(struct iamt_heci_device *dev)
> +{
> +}
> +
> +
> +/**
> + * host_init_iamthif - heci initialization iamthif client.
> + *
> + * @dev: Device object for our driver
> + *
> + */
> +static void host_init_iamthif(struct iamt_heci_device *dev)
> +{
> +}
> +
> +/**
> + * heci_alloc_file_private - allocates a private file structure and set it up.
> + * @file: the file structure
> + *
> + * @return  The allocated file or NULL on failure

 * Returns ....

> + */
> +struct heci_file_private *heci_alloc_file_private(struct file *file)
> +{
> +}
> +
> +
> +
> +/**
> + * heci_disconnect_host_client  - send disconnect message  to fw from host client.
> + *
> + * @dev: Device object for our driver
> + * @file_ext: private data of the file object
> + *
> + * @return 0 on success, <0 on failure.

Argh.

> + */
> +int heci_disconnect_host_client(struct iamt_heci_device *dev,
> +		struct heci_file_private *file_ext)
> +{
> +}
> +
> +/**
> + * heci_remove_client_from_file_list  -
> + *	remove file private data from device file list
> + *
> + * @dev: Device object for our driver
> + * @host_client_id: host client id to be removed
> + *
> + */
> +void heci_remove_client_from_file_list(struct iamt_heci_device *dev,
> +				       __u8 host_client_id)
> +{
> +}

> diff --git a/drivers/char/heci/heci_interface.c b/drivers/char/heci/heci_interface.c
> new file mode 100644
> index 0000000..2527bb2
> --- /dev/null
> +++ b/drivers/char/heci/heci_interface.c
> @@ -0,0 +1,517 @@
> +
> +/**
> + * read_heci_register - Read a byte from the heci device
> + *
> + * @device: the device structure
> + * @offset: offset from which to read the data
> + *
> + * @return  the byte read.

 * Returns the byte read.

> + */
> +__u32 read_heci_register(struct iamt_heci_device *device,
> +			    unsigned long offset)
> +{
> +	return readl(device->mem_addr + offset);
> +}
> +
> +/**
> + * write_heci_register - Write  4 bytes to the heci device
> + *
> + * @device: the device structure
> + * @offset: offset from which to write the data
> + * @value: the byte to write
> + */
> +void write_heci_register(struct iamt_heci_device *device, unsigned long offset,
> +			 __u32 value)
> +{
> +	writel(value, device->mem_addr + offset);
> +}
> +
> +
> +/**
> + * heci_set_csr_register - write H_CSR register to the heci device
> + *
> + * @dev: device object for our driver
> + */
> +void heci_set_csr_register(struct iamt_heci_device *dev)
> +{
> +	write_heci_register(dev, H_CSR, dev->host_hw_state);
> +	dev->host_hw_state = read_heci_register(dev, H_CSR);
> +}
> +
> +/**
> + * heci_csr_enable_interrupts - enable heci device interrupts
> + *
> + * @dev: device object for our driver
> + */
> +void heci_csr_enable_interrupts(struct iamt_heci_device *dev)
> +{
> +	dev->host_hw_state |= H_IE;
> +	heci_set_csr_register(dev);
> +}
> +
> +/**
> + * heci_csr_disable_interrupts - disable heci device interrupts
> + *
> + * @dev: device object for our driver
> + */
> +void heci_csr_disable_interrupts(struct iamt_heci_device *dev)
> +{
> +	dev->host_hw_state &= ~H_IE;
> +	heci_set_csr_register(dev);
> +}
> +
> +
> +/**
> + * _host_get_filled_slots - get number of device filled buffer slots
> + *
> + * @device: the device structure
> + *
> + * @return numer of filled slots

Not @return.

> + */
> +static unsigned char _host_get_filled_slots(struct iamt_heci_device *dev)
> +{
> +	char read_ptr, write_ptr;
> +
> +	read_ptr = (char) ((dev->host_hw_state & H_CBRP) >> 8);
> +	write_ptr = (char) ((dev->host_hw_state & H_CBWP) >> 16);
> +
> +	return (unsigned char) (write_ptr - read_ptr);
> +}
> +
> +/**
> + * host_buffer_is_empty  - check if host buffer is empty.
> + *
> + * @dev: device object for our driver
> + *
> + * @return  1 if empty, 0 - otherwise.

Ditto.

> + */
> +int host_buffer_is_empty(struct iamt_heci_device *dev)
> +{
> +	unsigned char filled_slots;
> +
> +	dev->host_hw_state = read_heci_register(dev, H_CSR);
> +	filled_slots = _host_get_filled_slots(dev);
> +
> +	if (filled_slots > 0)
> +		return 0;
> +
> +	return 1;
> +}
> +
> +/**
> + * count_empty_write_slots  - count write empty slots.
> + *
> + * @dev: device object for our driver
> + *
> + * @return -1(ESLOTS_OVERFLOW) if overflow, otherwise empty slots count

Ditto.

> + */
> +__s32 count_empty_write_slots(struct iamt_heci_device *dev)
> +{
> +	unsigned char buffer_depth, filled_slots, empty_slots;
> +
> +	buffer_depth = (unsigned char) ((dev->host_hw_state & H_CBD) >> 24);
> +	filled_slots = _host_get_filled_slots(dev);
> +	empty_slots = buffer_depth - filled_slots;
> +
> +	if (filled_slots > buffer_depth) {
> +		/* overflow */
> +		return -ESLOTS_OVERFLOW;
> +	}
> +
> +	return (__s32) empty_slots;
> +}
> +
> +/**
> + * heci_write_message  - write a message to heci device.
> + *
> + * @dev: device object for our driver
> + * @heci_hdr: header of  message
> + * @write_buffer: message buffer will be write
> + * @write_length: message size will be write
> + *
> + * @return 1 if success, 0 - otherwise.

Ditto.

> + */
> +int heci_write_message(struct iamt_heci_device *dev,
> +			     struct heci_msg_hdr *header,
> +			     unsigned char *write_buffer,
> +			     unsigned long write_length)
> +{
> +}
> +
> +/**
> + * count_full_read_slots  - count read full slots.
> + *
> + * @dev: device object for our driver
> + *
> + * @return -1(ESLOTS_OVERFLOW) if overflow, otherwise filled slots count

Not @return.

> + */
> +__s32 count_full_read_slots(struct iamt_heci_device *dev)
> +{
> +}
> +
> +/**
> + * heci_read_slots  - read a message from heci device.
> + *
> + * @dev: device object for our driver
> + * @buffer: message buffer will be write
> + * @buffer_length: message size will be read
> + */
> +void heci_read_slots(struct iamt_heci_device *dev,
> +		     unsigned char *buffer, unsigned long buffer_length)
> +{
> +}
> +
> +/**
> + * flow_ctrl_creds  - check flow_control credentials.
> + *
> + * @dev: device object for our driver
> + * @file_ext: private data of the file object
> + *
> + * @return 1 if flow_ctrl_creds >0, 0 - otherwise.

Not @return.  OK, I won't keep repeating this comment.

> + */
> +int flow_ctrl_creds(struct iamt_heci_device *dev,
> +				   struct heci_file_private *file_ext)
> +{
> +}
> +
> +/**
> + * flow_ctrl_reduce  - reduce flow_control.
> + *
> + * @dev: device object for our driver
> + * @file_ext: private data of the file object
> + */
> +void flow_ctrl_reduce(struct iamt_heci_device *dev,
> +			 struct heci_file_private *file_ext)
> +{
> +}
> +
> +/**
> + * heci_send_flow_control - send flow control to fw.
> + *
> + * @dev: device object for our driver
> + * @file_ext: private data of the file object
> + *
> + * @return 1 if success, 0 - otherwise.
> + */
> +int heci_send_flow_control(struct iamt_heci_device *dev,
> +				 struct heci_file_private *file_ext)
> +{
> +}
> +
> +/**
> + * other_client_is_connecting  - check if other
> + * client with the same client id is connected.
> + *
> + * @dev: device object for our driver
> + * @file_ext: private data of the file object
> + *
> + * @return 1 if other client is connected, 0 - otherwise.
> + */
> +int other_client_is_connecting(struct iamt_heci_device *dev,
> +		struct heci_file_private *file_ext)
> +{
> +}
> +
> +/**
> + * heci_send_wd  - send watch dog message to fw.
> + *
> + * @dev: device object for our driver
> + *
> + * @return 1 if success, 0 - otherwise.
> + */
> +int heci_send_wd(struct iamt_heci_device *dev)
> +{
> +}
> +
> +/**
> + * heci_disconnect  - send disconnect message to fw.
> + *
> + * @dev: device object for our driver
> + * @file_ext: private data of the file object
> + *
> + * @return 1 if success, 0 - otherwise.
> + */
> +int heci_disconnect(struct iamt_heci_device *dev,
> +			  struct heci_file_private *file_ext)
> +{
> +}
> +
> +/**
> + * heci_connect - send connect message to fw.
> + *
> + * @dev: device object for our driver
> + * @file_ext: private data of the file object
> + *
> + * @return 1 if success, 0 - otherwise.
> + */
> +int heci_connect(struct iamt_heci_device *dev,
> +		       struct heci_file_private *file_ext)
> +{
> +}

> diff --git a/drivers/char/heci/heci_interface.h b/drivers/char/heci/heci_interface.h
> new file mode 100644
> index 0000000..a045853
> --- /dev/null
> +++ b/drivers/char/heci/heci_interface.h
> @@ -0,0 +1,170 @@
> +
> +#ifndef _HECI_INTERFACE_H_
> +#define _HECI_INTERFACE_H_
> +
> +
> +/* IOCTL commands */
> +#define IOCTL_HECI_GET_VERSION \
> +    _IOWR('H' , 0x0, struct heci_message_data)
> +#define IOCTL_HECI_CONNECT_CLIENT \
> +    _IOWR('H' , 0x01, struct heci_message_data)
> +#define IOCTL_HECI_WD \
> +    _IOWR('H' , 0x02, struct heci_message_data)
> +#define IOCTL_HECI_BYPASS_WD \
> +    _IOWR('H' , 0x10, struct heci_message_data)
> +

Needs an update to Documentation/ioctl-number.txt .

> +
> +#endif /* _HECI_INTERFACE_H_ */

> diff --git a/drivers/char/heci/heci_main.c b/drivers/char/heci/heci_main.c
> new file mode 100644
> index 0000000..ecc6031
> --- /dev/null
> +++ b/drivers/char/heci/heci_main.c
> @@ -0,0 +1,1523 @@
> +
> +/**
> + * Set up the cdev structure for heci device.

kernel-doc format:

 * heci_registration_cdev - set up the cdev structure for the heci device

> + *
> + * @dev: char device struct
> + * @hminor: minor number for registration char device
> + * @fops: file operations structure
> + *
> + * @return 0 on success, <0 on failure.
> + */
> +static int heci_registration_cdev(struct cdev *dev, int hminor,
> +				  struct file_operations *fops)
> +{
> +	int ret, devno = MKDEV(heci_major, hminor);
> +
> +	cdev_init(dev, fops);
> +	dev->owner = THIS_MODULE;
> +	ret = cdev_add(dev, devno, 1);
> +	/* Fail gracefully if need be */
> +	if (ret) {
> +		printk(KERN_ERR "heci: Error %d registering heci device %d\n",
> +		       ret, hminor);
> +	}
> +	return ret;
> +}
> +
> +/* Display the version of heci driver. */
> +static ssize_t version_show(struct class *dev, char *buf)
> +{
> +	return sprintf(buf, "%s %s.\n",
> +		       heci_driver_string, heci_driver_version);
> +}
> +
> +static CLASS_ATTR(version, S_IRUGO, version_show, NULL);
> +
> +/**
> + * heci_register_cdev - registers heci char device
> + *
> + * @return 0 on success, <0 on failure.
> + */
> +static int heci_register_cdev(void)
> +{
> +}
> +
> +
> +
> +
> +/**
> + * heci_open - the open function

Missing parameter descriptions.

> + */
> +static int heci_open(struct inode *inode, struct file *file)
> +{
> +}
> +
> +/**
> + * heci_release - the release function

Ditto.

> + */
> +static int heci_release(struct inode *inode, struct file *file)
> +{
> +}
> +
> +
> +/**
> + * heci_read - the read client message function.

Ditto.

> + */
> +static ssize_t heci_read(struct file *file, char __user *ubuf,
> +			 size_t length, loff_t *offset)
> +{
> +}
> +
> +/**
> + * heci_write - the write function.

Ditto.

> + */
> +static ssize_t heci_write(struct file *file, const char __user *ubuf,
> +			  size_t length, loff_t *offset)
> +{
> +}
> +
> +/**
> + * heci_ioctl - the IOCTL function

Tritto.

> + */
> +static int heci_ioctl(struct inode *inode, struct file *file,
> +		      unsigned int cmd, unsigned long data)
> +{
> +}
> +
> +/**
> + * heci_poll - the poll function

Again.

> + */
> +static unsigned int heci_poll(struct file *file, poll_table *wait)
> +{
> +}

> diff --git a/drivers/char/heci/interrupt.c b/drivers/char/heci/interrupt.c
> new file mode 100644
> index 0000000..b41e8d3
> --- /dev/null
> +++ b/drivers/char/heci/interrupt.c
> @@ -0,0 +1,1552 @@
> +
> +
> +/**
> + * _heci_cmpl: process completed operation.

 * _heci_cmpl - process completed operation

> + *
> + * @file_ext: private data of the file object.
> + * @priv_cb_pos: callback block.
> + */
> +static void _heci_cmpl(struct heci_file_private *file_ext,
> +				struct heci_cb_private *priv_cb_pos)
> +{
> +}
> +
> +/**
> + * _heci_cmpl_iamthif: process completed iamthif operation.

s/: / - /

> + *
> + * @dev: Device object for our driver.
> + * @priv_cb_pos: callback block.
> + */
> +static void _heci_cmpl_iamthif(struct iamt_heci_device *dev,
> +				struct heci_cb_private *priv_cb_pos)
> +{
> +}
> +/**
> + * _heci_bh_iamthif_read: prepare to read iamthif data.

s/: / - /

> + *
> + * @dev: Device object for our driver.
> + * @slots: free slots.
> + *
> + * @return  0, OK; otherwise, error.
> + */
> +static int _heci_bh_iamthif_read(struct iamt_heci_device *dev,	__s32 *slots)
> +{
> +}
> +
> +/**
> + * _heci_bh_close: process close related operation.

s/: / - /

> + *
> + * @dev: Device object for our driver.
> + * @slots: free slots.
> + * @priv_cb_pos: callback block.
> + * @file_ext: private data of the file object.
> + * @cmpl_list: complete list.
> + *
> + * @return  0, OK; otherwise, error.
> + */
> +static int _heci_bh_close(struct iamt_heci_device *dev,	__s32 *slots,
> +			struct heci_cb_private *priv_cb_pos,
> +			struct heci_file_private *file_ext,
> +			struct io_heci_list *cmpl_list)
> +{
> +}
> +
> +/**
> + * _heci_hb_close: process read related operation.

s/: / - /

> + *
> + * @dev: Device object for our driver.
> + * @slots: free slots.
> + * @priv_cb_pos: callback block.
> + * @file_ext: private data of the file object.
> + * @cmpl_list: complete list.
> + *
> + * @return 0, OK; otherwise, error.
> + */
> +static int _heci_bh_read(struct iamt_heci_device *dev,	__s32 *slots,
> +			struct heci_cb_private *priv_cb_pos,
> +			struct heci_file_private *file_ext,
> +			struct io_heci_list *cmpl_list)
> +{
> +}
> +
> +
> +/**
> + * _heci_bh_ioctl: process ioctl related operation.

s/: / - /

> + *
> + * @dev: Device object for our driver.
> + * @slots: free slots.
> + * @priv_cb_pos: callback block.
> + * @file_ext: private data of the file object.
> + * @cmpl_list: complete list.
> + *
> + * @return  0, OK; otherwise, error.
> + */
> +static int _heci_bh_ioctl(struct iamt_heci_device *dev,	__s32 *slots,
> +			struct heci_cb_private *priv_cb_pos,
> +			struct heci_file_private *file_ext,
> +			struct io_heci_list *cmpl_list)
> +{
> +}
> +
> +/**
> + * _heci_bh_cmpl: process completed and no-iamthif operation.

s/: / - /

> + *
> + * @dev: Device object for our driver.
> + * @slots: free slots.
> + * @priv_cb_pos: callback block.
> + * @file_ext: private data of the file object.
> + * @cmpl_list: complete list.
> + *
> + * @return  0, OK; otherwise, error.
> + */
> +static int _heci_bh_cmpl(struct iamt_heci_device *dev,	__s32 *slots,
> +			struct heci_cb_private *priv_cb_pos,
> +			struct heci_file_private *file_ext,
> +			struct io_heci_list *cmpl_list)
> +{
> +}
> +
> +/**
> + * _heci_bh_cmpl_iamthif: process completed iamthif operation.

s/: / - /

> + *
> + * @dev: Device object for our driver.
> + * @slots: free slots.
> + * @priv_cb_pos: callback block.
> + * @file_ext: private data of the file object.
> + * @cmpl_list: complete list.
> + *
> + * @return  0, OK; otherwise, error.
> + */
> +static int _heci_bh_cmpl_iamthif(struct iamt_heci_device *dev, __s32 *slots,
> +			struct heci_cb_private *priv_cb_pos,
> +			struct heci_file_private *file_ext,
> +			struct io_heci_list *cmpl_list)
> +{
> +}


General (CodingStyle):  functions should not begin with a blank line after the
opening {, nor should they have blank lines before the closing }.  Yes, I saw both
of those.


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
