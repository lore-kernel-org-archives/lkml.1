Return-Path: <linux-kernel-owner+w=401wt.eu-S1758156AbZENLfv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758156AbZENLfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 07:35:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761AbZENLfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 07:35:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:43660 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753595AbZENLfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 07:35:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,194,1241420400"; 
   d="scan'208";a="412375091"
Date: Thu, 14 May 2009 13:37:50 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH] MFD: Add U300 AB3100 core support v1
Message-ID: <20090514113748.GA1324@sortiz.org>
References: <63386a3d0905140129s5fd0f32cxde1114489678f012@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63386a3d0905140129s5fd0f32cxde1114489678f012@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Some code comments here:

On Thu, May 14, 2009 at 10:29:02AM +0200, Linus Walleij wrote:
> +/*
> + * I2C communication
> + *
> + * The AB3100 is assigned address 0x48 (7-bit)
> + * Since the driver does not require SMBus support, we
> + * cannot be sure to probe for the device address here,
> + * so the boot loader or modprobe may need to pass in a parameter
> + * like ab3100-core.force=0,0x48.
> + *
> + */
> +static unsigned short normal_i2c[] = { 0x48, I2C_CLIENT_END };
> +I2C_CLIENT_INSMOD_1(ab3100);
> +
> +/* Whether the chip has been initialized */
> +static bool ab3100_initialized;
> +/* Lock out concurrent accesses to the AB3100 registers */
> +static DEFINE_MUTEX(ab3100_access_mutex);
> +/* Self describing stuff */
> +static struct i2c_client *ab3100_i2c_client;
> +static char ab3100_chip_name[32];
> +static u8 ab3100_chip_id;
All those static definitions dont look good to me.
Typically, one would define a struct ab3100 structure containing all of those.
Then, at device probe time you dynamically allocate one of those structure,
and linke your i2c client to it through i2c_set_clientdata().
This would make your driver look much better.

> +/* Event handling */
> +struct event {
> +	struct list_head node;
> +	struct device *dev;
> +	struct ab3100_event_mask event_mask;
> +	void *client_data;
> +	void (*cb_handler)(struct ab3100_event_mask, void *client_data);
> +};
> +/* The event list */
> +static DEFINE_MUTEX(event_list_mutex);
> +static LIST_HEAD(subscribers);
> +/* Save the first reading of the event registers */
> +static struct ab3100_event_mask startup_event_mask;
> +static bool startup_events_read;
> +
> +u8 ab3100_get_chip_type()
> +{
> +	u8 chip = ABUNKNOWN;
> +
> +	switch (ab3100_chip_id & 0xf0) {
> +	case  0xa0:
> +		chip = AB3000;
> +		break;
> +	case  0xc0:
> +		chip = AB3100;
> +		break;
> +	}
> +	return chip;
> +}
> +EXPORT_SYMBOL(ab3100_get_chip_type);
> +
> +int ab3100_set_register(u8 reg, u8 regval)
> +{
> +	u8 regandval[2] = {reg, regval};
> +	struct i2c_msg msgs[1];
> +	int err = 0;
> +
> +	if (!ab3100_initialized)
> +		return -ENODEV;
> +
> +	msgs[0].addr = ab3100_i2c_client->addr;
> +	msgs[0].flags = 0;
> +	msgs[0].len = 2;
> +	msgs[0].buf = regandval;
> +	err = mutex_lock_interruptible(&ab3100_access_mutex);
> +	if (err)
> +		return err;
> +
> +	/*
> +	 * A two-byte write message with the first byte containing the register
> +	 * number and the second byte containing the value to be written
> +	 * effectively sets a register in the AB3100.
> +	 */
> +	if ((i2c_transfer(ab3100_i2c_client->adapter,
> +					&msgs[0], 1)) != 1) {
> +		dev_err(&ab3100_i2c_client->dev,
> +				"%s: write error (write register)\n",
> +				__func__);
> +		err = -EIO;
> +	}
> +	mutex_unlock(&ab3100_access_mutex);
> +	return err;
> +}
> +EXPORT_SYMBOL(ab3100_set_register);
All those register access routines are accessible from anywhere. By
dynamically allocating your driver structure and registering its subdevices as
platform devices, you could restrict the usage of those routines to the
subdevices only. 


> +static struct file_operations ab3100_registers_fops = {
> +	.open = ab3100_registers_open,
> +	.read = seq_read,
> +	.llseek = seq_lseek,
> +	.release = single_release,
> +	.owner = THIS_MODULE,
> +};
This one should be const.


> +static int __init ab3100_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)
> +{
> +	int err;
> +	int i;
> +
> +	ab3100_i2c_client = client;
> +	ab3100_initialized = true;
> +
> +	/* Read chip ID register */
> +	err = ab3100_get_register(AB3100_CID, &ab3100_chip_id);
> +	if (err) {
> +		dev_err(&client->dev,
> +			"could not detect i2c bus for AB3100 analog"
> +			"baseband chip\n");
> +		goto exit_no_detect;
> +	}
> +
> +	for (i = 0; ids[i].id != 0x0; i++) {
> +		if (ids[i].id == ab3100_chip_id) {
> +			if (ids[i].name != NULL) {
> +				snprintf(&ab3100_chip_name[0], 31, "AB3100 %s",
> +					 ids[i].name);
> +				break;
> +			} else {
> +				dev_err(&client->dev,
> +					"AB3000 is no longer supported\n");
> +				goto exit_no_detect;
> +			}
> +		}
> +	}
> +
> +	if (ids[i].id == 0x0) {
> +		dev_err(&client->dev, "Unknown chip id: 0x%x\n",
> +			ab3100_chip_id);
> +		goto exit_no_detect;
> +	}
> +
> +	dev_info(&client->dev, "Detected chip: %s\n",
> +		 &ab3100_chip_name[0]);
> +
> +	err = ab3100_setup();
> +	if (err)
> +		goto exit_no_detect;
> +
> +	/* This real unpredictable IRQ is of course sampled for entropy */
> +	err = request_irq(client->irq, ab3100_irq_handler,
> +			  IRQF_DISABLED | IRQF_SAMPLE_RANDOM,
> +			  "AB3100 IRQ", NULL);
> +	if (err)
> +		goto exit_no_detect;
> +
> +	ab3100_setup_debugfs();
> +
> +	return 0;
> +
> + exit_no_detect:
> +	return err;
> +}
> +
> +static int __exit ab3100_remove(struct i2c_client *client)
> +{
> +	struct event *e;
> +
> +	ab3100_remove_debugfs();
> +	/* Free the list of event subscribers here */
> +	mutex_lock(&event_list_mutex);
> +	list_for_each_entry(e, &subscribers, node) {
> +
> +		/* Found a client subscription => remove it */
> +		list_del(&e->node);
> +		kfree(e);
> +	}
> +	mutex_unlock(&event_list_mutex);
> +	return 0;
> +}
As Mike pointed out, you're probably missing a free_irq() here.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
