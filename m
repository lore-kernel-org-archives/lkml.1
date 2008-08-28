Return-Path: <linux-kernel-owner+w=401wt.eu-S1753972AbYH1KJ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbYH1KJ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 06:09:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750802AbYH1KJT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 06:09:19 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:34992 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbYH1KJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 06:09:17 -0400
From: Oliver Neukum <oliver@neukum.org>
Organization: NOvell
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] USB: add USB test and measurement class driver - round 2
Date: Thu, 28 Aug 2008 12:10:26 +0200
User-Agent: KMail/1.9.9
Cc: Alan Stern <stern@rowland.harvard.edu>,
       USB list <linux-usb@vger.kernel.org>,
       Stefan Kopp <stefan_kopp@agilent.com>, Marcel Janssen <korgull@home.nl>,
       Felipe Balbi <me@felipebalbi.com>,
       Kernel development list <linux-kernel@vger.kernel.org>
References: <20080827183615.GA15692@kroah.com> <Pine.LNX.4.44L0.0808271451550.17771-100000@iolanthe.rowland.org> <20080827234720.GC31264@kroah.com>
In-Reply-To: <20080827234720.GC31264@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808281210.27661.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag 28 August 2008 01:47:20 schrieb Greg KH:
> On Wed, Aug 27, 2008 at 02:58:08PM -0400, Alan Stern wrote:
> > On Wed, 27 Aug 2008, Greg KH wrote:
> > 
> > > On Wed, Aug 27, 2008 at 02:28:22PM -0400, Alan Stern wrote:
> > > > On Wed, 27 Aug 2008, Greg KH wrote:
> > > > 
> > > > > Here's an updated version of the usbtmc driver, with all of the
> > > > > different issues that have been raised, hopefully addressed.
> > > > 
> > > > This is an example of what I was discussing with Oliver.  In all 
> > > > likelihood you simply don't need usbtmc_mutex, and using it will cause 
> > > > a lockdep violation.
> > > > 
> > > > That's why so many of the other USB class drivers don't have an 
> > > > analogous static mutex.
> > > 
> > > Ok, then it's just safe to drop this static mutex entirely, right?
> > 
> > Yes, once you add the call to usb_deregister_dev.
> 
> Great, all done now.
> 
> Here's the updated version.

OK, here we go again.

> +static ssize_t usbtmc_read(struct file *filp, char __user *buf,
> +			   size_t count, loff_t *f_pos)
> +{

[..]

> +		/* Setup IO buffer for DEV_DEP_MSG_IN message
> +		 * Refer to class specs for details
> +		 */
> +		buffer[0] = 2;
> +		buffer[1] = data->bTag;
> +		buffer[2] = ~(data->bTag);
> +		buffer[3] = 0; /* Reserved */
> +		buffer[4] = (this_part - 12 - 3) & 255;
> +		buffer[5] = ((this_part - 12 - 3) >> 8) & 255;
> +		buffer[6] = ((this_part - 12 - 3) >> 16) & 255;
> +		buffer[7] = ((this_part - 12 - 3) >> 24) & 255;

We have excellent endianness conversion macros.

> +		buffer[8] = data->TermCharEnabled * 2;
> +		/* Use term character? */

smp_rmb(); /* we must make sure we don't read a stale terminator */

> +		buffer[9] = data->TermChar;
> +		buffer[10] = 0; /* Reserved */
> +		buffer[11] = 0; /* Reserved */
> +
> +		/* Send bulk URB */
> +		retval = usb_bulk_msg(data->usb_dev,
> +				      usb_sndbulkpipe(data->usb_dev,
> +						      data->bulk_out),
> +				      buffer, 12, &actual, USBTMC_TIMEOUT);
> +
> +		/* Store bTag (in case we need to abort) */
> +		data->bTag_last_write = data->bTag;

even if usb_bulk_msg() failed?

> +
> +		/* Increment bTag -- and increment again if zero */
> +		data->bTag++;
> +		if (!data->bTag)
> +			(data->bTag)++;
> +
> +		if (retval < 0) {
> +			dev_err(dev, "usb_bulk_msg returned %d\n", retval);
> +			if (data->auto_abort)
> +				usbtmc_ioctl_abort_bulk_out(data);
> +			goto exit;
> +		}
> +
> +		/* Send bulk URB */
> +		retval = usb_bulk_msg(data->usb_dev,
> +				      usb_rcvbulkpipe(data->usb_dev,
> +						      data->bulk_in),
> +				      buffer, USBTMC_SIZE_IOBUFFER, &actual,
> +				      USBTMC_TIMEOUT);
> +
> +		/* Store bTag (in case we need to abort) */
> +		data->bTag_last_read = data->bTag;
> +
> +		if (retval < 0) {
> +			dev_err(dev, "Unable to read data, error %d\n", retval);
> +			if (data->auto_abort)
> +				usbtmc_ioctl_abort_bulk_in(data);
> +			goto exit;
> +		}
> +
> +		/* How many characters did the instrument send? */
> +		n_characters = buffer[4] +
> +			       (buffer[5] << 8) +
> +			       (buffer[6] << 16) +
> +			       (buffer[7] << 24);

endianness macro

> +
> +		/* Copy buffer to user space */
> +		if (copy_to_user(buf + done, &buffer[12], n_characters)) {
> +			/* There must have been an addressing problem */
> +			retval = -EFAULT;
> +			goto exit;
> +		}
> +
> +		done += n_characters;
> +		if (n_characters < USBTMC_SIZE_IOBUFFER)
> +			remaining = 0;
> +	}
> +
> +	/* Update file position value */
> +	*f_pos = *f_pos + done;

