Return-Path: <linux-kernel-owner+w=401wt.eu-S1759425AbYAJJBG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425AbYAJJBG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 04:01:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754908AbYAJJAx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 04:00:53 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:37731 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754012AbYAJJAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 04:00:51 -0500
Date: Thu, 10 Jan 2008 01:00:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: oakad@exemail.com.au
Cc: linux-kernel@vger.kernel.org, Alex Dubov <oakad@yahoo.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] [MEMSTICK] Initial commit for Sony MemoryStick support
Message-Id: <20080110010049.695da076.akpm@linux-foundation.org>
In-Reply-To: <1199256144-1019-1-git-send-email-oakad@exemail.com.au>
References: <1199256144-1019-1-git-send-email-oakad@exemail.com.au>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  2 Jan 2008 17:42:24 +1100 oakad@exemail.com.au wrote:

> From: Alex Dubov <oakad@yahoo.com>
> 
> Sony MemoryStick cards are used in many products manufactured by Sony. They
> are available both as storage and as IO expansion cards. Currently, only
> MemoryStick Pro storage cards are supported via TI FlashMedia MemoryStick
> interface.
> 

Will you be running a git tree for this?  If so, please send me the link.

Will this enable that thus-far useless slot on my Vaio?

Where did the info come from which enabled this driver to be written?  I
thought Sony were super-secretive about this stuff?


> @@ -0,0 +1,26 @@
> +#
> +# MemoryStick subsystem configuration
> +#
> +
> +menuconfig MEMSTICK
> +	tristate "Sony MemoryStick card support (EXPERIMENTAL)"
> +	help
> +	  Sony MemoryStick is a proprietary storage/extension card protocol.
> +
> +	  If you want MemoryStick support, you should say Y here and also
> +	  to the specific driver for your MMC interface.

Are you sure this has enough dependencies?  CONFIG_TIFM_* for a start?

<fiddles with Kconfig>

We can create a config which has CONFIG_TIFM_CORE=m, CONFIG_MEMSTICK=y. 
That might not work?

Anyway, please have a think about that.

> +static int memstick_uevent(struct device *dev, struct kobj_uevent_env *env)
> +{
> +	struct memstick_dev *card = container_of(dev, struct memstick_dev,
> +						  dev);
> +
> +	if (add_uevent_var(env, "MEMSTICK_TYPE=%02X", card->id.type))
> +		return -ENOMEM;
> +
> +	if (add_uevent_var(env, "MEMSTICK_CATEGORY=%02X", card->id.category))
> +		return -ENOMEM;

I trust higher-level code cleans up the MEMSTICK_TYPE string if this call
fails.

> +	if (add_uevent_var(env, "MEMSTICK_CLASS=%02X", card->id.class))
> +		return -ENOMEM;
> +
> +	return 0;
> +}
> +
> +static int memstick_device_probe(struct device *dev)
> +{
> +	struct memstick_dev *card = container_of(dev, struct memstick_dev,
> +						 dev);
> +	struct memstick_driver *drv = container_of(dev->driver,
> +						   struct memstick_driver,
> +						   driver);
> +	int rc = -ENODEV;
> +
> +	get_device(dev);
> +	if (dev->driver && drv->probe) {
> +		rc = drv->probe(card);
> +		if (!rc)
> +			return 0;
> +	}
> +	put_device(dev);
> +	return rc;
> +}

Could just do:

	int rc = -ENODEV;
	if (dev->driver && drv->probe) {
		rc = drv->probe(card);
		if (!rc)
			get_device(dev);
	}
	return rc;

If the earlier get_device() is indeed needed then we already have a
problem..

> +
> +static int memstick_device_remove(struct device *dev)
> +{
> +	struct memstick_dev *card = container_of(dev, struct memstick_dev,
> +						  dev);
> +	struct memstick_driver *drv = container_of(dev->driver,
> +						   struct memstick_driver,
> +						   driver);
> +
> +	if (dev->driver && drv->remove) {
> +		drv->remove(card);
> +		card->dev.driver = NULL;

Is this needed?

> +	}
> +
> +	put_device(dev);
> +	return 0;
> +}
>
> ...
>
> +void memstick_init_req(struct memstick_request *mrq, unsigned char tpc,
> +		       void *buf, size_t length)
> +{
> +	mrq->tpc = tpc;
> +	if (tpc & 8)
> +		mrq->data_dir = WRITE;
> +	else
> +		mrq->data_dir = READ;
> +
> +	mrq->data_len = length > sizeof(mrq->data) ? sizeof(mrq->data) : length;
> +	if (mrq->data_dir == WRITE)
> +		memcpy(mrq->data, buf, mrq->data_len);
> +
> +	mrq->io_type = MEMSTICK_IO_VAL;
> +
> +	if (tpc == MS_TPC_SET_CMD || tpc == MS_TPC_EX_SET_CMD)
> +		mrq->need_card_int = 1;
> +	else
> +		mrq->need_card_int = 0;
> +
> +	mrq->get_int_reg = 0;
> +}
> +EXPORT_SYMBOL(memstick_init_req);

It's kinda polite to add some commentary to global, exported-to-modules
functions.

It leads to more effective code review too.  Reviewing code is the process
of determining whether implementation != intention.  But without comments,
the reviewer's starting point is intention = implementation.  So we end up
incorrectly returning true ;)

> +static int h_memstick_read_dev_id(struct memstick_dev *card,
> +				  struct memstick_request **mrq)
> +{
> +	struct ms_id_register id_reg;
> +
> +	if (!(*mrq)) {
> +		memstick_init_req(&card->current_mrq, MS_TPC_READ_REG, NULL,
> +				  sizeof(struct ms_id_register));
> +		*mrq = &card->current_mrq;
> +		return 0;
> +	} else {
> +		if (!(*mrq)->error) {
> +			memcpy(&id_reg, (*mrq)->data, sizeof(id_reg));
> +			card->id = (struct memstick_device_id){
> +				.match_flags = MEMSTICK_MATCH_ALL,
> +				.type = id_reg.type,
> +				.category = id_reg.category,
> +				.class = id_reg.class
> +			};
> +		}
> +		complete(&card->mrq_complete);
> +		return -EAGAIN;
> +	}
> +}

Without comments this little reader is mystified as to why this function
would return -EAGAIN, and what such a thing means.

> +static int h_memstick_set_rw_addr(struct memstick_dev *card,
> +				  struct memstick_request **mrq)
> +{
> +	if (!(*mrq)) {
> +		memstick_init_req(&card->current_mrq, MS_TPC_SET_RW_REG_ADRS,
> +				  (char *)&card->reg_addr,
> +				  sizeof(card->reg_addr));
> +		*mrq = &card->current_mrq;
> +		return 0;
> +	} else {
> +		complete(&card->mrq_complete);
> +		return -EAGAIN;
> +	}
> +}
> +
> +int memstick_set_rw_addr(struct memstick_dev *card)
> +{
> +	card->next_request = h_memstick_set_rw_addr;
> +	memstick_new_req(card->host);
> +	wait_for_completion(&card->mrq_complete);
> +
> +	return card->current_mrq.error;
> +}
> +EXPORT_SYMBOL(memstick_set_rw_addr);
> +
> +static struct memstick_dev *memstick_alloc_card(struct memstick_host *host)
> +{
> +	struct memstick_dev *card = kzalloc(sizeof(struct memstick_dev),
> +					    GFP_KERNEL);
> +	struct memstick_dev *old_card = host->card;
> +	struct ms_id_register id_reg;
> +
> +	if (card) {
> +		card->host = host;
> +		snprintf(card->dev.bus_id, sizeof(card->dev.bus_id),
> +			 "%s", host->cdev.class_id);
> +		card->dev.parent = host->cdev.dev;
> +		card->dev.bus = &memstick_bus_type;
> +		card->dev.release = memstick_free_card;
> +		card->check = memstick_dummy_check;
> +
> +		card->reg_addr = (struct ms_register_addr){
> +			offsetof(struct ms_register, id),
> +			sizeof(id_reg),
> +			offsetof(struct ms_register, id),
> +			sizeof(id_reg)
> +		};

You may find that gcc generates crappy code for this: assembles a struct on
the stack them does a memcpy (or even a memb-er-by-member copy).  Doing
member-at-a-time assignment would produce a better result.  If you care much.


> +		init_completion(&card->mrq_complete);
> +
> +		host->card = card;
> +		if (memstick_set_rw_addr(card))
> +			goto err_out;
> +
> +		card->next_request = h_memstick_read_dev_id;
> +		memstick_new_req(host);
> +		wait_for_completion(&card->mrq_complete);
> +
> +		if (card->current_mrq.error)
> +			goto err_out;
> +	}
> +	host->card = old_card;
> +	return card;
> +err_out:
> +	host->card = old_card;
> +	kfree(card);
> +	return NULL;
> +}
> +
>
> ...
>
> +
> +struct mspro_sys_attr {
> +	size_t                  size;
> +	unsigned char           *data;
> +	unsigned char           id;
> +	char                    name[32];
> +	struct device_attribute sys_attr;
> +};
> +
> +struct mspro_attr_entry {
> +	unsigned int  address;
> +	unsigned int  size;
> +	unsigned char id;
> +	unsigned char reserved[3];
> +} __attribute__((packed));
> +
> +struct mspro_attribute {
> +	unsigned short          signature;
> +	unsigned short          version;
> +	unsigned char           count;
> +	unsigned char           reserved[11];
> +	struct mspro_attr_entry entries[];
> +} __attribute__((packed));