That'll get out of sync if -EFAULT is returned

> +	retval = done;
> +
> +exit:
> +	mutex_unlock(&data->io_mutex);
> +	kfree(buffer);
> +	return retval;
> +}
> +
> +static ssize_t usbtmc_write(struct file *filp, const char __user *buf,
> +			    size_t count, loff_t *f_pos)
> +{
> +	struct usbtmc_device_data *data;
> +	u8 *buffer;
> +	int retval;
> +	int actual;
> +	unsigned long int n_bytes;
> +	int n;
> +	int remaining;
> +	int done;
> +	int this_part;
> +
> +	data = filp->private_data;
> +
> +	buffer = kmalloc(USBTMC_SIZE_IOBUFFER, GFP_KERNEL);
> +	if (!buffer)
> +		return -ENOMEM;
> +
> +	mutex_lock(&data->io_mutex);

This and usbtmc_read() need a test for disconnection. Open() and disconnect
are guarded in usbcore, read & write are not. By reference count you've made
sure you have a valid device descriptor, but the device may have been reprobed.

> +
> +	remaining = count;
> +	done = 0;
> +
> +	while (remaining > 0) {
> +		if (remaining > USBTMC_SIZE_IOBUFFER - 12) {
> +			this_part = USBTMC_SIZE_IOBUFFER - 12;
> +			buffer[8] = 0;
> +		} else {
> +			this_part = remaining;
> +			buffer[8] = 1;
> +		}
> +
> +		/* Setup IO buffer for DEV_DEP_MSG_OUT message */
> +		buffer[0] = 1;
> +		buffer[1] = data->bTag;
> +		buffer[2] = ~(data->bTag);
> +		buffer[3] = 0; /* Reserved */
> +		buffer[4] = this_part & 255;
> +		buffer[5] = (this_part >> 8) & 255;
> +		buffer[6] = (this_part >> 16) & 255;
> +		buffer[7] = (this_part >> 24) & 255;

endianness macro

> +		/* buffer[8] is set above... */
> +		buffer[9] = 0; /* Reserved */
> +		buffer[10] = 0; /* Reserved */
> +		buffer[11] = 0; /* Reserved */
> +
> +		if (copy_from_user(&buffer[12], buf + done, this_part)) {
> +			retval = -EFAULT;
> +			goto exit;
> +		}
> +
> +		n_bytes = 12 + this_part;
> +		if (this_part % 4)
> +			n_bytes += 4 - this_part % 4;
> +			for (n = 12 + this_part; n < n_bytes; n++)
> +				buffer[n] = 0;
> +
> +		retval = usb_bulk_msg(data->usb_dev,
> +				      usb_sndbulkpipe(data->usb_dev,
> +						      data->bulk_out),
> +				      buffer, n_bytes, &actual, USBTMC_TIMEOUT);
> +
> +		data->bTag_last_write = data->bTag;

error case?

[..]
> +static int get_capabilities(struct usbtmc_device_data *data)
> +{
> +	struct device *dev = &data->usb_dev->dev;
> +	char *buffer;
> +	int rv;
> +
> +	buffer = kmalloc(0x18, GFP_KERNEL);
> +	if (!buffer)
> +		return -ENOMEM;
> +
> +	rv = usb_control_msg(data->usb_dev, usb_rcvctrlpipe(data->usb_dev, 0),
> +			     USBTMC_REQUEST_GET_CAPABILITIES,
> +			     USB_DIR_IN | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
> +			     0, 0, buffer, 0x18, USBTMC_TIMEOUT);
> +	if (rv < 0) {
> +		dev_err(dev, "usb_control_msg returned %d\n", rv);
> +		return rv;

memory leak

> +	}
> +
> +	dev_dbg(dev, "GET_CAPABILITIES returned %x\n", buffer[0]);
> +	dev_dbg(dev, "Interface capabilities are %x\n", buffer[4]);
> +	dev_dbg(dev, "Device capabilities are %x\n", buffer[5]);
> +	dev_dbg(dev, "USB488 interface capabilities are %x\n", buffer[14]);
> +	dev_dbg(dev, "USB488 device capabilities are %x\n", buffer[15]);
> +	if (buffer[0] != USBTMC_STATUS_SUCCESS) {
> +		dev_err(dev, "GET_CAPABILITIES returned %x\n", buffer[0]);
> +		return -EPERM;

memory leak

[..]
> +static ssize_t store_TermChar(struct device *dev,
> +			      struct device_attribute *attr,
> +			      const char *buf, size_t count)
> +{
> +	struct usb_interface *intf = to_usb_interface(dev);
> +	struct usbtmc_device_data *data = usb_get_intfdata(intf);
> +
> +	if (count < 1)
> +		return -EINVAL;
> +	data->TermChar = buf[0];

smp_wmb(); /* must hit RAM before enablement */

> +	return count;
> +}
> +static DEVICE_ATTR(TermChar, S_IRUGO, show_TermChar, store_TermChar);
> +
> +#define data_attribute(name)						\
> +static ssize_t show_##name(struct device *dev,				\
> +			   struct device_attribute *attr, char *buf)	\
> +{									\
> +	struct usb_interface *intf = to_usb_interface(dev);		\
> +	struct usbtmc_device_data *data = usb_get_intfdata(intf);	\
> +									\
> +	return sprintf(buf, "%d\n", data->name);			\
> +}									\
> +static ssize_t store_##name(struct device *dev,				\
> +			    struct device_attribute *attr,		\
> +			    const char *buf, size_t count)		\
> +{									\
> +	struct usb_interface *intf = to_usb_interface(dev);		\
> +	struct usbtmc_device_data *data = usb_get_intfdata(intf);	\
> +	ssize_t result;							\
> +	unsigned val;							\
> +									\
> +	result = sscanf(buf, "%u\n", &val);				\
> +	if (result != 1)						\
> +		result = -EINVAL;					\

smp_rmb(); /* must hit RAM after the terminator */	\

There are subtle penalties to avoiding ioctl(). Among them is the loss
of atomicity.
[..]
> +static long usbtmc_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> +{
> +	struct usbtmc_device_data *data;
> +	int retval = -EBADRQC;
> +
> +	data = file->private_data;
> +	mutex_lock(&data->io_mutex);

check for disconnect as in read & write

> +
> +	switch (cmd) {
> +	case USBTMC_IOCTL_CLEAR_OUT_HALT:
> +		retval = usbtmc_ioctl_clear_out_halt(data);
> +
> +	case USBTMC_IOCTL_CLEAR_IN_HALT:
> +		retval = usbtmc_ioctl_clear_in_halt(data);
> +
> +	case USBTMC_IOCTL_INDICATOR_PULSE:
> +		retval = usbtmc_ioctl_indicator_pulse(data);
> +
> +	case USBTMC_IOCTL_CLEAR:
> +		retval = usbtmc_ioctl_clear(data);
> +
> +	case USBTMC_IOCTL_ABORT_BULK_OUT:
> +		retval = usbtmc_ioctl_abort_bulk_out(data);
> +
> +	case USBTMC_IOCTL_ABORT_BULK_IN:
> +		retval = usbtmc_ioctl_abort_bulk_in(data);
> +	}

This is missing a whole lot of "break;"

> +static int usbtmc_probe(struct usb_interface *intf,
> +			const struct usb_device_id *id)
> +{
> +	struct usbtmc_device_data *data;
> +	struct usb_host_interface *iface_desc;
> +	struct usb_endpoint_descriptor *endpoint;
> +	int n;
> +	int retcode;
> +
> +	dev_dbg(&intf->dev, "%s called\n", __func__);
> +
> +	data = kmalloc(sizeof(struct usbtmc_device_data), GFP_KERNEL);
> +	if (!data) {
> +		dev_err(&intf->dev, "Unable to allocate kernel memory\n");
> +		return -ENOMEM;
> +	}
> +
> +	data->intf = intf;
> +	data->id = id;
> +	data->usb_dev = usb_get_dev(interface_to_usbdev(intf));
> +	usb_set_intfdata(intf, data);
> +	kref_init(&data->kref);
> +	mutex_init(&data->io_mutex);
> +
> +	/* Initialize USBTMC bTag and other fields */
> +	data->bTag	= 1;
> +	data->TermCharEnabled = 0;
> +	data->TermChar = '\n';
> +
> +	/* USBTMC devices have only one setting, so use that */
> +	iface_desc = data->intf->cur_altsetting;
> +
> +	/* Find bulk in endpoint */
> +	for (n = 0; n < iface_desc->desc.bNumEndpoints; n++) {
> +		endpoint = &iface_desc->endpoint[n].desc;
> +
> +		if (usb_endpoint_is_bulk_in(endpoint)) {
> +			data->bulk_in = endpoint->bEndpointAddress;
> +			dev_dbg(&intf->dev, "Found bulk in endpoint at %u\n",
> +				data->bulk_in);
> +			break;
> +		}
> +	}
> +
> +	/* Find bulk out endpoint */
> +	for (n = 0; n < iface_desc->desc.bNumEndpoints; n++) {
> +		endpoint = &iface_desc->endpoint[n].desc;
> +
> +		if (usb_endpoint_is_bulk_out(endpoint)) {
> +			data->bulk_out = endpoint->bEndpointAddress;
> +			dev_dbg(&intf->dev, "Found Bulk out endpoint at %u\n",
> +				data->bulk_out);
> +			break;
> +		}
> +	}
> +
> +	retcode = get_capabilities(data);
> +	if (retcode)
> +		dev_err(&intf->dev, "can't read capabilities\n");
> +	else
> +		retcode = sysfs_create_group(&intf->dev.kobj,
> +					     &capability_attr_grp);
> +
> +	retcode = sysfs_create_group(&intf->dev.kobj, &data_attr_grp);

If you ignore an error return, be open about it.

> +	retcode = usb_register_dev(intf, &usbtmc_class);
> +	if (retcode) {
> +		dev_err(&intf->dev, "Not able to get a minor"
> +			" (base %u, slice default): %d\n", USBTMC_MINOR_BASE,
> +			retcode);
> +		goto error_register;
> +	}
> +	dev_dbg(&intf->dev, "Using minor number %d\n", intf->minor);
> +
> +	return 0;
> +
> +error_register:
> +	sysfs_remove_group(&intf->dev.kobj, &capability_attr_grp);
> +	sysfs_remove_group(&intf->dev.kobj, &data_attr_grp);

The groups might never have been created.

> +	kref_put(&data->kref, usbtmc_delete);
> +	return retcode;
> +}
> +
> +static void usbtmc_disconnect(struct usb_interface *intf)
> +{
> +	struct usbtmc_device_data *data;
> +
> +	dev_dbg(&intf->dev, "usbtmc_disconnect called\n");
> +

You must set a flag for read, write and ioctl.

	Regards
		Oliver