Why are these packed?  Do they map onto something whcih hardware knows
about?

Again, the lack of comments leaves me at a loss.

>
> ...
>
> +struct mspro_block_data {
> +	struct memstick_dev   *card;
> +	unsigned int          usage_count;
> +	struct gendisk        *disk;
> +	struct request_queue  *queue;
> +	spinlock_t            q_lock;
> +	wait_queue_head_t     q_wait;
> +	struct task_struct    *q_thread;
> +
> +	unsigned short        page_size;
> +	unsigned short        cylinders;
> +	unsigned short        heads;
> +	unsigned short        sectors_per_track;
> +
> +	unsigned char         system;
> +	unsigned char         read_only:1,
> +			      active:1,
> +			      has_request:1,
> +			      data_dir:1;

You're aware that these four fields occupy the same machine word and that
the compiler provides no locking?  So if one thread attempts to modify
"read_only" while another modifies "has_request", one can corrupt the work
of the other?

If this is indeed safe then a comment here whcih clearly explains that
would be useful.

> +	unsigned char         transfer_cmd;
> +
> +	int                   (*mrq_handler)(struct memstick_dev *card,
> +					     struct memstick_request **mrq);
> +
> +	unsigned char         attr_count;
> +	struct mspro_sys_attr *attributes;
> +
> +	struct scatterlist    req_sg[MSPRO_BLOCK_MAX_SEGS];
> +	unsigned int          seg_count;
> +	unsigned int          current_seg;
> +	unsigned short        current_page;
> +};
>
> ...
>
> +static ssize_t mspro_block_attr_show_default(struct device *dev,
> +					     struct device_attribute *attr,
> +					     char *buffer)
> +{
> +	struct mspro_sys_attr *x_attr = container_of(attr,
> +						     struct mspro_sys_attr,
> +						     sys_attr);
> +
> +	ssize_t cnt, rc = 0;
> +
> +	for (cnt = 0; cnt < x_attr->size; cnt++) {
> +		if (cnt && !(cnt % 16)) {
> +			if (PAGE_SIZE - rc)
> +				buffer[rc++] = '\n';
> +		}
> +
> +		rc += snprintf(buffer + rc, PAGE_SIZE - rc, "%02x ",
> +			       x_attr->data[cnt]);

scnprintf, I suspect?

> +	}
> +	return rc;
> +}
> +
> +static ssize_t mspro_block_attr_show_sysinfo(struct device *dev,
> +					     struct device_attribute *attr,
> +					     char *buffer)
> +{
> +	struct mspro_sys_attr *x_attr = container_of(attr,
> +						     struct mspro_sys_attr,
> +						     sys_attr);
> +	struct mspro_sys_info *x_sys = (struct mspro_sys_info *)x_attr->data;

Maybe .data should have been void*.

> +	ssize_t rc = 0;
> +
> +	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "class: %x\n",
> +		       x_sys->class);
> +	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "block size: %x\n",
> +		       be16_to_cpu(x_sys->block_size));
> +	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "block count: %x\n",
> +		       be16_to_cpu(x_sys->block_count));
> +	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "user block count: %x\n",
> +		       be16_to_cpu(x_sys->user_block_count));
> +	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "page size: %x\n",
> +		       be16_to_cpu(x_sys->page_size));
> +	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "assembly date: "
> +		       "%d %04u-%02u-%02u %02u:%02u:%02u\n",
> +		       x_sys->assembly_date[0],
> +		       be16_to_cpu(*(unsigned short *)&x_sys->assembly_date[1]),
> +		       x_sys->assembly_date[3], x_sys->assembly_date[4],
> +		       x_sys->assembly_date[5], x_sys->assembly_date[6],
> +		       x_sys->assembly_date[7]);
> +	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "serial number: %x\n",
> +		       be32_to_cpu(x_sys->serial_number));
> +	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "assembly maker code: %x\n",
> +		       x_sys->assembly_maker_code);
> +	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "assembly model code: "
> +		       "%02x%02x%02x\n", x_sys->assembly_model_code[0],
> +		       x_sys->assembly_model_code[1],
> +		       x_sys->assembly_model_code[2]);
> +	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "memory maker code: %x\n",
> +		       be16_to_cpu(x_sys->memory_maker_code));
> +	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "memory model code: %x\n",
> +		       be16_to_cpu(x_sys->memory_model_code));
> +	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "vcc: %x\n",
> +		       x_sys->vcc);
> +	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "vpp: %x\n",
> +		       x_sys->vpp);
> +	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "controller number: %x\n",
> +		       be16_to_cpu(x_sys->controller_number));
> +	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "controller function: %x\n",
> +		       be16_to_cpu(x_sys->controller_function));
> +	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "start sector: %x\n",
> +		       be16_to_cpu(x_sys->start_sector));
> +	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "unit size: %x\n",
> +		       be16_to_cpu(x_sys->unit_size));
> +	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "sub class: %x\n",
> +		       x_sys->ms_sub_class);
> +	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "interface type: %x\n",
> +		       x_sys->interface_type);
> +	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "controller code: %x\n",
> +		       be16_to_cpu(x_sys->controller_code));
> +	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "format type: %x\n",
> +		       x_sys->format_type);
> +	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "device type: %x\n",
> +		       x_sys->device_type);
> +	rc += snprintf(buffer + rc, PAGE_SIZE - rc, "mspro id: %s\n",
> +		       x_sys->mspro_id);
> +	return rc;

Again, this will return a wrong result if the output was truncated. 
scnprintf would fix.

> +}
> +
> +static ssize_t mspro_block_attr_show_modelname(struct device *dev,
> +					       struct device_attribute *attr,
> +					       char *buffer)
> +{
> +	struct mspro_sys_attr *x_attr = container_of(attr,
> +						     struct mspro_sys_attr,
> +						     sys_attr);
> +
> +	return snprintf(buffer, PAGE_SIZE, "%s", x_attr->data);
> +}
>
> ...
>
> +static int mspro_block_sysfs_register(struct memstick_dev *card)
> +{
> +	struct mspro_block_data *msb = memstick_get_drvdata(card);
> +	int cnt, rc = 0;
> +
> +	for (cnt = 0; cnt < msb->attr_count; cnt++) {
> +		rc = device_create_file(&card->dev,
> +					&msb->attributes[cnt].sys_attr);
> +
> +		if (rc) {
> +			if (cnt) {
> +				for (cnt--; cnt >= 0; cnt--)

ow. my brain hurts.

The `if (cnt)' is actually unneeded.  But if it were mine I'd be doing
something simpler and obviouser here.  Like `for (i = 0; i < cnt; i++)'
simple == good.  !simple == !.

> +					device_remove_file(&card->dev,
> +							   &msb->attributes[cnt]
> +								.sys_attr);
> +			}
> +			break;
> +		}
> +	}
> +	return rc;
> +}

Could we be using attribute groups for all this?

> +static void mspro_block_sysfs_unregister(struct memstick_dev *card)
> +{
> +	struct mspro_block_data *msb = memstick_get_drvdata(card);
> +	int cnt;
> +
> +	for (cnt = 0; cnt < msb->attr_count; cnt++)
> +		device_remove_file(&card->dev, &msb->attributes[cnt].sys_attr);
> +}
>
> ...
>
> +static int h_mspro_block_get_ro(struct memstick_dev *card,
> +				struct memstick_request **mrq)
> +{
> +	struct mspro_block_data *msb = memstick_get_drvdata(card);
> +
> +	if ((*mrq)->error) {
> +		complete(&card->mrq_complete);
> +		return (*mrq)->error;
> +	}
> +
> +	if ((*mrq)->data[offsetof(struct ms_status_register, status0)]

It would be simpler and clearer to do

	struct ms_status_register *msr;
	msr = (struct ms_status_register *)(*mrq)->data;
	if (msr->status0)

no?

Again, making .data void* would improve things here.

> +	    & MEMSTICK_STATUS0_WP)
> +		msb->read_only = 1;
> +	else
> +		msb->read_only = 0;
> +
> +	complete(&card->mrq_complete);
> +	return -EAGAIN;
> +}
> +
> +static int h_mspro_block_wait_for_ced(struct memstick_dev *card,
> +				      struct memstick_request **mrq)
> +{
> +	if ((*mrq)->error) {
> +		complete(&card->mrq_complete);
> +		return (*mrq)->error;
> +	}
> +
> +	dev_dbg(&card->dev, "wait for ced: value %x\n", (*mrq)->data[0]);
> +
> +	if ((*mrq)->data[0] & (MEMSTICK_INT_CMDNAK | MEMSTICK_INT_ERR)) {

elsewhere.

> +		card->current_mrq.error = -EFAULT;
> +		complete(&card->mrq_complete);
> +		return card->current_mrq.error;
> +	}
> +
> +	if (!((*mrq)->data[0] & MEMSTICK_INT_CED))
> +		return 0;
> +	else {
> +		card->current_mrq.error = 0;
> +		complete(&card->mrq_complete);
> +		return -EAGAIN;
> +	}
> +}
> +
> +static int h_mspro_block_transfer_data(struct memstick_dev *card,
> +				       struct memstick_request **mrq)
> +{
> +	struct memstick_host *host = card->host;
> +	struct mspro_block_data *msb = memstick_get_drvdata(card);
> +	unsigned char t_val = 0;
> +	struct scatterlist t_sg = { 0 };

Should this be using sg_init_table()?

> +	size_t t_offset;
> +
> +	if ((*mrq)->error) {
> +		complete(&card->mrq_complete);
> +		return (*mrq)->error;
> +	}
> +
> +	switch ((*mrq)->tpc) {
> +	case MS_TPC_WRITE_REG:
> +		memstick_init_req(*mrq, MS_TPC_SET_CMD, &msb->transfer_cmd, 1);
> +		(*mrq)->get_int_reg = 1;
> +		return 0;
> +	case MS_TPC_SET_CMD:
> +		t_val = (*mrq)->int_reg;
> +		memstick_init_req(*mrq, MS_TPC_GET_INT, NULL, 1);
> +		if (host->caps & MEMSTICK_CAP_AUTO_GET_INT)
> +			goto has_int_reg;
> +		return 0;
>
> ...
>
> +
> +static void mspro_block_process_request(struct memstick_dev *card,
> +					struct request *req)
> +{
> +	struct mspro_block_data *msb = memstick_get_drvdata(card);
> +	struct mspro_param_register param;
> +	int rc, chunk, cnt;
> +	unsigned short page_count;
> +	sector_t t_sec;
> +	unsigned long flags;
> +
> +	do {
> +		page_count = 0;
> +		msb->current_seg = 0;
> +		msb->seg_count = blk_rq_map_sg(req->q, req, msb->req_sg);
> +
> +		if (msb->seg_count) {
> +			msb->current_page = 0;
> +			for (rc = 0; rc < msb->seg_count; rc++)
> +				page_count += msb->req_sg[rc].length
> +					      / msb->page_size;
> +
> +			t_sec = req->sector;
> +			sector_div(t_sec, msb->page_size >> 9);
> +			param = (struct mspro_param_register) {
> +				.system = msb->system,
> +				.data_count = cpu_to_be16(page_count),
> +				.data_address = cpu_to_be32((uint32_t)t_sec),
> +				.cmd_param = 0
> +			};

Might generate bad code.

> +			msb->data_dir = rq_data_dir(req);
> +			msb->transfer_cmd = msb->data_dir == READ
> +					    ? MSPRO_CMD_READ_DATA
> +					    : MSPRO_CMD_WRITE_DATA;
> +
> +			dev_dbg(&card->dev, "data transfer: cmd %x, "
> +				"lba %x, count %x\n", msb->transfer_cmd,
> +				be32_to_cpu(param.data_address),
> +				page_count);
> +
> +			card->next_request = h_mspro_block_req_init;
> +			msb->mrq_handler = h_mspro_block_transfer_data;
> +			memstick_init_req(&card->current_mrq, MS_TPC_WRITE_REG,
> +					  &param, sizeof(param));
> +			memstick_new_req(card->host);
> +			wait_for_completion(&card->mrq_complete);
> +			rc = card->current_mrq.error;
> +
> +			if (rc || (card->current_mrq.tpc == MSPRO_CMD_STOP)) {
> +				for (cnt = 0; cnt < msb->current_seg; cnt++)
> +					page_count += msb->req_sg[cnt].length
> +						      / msb->page_size;
> +
> +				if (msb->current_page)
> +					page_count += msb->current_page - 1;
> +
> +				if (page_count && (msb->data_dir == READ))
> +					rc = msb->page_size * page_count;
> +				else
> +					rc = -EIO;
> +			} else
> +				rc = msb->page_size * page_count;
> +		} else
> +			rc = -EFAULT;
> +
> +		spin_lock_irqsave(&msb->q_lock, flags);
> +		if (rc >= 0)
> +			chunk = end_that_request_chunk(req, 1, rc);
> +		else
> +			chunk = end_that_request_first(req, rc,
> +						       req->current_nr_sectors);
> +
> +		dev_dbg(&card->dev, "end chunk %d, %d\n", rc, chunk);
> +		if (!chunk) {
> +			add_disk_randomness(req->rq_disk);
> +			blkdev_dequeue_request(req);
> +			end_that_request_last(req, rc > 0 ? 1 : rc);
> +		}
> +		spin_unlock_irqrestore(&msb->q_lock, flags);
> +	} while (chunk);
> +
> +}
>
> ...
>
>
> +static int mspro_block_queue_thread(void *data)
> +{
> +	struct memstick_dev *card = data;
> +	struct memstick_host *host = card->host;
> +	struct mspro_block_data *msb = memstick_get_drvdata(card);
> +	struct request *req;
> +	unsigned long flags;
> +
> +	while (1) {
> +		wait_event(msb->q_wait, mspro_block_has_request(msb));
> +		dev_dbg(&card->dev, "thread iter\n");
> +
> +		spin_lock_irqsave(&msb->q_lock, flags);
> +		req = elv_next_request(msb->queue);
> +		dev_dbg(&card->dev, "next req %p\n", req);
> +		if (!req) {
> +			msb->has_request = 0;
> +			if (kthread_should_stop()) {
> +				spin_unlock_irqrestore(&msb->q_lock, flags);
> +				break;
> +			}
> +		} else
> +			msb->has_request = 1;
> +		spin_unlock_irqrestore(&msb->q_lock, flags);
> +
> +		if (req) {
> +			mutex_lock(&host->lock);
> +			mspro_block_process_request(card, req);
> +			mutex_unlock(&host->lock);
> +		}
> +	}

Should this have a try_to_freeze() in it?

> +	dev_dbg(&card->dev, "thread finished\n");
> +	return 0;
> +}
> +
> +static void mspro_block_request(struct request_queue *q)
> +{
> +	struct memstick_dev *card = q->queuedata;
> +	struct mspro_block_data *msb = memstick_get_drvdata(card);
> +	struct request *req = NULL;
> +
> +	if (!msb->q_thread) {
> +		for (req = elv_next_request(q); req;
> +		     req = elv_next_request(q)) {
> +			while (end_that_request_chunk(req, -ENODEV,
> +						      req->current_nr_sectors
> +						      << 9)) {}
> +			end_that_request_last(req, -ENODEV);
> +		}
> +	} else {
> +		msb->has_request = 1;
> +		wake_up_all(&msb->q_wait);
> +	}
> +}

Suggest that you cc Jens on this, see if he can check it all over.

> +/*** Initialization ***/
> +
> +static int mspro_block_wait_for_ced(struct memstick_dev *card)
> +{
> +	struct mspro_block_data *msb = memstick_get_drvdata(card);
> +
> +	card->next_request = h_mspro_block_req_init;
> +	msb->mrq_handler = h_mspro_block_wait_for_ced;
> +	memstick_init_req(&card->current_mrq, MS_TPC_GET_INT, NULL, 1);
> +	memstick_new_req(card->host);
> +	wait_for_completion(&card->mrq_complete);
> +	return card->current_mrq.error;
> +}
>
> ...
>
> +static int mspro_block_read_attributes(struct memstick_dev *card)
> +{
> +	struct mspro_block_data *msb = memstick_get_drvdata(card);
> +	struct mspro_param_register param = {
> +		.system = msb->system,
> +		.data_count = cpu_to_be16(1),
> +		.data_address = 0,
> +		.cmd_param = 0
> +	};
> +	struct mspro_attribute *attr = NULL;
> +	unsigned char *buffer = NULL;
> +	int cnt, rc;
> +	unsigned int addr;
> +	unsigned short page_count;
> +
> +	attr = kmalloc(msb->page_size, GFP_KERNEL);
> +	if (!attr)
> +		return -ENOMEM;
> +
> +	sg_init_one(&msb->req_sg[0], attr, msb->page_size);
> +	msb->seg_count = 1;
> +	msb->current_seg = 0;
> +	msb->current_page = 0;
> +	msb->data_dir = READ;
> +	msb->transfer_cmd = MSPRO_CMD_READ_ATRB;
> +
> +	card->next_request = h_mspro_block_req_init;
> +	msb->mrq_handler = h_mspro_block_transfer_data;
> +	memstick_init_req(&card->current_mrq, MS_TPC_WRITE_REG, &param,
> +			  sizeof(param));
> +	memstick_new_req(card->host);
> +	wait_for_completion(&card->mrq_complete);
> +	if (card->current_mrq.error) {
> +		rc = card->current_mrq.error;
> +		goto out_free_attr;
> +	}
> +
> +	if (be16_to_cpu(attr->signature) != MSPRO_BLOCK_SIGNATURE) {
> +		printk(KERN_ERR "%s: unrecognized device signature %x\n",
> +		       card->dev.bus_id, be16_to_cpu(attr->signature));
> +		rc = -ENODEV;
> +		goto out_free_attr;
> +	}
> +
> +	if (attr->count > MSPRO_BLOCK_MAX_ATTRIBUTES) {
> +		printk(KERN_WARNING "%s: way too many attribute entries\n",
> +		       card->dev.bus_id);
> +		msb->attr_count = MSPRO_BLOCK_MAX_ATTRIBUTES;
> +	} else
> +		msb->attr_count = attr->count;
> +
> +	msb->attributes = kzalloc(msb->attr_count
> +				  * sizeof(struct mspro_sys_attr),
> +				  GFP_KERNEL);
> +	if (!msb->attributes) {
> +		msb->attr_count = 0;
> +		rc = -ENOMEM;
> +		goto out_free_attr;
> +	}
> +
> +	buffer = kmalloc(msb->page_size, GFP_KERNEL);
> +	if (!buffer) {
> +		rc = -ENOMEM;
> +		goto out_free_attr;

I think we leak msb->attributes if this is taken.  Please double-check the
unwinding here.

> +	}
> +	memcpy(buffer, (char *)attr, msb->page_size);

unneeded cast?

> +	page_count = 1;
> +
> +	for (cnt = 0; cnt < msb->attr_count; cnt++) {
> +		addr = be32_to_cpu(attr->entries[cnt].address);
> +		rc = be32_to_cpu(attr->entries[cnt].size);
> +		dev_dbg(&card->dev, "adding attribute %d: id %x, address %x, "
> +			"size %x\n", cnt, attr->entries[cnt].id, addr, rc);
> +		msb->attributes[cnt].id = attr->entries[cnt].id;
> +		if (mspro_block_attr_name(attr->entries[cnt].id))
> +			snprintf(msb->attributes[cnt].name,
> +				 sizeof(msb->attributes[cnt].name), "%s",
> +				 mspro_block_attr_name(attr->entries[cnt].id));
> +		else
> +			snprintf(msb->attributes[cnt].name,
> +				 sizeof(msb->attributes[cnt].name),
> +				 "attr_x%02x",
> +				 attr->entries[cnt].id);
> +
> +		msb->attributes[cnt].sys_attr
> +			= (struct device_attribute){
> +				.attr = {
> +					.name = msb->attributes[cnt].name,
> +					.mode = S_IRUGO,
> +					.owner = THIS_MODULE
> +				},
> +				.show = mspro_block_attr_show(
> +						msb->attributes[cnt].id),
> +				.store = NULL
> +			};

Wow, that's giving the compiler a workout.  Trusting soul ;)

Alas, you may fnd the result isn't good.

> +		if (!rc)
> +			continue;
> +
> +		msb->attributes[cnt].size = rc;
> +		msb->attributes[cnt].data = kmalloc(rc, GFP_KERNEL);
> +		if (!msb->attributes[cnt].data) {
> +			rc = -ENOMEM;
> +			goto out_free_buffer;
> +		}
> +
> +		if (((addr / msb->page_size)
> +		     == be32_to_cpu(param.data_address))
> +		    && (((addr + rc - 1) / msb->page_size)
> +			== be32_to_cpu(param.data_address))) {
> +			memcpy(msb->attributes[cnt].data,
> +			       buffer + addr % msb->page_size,
> +			       rc);
> +			continue;
> +		}
> +
> +		if (page_count <= (rc / msb->page_size)) {
> +			kfree(buffer);
> +			page_count = (rc / msb->page_size) + 1;
> +			buffer = kmalloc(page_count * msb->page_size,
> +					 GFP_KERNEL);
> +			if (!buffer) {
> +				rc = -ENOMEM;
> +				goto out_free_attr;
> +			}
> +		}
> +
> +		param = (struct mspro_param_register){
> +			.system = msb->system,
> +			.data_count = cpu_to_be16((rc / msb->page_size) + 1),
> +			.data_address = cpu_to_be32(addr / msb->page_size),
> +			.cmd_param = 0
> +		};
> +
> +		sg_init_one(&msb->req_sg[0], buffer,
> +			    be16_to_cpu(param.data_count) * msb->page_size);
> +		msb->seg_count = 1;
> +		msb->current_seg = 0;
> +		msb->current_page = 0;
> +		msb->data_dir = READ;
> +		msb->transfer_cmd = MSPRO_CMD_READ_ATRB;
> +
> +		dev_dbg(&card->dev, "reading attribute pages %x, %x\n",
> +			be32_to_cpu(param.data_address),
> +			be16_to_cpu(param.data_count));
> +
> +		card->next_request = h_mspro_block_req_init;
> +		msb->mrq_handler = h_mspro_block_transfer_data;
> +		memstick_init_req(&card->current_mrq, MS_TPC_WRITE_REG,
> +				  (char *)&param, sizeof(param));
> +		memstick_new_req(card->host);
> +		wait_for_completion(&card->mrq_complete);
> +		if (card->current_mrq.error) {
> +			rc = card->current_mrq.error;
> +			goto out_free_buffer;
> +		}
> +
> +		memcpy(msb->attributes[cnt].data,
> +		       buffer + addr % msb->page_size,
> +		       rc);
> +	}
> +
> +	rc = 0;
> +out_free_buffer:
> +	kfree(buffer);
> +out_free_attr:
> +	kfree(attr);
> +	return rc;
> +}
>
> ...
>
> +static int mspro_block_resume(struct memstick_dev *card)
> +{
> +	struct mspro_block_data *msb = memstick_get_drvdata(card);
> +	unsigned long flags;
> +	int rc = 0;
> +
> +#ifdef CONFIG_MEMSTICK_UNSAFE_RESUME
> +
> +	struct mspro_block_data *new_msb;
> +	struct memstick_host *host = card->host;
> +	unsigned char cnt;
> +
> +	mutex_lock(&host->lock);
> +	new_msb = kzalloc(sizeof(struct mspro_block_data), GFP_KERNEL);

If anything takes host->lock on the IO path then there might be a deadlock
here.  GFP_NOIO, perhaps.  or just swap these two lines.

> +	if (!new_msb) {
> +		rc = -ENOMEM;
> +		goto out_unlock;
> +	}
> +
> +	new_msb->card = card;
> +	memstick_set_drvdata(card, new_msb);
> +	if (mspro_block_init_card(card))

except this might do allocations too, dunno.

> +		goto out_free;
> +
> +	for (cnt = 0; cnt < new_msb->attr_count; cnt++) {
> +		if (new_msb->attributes[cnt].id == MSPRO_BLOCK_ID_SYSINFO
> +		    && cnt < msb->attr_count
> +		    && msb->attributes[cnt].id == MSPRO_BLOCK_ID_SYSINFO) {
> +			if (memcmp(new_msb->attributes[cnt].data,
> +				   msb->attributes[cnt].data,
> +				   msb->attributes[cnt].size))
> +				break;
> +
> +			memstick_set_drvdata(card, msb);
> +			msb->q_thread = kthread_run(mspro_block_queue_thread,
> +						    card, DRIVER_NAME"d");
> +			if (IS_ERR(msb->q_thread))
> +				msb->q_thread = NULL;
> +			else
> +				msb->active = 1;
> +
> +			break;
> +		}
> +	}
> +
> +out_free:
> +	memstick_set_drvdata(card, msb);
> +	mspro_block_data_clear(new_msb);
> +	kfree(new_msb);
> +out_unlock:
> +	mutex_unlock(&host->lock);
> +
> +#endif /* CONFIG_MEMSTICK_UNSAFE_RESUME */
> +
> +	spin_lock_irqsave(&msb->q_lock, flags);
> +	blk_start_queue(msb->queue);
> +	spin_unlock_irqrestore(&msb->q_lock, flags);
> +	return rc;
> +}

Here my attention span ran out.  Except for...

> +inline void *memstick_priv(struct memstick_host *host)
> +{
> +	return (void *)host->private;
> +}
> +
> +inline void *memstick_get_drvdata(struct memstick_dev *card)
> +{
> +	return dev_get_drvdata(&card->dev);
> +}
> +
> +inline void memstick_set_drvdata(struct memstick_dev *card, void *data)
> +{
> +	dev_set_drvdata(&card->dev, data);
> +}

static inline.


Generally: a clean and idiomatic-looking driver but I am not able to review
it very effectively due to its extraordinary lack of commentary.

